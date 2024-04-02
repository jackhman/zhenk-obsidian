# 消息存储

上一篇文章主要介绍了 Broker 的基础架构设计和功能，Broker中还有消息生产、消息消费、Broker管理、事务管理、消息存储等核心功能，这篇文章我们先研究消息存储模块的设计，之后在这个基础上去研究生产者、消费者等相关功能就很容易了。通过研究RocketMQ的消息存储设计，我们也能掌握如何通过文件来高性能存储数据以及访问数据。

## MessageStore

Broker 端是通过 MessageStore 来存储、读取消息，可以看到 MessageStore 主要提供了如下的一些写入消息、读取消息、读取消息偏移量等相关的接口。

```java
public interface MessageStore {
    // 加载已存储的数据  
    boolean load();

    // 异步将消息写入存储  
    default CompletableFuture<PutMessageResult> asyncPutMessage(final MessageExtBrokerInner msg); 

    // 异步批量写入消息  
    default CompletableFuture<PutMessageResult> asyncPutMessages(final MessageExtBatch messageExtBatch); 

    // 同步写入消息  
    PutMessageResult putMessage(final MessageExtBrokerInner msg);  

    // 同步批量写入消息  
    PutMessageResult putMessages(final MessageExtBatch messageExtBatch);

    // 查询消息
    GetMessageResult getMessage(final String group, String topic, int queueId, long offset, int maxMsgNums, MessageFilter messageFilter);  

    // 获取消息队列最大偏移量
    long getMaxOffsetInQueue(final String topic, final int queueId);

    // 通过偏移量读取一条消息
    MessageExt lookMessageByOffset(final long commitLogOffset);  

    // ......
}
```

MessageStore 的实现类是 DefaultMessageStore，消息存储的实现逻辑也非常复杂，有消息存储 CommitLog，磁盘文件映射 MappedFile，消费队列 ConsumeQueue，消息检索 IndexService 等核心组件。

![](https://cdn.nlark.com/yuque/0/2024/webp/744990/1705397269438-8198f6e4-ed85-440b-b09e-af7a97c5fedf.webp)

从下图可以看到 DefaultMessageStore 的初始化以及加载过程。BrokerStartup 中创建了 BrokerController，BrokerController在初始化方法中创建了 DefaultMessageStore，然后调用其 load() 方法加载磁盘文件数据。之后 BrokerStartup 启动 BrokerController，BrokerController 的启动方法中，又启动了 DefaultMessageStore，其 start() 方法中启动了消息存储相关的组件。

![](https://cdn.nlark.com/yuque/0/2024/webp/744990/1705397269426-fd04fe67-9b24-492b-9696-21c8306c0bc3.webp)

## 文件锁定

在启动 BrokerStartup 时，DefaultMessageStore 构造方法中会创建 commitlog、consumequeue 等目录，期初目录下还没有文件。

```java
File file = new File(StorePathConfigHelper.getLockFile(messageStoreConfig.getStorePathRootDir()));  
// /store  
MappedFile.ensureDirOK(file.getParent());  
// /store/commitlog  
MappedFile.ensureDirOK(getStorePathPhysic());  
// /store/consumequeue  
MappedFile.ensureDirOK(getStorePathLogic());
// /store/lock
lockFile = new RandomAccessFile(file, "rw");
```

![](https://cdn.nlark.com/yuque/0/2024/webp/744990/1705397269601-3bfac447-e662-4ed4-8bc2-f96cadd29007.webp)

最后可以看到一直创建了一个锁文件 lockFile，在 DefaultMessageStore 启动的时候，就会通过 lockFile 获取的 FileChannel 来锁定 /store/lock 文件。如果无法锁定，就直接抛出异常，这说明 /store 下的目录只会被一个 Broker 独占，其它进程都不可以再占用 /store 目录下的文件。它会锁定直到 DefaultMessageStore 停止的时候才会释放。

通过这里可以了解到 FileChannel 的一个特性，其支持对文件进行锁定，以避免多个进程或线程同时访问文件的问题。可以使用 lock() 和 tryLock() 方法来实现文件的独占锁定。

```java
public void start() throws Exception {
lock = lockFile.getChannel().tryLock(0, 1, false);
if (lock == null || lock.isShared() || !lock.isValid()) {
    throw new RuntimeException("Lock failed,MQ already started");
}

lockFile.getChannel().write(ByteBuffer.wrap("lock".getBytes()));
lockFile.getChannel().force(true);

this.commitLog.start();
....
}

public void shutdown() {
    this.commitLog.shutdown();
    ......

    if (lockFile != null && lock != null) {
        lock.release();
        lockFile.close();
    }
}
```

# CommitLog

这篇文章我们就主要来研究消息存储核心组件之一的 CommitLog，DefaultMessageStore 写入、读取消息主要就是通过CommitLog来完成。

## CommitLog

CommitLog 主要有如下一些组件和属性，大部分的组件都在 CommitLog 构造方法中做了初始化。

![](https://cdn.nlark.com/yuque/0/2024/webp/744990/1705397269386-066e55e0-db08-4018-b51e-51d091bd4bc9.webp)

从 CommitLog 的构造方法中可以得知，commitlog 文件默认存储在 ${storePathRootDir}/commitlog 目录下。在构造方法中，创建了 commitlog 目录的映射对象 MappedFileQueue，然后在 CommitLog 加载的时候就会加载已存在的 commitlog 文件，映射为 MappedFile 对象。可以看到 commitlog 文件默认大小固定是 1GB。加载已存在的 commitlog 我们最后再来研究。

```java
public CommitLog(final DefaultMessageStore defaultMessageStore) {
    // CommitLog 存储路径，默认在 ${storePathRootDir}/commitlog
    String storePath = defaultMessageStore.getMessageStoreConfig().getStorePathCommitLog();

    // 将磁盘中的 CommitLog 做 MappedFile 内存映射
    this.mappedFileQueue = new MappedFileQueue(
        storePath,  // /commitlog 目录
        // commitlog 文件大小默认为 1GB
        defaultMessageStore.getMessageStoreConfig().getMappedFileSizeCommitLog(),
        // AllocateMappedFileService
        defaultMessageStore.getAllocateMappedFileService());
}

public boolean load() {  
    boolean result = this.mappedFileQueue.load();  
    log.info("load commit log " + (result ? "OK" : "Failed"));  
    return result;  
}
```

启动 CommitLog 的时候就会去启动一些辅助组件。

```java
public void start() {
    this.flushCommitLogService.start();

    // 刷盘监控组件，守护线程
    flushDiskWatcher.setDaemon(true);
    flushDiskWatcher.start();

    if (defaultMessageStore.getMessageStoreConfig().isTransientStorePoolEnable()) {
        this.commitLogService.start();
    }
}
```

## 消息结构

生产者向 Broker 发送消息时，DefaultMessageStore 会调用 CommitLog 的 asyncPutMessage 来写入消息，这节就来研究下消息写入过程以及如何存储的。

首先 asyncPutMessage 的入参是 MessageExtBrokerInner，它继承自 MessageExt，MessageExt 又继承自 Message。消息主要有如下的一些属性字段，最基础的便是消息投递到那个 Broker（brokerName）、哪个主题（topic）、主题下的哪个队列（queueId），以及消息内容（body）。

```java
public class Message implements Serializable {
    // 消息投递到哪个 topic
    private String topic;
    // flag
    private int flag;
    // 消息属性
    private Map<String, String> properties;
    // 消息内容
    private byte[] body;
    // 事务消息ID
    private String transactionId;
}

public class MessageExt extends Message {
    // Broker组
    private String brokerName;
    // Topic里的queue
    private int queueId;
    // 消息存储大小
    private int storeSize;
    // 消息队列偏移量
    private long queueOffset;
    // 系统标识
    private int sysFlag;
    // 消息诞生时间
    private long bornTimestamp;
    // 消息诞生的客户端网络连接地址
    private SocketAddress bornHost;
    // 消息存储时间
    private long storeTimestamp;
    // 消息存储的机器地址
    private SocketAddress storeHost;
    // 消息ID
    private String msgId;
    // 消息在commitlog里的偏移量
    private long commitLogOffset;
    // 消息体crc校验和
    private int bodyCRC;
    // 重新消费的次数
    private int reconsumeTimes;
    // 预准备事务偏移量
    private long preparedTransactionOffset;
}

public class MessageExtBrokerInner extends MessageExt {
    // 消息属性
    private String propertiesString;
    // tags code
    private long tagsCode;
    // 消息编码后的 buffer
    private ByteBuffer encodedBuff;
}
```

## 写入消息

我们可以在本地调试，首先启动 NamesrvStartup 和 BrokerStartup，然后运行 rocketmq-example 下面的 org.apache.rocketmq.example.quickstart.Producer 来启动生产者发送一个消息，我们就可以在 asyncPutMessage 方法中打断点来调试消息的写入过程。

消息写入的主流程如下：

1. 设置消息存储时间戳、设置消息体 crc32 校验和，避免消息篡改
2. 设置消息来源服务器以及存储服务器的 IPv6 地址标识
3. 获取线程副本 PutMessageThreadLocal，它的内部有一个 MessageExtEncoder 的编码器用于编码消息。MessageExtEncoder 在消息编码时，就是将消息的一个个属性写入到一个 ByteBuffer 里。正常情况下 PutMessageResult 返回为 null，如果编码失败，比如消息默认不能超过4MB，超长就会认为消息非法然后返回一个 PutMessageResult，这个时候就会直接返回。
4. 如果消息编码成功，就会将编码得到的 ByteBuffer 设置到 MessageExtBrokerInner 里面，然后创建写入消息上下文对象 PutMessageContext。
5. 接下来开始准备写入消息，先用 putMessageLock 加写锁，保证同一时刻只有一个线程能写入消息。从这里可以看出， CommitLog 写入消息是串行的，但后面的 IO 机制能保证串行写入的高性能。加锁之后，通过 MappedFileQueue 获取最后一个 MappedFile。前面已经大概了解到，commitlog 目录对应 MappedFileQueue，目录下的文件就对应多个 MappedFile，写满一个切换下一个，所以每次都应该写入最后一个。如果获取最后一个 MappedFile 返回 null，那么说明是程序初次启动，还没有 commitlog 文件。这时就会去获取偏移量为 0 的 MappedFile，也就是会创建第一个 commitlog 文件。接着就是向这个 MappedFile 追加消息 appendMessage，可以看到参数还传入了 AppendMessageCallback，这是在 MappedFile 写入消息后，就会执行这个回调。
6. 消息追加后，如果消息写满了，将会创建一个写的 MappedFile，继续写入消息。消息写入完成后，最后在 finally 中释放 putMessageLock 锁。
7. 如果MappedFile写满了，且启用了预热机制的情况下，就会调用 unlockMappedFile 解锁文件。这个其实是创建 MappedFile 的时候，如果启用了预热机制，就会提前把磁盘数据加载到内存区域，并调用mlock系统调用锁定 MappedFile 对应的内存区域。这里就是在写满 MappedFile 后，调用munlock系统调用解锁之前锁定的内存区域。这个我们讲 MappedFile 的时候再详细看。
8. 写入消息完了之后就是增加统计信息，统计topic写入次数以及写入消息总量等。
9. 最后就是同步提交 flush 请求和 replica 请求，就是强制刷盘，并将数据同步到 slave 节点，最后返回追加消息结果。

```java
public CompletableFuture<PutMessageResult> asyncPutMessage(final MessageExtBrokerInner msg) {
    // 设置存储时间戳
    msg.setStoreTimestamp(System.currentTimeMillis());
    // 设置消息体 crc32 校验和
    msg.setBodyCRC(UtilAll.crc32(msg.getBody()));

    // 消息诞生机器 IPv6 地址标识
    InetSocketAddress bornSocketAddress = (InetSocketAddress) msg.getBornHost();
    if (bornSocketAddress.getAddress() instanceof Inet6Address) {
        msg.setBornHostV6Flag();
    }
    // 消息存储机器 IPv6 地址标识
    InetSocketAddress storeSocketAddress = (InetSocketAddress) msg.getStoreHost();
    if (storeSocketAddress.getAddress() instanceof Inet6Address) {
        msg.setStoreHostAddressV6Flag();
    }

    // 获取线程副本中的消息编码器对消息编码
    PutMessageThreadLocal putMessageThreadLocal = this.putMessageThreadLocal.get();
    PutMessageResult encodeResult = putMessageThreadLocal.getEncoder().encode(msg);
    if (encodeResult != null) {
        return CompletableFuture.completedFuture(encodeResult);
    }

    // 设置消息编码后的 ByteBuffer
    msg.setEncodedBuff(putMessageThreadLocal.getEncoder().encoderBuffer);
    // 创建写入消息上下文
    PutMessageContext putMessageContext = new PutMessageContext(generateKey(putMessageThreadLocal.getKeyBuilder(), msg));

    // 写入消息返回结果
    AppendMessageResult result = null;
    MappedFile unlockMappedFile = null;
    // 写入消息时加锁
    putMessageLock.lock();
    try {
        // 获取 MappedFile
        MappedFile mappedFile = this.mappedFileQueue.getLastMappedFile();

        // 设置消息存储时间戳
        long beginLockTimestamp = this.defaultMessageStore.getSystemClock().now();
        msg.setStoreTimestamp(beginLockTimestamp);

        if (null == mappedFile || mappedFile.isFull()) {
            // 第一个文件的起始偏移量就是 0，参数 startOffset 起始偏移量
            mappedFile = this.mappedFileQueue.getLastMappedFile(0);
        }

        // 向 MappedFile 追加消息
        result = mappedFile.appendMessage(msg, this.appendMessageCallback, putMessageContext);
        switch (result.getStatus()) {
            case PUT_OK:
                break;
            case END_OF_FILE:  // 文件写满了
                unlockMappedFile = mappedFile;
                // 一个文件写满了之后，创建一个新的文件，继续写这条消息
                mappedFile = this.mappedFileQueue.getLastMappedFile(0);
                result = mappedFile.appendMessage(msg, this.appendMessageCallback, putMessageContext);
                break;
            case MESSAGE_SIZE_EXCEEDED:
                ......
            default:
                return CompletableFuture.completedFuture(new PutMessageResult(PutMessageStatus.UNKNOWN_ERROR, result));
        }
    } finally {
        // 释放锁
        putMessageLock.unlock();
    }

    // munlock 解锁文件
    if (null != unlockMappedFile && this.defaultMessageStore.getMessageStoreConfig().isWarmMapedFileEnable()) {
        this.defaultMessageStore.unlockMappedFile(unlockMappedFile);
    }

    // 消息写入结果
    PutMessageResult putMessageResult = new PutMessageResult(PutMessageStatus.PUT_OK, result);

    // Statistics
    StoreStatsService storeStatsService = this.defaultMessageStore.getStoreStatsService();
    storeStatsService.getSinglePutMessageTopicTimesTotal(msg.getTopic()).add(1);
    storeStatsService.getSinglePutMessageTopicSizeTotal(topic).add(result.getWroteBytes());

    // 每次写完一条消息后，就会提交 flush 请求和 replica 请求
    CompletableFuture<PutMessageStatus> flushResultFuture = submitFlushRequest(result, msg);
    CompletableFuture<PutMessageStatus> replicaResultFuture = submitReplicaRequest(result, msg);

    // 等待 flush 和 replica 请求完成
    return flushResultFuture.thenCombine(replicaResultFuture, (flushStatus, replicaStatus) -> {
        if (flushStatus != PutMessageStatus.PUT_OK) {
            putMessageResult.setPutMessageStatus(flushStatus);
        }
        if (replicaStatus != PutMessageStatus.PUT_OK) {
            putMessageResult.setPutMessageStatus(replicaStatus);
        }
        return putMessageResult;
    });
}
```

我们看消息编码的方法，可以看到消息是按如下顺序写入到一块 ByteBuffer 缓冲区中的，消息读取的时候也会按照这个顺序来读消息。

![](https://cdn.nlark.com/yuque/0/2024/webp/744990/1705397269379-d6ab19a6-1c75-4ec4-9e5a-dc661c59aee3.webp)

## 一个整数存多个标识

写入消息过程可以看到有如下两行代码，就是设置消息诞生和消息存储服务器IP地址是否为 IPv6 的标识。

```java
msg.setBornHostV6Flag();
msg.setStoreHostAddressV6Flag();
```

可以看到，这两个方法都是更新同一个整数 sysFlag，那么它是如何用一个整数存储多个标识的呢？

```java
private int sysFlag;

public void setStoreHostAddressV6Flag() { 
    this.sysFlag = this.sysFlag | MessageSysFlag.STOREHOSTADDRESS_V6_FLAG; 
}
public void setBornHostV6Flag() { 
    this.sysFlag = this.sysFlag | MessageSysFlag.BORNHOST_V6_FLAG; 
}
```

首先可以看到 MessageSysFlag 中有很多标识，如果每个标识都在消息中单独用一个字段来存，那么这条消息就会多出几十个字节，消息存储在磁盘文件中就会占用更多存储空间。所以这里用一个 int 整数就存了10几个标识，将节约很多存储空间。

```java
public class MessageSysFlag {
    /**
     * Meaning of each bit in the system flag
     *
     * | bit    | 7 | 6 | 5         | 4        | 3           | 2                | 1                | 0                |
     * |--------|---|---|-----------|----------|-------------|------------------|------------------|------------------|
     * | byte 1 |   |   | STOREHOST | BORNHOST | TRANSACTION | TRANSACTION      | MULTI_TAGS       | COMPRESSED       |
     * | byte 2 |   |   |           |          |             | COMPRESSION_TYPE | COMPRESSION_TYPE | COMPRESSION_TYPE |
     * | byte 3 |   |   |           |          |             |                  |                  |                  |
     * | byte 4 |   |   |           |          |             |                  |                  |                  |
     */
    public final static int COMPRESSED_FLAG = 0x1;
    public final static int MULTI_TAGS_FLAG = 0x1 << 1;
    public final static int TRANSACTION_NOT_TYPE = 0;
    public final static int TRANSACTION_PREPARED_TYPE = 0x1 << 2;
    public final static int TRANSACTION_COMMIT_TYPE = 0x2 << 2;
    public final static int TRANSACTION_ROLLBACK_TYPE = 0x3 << 2;
    public final static int BORNHOST_V6_FLAG = 0x1 << 4;
    public final static int STOREHOSTADDRESS_V6_FLAG = 0x1 << 5;
    public final static int COMPRESSION_LZ4_TYPE = 0x1 << 8;
    public final static int COMPRESSION_ZSTD_TYPE = 0x2 << 8;
    public final static int COMPRESSION_ZLIB_TYPE = 0x3 << 8;
    public final static int COMPRESSION_TYPE_COMPARATOR = 0x7 << 8;
}
```

一个 int 占4个字节，也就是 32 个bit位，从 MessageSysFlag 的注释也可以了解到，定义的每个标识都对应到这个整数二进制的某个位置。再结合前面的代码可以看出，在设置标识时，就是通过对整数异或(|)的方式将标识设置到二进制位上，也就是对应位置设置为 1。

反之，对这个整数与(&)就可以读取出这个标识。

```java
int bornhostLength = (sysFlag & MessageSysFlag.BORNHOST_V6_FLAG) == 0 ? 8 : 20;
int storehostAddressLength = (sysFlag & MessageSysFlag.STOREHOSTADDRESS_V6_FLAG) == 0 ? 8 : 20;
```

RocketMQ 中类似的用一个整数来存储多种标识、状态的地方有很多，比如[基于Netty的网络服务器](https://juejin.cn/post/7115707196142256158)这篇文章中就介绍了通信协议中用一个 int 型整数来存储请求头的长度和序列化类型两个状态。

## 写入消息锁

来看下写入消息锁 PutMessageLock，它只是提供了 lock 和 unlock 两个接口。

```java
public interface PutMessageLock {
    void lock();

    void unlock();
}
```

在创建写入消息锁的时候，会根据配置 useReentrantLockWhenPutMessage 来决定具体的类型，这个值默认是 true。

```java
this.putMessageLock = defaultMessageStore.getMessageStoreConfig().isUseReentrantLockWhenPutMessage() 
? new PutMessageReentrantLock() : new PutMessageSpinLock();
```

也就是默认情况下会使用 PutMessageReentrantLock，可以看到它其实就是代理 ReentrantLock 的实现。

```java
public class PutMessageReentrantLock implements PutMessageLock {
    private ReentrantLock putMessageNormalLock = new ReentrantLock(); // NonfairSync

    @Override
    public void lock() {
        putMessageNormalLock.lock();
    }

    @Override
    public void unlock() {
        putMessageNormalLock.unlock();
    }
}
```

另一种类型就是 PutMessageSpinLock，这个锁是通过 AtomicBoolean 的 CAS（Compare-And-Swap） 机制来实现的，CAS 会保证只有一个线程能设置成功。释放锁的时候，将 AtomicBoolean 设置为 true；加锁的时候，就会一直循环，直到能将 AtomicBoolean 从 true 改为 false，且只有一个线程能成功，其它线程就会一直轮询。

```java
public class PutMessageSpinLock implements PutMessageLock {
    private AtomicBoolean putMessageSpinLock = new AtomicBoolean(true);

    @Override
    public void lock() {
        boolean flag;
        do {
            flag = this.putMessageSpinLock.compareAndSet(true, false);
        }
        while (!flag);
    }

    @Override
    public void unlock() {
        this.putMessageSpinLock.compareAndSet(false, true);
    }
}
```

这里我们需要思考的是，它为什么要提供一种 CAS 的实现？

CAS 提供了一种乐观锁的机制，允许多个线程同时尝试修改共享变量，只有一个线程会成功。CAS 是一种非阻塞的并发控制方式，不会引起线程的阻塞，适用于高并发的情况。所以 CAS 操作通常比使用锁更高效，因为它避免了线程的阻塞和唤醒操作。

但 CAS 在失败时需要自旋重试（while循环），如果在竞争激烈的情况下，多个线程可能会不断尝试CAS操作，自旋次数可能会过多，导致大量的CPU自旋时间，浪费了CPU资源。而且 CAS 还有 ABA 的问题。

所以 CAS 是适用于高并发、低竞争的场景。这个配置可以根据我们的系统写入消息的并发度来配置，如果消息写入的并发并不是很高，就可以使用 CAS 版本的锁来提升写锁的性能。

# MappedFile

## MappedFileQueue

CommitLog 写入消息就是在将消息追加到 MappedFile 中，MappedFile 是 RocketMQ 对磁盘文件的一个抽象。而 MappedFileQueue 是一个目录的抽象对象，可以看出就是 MappedFile 的集合。

MappedFileQueue 用一个 CopyOnWriteArrayList 队列来存储目录下的文件映射对象 MappedFile。CopyOnWriteArrayList 就是采用COW的模式，即写时复制来保证集合的并发安全，对于读多写少的场景是很合适的。

```java
public class MappedFileQueue {
    // CommitLog 存储文件路径
    private final String storePath;
    // 映射文件大小，默认 1G
    protected final int mappedFileSize;
    // 所有的映射文件
    protected final CopyOnWriteArrayList<MappedFile> mappedFiles = new CopyOnWriteArrayList<MappedFile>();
    // 映射文件分配服务
    private final AllocateMappedFileService allocateMappedFileService;

    // 刷新位置
    protected long flushedWhere = 0;
    // 提交位置
    private long committedWhere = 0;
    // 存储时间
    private volatile long storeTimestamp = 0;

    public MappedFileQueue(final String storePath, int mappedFileSize, AllocateMappedFileService allocateMappedFileService) {
        this.storePath = storePath;
        this.mappedFileSize = mappedFileSize;
        this.allocateMappedFileService = allocateMappedFileService;
    }
}
```

CommitLog 中通过 getLastMappedFile 方法获取最后一个 MappedFile。

如果 MappedFileQueue 中还没有 MappedFile，或者最后一个文件写满了，就会尝试新建一个 MappedFile。

```java
public MappedFile getLastMappedFile() {
    MappedFile mappedFileLast = null;
    if (!this.mappedFiles.isEmpty()) {
        mappedFileLast = this.mappedFiles.get(this.mappedFiles.size() - 1);
    }
    return mappedFileLast;
}

public MappedFile getLastMappedFile(final long startOffset) {
    return getLastMappedFile(startOffset, true);
}

public MappedFile getLastMappedFile(final long startOffset, boolean needCreate) {
    long createOffset = -1;
    MappedFile mappedFileLast = getLastMappedFile();
    if (mappedFileLast == null) {
        createOffset = startOffset - (startOffset % this.mappedFileSize);
    }
    if (mappedFileLast != null && mappedFileLast.isFull()) {
        createOffset = mappedFileLast.getFileFromOffset() + this.mappedFileSize;
    }
    // 创建新的 MappedFile
    if (createOffset != -1 && needCreate) {
        return tryCreateMappedFile(createOffset);
    }
    return mappedFileLast;
}
```

创建 MappedFile 的时候，会根据起始偏移量计算文件名，文件名默认是20位长度，不足前面补0。从这可以看出，MappedFile 映射的文件名就是该文件中数据的起始偏移量。比如 commitlog 文件的大小默认是 1GB，第一个 commitlog 文件的起始偏移量是 0，那么第一个 commitlog 的文件名就是 00000000000000000000，第二个 commitlog 文件的文件名就是 00000000001073741824。

```java
protected MappedFile tryCreateMappedFile(long createOffset) {
String nextFilePath = this.storePath + File.separator + UtilAll.offset2FileName(createOffset);
String nextNextFilePath = this.storePath + File.separator + UtilAll.offset2FileName(createOffset + this.mappedFileSize);
// 创建下一个和下下一个 MappedFile
return doCreateMappedFile(nextFilePath, nextNextFilePath);
}

public static String offset2FileName(final long offset) {
    final NumberFormat nf = NumberFormat.getInstance();
    nf.setMinimumIntegerDigits(20);
    nf.setMaximumFractionDigits(0);
    nf.setGroupingUsed(false);
    return nf.format(offset);
}
```

![](https://cdn.nlark.com/yuque/0/2024/webp/744990/1705397269815-8dba4b62-c52c-4ea7-8d11-ed725149d62c.webp)

如果创建 MappedFileQueue 的时候传入了 AllocateMappedFileService 组件，就会用 AllocateMappedFileService 来创建 MappedFile，而且是一次创建两个连续的 MappedFile，这样的目的应该是提前预分配好，避免频繁分配MappedFile。如果没有传入 AllocateMappedFileService，就会直接创建 MappedFile。创建完 MappedFile 后，如果是第一个文件，就会设置其第一个创建的属性，然后添加到 COW 队列。

```java
protected MappedFile doCreateMappedFile(String nextFilePath, String nextNextFilePath) {
    MappedFile mappedFile = null;

    if (this.allocateMappedFileService != null) {
        mappedFile = this.allocateMappedFileService.putRequestAndReturnMappedFile(nextFilePath,
                                                                                  nextNextFilePath, this.mappedFileSize);
    } else {
        mappedFile = new MappedFile(nextFilePath, this.mappedFileSize);
    }

    if (mappedFile != null) {
        if (this.mappedFiles.isEmpty()) {
            mappedFile.setFirstCreateInQueue(true);
        }
        this.mappedFiles.add(mappedFile);
    }
    return mappedFile;
}
```

## AllocateMappedFileService

前面提到，MappedFileQueue 创建时，如果传入了 AllocateMappedFileService，即 MappedFile 分配服务，就会通过它来创建 MappedFile。

**1、提交分配MappedFile请求**

AllocateMappedFileService 内主要有一个 requestTable 表和 requestQueue 的优先级阻塞队列，里面的对象都是 AllocateRequest。

```java
public class AllocateMappedFileService extends ServiceThread {
    // 分配请求映射表
    private final ConcurrentMap<String, AllocateRequest> requestTable = new ConcurrentHashMap<>();
    // 分配请求优先级队列
    private final PriorityBlockingQueue<AllocateRequest> requestQueue = new PriorityBlockingQueue<>();
}
```

我们看 CommitLog 调用的 putRequestAndReturnMappedFile 方法来获取 MappedFile。这个方法是支持创建两个连续的 MappedFile 的。

1. 首先 canSubmitRequests=2 表明要提交两个创建 MappedFile 的请求。
2. 如果开启了瞬时存储池化技术，可以提交的请求数还要根据池子中的Buffer数量变化。在当前Broker是Master节点的情况下，可以提交请求的数量 = 池子里可用的Buffer数量 - 请求队列 requestQueue 中的数量。也就是总的 MappedFile 数量不会超过池子中 Buffer 的数量。
3. 接着就根据分配的文件路径和文件大小创建一个分配请求 AllocateRequest，并放入请求表 requestTable 中。使用 putIfAbsent 就是保证同一路径不会重复分配创建。
4. 接着可以看到，在开启瞬时存储池化技术时，如果存储池Buffer不够了，不能够提交一个分配请求了，就直接移除这个请求，返回 null。如果足够，就会将这个分配请求添加到 requestQueue 队列中；能分配的请求数量也会减一。
5. 接着就是同样的方式创建下一个分配请求，这就是预分配机制，提前创建好 MappedFile。
6. 分配请求提交到队列之后，之后就是从请求表 requestTable 中获取第一个文件的分配请求，开始等待它的分配。如果等待超时还没分配好（默认5秒），就返回 null；如果分配成功，就移除分配请求，并返回创建好的 MappedFile。

```java
public MappedFile putRequestAndReturnMappedFile(String nextFilePath, String nextNextFilePath, int fileSize) {
    int canSubmitRequests = 2;
    // 启用了瞬时存储池化技术（默认不开启）
    if (this.messageStore.getMessageStoreConfig().isTransientStorePoolEnable()) {
        if (BrokerRole.SLAVE != this.messageStore.getMessageStoreConfig().getBrokerRole()) {
            canSubmitRequests = this.messageStore.getTransientStorePool().availableBufferNums() - this.requestQueue.size();
        }
    }

    // 创建分配请求
    AllocateRequest nextReq = new AllocateRequest(nextFilePath, fileSize);
    boolean nextPutOK = this.requestTable.putIfAbsent(nextFilePath, nextReq) == null;
    if (nextPutOK) {
        if (canSubmitRequests <= 0) {
            log.warn("[NOTIFYME]TransientStorePool is not enough, so create mapped file error, " +
                     "RequestQueueSize : {}, StorePoolSize: {}", this.requestQueue.size(), this.messageStore.getTransientStorePool().availableBufferNums());
            this.requestTable.remove(nextFilePath);
            return null;
        }
        // 可以提交请求，将请求放入队列
        boolean offerOK = this.requestQueue.offer(nextReq);
        canSubmitRequests--;
    }

    // 下下个文件（预分配机制）
    AllocateRequest nextNextReq = new AllocateRequest(nextNextFilePath, fileSize);
    boolean nextNextPutOK = this.requestTable.putIfAbsent(nextNextFilePath, nextNextReq) == null;
    if (nextNextPutOK) {
        if (canSubmitRequests <= 0) {
            this.requestTable.remove(nextNextFilePath);
        } else {
            boolean offerOK = this.requestQueue.offer(nextNextReq);
        }
    }

    // 从队列取出请求
    AllocateRequest result = this.requestTable.get(nextFilePath);
    boolean waitOK = result.getCountDownLatch().await(waitTimeOut, TimeUnit.MILLISECONDS);
    if (!waitOK) {
        return null;
    } else {
        this.requestTable.remove(nextFilePath);
        return result.getMappedFile();
    }
}
```

AllocateRequest 包含如下属性，其中 CountDownLatch 就是用来等待分配完成的并发工具。

CountDownLatch 有两个主要操作：countDown() 和 await()。await 已经有地方调用了，那么必然就还有其它地方会调用 countDown() 方法。

```java
AllocateRequest {
    // MappedFile 映射的磁盘文件路径
    private String filePath;
    // 磁盘文件大小
    private int fileSize;
    // 并发控制组件
    private CountDownLatch countDownLatch = new CountDownLatch(1);
    // 分配的 MappedFile
    private volatile MappedFile mappedFile = null;
}
```

**2、独立线程创建 MappedFile**

AllocateMappedFileService 继承自 ServiceThread，说明它也是一个线程组件，会有一个 Runnable 来执行线程任务。可以看到它的 run() 方法里就是在循环执行 mmapOperation() 方法，这个方法就是在执行具体的分配请求，创建 MappedFile。

1. 首先从请求队列 requestQueue 中取出第一个分配请求 AllocateRequest，创建 MappedFile 对象；如果启用了瞬时存储池化技术，就会传入池子对象。
2. 接下来会看是否启用预热机制，如果开启了预热机制，则会初始化 MappedFile 关联的 ByteBuffer 区域，对其进行一个预热的操作。这块我们后面再看。
3. 最后就是将创建成功的 MappedFile 设置回 AllocateRequest 中；并在 finally 中通过其 CountDownLatch 的 countDown() 操作来通知 MappedFile 已经创建成功，这就和上面对应上了。

```java
public void run() {
    while (!this.isStopped() && this.mmapOperation()) {
    }
}
private boolean mmapOperation() {
    AllocateRequest req = null;
    try {
        req = this.requestQueue.take();
        // 开始分配 MappedFile
        if (req.getMappedFile() == null) {
            long beginTime = System.currentTimeMillis();

            // 创建 MappedFile
            MappedFile mappedFile;
            if (messageStore.getMessageStoreConfig().isTransientStorePoolEnable()) {
                mappedFile = new MappedFile(req.getFilePath(), req.getFileSize(), messageStore.getTransientStorePool());
            } else {
                mappedFile = new MappedFile(req.getFilePath(), req.getFileSize());
            }

            // ByteBuffer 预热机制
            if (this.messageStore.getMessageStoreConfig().isWarmMapedFileEnable()) {
                mappedFile.warmMappedFile(this.messageStore.getMessageStoreConfig().getFlushDiskType(),// 刷盘类型
                                          this.messageStore.getMessageStoreConfig().getFlushLeastPagesWhenWarmMapedFile());
            }

            req.setMappedFile(mappedFile);
        }
    } finally {
        if (req != null)
            // 通知 MappedField 构建完毕
            req.getCountDownLatch().countDown();
    }
    return true;
}
```

## TransientStorePool

来看一下瞬时存储池TransientStorePool的设计。它在创建时池子大小默认是 5，文件大小默认为 commitlog 文件大小（1GB），也就是说这是专门针对 commitlog 的池子。然后用一个Deque双端队列来存储预分配的ByteBuffer对象，这个瞬时存储池的对象就是 ByteBuffer。

然后它的初始化方法 init() 中，会循环分配出5块 ByteBuffer，最后将这块ByteBuffer放入队列中，等待使用。

还可以看到分配出来的 ByteBuffer 会被系统调用 mlock 锁定，这其实就提供一种内存锁定，将当前堆外内存一直锁定在内存中，避免被进程将内存交换到磁盘。而与之对应的，在程序下线时，会在 destroy 方法中调用 munlock 系统调用释放这块内存锁定。

```java
public class TransientStorePool {
    private final int poolSize;
    private final int fileSize;
    private final Deque<ByteBuffer> availableBuffers;
    private final MessageStoreConfig storeConfig;

    public TransientStorePool(final MessageStoreConfig storeConfig) {
        this.storeConfig = storeConfig;
        // 默认5个
        this.poolSize = storeConfig.getTransientStorePoolSize();
        // CommitLog 文件大小1G
        this.fileSize = storeConfig.getMappedFileSizeCommitLog();
        this.availableBuffers = new ConcurrentLinkedDeque<>();
    }

    public void init() {
        for (int i = 0; i < poolSize; i++) {
            ByteBuffer byteBuffer = ByteBuffer.allocateDirect(fileSize);

            final long address = ((DirectBuffer) byteBuffer).address();
            Pointer pointer = new Pointer(address);
            LibC.INSTANCE.mlock(pointer, new NativeLong(fileSize));

            availableBuffers.offer(byteBuffer);
        }
    }
}
```

TransientStorePool 提供了获取 ByteBuffer、归还 ByteBuffer、以及获取可用ByteBuffer数量的方法。

```java
public void returnBuffer(ByteBuffer byteBuffer) {
// 缓冲区复位
byteBuffer.position(0);
byteBuffer.limit(fileSize);
this.availableBuffers.offerFirst(byteBuffer);
}

public ByteBuffer borrowBuffer() {
    ByteBuffer buffer = availableBuffers.pollFirst();
    if (availableBuffers.size() < poolSize * 0.4) { // 数量小于2/5时给个警告
        log.warn("TransientStorePool only remain {} sheets.", availableBuffers.size());
    }
    return buffer;
}

public int availableBufferNums() {
    if (storeConfig.isTransientStorePoolEnable()) {
        return availableBuffers.size();
    }
    return Integer.MAX_VALUE;
}
```

TransientStorePool 的开启条件为：启用了瞬时存储池化技术，且刷盘策略为异步刷盘，且当前为Master节点。

```java
public boolean isTransientStorePoolEnable() {
    return transientStorePoolEnable && FlushDiskType.ASYNC_FLUSH == getFlushDiskType()
    && BrokerRole.SLAVE != getBrokerRole();
}
```

## ByteBuffer 对象池

**1、为何要池化 ByteBuffer**

可以看出，TransientStorePool 就是池化 ByteBuffer 对象，在高性能、高并发的场景中，将 ByteBuffer 对象池化是一种常见的做法，它能带来如下一些好处。

- _减少内存分配开销_：allocateDirect() 分配的堆外内存对象相对较昂贵，因为涉及到与操作系统的交互。通过池化，可以减少频繁的内存分配和释放，从而降低了内存分配的开销。
- _提高性能_：避免频繁的内存分配和垃圾回收可以显著提高应用程序的性能，这对于需要处理大量数据或高并发的情况尤其重要。
- _避免内存碎片_：在分配和释放大量 ByteBuffer 对象时，可能会导致堆外内存碎片。通过池化，可以更有效地重复使用已分配的内存块，从而减少了碎片化问题。
- _控制内存使用_：通过限制池中的对象数量，可以控制应用程序使用的总内存量，防止内存泄漏或过度消耗内存。
- _提高资源利用率_：由于池化的对象可以重复使用，因此资源利用率更高。这在某些情况下可以降低系统负载，因为不需要频繁地请求新的内存块。

但ByteBuffer池化并不适用于所有场景，只有在需要高性能和低延迟的场景下才会带来显著的性能优势，所以 TransientStorePool 默认是不开启的。

**2、堆外内存**

最后需要注意 TransientStorePool 中的 ByteBuffer 是使用 ByteBuffer.allocateDirect() 方法分配出来的。我们会在 RocketMQ 其它地方看到很多用 ByteBuffer.allocate() 分配 ByteBuffer 的。

那么我们需要了解下它们的区别。

_allocate()：_

- allocate 使用 JVM 的堆内存来分配空间，这意味着数据存储在 Java 堆上，分配的内存将由 Java 垃圾回收器自动回收，你不需要手动释放它。
- allocate 适用于相对小型的数据对象，可以受到 Java 垃圾回收的好处。
- allocate 分配的是JVM堆内内存，因此在不同的平台和 JVM 实现之间具有更好的可移植性。相比之下，allocateDirect 分配的堆外内存可能会受到底层操作系统和 JVM 实现的限制。

_allocateDirect()：_

- allocateDirect 使用操作系统的本机堆外内存 (Native Memory) 分配空间，这些内存块不受Java垃圾回收的管理，它们在 Java 堆之外，由操作系统直接管理。由于不受垃圾回收器的干扰，从而也减少了不可预测的垃圾回收暂停。
- allocateDirect 分配的内存不受 Java 垃圾回收的管理，因此需要手动调用 ByteBuffer 对象的 cleaner() 方法，并在不再需要该内存时手动释放它。这使得内存管理更加复杂，但也提供了更多的控制。
- allocateDirect 创建的 ByteBuffer 对象直接映射到本机内存，因此在读取和写入数据时通常比 allocate 分配的对象更快。所以它更适用于高性能、大数据量、频繁进行I/O操作的场景，例如网络编程或处理大型文件。

## MappedFile

CommitLog 的消息最后就是追加到 MappedFile 中，这节我们就来初步看下 MappedFile 的设计以及消息写入。

MappedFile 继承自 ReferenceResource，看名字就知道是一个引用计数组件，用来对 MappedFile 使用的引用。

MappedFile 有如下属性，看属性就大概知道其功能：

- 通过三个 AtomicInteger 类型的 wrotePosition、committedPosition、flushedPosition 来表示数据的写入位置、提交位置、刷盘位置。这块我们后面讲刷盘机制这块的时候再一起看。
- 然后是关联文件的一些属性：文件大小、名称、起始偏移量、File 对象，是否第一次创建到 MappedFileQueue 队列等
- 最后是读写文件相关的 FileChannel、writeBuffer、mappedByteBuffer。

```java
public class MappedFile extends ReferenceResource {
    public static final int OS_PAGE_SIZE = 1024 * 4;
    // 写入位置
    protected final AtomicInteger wrotePosition = new AtomicInteger(0);
    // 提交位置
    protected final AtomicInteger committedPosition = new AtomicInteger(0);
    // flush 位置
    private final AtomicInteger flushedPosition = new AtomicInteger(0);

    // 文件大小
    protected int fileSize;
    // 文件名
    private String fileName;
    // 文件从哪个偏移量开始
    private long fileFromOffset;
    // 文件
    private File file;

    // FileChannel
    protected FileChannel fileChannel;
    // 写缓冲区
    protected ByteBuffer writeBuffer = null;
    // 磁盘内存映射字节数据
    private MappedByteBuffer mappedByteBuffer;

    // 存储时间戳
    private volatile long storeTimestamp = 0;
    // 是否第一次创建到队列
    private boolean firstCreateInQueue = false;
}
```

接下来看 MappedFile 的初始化过程。

1. MappedFile 有两个构造方法，在开启瞬时存储池化技术时，则会传入 TransientStorePool，可以看到这里就会从池子里取一个 ByteBuffer 赋值给 writeBuffer，就是写缓冲区。
2. 接着看 init() 方法，可以看到 fileSize 就是传入的文件大小，commitlog 就是1GB。然后会关联磁盘中的文件，比如 commitlog，创建一个 File 对象。
3. 通过第16行代码可以知道，MappedFile 起始偏移量就是文件的名字。一个文件写满之后，就会创建一个新的文件来继续写，那么文件的名字对应着起始偏移量。以commitlog为例，一个完整的 CommitLog 会拆分为多个 MappedFile，不断的写入消息，偏移量会不断的增长，会不断的拆分出一个个 MappedFile，每个磁盘文件的文件名称，都是 CommitLog 里面某一个位置的偏移量。用写入到的一个偏移量位置作为一个新的 MappedFile 文件名称，所以在这里会对文件名称进行 long 型数据的转化。第一个commitlog文件的名字是 00000000000000000000，它的意思就是这个commitlog文件的起始偏移量是 0。
4. 之后构建了随机读写文件 RandomAccessFile，拿到了NIO的文件通道 FileChannel，后面就是通过这个来完成磁盘文件数据的写入和读取。FileChannel 是 Java NIO 库中的关键组件，用于高效处理文件 I/O 操作。其支持高效数据传输、随机访问、内存映射、锁定文件区域、通道之间数据传输、非阻塞模式和异步 I/O、并发控制等，是高并发场景下快速读写文件不可或缺的工具。
5. 接着通过 FileChannel.map 函数把磁盘文件做一个内存映射，映射到内存区域里，拿到 MappedByteBuffer，使用 MappedByteBuffer 就可以在内存中进行更高效的读写操作。注意 FileChannel.map() 返回的 MappedByteBuffer 对象使用的是堆外内存，也就是直接映射到本机内存的内存。

```java
public MappedFile(final String fileName, final int fileSize) throws IOException {  
    init(fileName, fileSize);  
}
public MappedFile(final String fileName, final int fileSize,
                  final TransientStorePool transientStorePool) throws IOException {
    this.writeBuffer = transientStorePool.borrowBuffer();
    this.transientStorePool = transientStorePool;
    init(fileName, fileSize);
}

private void init(final String fileName, final int fileSize) throws IOException {
    this.fileName = fileName;
    this.fileSize = fileSize;

    this.file = new File(fileName);
    this.fileFromOffset = Long.parseLong(this.file.getName());
    // 确保父目录存在
    ensureDirOK(this.file.getParent());

    this.fileChannel = new RandomAccessFile(this.file, "rw").getChannel();
    this.mappedByteBuffer = this.fileChannel.map(MapMode.READ_WRITE, 0, fileSize);
}
```

## 写入消息

单条消息或是批量消息写入最终都会调用 MappedFile 的 appendMessagesInner 方法。

1. 先获取消息的写入位置，写入位置必须小于文件大小
2. 接着获取要写入的缓冲区 ByteBuffer，如果启用了瞬时存储池化技术，就会用到 MappedFile 创建时绑定的写入缓冲区 writeBuffer。否则，就使用 MMAP 映射出来的 mappedByteBuffer。然后通过 ByteBuffer 的 slice() 方法得到写入缓冲区的一个视图。再设置写缓冲区的开始写入位置。
3. 之后就是追加消息，可以看到写入消息是在 AppendMessageCallback 中完成的，其实就回到了 CommitLog 中。
4. 最后，更新当前的写入位置加上当前写入的总字节数。以及更新最新的存储时间戳。

```java
public AppendMessageResult appendMessagesInner(
    final MessageExt messageExt, // 消息
    final AppendMessageCallback cb, // 消息写入后的回调
    PutMessageContext putMessageContext) {
    int currentPos = this.wrotePosition.get();
    if (currentPos < this.fileSize) {
        // 写缓冲区
        ByteBuffer byteBuffer = writeBuffer != null ? writeBuffer.slice() : this.mappedByteBuffer.slice();
        // 写位置
        byteBuffer.position(currentPos);

        AppendMessageResult result;
        // 单条消息
        if (messageExt instanceof MessageExtBrokerInner) {
            result = cb.doAppend(this.getFileFromOffset(), byteBuffer, this.fileSize - currentPos,
                                 (MessageExtBrokerInner) messageExt, putMessageContext);
        }
            // 批量消息
        else if (messageExt instanceof MessageExtBatch) {
            result = cb.doAppend(this.getFileFromOffset(), byteBuffer, this.fileSize - currentPos,
                                 (MessageExtBatch) messageExt, putMessageContext);
        }

        // 更新写入位置
        this.wrotePosition.addAndGet(result.getWroteBytes());
        // 存储时间戳
        this.storeTimestamp = result.getStoreTimestamp();
        return result;
    }
    return new AppendMessageResult(AppendMessageStatus.UNKNOWN_ERROR);
}
```

我们以 DefaultAppendMessageCallback 追加单条消息为例来看下消息是如何追加到写缓冲区的。

CommitLog 在创建 DefaultAppendMessageCallback 时传入了消息的默认大小为 4MB，也就是说消息的总大小不能超过 4MB。然后其构造方法中创建了一个 4 + 4 字节的 ByteBuffer，看注释意思就是文件末尾会写入的两个 int 值。

doAppend 方法一共有 5 个参数：

- fileFromOffset：文件起始偏移量，其实就是文件的名字对应的值
- byteBuffer：MappedFile 中传入的 写缓冲区
- maxBlank：MappedFile 文件空闲大小
- msgInner：要追加的消息
- putMessageContext：写入消息上下文

再来看消息追加的流程，其中我省略了多路分发与事务相关的代码，这个后面再做研究。

1. 首先计算 写入偏移量 = 文件的偏移量 + 写缓冲区的写入位置，这就可以定位到磁盘文件物理偏移量位置。
2. 然后计算 消息ID = ip+port+wroteOffset，注意是消息存储机器的IP端口。
3. 然后记录消息存入的主题队列（topic-queueId）偏移量，初始值 offset=0，可以看到最后消息追加成功后会自增1。
4. 接着从 msgInner 中拿到之前的消息编码 ByteBuffer，其第一个 int 是存储的消息总长度。接下来就会判断消息总长度 + 预留的 4+4 字节是否大于文件空闲大小，如果大于了，则说明这个文件写满了，不能继续写入消息。可以看到就会向 msgStoreItemMemory 写入预留信息，第一个 int 写入文件空闲大小，第二个 int 写入一个固定的空闲魔数编码。然后将 msgStoreItemMemory 写入 MappedFile 的写缓冲区，其实就表示这个文件已经写满消息了。然后返回文件已经写满的结果（END_OF_FILE），这个之前分析 CommitLog 写入消息时就知道了，如果返回了 END_OF_FILE 就会创建一个新的 MappedFile 继续写入消息。从这里也可以看出，一条消息是不会跨文件存储的，如果一个文件的空余空间不足以写入这条消息，就会创建一个新的 MappedFile 去写入。
5. 如果文件剩余空间足够，接下来会向消息 ByteBuffer 中写入一些信息，注意这里是和之前消息编码是一一对应的，包括要写入的队列偏移量、物理偏移量等都是之前预留好了位置的。
6. 在最后，就是将消息编码的 ByteBuffer 写入 MappedFile 的写缓冲区 ByteBuffer，并返回写入成功的结果（PUT_OK）。然后消息主体队列的偏移量自增1。

```java
class DefaultAppendMessageCallback implements AppendMessageCallback {
    // 文件末尾有一个空白区: int + int
    private static final int END_FILE_MIN_BLANK_LENGTH = 4 + 4;
    // 消息存储条目缓冲区
    private final ByteBuffer msgStoreItemMemory;
    // 消息最大长度，默认4MB
    private final int maxMessageSize;

    DefaultAppendMessageCallback(final int size) {
        this.msgStoreItemMemory = ByteBuffer.allocate(END_FILE_MIN_BLANK_LENGTH);
        this.maxMessageSize = size;
    }

    public AppendMessageResult doAppend(final long fileFromOffset, final ByteBuffer byteBuffer,
                                        final int maxBlank, final MessageExtBrokerInner msgInner, PutMessageContext putMessageContext) {
        // 物理偏移量
        long wroteOffset = fileFromOffset + byteBuffer.position();

        // 消息ID为：ip+port+wroteOffset
        Supplier<String> msgIdSupplier = () -> {
            int msgIdLen = (msgInner.getSysFlag() & MessageSysFlag.STOREHOSTADDRESS_V6_FLAG) == 0 ? 4 + 4 + 8 : 16 + 4 + 8;
            ByteBuffer msgIdBuffer = ByteBuffer.allocate(msgIdLen);
            MessageExt.socketAddress2ByteBuffer(msgInner.getStoreHost(), msgIdBuffer);
            msgIdBuffer.putLong(msgIdLen - 8, wroteOffset);
            return UtilAll.bytes2string(msgIdBuffer.array());
        };

        // 记录队列偏移量
        String key = putMessageContext.getTopicQueueTableKey();
        Long queueOffset = CommitLog.this.topicQueueTable.get(key);
        if (null == queueOffset) {
            queueOffset = 0L;
            CommitLog.this.topicQueueTable.put(key, queueOffset);
        }

        // 消息内容
        ByteBuffer preEncodeBuffer = msgInner.getEncodedBuff();
        // 开始4字节标识消息长度
        final int msgLen = preEncodeBuffer.getInt(0);

        // 消息长度超过了文件空闲大小（异常情况）
        if ((msgLen + END_FILE_MIN_BLANK_LENGTH) > maxBlank) {
            this.msgStoreItemMemory.clear();
            // 1 TOTALSIZE  总大小
            this.msgStoreItemMemory.putInt(maxBlank);
            // 2 MAGICCODE  魔数
            this.msgStoreItemMemory.putInt(CommitLog.BLANK_MAGIC_CODE);
            // 写入缓冲区
            byteBuffer.put(this.msgStoreItemMemory.array(), 0, 8);
            // 返回超出文件大小的结果
            return new AppendMessageResult(AppendMessageStatus.END_OF_FILE, wroteOffset, maxBlank,
                                           msgIdSupplier, msgInner.getStoreTimestamp(), queueOffset);
        }

        // 1.TOTALSIZE + 2.MAGICCODE + 3.BODYCRC + 4.QUEUEID + 5.FLAG
        int pos = 4 + 4 + 4 + 4 + 4;
        // 6.QUEUEOFFSET  queue 对应的偏移量
        preEncodeBuffer.putLong(pos, queueOffset);
        pos += 8;
        // 7.PHYSICALOFFSET  物理偏移量
        preEncodeBuffer.putLong(pos, fileFromOffset + byteBuffer.position());
        int ipLen = (msgInner.getSysFlag() & MessageSysFlag.BORNHOST_V6_FLAG) == 0 ? 4 + 4 : 16 + 4;
        // 8.SYSFLAG, 9.BORNTIMESTAMP, 10.BORNHOST, 11.STORETIMESTAMP
        pos += 8 + 4 + 8 + ipLen;
        // 更新存储时间戳
        preEncodeBuffer.putLong(pos, msgInner.getStoreTimestamp());

        // 消息写入队列buffer（追加消息）
        byteBuffer.put(preEncodeBuffer);
        // 清空关联的 ByteBuffer
        msgInner.setEncodedBuff(null);
        
        // 追加消息成功
        AppendMessageResult result = new AppendMessageResult(AppendMessageStatus.PUT_OK, wroteOffset, msgLen, 
                    msgIdSupplier, msgInner.getStoreTimestamp(), queueOffset);
        // 更新主题队列偏移量
        CommitLog.this.topicQueueTable.put(key, ++queueOffset);
        return result;
    }
}
```

## ByteBuffer 切片

ByteBuffer 的 slice() 切片操作是用于创建一个新的 ByteBuffer（视图），该新 ByteBuffer 与原始 ByteBuffer 共享同一底层数据数组（byte[]），但具有自己的位置、限制和容量。这样可以在原始 ByteBuffer 和切片之间共享数据，同时在每个 ByteBuffer 上保持不同的读写位置。

slice() 操作返回的 ByteBuffer 的 position=0，limit/capcity = 原始 ByteBuffer 的剩余大小。比如原始 ByteBuffer 的 limit/capatity=12，position=4，那么 slice() 返回来的 ByteBuffer 的 position=0，limit/capacity = 12-4 = 8。ByteBuffer 还有一个 offset 来表示自己相对于底层数组的偏移量，原始 buffer 的 offset=0，新 buffer 的 offset=原始buffer 的 position，也就是说新 buffer 写入数据是从 offset 位置开始写的。

![](https://cdn.nlark.com/yuque/0/2024/webp/744990/1705397269907-ed61c0dd-036f-432a-8c6a-03c0aa6f5a6e.webp)

因为 slice() 得到的新 buffer 和原 buffer 共享同一底层数组，而且它对底层数组的起始偏移量是原始的 position，所以，对新 buffer 的写操作会追加到原 buffer，但原 buffer 的 position 不会发生变化，如果原 buffer 继续写入数据就会覆盖新 buffer 写入的数据。

![](https://cdn.nlark.com/yuque/0/2024/webp/744990/1705397269841-91707cb0-8636-45c4-b457-5262898a6644.webp)

回过头来看 MappedFile 中的 writeBuffer 和 mappedByteBuffer，会发现所有的读写操作都不会直接操作原始的 writeBuffer 和 mappedByteBuffer，直接操作原始的 buffer 就会改变它的 position。所以每次都是通过 slice() 切片得到一个新的 ByteBuffer，再来读写这个新 buffer。由于原 buffer 的 position=0，所以新 buffer 的 position 和 offset 也都是 0，因此通过 slice() 得到的新 buffer 每次都是完整映射了整个底层数组。

所以可以看到，MappedFile 中有一个 wrotePosition 来表示写入的位置，slice() 得到的新ByteBuffer也不能直接从0开始写数据，那样会将之前的数据覆盖，所以每次都会先设置当前写入的位置 position(wrotePosition)，之后才开始写入数据。采用这种切片的方式就能支持并发的读写缓冲区中的数据。

# 消息存储总结

## MappedFile 创建流程

我们先总结下 MappedFileQueue 是如何创建一个 MappedFile 的。CommitLog 创建 MappedFileQueue 是提供了 AllocateMappedFileService 的，所以它会用这个分配服务来创建 MappedFile。

而 AllocateMappedFileService 中分为了 提交分配请求 和 一个独立线程创建MappedFile 两部分，它们之间是通过一个阻塞队列来完成的，创建完成后，通过 CountDownLatch 来实现线程协作通知。

如果启用了 TransientStorePool，创建 MappedFile 时会传入这个瞬时存储池，然后从中取出一块 ByteBuffer 作为写缓冲区。MappedFile 构建时首先通过 File 来关联磁盘文件，然后得到文件通道 FileChanel，再拿到内存映射对象 MappedByteBuffer。最后消息写入就是写入到写缓冲区或这块 MappedByteBuffer 中。

![](https://cdn.nlark.com/yuque/0/2024/webp/744990/1705397270075-204b049d-f255-48fd-a547-555cdbe55cd4.webp)

## 消息写入流程

用一张图来总结下 CommitLog 消息的写入过程，可以看到 CommitLog 中的消息写入主要是设置消息的一些属性，将消息编码成 ByteBuffer。然后从 MappedFileQueue 中获取 MappedFile，然后将消息追加到 MappedFile 中，最后就是消息刷盘及同步。

在 MappedFile 中，主要就是拿到要写入的缓冲区，然后调用 AppendMessageCallback 来追加消息。

最后在 AppendMessageCallback 中才真正写入消息，它会先判断文件剩余空间是否足够写入消息，不够会直接返回失败；否则就会在更新一些消息属性后，将消息写入缓冲区中，然后返回消息追加成功。

![](https://cdn.nlark.com/yuque/0/2024/webp/744990/1705397270199-0a0040d4-b10d-4cf1-a89d-6f1166e01500.webp)

## RocketMQ 高性能核心技术

通过前面对RocketMQ消息存储（消息写入）的源码分析，我们大概能够知道 RocketMQ 实现高性能读写文件的核心技术是什么了。

**1. FileChannel 技术**

首先我们都应该知道传统的 InputStream/OutputStream 是阻塞式I/O、单线程、不支持异步等，读写性能很差。所以 RocketMQ 在 MappedFile 里是基于 FileChannel 来实现文件读写，FileChannel 提供了一种通道（Channel）的方式来进行文件的操作，FileChannel 支持非阻塞 I/O、异步I/O，支持多线程读写，还支持随机读写、直接内存访问、内存映射文件等操作。

FileChannel 在处理大文件、随机访问文件、并发读写文件等场景中特别有用，尤其在多线程访问文件时，能够更好地利用操作系统的文件缓存和磁盘 I/O，提高读写效率。但需要注意的是，FileChannel 是非阻塞的，因此在进行文件读写时需要自行处理缓冲区的状态和同步问题。

**2. MMAP 内存映射技术**

然后 RocketMQ 的存储与读写是基于 JDK NIO 的内存映射机制（MMAP），就是通过 FileChannel.map() 拿到的 MappedByteBuffer 对象。MappedByteBuffer 使用的是直接内存（堆外内存），而不是传统的堆内存 ByteBuffer 对象，直接内存可以直接与操作系统进行交互，这样就可以通过零拷贝（Zero-Copy）技术实现高效的文件读写操作。

MMAP（Memory-mapped file）技术是一种操作系统提供的特性，它允许将文件的一部分或整个文件映射到进程的虚拟内存空间中。这意味着文件的内容可以直接映射到进程的内存中，从而使得文件的读写操作看起来就像在访问内存一样。

_MMAP 技术的主要特点和用途：_

- 文件映射：MMAP 技术允许将文件的内容映射到进程的虚拟内存空间中，从而可以通过内存地址访问文件的数据。这种映射是基于页的，意味着文件的一部分或整个文件可以映射到一个或多个内存页。
- 零拷贝：由于文件内容被映射到直接内存中，读写操作可以直接在堆外内存中进行，而无需经过应用程序（用户态）和操作系统（内核态）之间的多次数据拷贝，从而减少了拷贝的开销，提高了性能。
- 随机访问：MMAP 允许文件的随机访问，即可以通过内存中的地址来随机访问文件的任意位置，而不需要按顺序读取。
- 缓存机制：操作系统通常会将映射的文件内容缓存在内存中，这可以提高后续读取文件的性能，因为从内存中读取数据比从磁盘上读取数据要快得多。
- 写操作：通过 MMAP 写入文件时，可以通过修改内存中的数据来实现，操作系统会在适当的时机将内存中的修改同步到磁盘上。
- 适用场景：MMAP 技术在处理大文件、高并发读写、随机访问以及与其它进程共享数据等场景中非常有用。它能够利用操作系统的缓存机制，提供更高效的文件读写。

_MMAP 技术的限制和潜在问题：_

- MMAP 技术在进行文件映射的时候，一般大小限制在 1.5GB ~ 2GB 之间。所以 RocketMQ 才让CommitLog单个文件在 1GB，ConsumeQueue文件在 5.72MB，不会太大。
- 由于文件映射到了内存中，可能会占用大量的虚拟内存空间，特别是对于大文件。这可能导致内存使用过多，影响系统的稳定性。
- MMAP 操作是基于页的，所以文件的读写必须是页大小的倍数，否则可能会浪费部分内存。 在一些情况下，操作系统可能会限制进程可以映射的文件大小。

**3. 磁盘文件预热技术**

另外 AllocateMappedFileService 在创建 MappedFile 时，如果启用了预热机制（warmMapedFileEnable），还会预热磁盘文件映射 MappedByteBuffer。

可以看到它其实就是往每个系统缓存页（4KB）写入一个字节，然后强制刷盘（force()），这样就和磁盘文件保持了同步。这可以减少在关键路径上的内存复制和初始化开销，从而提高了性能。

```java
public void warmMappedFile(FlushDiskType type, int pages) {
    // 得到 MappedByteBuffer 的视图
    ByteBuffer byteBuffer = this.mappedByteBuffer.slice();
    // 每一个系统缓存页写一个字节的数据
    for (int i = 0, j = 0; i < this.fileSize; i += MappedFile.OS_PAGE_SIZE, j++) {
        byteBuffer.put(i, (byte) 0);
        if (type == FlushDiskType.SYNC_FLUSH) {
            if ((i / OS_PAGE_SIZE) - (flush / OS_PAGE_SIZE) >= pages) {
                flush = i;
                mappedByteBuffer.force();
            }
        }
    }
    // 异步刷盘
    if (type == FlushDiskType.SYNC_FLUSH) {
        mappedByteBuffer.force();
    }
    // mlock
    this.mlock();
}
```

预热最后还是用了 mlock 和 madvise 系统调用来锁定内存区域，再次提升访问性能。

- _mlock（Memory Lock）_：mlock 系统调用的主要作用是将指定的内存区域锁定在物理内存中，防止它被操作系统交换到硬盘的交换空间（swap space）。这对于需要快速响应的程序非常重要，因为从交换空间恢复内存的操作通常会导致显著的延迟。
- _madvise（Memory Advice）_：madvise 系统调用的主要目的是帮助内核更好地管理虚拟内存，提高内存使用的效率。通过madvise系统调用，进程可以向内核提供一些关于内存映射区域的信息，以便内核可以更好地优化内存使用和访问模式。

```java
public void mlock() {
    final long address = ((DirectBuffer) (this.mappedByteBuffer)).address();
    Pointer pointer = new Pointer(address);

    LibC.INSTANCE.mlock(pointer, new NativeLong(this.fileSize));
    LibC.INSTANCE.madvise(pointer, new NativeLong(this.fileSize), 
                          }
```

MappedByteBuffer 预热机制 是一种性能优化技巧，通常用于在程序启动或在需要高性能的场景中，提前将文件内容映射到内存中的 MappedByteBuffer 对象，以避免在关键路径上发生磁盘 I/O 或其他性能瓶颈。这种技巧通常用于提高文件读取操作的速度，特别是对于需要频繁访问文件内容的情况。

需要注意的是，ByteBuffer预热机制并不适用于所有应用程序，只有在需要高性能和低延迟的场景下才会带来显著的性能优势。此外，使用ByteBuffer预热机制需要谨慎，因为它可能会增加内存使用量，特别是在大规模使用直接内存的情况下。

**4. 瞬时存储池化技术+写缓冲区**

RocketMQ 提供了瞬时存储池化技术，如果开启了这个能力（transientStorePoolEnable），TransientStorePool 中会预分配默认 5 个 ByteBuffer 堆外内存区域。

对于这种大文件的读写，由于堆外内存直接映射到本机内存，在读取和写入数据时通常更快。而且通过池化技术，也能减少内存分配开销、提高性能、避免内存碎片化等。

MappedFile 创建时就会绑定一块写缓冲区（writeBuffer），想想就知道就是在写入消息的时候先写入这块堆外内存缓冲区，再批量写入 FileChannel 中，最终持久化到磁盘，这又能大幅提升高并发下写入消息的性能。

**5. 读写分离技术**

首先要知道 FileChannel.map 映射的 MappedByteBuffer 是映射在堆外内存(直接内存)上，它用于与磁盘上的消息存储文件进行交互，它是一种直接的、零拷贝的方式来读取和写入文件数据。

而如果启用了瞬时存储池技术，MappedFile 还会从 TransientStorePool 获取一块 ByteBuffer 来作为写缓冲区，而 TransientStorePool 中分配的 ByteBuffer 也是堆外内存(直接内存)。

那么问题来了，既然两块 ByteBuffer 都是堆外内存，那为何还要先写入一块 ByteBuffer 写缓冲区，再同步到 FileChannel 呢，这个问题值得思考下。

我猜想 RocketMQ 是采用了读写分离的思想，其中读取操作使用 MappedByteBuffer 直接从文件映射内存中读取数据，而写入操作则使用 ByteBuffer 写缓冲区来构建要写入的消息数据。这种分离的设计允许读取和写入操作同时进行，能够提高消息引擎的性能。

通过读写分离，可以将一批消息写入 ByteBuffer 缓冲区后再一起同步写入 MappedByteBuffer 中，再由其刷盘机制将数据持久化到磁盘中。这样就能减少系统调用和文件 I/O 操作，减少磁盘写入的开销，提高写入性能。

这块在我们研究消息消费的时候就知道了。

## 消息存储架构

最后我们再来总结一下 RocketMQ 消息存储的架构设计：

1. 首先 RocketMQ 消息存储在 commitlog 目录下磁盘文件中。
2. 通过 MappedFileQueue 映射 commitlog，通过 MappedFile 映射 commitlog 磁盘文件，并支持使用 AllocateMappedFileService 来分配创建 MappedFile。
3. MappedFile 通过 FileChannel 关联磁盘文件，然后通过 FileChannel.map() 拿到内存映射 MappedByteBuffer，通过这块内存映射来读写文件数据。
4. TransientStorePool 支持池化技术预分配几块缓冲区 ByteBuffer，MappedFile 可以从中获取 ByteBuffer 来作为写缓冲区。
5. 上层消息写入链路为 MessageStore -> CommitLog -> MappedFile -> ByteBuffer -> MappedByteBuffer -> 磁盘文件commitlog。
6. 外层消息生产者发送消息，Broker 收到消息后经过请求处理器 SendMessageProcessor 来处理消息写入，它解析消息生成 MessageExtBrokerInner，调用 MessageStore 来完成消息写入。

![](https://cdn.nlark.com/yuque/0/2024/webp/744990/1705397270287-8945bdec-1618-4181-8864-b56570a2c825.webp)