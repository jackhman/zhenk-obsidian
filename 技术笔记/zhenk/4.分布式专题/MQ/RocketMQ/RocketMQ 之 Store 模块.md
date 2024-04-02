# 一. 概述

需要存储消息到磁盘，避免消息被丢失。在 RocketMQ 框架中除了消息需要保存到磁盘，还有哪些数据需要存放到磁盘，其数据结构是什么样的？磁盘中的数据又是如何跟其他模块进行交互的，例如，Broker 模块等；在官方文档中提供了这么一张图，如下：

![](https://static001.geekbang.org/infoq/b7/b72870c61e8dce663b8712ad426baf41.png)

从上面的图来看，生产者生产消息会保存到磁盘文件 CommitLog 中；意味着所有消息都保存到 CommitLog 文件中；那么问题来了，CommitLog 的文件结构是什么样的；

消费者是通过 ConsumerQueue 拉取消息进行消费，从而记录每个 Topic 对应的 queue 的消费情况；那么问题来了，为什么不直接通过 CommitLog 进行拉取消息进行消费；主要还是 CommitLog 文件的数据量错终复杂，如果从 CommitLog 去拉取消息，会花大量的时间去检索到对应的消息，所以才提出了这么 ConsumerQueue 这么一个概念，我们可以理解为 CommitLog 文件的索引信息，且会记录消费情况；那么 ConsumerQueue 的文件结构是怎么样的；

其里面隐藏了一类文件，叫做索引文件，IndexFile。

RocketMQ 是如何管理这些文件的。这篇只是围绕 CommitLog 进行展开，并没有对 DLedgerCommitLog 进行解读，后续会对其进行分析；

# 二. CommitLog

消息主题以及元数据的存储主题，存储 Producer 端写入的消息主题内容，消息内容不是定长的。单个文件默认 1G，文件名长度为 20 位，左边补零，剩余为起始偏移量，比如 00000000000000000000 代表了第一个文件，起始偏移量为 0，文件大小为 1G=1073741824；当第一个文件写满了，第二个文件为 00000000001073741824，起始偏移量为 1073741824，以此类推。消息主要是顺序写入日志文件，当文件满了，写入下一个文件；

我们会首先看单个文件所存储的内容结构，接着会解读 RocketMQ 是如何对 CommitLog 进行管理的。

## 1. 文件结构

如下图：

![](https://static001.geekbang.org/infoq/83/83179bb97e53b7940cc2df2290bce186.png)

我们重点查看消息记录格式：

- TOTAL_SIZE 该消息条目的总长度
    
- MAGIC_CODE 魔术，固定值：0x255CDF59
    
- BODY_CRC 消息体 crc 校验码
    
- QUEUE_ID 消息消费队列 ID
    
- FLAG 消息 FLAG，供应用程序使用
    
- QUEUE_OFFSET 消息在消费队列的偏移量
    
- PHYSICAL_OFFSET 消息在 CommitLog 文件中的偏移量
    
- SYS_FLAG 消息系统 FLAG，例如是否压缩，是否是事务消息等
    
- BORN_TIMESTAMP 消息生产者调用消息发送 API 的时间戳
    
- BORN_HOST 消息生产者 IP、端口信息
    
- STORE_TIMESTAMP 消息存储时间戳
    
- STORE_HOST broker 服务器 IP、端口信息
    
- RECONSUME_TIMES 消息重试次数
    
- PREPARED_TRANSACTION_OFFSET 事务消息物理偏移量
    
- BODY_LENGTH 消息体长度
    
- BODY 消息体内容
    
- TOPIC_LENGTH 主题名称长度
    
- TOPIC 主题名称
    
- PROPERTIES_LENGTH 消息属性长度
    
- PROPERTIES 消息属性
    

我们在生产端发送单个消息以及批量消息时，Broker 是如何对其处理，从而保存到 CommitLog 文件中的；

- 单个消息，到 Broker 后，会由 DefaultAppendMessageCallback.doAppend 进行处理；
    
- 批量消息，到 broker 后，先由 MessageExtBatchEncoder.encode 方法对批量消息 MessageExtBatch 处理后，再由 DefaultAppendMessageCallback.doAppend 进行处理；
    

当文件快满了，如何保存完整的消息时，会在末尾添加 8 个字节的信息，来确定文件结尾；

## 2. 文件管理

主要围绕对 CommitLog 文件管理进行解读，主要围绕几大关键动作进行了解：

- 创建文件，基于什么样的机制会创建文件；
    
- 删除文件，基于什么样的策略会将文件进行删除；
    
- 加载文件，RocketMQ 是如何加载文件的，例如 Broker 重新启动时会去加载 CommitLog 文件；这里需要特别说一下，为什么会出现加载动作：主要有两种情况会出现：开发人员手动停止 Broker 服务，另外一种是 Broker 服务器异常；所以需要重新启动 Broker 服务器，那么就会触发加载文件动作。
    
- 关闭文件，RocketMQ 是如何关闭
    
- 添加消息，这里的添加主要是向 CommitLog 文件中插入消息
    
- 查询消息，向 CommitLog 文件查询到对应的消息
    

有关 commit 基础的配置项如下：

- storePathCommitLog CommitLog 存储目录，默认为 ${Broker 存储目录}/commitlog
    
- mappedFileSizeCommitLog 单个 commitlog 文件的大小，默认为 1G
    

### 2.1 创建文件

当新的 Broker 启动时，其并没有创建任何 CommitLog 文件，然而并没有立马创建；而是在需要时才创建该文件；而创建文件，则交由 AllocateMappedFileService 去创建文件；AllocateMappedFileService 是线程对象，会在后台一直循环处理，除非被中断打断该执行。所以创建文件是属于异步创建；

通过调用 AllocateMappedFileService.putRequestAndReturnMappedFile 方法，将创建 MappedFile 文件请求保存到队列里面，然后交由线程去自行处理创建文件；RocketMQ 针对 AllocateMappedFileService 线程对象，提供了相关的配置项：

- transientStorePoolEnable 是否开启 transientStorePool 机制，默认值为 false。
    
- transientStorePoolSize transientStorePool 中缓存 byteBuffer 个数，默认 5 个
    
- fastFailIfNoBufferInStorePool 从 transientStorePool 中获取 ByteBuffer 是否支持快速失败，默认为 false.
    
- warmMapedFileEnable 是否温和地使用 MappedFile，默认为 false；我们可以理解为预热，是为了避免缺页中断导致用户态与内核态切换导致性能降低；
    
- flushLeastPagesWhenWarmMapedFile 用字节 0 填充整个文件，每多少页刷盘一次。默认 4096 页，异步刷盘模式生效
    
- flushDiskType 刷盘类型，有异步刷盘和同步刷盘两种类型；
    

具体的代码在 AllocateMappedFileService 类中的 putRequestAndReturnMappedFile 方法与 mmapOperation 方法；

### 2.2 删除文件

删除文件，主要是哪些过期文件；那么在 RocketMQ 是如何定义哪些文件是过期的。在 RocketMQ 是会定义一个阈值，来确定文件的存活时间；在 RocketMQ 是提供这样的配置项：

- fileReservedTime 文件保留时间，默认 72 小时，表示非当前写文件最后一次更新时间加上 fileReservedTime 小于当前时间，该文件将被清理
    

删除文件动作并不是交由主线程来进行操作，而是异步定时去清理，频率是通过配置来决定；

- cleanResourceInterval 清除过期文件线程调度频率，默认每隔 10s 检测一下是否需要清除过期文件
    

  

然而就算发现了过期文件存在，也不会立即去清除；而是满足下列条件之一，才能做清理文件动作

- 是否到了指定时间 -> 配置项 deleteWhen： 磁盘文件充足的情况下，默认每天的什么时候执行删除过期文件。默认为 04，表示凌晨 4 点
    
- 空间是否满了 -> 当 commitlog 目录所在分区的最大使用比例，如果 commitlog 目录所在的分区使用比例大于该值，则触发过期文件删除，配置由 diskMaxUsedSpaceRatio 进行配置，默认值为 75，一般我们都不用做特殊处理；
    
- 手工删除 -> 目前并没有找到对应哪类接口去手工删除；可以先暂时忽略
    

值得注意的是清理文件动作，并不意味已经发现了过期文件，进行删除；而是执行 CommitLog 类中的 deleteExpiredFile 方法；接下来我们对其方法进行解读，该方法暴露的方法参数如下：

- expiredTime 过期时间，也就是我们配置项中的 fileReservedTime。
    
- deletePhysicFilesInterval 删除文件频率，意味着不是一次性删除完，而是没删除一份文件，先休息一段在接着删除；我们通过配置 deleteCommitLogFilesInterval：删除 CommitLog 文件的间隔时间，删除一个文件后，等一下再删除下一个文件。默认为 100ms
    
- destroyMapedFileIntervalForcibly 这是是配置项，销毁 MappedFile 被拒绝的最大从存活时间，默认为 120s。清除过期文件线程在初次销毁 MappedFile 时，如果该文件被其他线程（引用次数大于 0），则设置 MappedFile 的可用状态为 false，并设置第一次删除时间，下一次清理任务到达时，如果系统时间大于初次删除时间加上 destroyMappedFileIntervalForcibly，则将 ref 次数一次减 1000，直到引用次数小于 0，则释放物理资源。
    
- cleanImmediately 立即清除，表示：无条件清理文件。当为 true 时，会忽略过期文件条件，直接删除文件，具体的代码 MappedFileQueue.deleteExpiredFileByTime。其通过两个值进行与换算得来；
    
- 配置项 cleanFileForciblyEnable 是否支持强行删除过期文件，默认为 true
    
- 是否立即清除标志，其表示是通过磁盘空间使用率来设置，方法在 CleanCommitLogService.isSpaceToDelete。磁盘空间使用率超过 85%，就会设置为 true。磁盘空间使用率有两个分区，一个是 CommitLog 所在目录所在的分区，另外一个是 RocketMQ 主目录所在的分区；
    

  

我们上面介绍了 destroyMapedFileIntervalForcibly 配置项，说明并不会成功删除文件；那么 RocketMQ 会定时的尝试删除该未删除成功的文件；相关的配置项如下：

- redeleteHangedFileInterval 重试删除文件间隔，默认为 120s，配合 destroyMappedFileIntervalForcibly 使用
    

上面的删除文件的定时主要是 CleanCommitLogService 对象；详细细节可查阅其代码

### 2.3 加载文件

当 Broker 服务重新启动时，会触发加载 CommitLog 目录下的 commitlog 文件；

其会检验每份文件的大小，如果不等于 mappedFileSizeCommitLog，则认为加载失败，那么启动就会失败；具体的代码在 CommitLog.load；

同时会去做校验动作，来校验 commitlog 是否合法；

正常启动时，会去调用 CommitLog.recoverNormally 方法；异常宕机时，会去调用 CommitLog.recoverAbnormally 方法；详细的细节查阅相关的代码；

有关配置项如下：

- checkCRCOnRecover 文件恢复时是否检验 CRC，默认为 true
    

**正常恢复操作**：

![](https://static001.geekbang.org/infoq/82/82a7738c770e9489d49eb88ea5615c3c.png)

**异常恢复操作**：

跟正常恢复操作逻辑差不多，只是在之前多了一个步骤；

就是从最后一个文件往前走，找到第一个消息存储正常的文件；

### 2.4 关闭文件

当关闭服务器，并没有执行文件关闭动作，只有在删除过期文件时会关闭文件，具体代码如下：

```
//MappedFile
```

复制代码

### 2.5 添加消息

终于到了关键的操作，消息中间件中生产者生产消息发送给 broker 服务器时，会向 Commitlog 文件上追加消息，以确保消息真正的持久化到磁盘中，避免了消息丢失问题；有关配置项如下：

- maxMessageSize 默认允许的最大消息体，默认为 4M
    

然而添加消息时，做了关键的几个动作，具体代码如下：

```
//CommitLog
```

复制代码

有关锁 putMessageLock 对象，是根据配置项来决定；

- useReentrantLockWhenPutMessage 消息存储到 commitlog 文件时获取锁类型，如果为 true，使用 ReentrantLock；否则使用自旋锁，默认为 false
    

  

这里单独列了这么一个方法，其他的方法都大同小异，要么是异步，要么是同步的形式添加消息；

添加消息的主要过程如下：

- 处理消息
    
- 向文件追加消息
    
- 统计数据
    
- 磁盘刷盘
    
- 同步消息到其他从节点
    

  

**磁盘刷盘**，会根据我们的配置项来决定，配置项：

- flushDiskType 刷盘方式，默认为 ASYNC_FLUSH(异步刷盘)，可选值：SYNC_FLUSH(同步刷盘)
    

如果是同步刷盘，其会根据消息中的属性是否有设置了

WAIT(MessageConst.PROPERTY_WAIT_STORE_MSG_OK)为 true，如果没有设置，默认为 true;

- syncFlushTimeout 同步刷盘超时时间
    

详细代码如下：

```
public void handleDiskFlush(AppendMessageResult result, PutMessageResult putMessageResult, MessageExt messageExt) {  
```

复制代码

有关刷盘，RocketMQ 提供了相关的配置项，如下：

- flushIntervalCommitLog commitlog 刷盘频率，默认为 500ms
    
- flushCommitLogLeastPages 一次刷盘至少需要脏页的数量，默认 4 页，针对 CommitLog 文件
    
- flushCommitLogThoroughInterval commitlog 两次刷盘的最大间隔，如果超过该间隔，将忽略 flushCommitLogLeastPages 要求直接执行刷盘操作，默认为 10s.
    
    commitIntervalCommitLog commitlog 提交频率，默认为 200ms
    
- commitCommitLogLeastPages 一次提交至少需要脏页的数量，默认 4 页，针对 CommitLog 文件
    
- commitCommitLogThoroughInterval CommitLog 两次提交的最大间隔，如果超过该间隔，将忽略 commitCommitLogLeastPages 直接提交。默认 200ms.
    
- flushCommitLogTimed 默认为 false，表示 await 方法等待 flushIntervalCommitLog 。如果为 true，表示使用 Thread.sleep 方法等待
    

这里稍微注意的是，在追加信息，commit，以及 flush 操作时，会记录文件的指针；

对象 MappedFileQueue 中属性

- flushedWhere 已经执行 flush 操作的位置指针
    
- committedWhere 已经执行 commit 操作的位置指针
    
- storeTimestamp 记录 commitlog 更新时间
    

对象 MappedFile 中属性

- wrotePosition 已经写入的位置指针
    
- committedPosition 已经 commit 的位置指针
    
- flushedPosition 已经 flush 的位置指针
    

  

**同步消息**，主节点的数据同步到从节点，会根据我们的配置项来决定是否同步；

- brokerRole Broker 角色，分为 ASYNC_MASTER, SYNC_MASTER, SLAVE, 默认为异步 Master(ASYNC_MASTER)
    
- ASYNC_MASTER 主从异步复制
    
- SYNC_MASTER 主从同步复制
    
- SLAVE 从节点角色
    

```
public void handleHA(AppendMessageResult result, PutMessageResult putMessageResult, MessageExt messageExt) {
```

复制代码

从上面的代码来看，创建 GroupCommitRequest 请求添加到 HAService 中的 GroupTransferService 线程去执行；然而 GroupTransferService 并没有真正执行数据同步到从节点；真正执行同步操作的是交由 HAConnection.ReadSocketService 线程去操作；

  

在上面的主从同步复制模式下，会去校验从节点与主节点是否偏移量差，从而判断从节点是否可用，配置项如下：

- haSlaveFallBehindMax 允许从服务器落户的最大偏移字节数，默认为 256M。超过该值则表示该 Slave 不可用
    

  

**HAService** 启动时，如果是从节点，会启动时 HAClient 会向主节点发起连接；如果是主节点，AcceptSocketService 线程接收到请求后，会创建 HAConnection 对象；

相关的配置项如下：

- haListenPort Master 监听端口，从服务器连接该端口，默认为 10912；
    
- haMasterAddress Master 服务器 IP 地址与端口号，如果从节点没有配置该主节点 IP，则会从集群中获取；
    
- haHousekeepingInterval Master 与 Slave 长链接空闲时间，超过该时间将关闭连接；这里关闭的连接主要是 **HAConnection** 以及 **HAClient** 对象的中的连接；
    

其中有一个关键的属性值，会与 GroupTransferService 线程相关；

- push2SlaveMaxOffset 已经推送给从节点的最大偏移量；
    

  

**HAConnection** 有两个内部线程；

- ReadSocketService 读取从节点返回的"已接收"的偏移量，会记录该偏移量到 HAConnection 的 slaveAckOffset 值，然后更新 HAService 的 push2SlaveMaxOffset 属性值；
    
- WriteSocketService 向从节点同步数据；
    

  

**WriteSocketService** 同步数据有限制，提供了相关的配置项，如下：

- haTransferBatchSize 一次 HA 主从同步传输的最大字节长度，默认为 32K
    

同步数据的协议如下：

![](https://static001.geekbang.org/infoq/29/29b0969ea969186ca2e36b35f48fa347.png)

  

**HAClient** 对象，会定时发送心跳给主节点，告知目前从节点"已接收"的偏移量；同时接收主节点发送过来的同步数据；相关配置项如下：

- haSendHeartbeatInterval Master 与 Slave 心跳包发送间隔，默认为 5s
    

相关的细节，可具体查阅相关代码；目前我也只是对其大体粗略看了一下；并没有过多详细梳理；

### 2.6 查询消息

查询消息，CommitLog 提供了相关的方法进行查询；在这里我们主要讲解的是 getData 方法的入参 offset 偏移量。意味着从 commitlog 文件查询对应的消息，是根据偏移量来查找；具体的细节可查阅其代码；

那么问题来了，offset 偏移量是如何计算出来的？那么就衍生了另外的两份文件，ConsumerQueue 以及 IndexFile；

# 三. ConsumerQueue

消息消费队列，引入的目的主要是提高消息消费的性能，由于 RocketMQ 是基于主题 topic 的订阅模式，消息消费是针对主题进行的，如果要遍历 commitlog 文件中根据 topic 检索消息是非常低效的。Consumer 即可根据 ConsumeQueue 来查找待消费的消息。其中，ConsumeQueue（逻辑消费队列）作为消费消息的索引，保存了指定 Topic 下的队列消息在 CommitLog 中的起始物理偏移量 offset，消息大小 size 和消息 Tag 的 HashCode 值。consumequeue 文件可以看成是基于 topic 的 commitlog 索引文件，故 consumequeue 文件夹的组织方式如下：topic/queue/file 三层组织结构，具体存储路径为：$HOME/store/consumequeue/{topic}/{queueId}/{fileName}。同样 consumequeue 文件采取定长设计，每一个条目共 20 个字节，分别为 8 字节的 commitlog 物理偏移量、4 字节的消息长度、8 字节 tag hashcode，单个文件由 30W 个条目组成，可以像数组一样随机访问每一个条目，每个 ConsumeQueue 文件大小约 5.72M；

上面的文件描述来自官方文档对其 ConsumerQueue 介绍；

我们按照 CommitLog 文件的思路去解读 ConsumerQueue 文件；

有关 ConsumeQueue 拓展属性就不再进行解读；相关的可以查阅代码；

## 1. 文件结构

![](https://static001.geekbang.org/infoq/98/9826708cb4a95220558a7516a3eeda30.png)

- offset 消息在 commitlog 物理偏移量
    
- size 消息的长度
    
- tagsCode tag 的 hashcode
    

## 2. 文件管理

RocketMQ 提供了相关的配置项：

- mappedFileSizeConsumeQueue 单个 consumequeue 文件的大小，默认为 30w*20(字节)。表示单个 ConsumeQueue 文件中存储 30W 个 ConsumeQueue。
    
    enableConsumeQueueExt 是否启用 ConsumeQueue 拓展属性，默认为 false
    
    mappedFileSizeConsumeQueueExt ConsumeQueue 拓展文件大小，默认位 48M
    
    bitMapLengthConsumeQueueExt ConsumeQueue 拓展过滤 bitmap 大小，默认为 64M
    
    flushIntervalConsumeQueue consumeQueue 文件刷盘频率，默认为 1s.
    
    flushConsumeQueueLeastPages 一次刷盘至少需要脏页的数量，默认 2 页，针对 Consume 文件
    
    flushConsumeQueueThoroughInterval Consume 两次刷盘的最大间隔，如果超过该间隔，将忽略 flushConsumeQueueLeastPages 直接刷盘，默认 60s.
    
    deleteConsumeQueueFilesInterval 删除 ConsumeQueue 文件的时间间隔，默认为 100ms.
    

### 2.1 创建文件

当添加 consumequeue 时，发现没有会创建对应的文件，相关的代码：DefaultMessageStore.findConsumeQueue

### 2.2 删除文件

有关删除文件的，跟 CommitLog 类似，具体的线程类 CleanConsumeQueueService；

只是定位过期的规则不一样，规则是根据现有的 Commitlog 最小偏移量 minOffset，跟 Consumequeue 文件中最后一个 item 中的 offset 进行比较；如果 minOffset>offset，则删除该 consumequeue 文件；

### 2.3 加载文件

Broker 启动时会去加载配置项指定的目录下 ${storePathRootDir}/consumequeue 的文件，配置项如下：

该目录有两级目录，第一级目录是 topic 名称目录，第二级目录是队列名称目录；

相关的代码如下：

加载： DefaultMessageStore.load -> DefaultMessageStore.loadConsumeQueue -> ConsumeQueue.load

恢复： DefaultMessageStore.load -> DefaultMessageStore.recover ->DefaultMessageStore.recoverConsumeQueue ->ConsumeQueue.recoverConsumeQueue

这里的恢复，并没有太多新颖的地方，主要是校验物理偏移量以及消息长度是否正常；并返回目前 consumeque 目前最大的物理偏移量，让 commitlog 去做额外操作；当其偏移量比 commitlog 的偏移量还要大，说明 consumequeue 中有脏数据，需要清理，清理的代码 DefaultMessageStore.truncateDirtyLogicFiles，其逻辑相对于比较简单；这里不在阐述，相关细节可以查阅其代码；

这里我有个疑问，为什么没有参照 IndexFile 的格式，在文件头部添加类似的信息，来记录该文件的记录的 commitlog 的最小、最大偏移量；从而快速的做恢复操作；

同时校正 consumequeue 的最小逻辑偏移量 minLogicOffset；

这里，给自己的一个猜想，异常宕机的场景发生的概率较小，而且日常添加消费队列时刷盘操作会提交多，为了实时刷盘头部信息到磁盘，会损耗大量的性能；

### 2.4 关闭文件

同样，这里没有关闭文件操作，具体可以参考 commitlog 中的关闭文件的介绍；

### 2.5 添加信息

文件结构中介绍了添加信息的结构，具体的代码查阅 ConsumeQueue.putMessagePositionInfoWrapper;

这里没有 commit 机制，只有刷盘动作，具体交由 FlushConsumeQueueService 线程去操作；

  

这里值得注意的是，什么时候会触发添加消息；

当消息保存到 commitlog 时，是没有直接调用 consumequeue 去将相关的信息保存到 consumequeue 里面的；而是通过线程 ReputMessageService 定时的抓取的；相关的属性为 reputFromOffset；每个消息封装成 DispatchRequest，进行分发给具体的处理器 CommitLogDispatcher，在 consumequeue 中就有对应的 CommitLogDispatcherBuildConsumeQueue 对象；具体可查阅其代码；

  

另外，需要注意的是 CommitLogDispatcherBuildConsumeQueue 中的事务类型；

### 2.6 查询信息

查询主要是围绕 topic 和 queueId，从而定位到具体某个 Consumequeue 对象，接着在根据偏移量去定位到具体哪个 item；这里的偏移量是个数，即 item 的数量；

  

# 四. IndexFile

IndexFile（索引文件）提供了一种可以通过 key 或时间区间来查询消息的方法。Index 文件的存储位置是：$HOME \store\index${fileName}，文件名 fileName 是以创建时的时间戳命名的，固定的单个 IndexFile 文件大小约为 400M，一个 IndexFile 可以保存 2000W 个索引，IndexFile 的底层存储设计为在文件系统中实现 HashMap 结构，故 rocketmq 的索引文件其底层实现为 hash 索引。

上面的文件描述来自官方文档对其 ConsumerQueue 介绍；

相关的配置项如下：

- messageIndexEnable 是否支持消息索引文件，默认为 true。
    
    maxHashSlotNum 单个索引文件 Hash 槽的个数，默认为 5 百万
    
    maxIndexNum 单个索引文件索引条目的个数，默认为 2 千万
    

## 1. 文件结构

![](https://static001.geekbang.org/infoq/69/6966e129520229fb094bcc43ea469feb.png)

按照同样的思路去解读 IndexFile 文件；这里就不在过多解读，相关的逻辑细节可查阅代码；

稍微值得一提的是，IndexFile 没有定时刷盘动作，而是等到 IndexFile 写满后，才触发刷盘动作；

当异常宕机时，其 IndexFile 有可能会数据被丢失的可能性；主要原因是其没有恢复机制；数据丢失就丢失了，

# 五. 总结

通过对 CommitLog 文件、consumequeue 文件、IndexFile 文件的粗糙的了解，大体知道 RocketMQ 是如何持久化消息，以及对文件的管理有一定的了解，这三个文件的关系；想要过多的了解细节，可查阅其代码；

当然我这里还有其他特性没有解读，如监听器 MessageArrivingListener，StoreCheckpoint 等；