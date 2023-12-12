## 常用的拓扑图

![](imag/1622026191479-3192d8cd-34a1-4737-9080-312ea6df1d3c.png)

多master模式：会出现数据丢失现象

多Master多Slave模式：异步复制的时候也会出现数据丢失现象，在同步复制中严格要求可靠性发送的情况下不会出现数据丢失现象

在发送消息的时候，Master只需要往一台Slave中发送数据就可以

- Broker配置文件中，brokerId=0 表示当前Broker为Master（支持读写），brokerId>0 表示为Slave（仅支持读），同时配置文件中的brokerRole参数也会说明是Master还是Slave
- **消费端的HA：**当从Master宕机或者繁忙时就会自动切换到从Slave进行读操作
- **生成端的HA**：创建Topic的时候，把这个Topic的多个Message Queue创建在多个Broker组上（相同Broker名称,不同brokerId的机器组成一个Broker组）,需要手动把Slave转成Master

### 同步复制和异步复制

如果Broker组有Master 和Slave，消息需要从Master 复制数据到Slave方式有两种分别为同步和异步，通过brokerRole进行配置AYNC_MASTER、SYNC_MASTER、SLAVE三个值的一个：

- **同步复制(****数据可靠,增大数据的写入延迟和降低吞吐量)**，Master和Slave均数据落盘成功后才反馈给客户端写成功状态，默认传输数据是可靠性发送，传到Mater的数据一定同步复制到Slave；
- **异步复制(****低延迟高吞吐量,但****会导致数据不一致****)**，只要Master数据落盘成功后就可以反馈给客户端写成功状态，在Master落盘的过程中会在Master主机当中另起一个异步线程来不断把数据异步复制到Slave中去。

### 同步刷盘和异步刷盘

消息在通过Producer写入MQ的Broker时，从内存持久化到磁盘的两种写磁盘方式

同步刷盘还是异步刷盘，是通过Broker 配置文件里的flushDiskType参数设置，这个参数被配置成SYNC_FLUSH、ASYNC_FLUSH

![](imag/1622027103989-8ed766d5-9a4f-4228-a172-c58e079e50da.png)

#### 异步刷盘

在返回写成功状态时，消息可能只是被写入了内存的PAGECACHE页缓存中，写操作的返回快，**吞吐量大**；当内存里的消息堆积到一定量时，统一会自动触发写磁盘操作，**快速写入也就是非常低的写入延迟**。

#### 同步刷盘

在返回写成功状态时，消息已经被写入磁盘。具体流程是，消息写入内存的PAGECACHE后，立刻通知刷盘线程刷盘，然后等待刷盘完成，刷盘线程执行完后唤醒等待的线程，返回消息写成功的状态，可靠性极强

![](imag/1622037267867-2d8cd95f-1eff-4e70-919b-32c2073e5962.jpeg.jpg)

### 总结

// 刷盘,手动立刻刷盘mmap.flip();

调用此方法时会消耗性能，可以不用调用此方法，而是使用异步线程进行异步刷盘；同步复制是在Broker 中的mater 和slave 内存同步复制数据，而不用在乎Master 中是否刷盘成功，因为slave 中可以刷盘。 **异步刷盘（） + 主从同步复制（****因为同步相对异步而已只是降低10%，但可以确保数据不丢失，同步数据中从有多个slave的时候只需要复制到一个slave中****）**

## 消息生产的HA(写)

**Topic创建在多Broker中**

**一个queue对应一个消费者，在一个Topic中可以横向扩张Queue。**

**一个Broker可以有Master和Slave两种角色存在**

### NameServer 更新策略

### 故障延迟机制（规避策略）

重试的时候一定会避开之前发送失败的那个Queue所在的Broker，这是常态默认策略。

重试的那个BrokerA有可能只是某段时间网络异常，如果开启规避策略的话，在某段延迟时间（更新路由之前）不对brokerA进行重试，会对另个broker提升了流量压力。

在NameServer更新Topic路由信息的这段时间之内（短时间部分状态），由于NameServer中的路由信息和Broker真实宕机状态没有及时同步，导致在Producer定时从NameServer获取到的路由信息中包含了不可用的Topic路由信息，再次发送消息的时候会规避之前第一次发送错误的那个Queue所在的Broker，直到某个延迟时间(更新完Producer中的Topic路由信息)才会正常发送。

NameServer发现Broker宕机的延迟时间和Producer拉取到NameServer中更新了的路由信息所用到的延迟时间

- **默认false，不开启，有点类似于JVM中内存分配空间的担保策略，延迟规避策略只在****重试时生效，**正常发送的消息还是走之前的BrokerA队列 sendLatencyFaultEnable = false
- **设置true，开启，**第一次重试和第二次或者在刷新Broker-routingInfo正常发送消息的时候会根据规避策略和sendWhichQueue轮询机制找到下一个Broker队列BrokerB-queue01进行发送，并且第二条数据也会往这个队列进行**发送而非重试**，而不会发送给之前的BrokerA，也是有个**延迟时间**，在这段时间都会继续往BrokerB-queue01发送数据而BrokerA就会在这时间内不参与选择队列的负载均衡

这样的情况下，RocketMQ是如何保证消息发送的高可用性：

在内部引入了重试机制，默认是重试2次；消息发送端采用的队列负载均衡默认是轮询

Broker故障转移机制的关键类LatencyFaultTolerance

#### (转载)消息发送高可用设计与故障规避机制

熟悉 RocketMQ 的小伙伴应该都知道，RocketMQ Topic 路由注册中心 NameServer 采用的是最终一致性模型，而且客户端是定时向 NameServer 拉取 Topic 的路由信息，即客户端（Producer、Consumer）是无法实时感知 Broker 宕机的，这样消息发送者会继续向已宕机的 Broker 发送消息，造成消息发送异常。那 RocketMQ 是如何保证消息发送的高可用性呢？

RocketMQ 为了保证消息发送的高可用性，在内部引入了重试机制，默认重试 2 次。RocketMQ 消息发送端采取的队列负载均衡默认采用轮循。

在 RocketMQ 中消息发送者是线程安全的，即一个消息发送者可以在多线程环境中安全使用。每一个消息发送者全局会维护一个 Topic 上一次选择的队列，然后基于这个序号进行递增轮循，引入了 ThreadLocal 机制，即每一个发送者线程持有一个上一次选择的队列，用 sendWhichQueue 表示。

接下来举例消息队列负载机制，例如 topicA 的路由信息如下图所示：

![](imag/1622161707271-b1957530-3151-4430-965a-59fd20910b36.png)

正如上图所 topicA 在 broker-a、broker-b 上分别创建了 4 个队列，例如一个线程使用 Producer 发送消息时，通过对 sendWhichQueue getAndIncrement() 方法获取下一个队列。

例如在发送之前 sendWhichQueue 该值为 broker-a 的 q1，如果由于此时 broker-a 的突发流量异常大导致消息发送失败，会触发重试，按照轮循机制，下一个选择的队列为 broker-a 的 q2 队列，此次消息发送大概率还是会失败，即尽管会重试 2 次，但都是发送给同一个 Broker 处理，此过程会显得不那么靠谱，即大概率还是会失败，那这样重试的意义将大打折扣。

故 RocketMQ 为了解决该问题，引入了故障规避机制，在消息重试的时候，会尽量规避上一次发送的 Broker，回到上述示例，当消息发往 broker-a q1 队列时返回发送失败，那重试的时候，会先排除 broker-a 中所有队列，即这次会选择 broker-b q1 队列，增大消息发送的成功率。

上述规避思路是默认生效的，即无需干预。

但 RocketMQ 提供了两种规避策略，该参数由 sendLatencyFaultEnable 控制，用户可干预，表示是否开启延迟规避机制，默认为不开启。（DefaultMQProducer中设置这两个参数）

sendLatencyFaultEnable 设置为 false：默认值，不开启，延迟规避策略只在重试时生效，例如在一次消息发送过程中如果遇到消息发送失败，规避 broekr-a，但是在下一次消息发送时，即再次调用 DefaultMQProducer 的 send 方法发送消息时，还是会选择 broker-a 的消息进行发送，只要继续发送失败后，重试时再次规避 broker-a。

sendLatencyFaultEnable 设置为 true：开启延迟规避机制，一旦消息发送失败会将 broker-a “悲观”地认为在接下来的一段时间内该 Broker 不可用，在为未来某一段时间内所有的客户端不会向该 Broker 发送消息。这个延迟时间就是通过 notAvailableDuration、latencyMax 共同计算的，就首先先计算本次消息发送失败所耗的时延，然后对应 latencyMax 中哪个区间，即计算在 latencyMax 的下标，然后返回 notAvailableDuration 同一个下标对应的延迟值。

温馨提示：如果所有的 Broker 都触发了故障规避，并且 Broker 只是那一瞬间压力大，那岂不是明明存在可用的 Broker，但经过你这样规避，反倒是没有 Broker 可用来，那岂不是更糟糕了？针对这个问题，会退化到队列轮循机制，即不考虑故障规避这个因素，按自然顺序进行选择进行兜底。

**笔者实战经验分享**

按照笔者的实践经验，RocketMQ Broker 的繁忙基本都是瞬时的，而且通常与系统 PageCache 内核的管理相关，很快就能恢复，故不建议开启延迟机制。因为一旦开启延迟机制，例如 5 分钟内不会向一个 Broker 发送消息，这样会导致消息在其他 Broker 激增，从而会导致部分消费端无法消费到消息，增大其他消费者的处理压力，导致整体消费性能的下降。

最后提醒: 消息发送时如果使用了 MessageQueueSelector，那消息发送的重试机制将失效，即 RocketMQ 客户端并不会重试，消息发送的高可用需要由业务方来保证

### 消息重试

看下获取到了路由信息后的发送代码

![](imag/1622522115044-0579a8d4-14b3-44bb-b4dc-6ea504b9b6ff.png)

可以看到timesTotal(发送次数)在同步模式下被设为1+this.defaultMQProducer.getRetryTimesWhenSendFailed()=3次，异步或者oneway模式为1次

即消息发送失败后，同步模式会重试2次，for循环内部的逻辑代码如下

![](imag/1622522128977-a73a70cd-e935-4011-a906-a31dfe1a91ec.png)

基本步骤如下

1. 选择消息队列
2. 发送消息，成功直接返回
3. 失败时，若异常为RemotingException、MQClientException，进行重试。若异常为MQBrokerException、InterruptedException，退出循环并抛异常

每个异常处理方法里都调用了一个updateFaultItem更新broker异常信息的方法，这里具体逻辑在broker容错机制里介绍

正常的消息发送失败后，会进行重试发送，这是MQ发送端实现高可用的关键之一

### 消息队列选择

#### 默认机制

消息队列选择实现在selectOneMessageQueue中，最终调用的是org.apache.rocketmq.client.latency.MQFaultStrategy#selectOneMessageQueue，看下具体实现

![](imag/1622522181405-5198b7dc-217c-43ee-a3be-0ab81ff0ab0c.png)

默认是不启用故障延迟机制的，所以走的是默认机制，即调用TopicPublishInfo#selectOneMessageQueue(java.lang.String)来进行队列选择，看下实现

![](imag/1622522190650-c6f1a748-6c04-4591-9b16-218f2954a8ba.png)

其逻辑比较简单，核心就是每次选择队列，对sendWhichQueue本地线程变量进行+1，然后取模获取对应消息队列，在某次发送失败时，会传入上次发送失败的brokerName，取模时，如果取到的消息队列还是上次发送失败的broker，则重新对sendWhichQueue+1，重新选择消息队列

既然这里有了broker的剔除机制，又为什么要单独设计一个broker故障延迟机制呢？

大家可以想想，在一次消息发送过程中，该方案能够规避上次发送失败的broker，重新对消息队列进行选择。但是如果是N次消息发送呢？N次发送都有可能会选择到故障broker的消息队列。

所以broker故障转移机制能够在一定时间范围内，规避选择到故障的broker

那么如果开启了broker故障转移机制，又是如何做到在一定时间内避免选择到故障broker的消息队列呢?

#### Broker故障转移机制

回想到Mq在消息发送异常时会调用updateFaultItem来更新broker异常信息，我们以此为切入点来分析故障容错机制，先看下org.apache.rocketmq.client.latency.MQFaultStrategy#updateFaultItem的实现

![](https://cdn.nlark.com/yuque/0/2021/png/744990/1622521982435-cbcc073f-6713-4f50-8e82-ab2941ff01b9.png)

分为两步

1. 根据消息发送时长(currentLatency)，计算broker不可用时长(duration)，即如果消息发送时间越久，mq会认为broker不可用的时长越久，broker不可用时长是个经验值，如果传入isolation为true，表示默认当前发送时长为30000L，即broker不可用时长为600000L
2. 调用latencyFaultTolerance.updateFaultItem更新broker异常容错信息

Broker故障转移机制的关键类LatencyFaultTolerance，其中有四个方法，如图所示

![](imag/1622522008620-63339265-45ed-4c97-9969-2c12cb65e9b7.png)

看下updateFaultItem的实现，一个broker对应一个faultItem，faultItem内容包含broker名称、消息发送时长、broker恢复正常的时间startTimestamp

![](imag/1622522014665-87a261cb-3943-4cf2-98af-afa673f6115a.png)

其关键点在于设置startTimestamp(意味broker预计可用的时间)，什么意思呢，假设某次消息发送时长为4000毫秒，则mq预计broker的不可用时长为18000L(根据latencyMax数组，notAvailableDuration数组对应关系得到)，则broker的预计恢复正常时间为：当前时间+不可用时长，即System.currentTimeMillis() + notAvailableDuration

因此LatencyFaultToleranceImpl#isAvailable判断broker是否预计可用的实现也很清晰了，只要当前时间>startTimestamp，即表示该broker正常了(逻辑意义上的正常，预计broker会在这个时间点后恢复正常)

![](imag/1622522021248-358994e5-6ee3-4c5d-9c7f-c08194224334.png)

在回到org.apache.rocketmq.client.latency.MQFaultStrategy#selectOneMessageQueue中，看下开启容错机制后的实现

![](imag/1622522031572-6445ecbc-e437-4b9e-bb29-a84e664db5a8.png)

现在整理下broker容错机制的思路及实现步骤

1. 在消息发送失败，mq根据消息发送耗时来预测该broker不可用的时长，并将broker名称，及”预计恢复时长“，存储于ConcurrentHashMap<String, FaultItem> faultItemTable中
2. 在开启消息容错后，选择消息队列时，会根据当前时间与FaultItem中该broker的预计恢复时间做比较，若(System.currentTimeMillis() - startTimestamp) >= 0，则预计该broker恢复正常，选择该broker的消息队列
3. 若所有的broker都预计不可用，随机选择一个不可用的broker，从路由信息中选择下一个消息队列，重置其brokerName，queueId，进行消息发送

介绍到这里，再回顾下开头提出的两个问题，可以一并回答

### 问题解决

**1、消息队列是如何选择的，即producer向哪个消息队列里发送消息？**

**2、消息发送失败了怎么办(网络原因，broker挂掉)？发送端如何实现的高可用？**

在默认队列选择机制下，会随机选择一个MessageQueue，若发送失败，轮询队列重新进行重试发送(屏蔽单次发送中不可用的broker)，同步模式下默认失败时重试发送2次

在开启容错机制后，消息队列选择时，会在一段时间内过滤掉mq认为不可用的broker，以此来避免不断向宕机的broker发送消息，从而实现消息发送高可用

## 消息消费的HA(读)![](imag/1622247328351-591408cc-1ce1-4b07-97fa-bfe3a1c0e5b4.png)

![](imag/1622216946459-fcdd4e78-70c2-47a0-aff8-f69a3ecb563f.png)

当主Master 宕机或者繁忙时（也就是Master所在记录未消费的最大偏移量大小 > 物理内存最大阈值总量 时表示服务器的内存不足）时，消费者就会从Slave中拉取消息消费。

**死信队列：**不会被消费者正常消费，只能在console控制台看，只能手动处理这些死信队列

## 负载均衡

### Producer的负载均衡

![](imag/1622250447288-8607bc11-ce56-46ac-aca6-dba965a21fdf.png)

生产者发送的消息会轮询落到不同的Broker和不同的Queue中。

### Consumer的负载均衡

#### 集群模式

![](imag/1622251055096-d31bbb1c-4df0-425d-a33f-b8517bd5b325.png)

- Queue只能分配给一个客户端，也就是说一个Queue上的消息不能被多个Consumer重复消费但是一个Consumer可以消费多个Queue里面的消息
- nQueue - 1Consumer（其中n表示1到更多）

#### 广播模式

- 由于广播模式下要求一条消息需要投递到一个消费组下面所有的消费者实例，所以也就没有消息被分摊消费的说法。
- 在实现上，其中一个不同就是在 consumer 分配 queue 的时候，所有 consumer 都分到所有的 queue。

## 可靠性优先的使用场景

### 全局顺序消息

消除所有并发的处理为单线程处理，Topic的读写队列设置为1，Producer和Consumer的并发设置为1，这和消息队列的高并发和高吞吐相互违背。

### 部分顺序消息

消息生产者要把同一个业务Id的消息发送到同一个Message Queue；在消费的时候要做到同一个Message Queue读取的消息不被并发处理。

1. 发送端使用MessageQueueSelector 类来控制把消息发往哪个Message Queue

![](imag/1628246079139-f3d4b50f-5c35-46f9-ba9d-f9a372fcbd08.png)

2. 消费端使用MessageListenerOrderly 来解决单MessageQueue的消息被并发处理的问题 ,禁止并发处理，为每个Consumer Queue加个锁，在消费每个消息之前会获取到这个消息对应的Consumer Queue所对应的锁，这样就可以保证了同一时间同一个Consumer Queue的消息不被并发消费，但不同的Consumer Queue的消息可以并发处理

![](imag/1628245959942-9a0c79e1-44ab-4fe3-86aa-7314a862f87d.png)

## 消息重复问题

producer.setRetryTimesWhenSendAsyncFailed(0); // 设置当异步方式下自动重试的次数，默认为2

1. 消息消费逻辑的幂等性
2. 维护一个已消费消息的记录，消费前查询这个消息是否被消费过。

## 动态增减机器

### 动态增减NameSrv

1. 通过代码设置：

producer.setNamesrvAddr("192.168.0.1:9876;192.168.0.2:9876");

consumer.setNamesrvAddr("192.168.0.1:9876;192.168.0.2:9876");

2. 使用Java启动参数设置：

对应的option是rocketmq.namesrv.addr

-Drocketmq.namesrv.addr=192.168.0.1:9876;192.168.0.2:9876

3. 通过Linux环境变量设置：

启动前设置变量：NAMESRV_ADDR

export NAMESRV_ADDR=192.168.0.1:9876;192.168.0.2:9876

4. 通过HTTP服务来设置，HTTP静态服务器寻址（默认）

该静态地址，客户端第一次会10s后调用，然后每个2分钟调用一次。

客户端启动后，会定时访问一个静态HTTP服务器，地址如下：[http://jmenv.tbsite.net:8080/rocketmq/nsaddr](http://jmenv.tbsite.net:8080/rocketmq/nsaddr)，这个URL的返回内容如下：

192.168.0.1:9876;192.168.0.2:9876

源码：org.apache.rocketmq.common.MixAll.java中：

![](imag/1628249808351-dfea0699-ac23-4dc5-b82f-02a1835b9374.png)

可以通过修改/etc/host 增加如下配置 10.232.191.1 jmenv.tbsite.net：

![](imag/1628249815583-33ffc2c0-3f0f-480c-a742-e834dd05c763.png)

在不设置nameserver地址时，依然可以访问，发送消息。

HTTP静态服务器资源(推荐) 客户端部署简单, Name Server集群可热部署

客户端启动后, 会定时访问一个静态HTTP服务器，比如: [http://jmenv.tbsite.net:8080/rocketmq/nsaddr](http://jmenv.tbsite.net:8080/rocketmq/nsaddr)

访问后，这个地址会返回 192.168.0.1:9876;192.168.0.2:9876

通过rocketmq.namesrv.domain参数来覆盖[jmenv.tbsite.net](http://jmenv.tbsite.net:8080/rocketmq/nsaddr)

通过rocketmq.namesrv.domain.subgroup参数来覆盖[nsaddr](http://jmenv.tbsite.net:8080/rocketmq/nsaddr)

### 动态增减Broker

1. sh ./bin/mqadmin updateTopic -b 192.168.0.1:10911 -t TestTopic -n

192.168.0.100:9876 新增一个Broker机器的地址是 192.168.0.1:10911，结果是在新增的Broker机器上，为TestTopic新创建了8个读写队列

2. 把新增的Topic指定到新的Broker机器上
3. 一个Topic只有一个Master Broker：减少Broker之前要确定Producer是否还在生产消息，当停止发送消息后才能停止Broker
4. 当某个Topic有多个Master Broker：停止一个Broker是否会丢失消息和Producer使用的发送消息方式有关，同步方式send(msg)发送会有自动重试机制,而异步方式send(msg, callback)或者用sendOneWay方式发送,会丢失切换过程中的消息,因为在此时producer.setRetryTimesWhenSendAsyncFailed(2)设置不起作用。