## 描述一下Spring中Bean的生命周期

1. 解析类得到BeanDefinition
2. 如果有多个构造方法，则要推断构造方法
3. 确定好构造方法后，进行实例化得到一个对象
4. 对对象中的加了@Autowired注解的属性进行属性填充
5. 回调Aware方法，比如BeanNameAware，BeanFactoryAware
6. 调用BeanPostProcessor的初始化前的方法
7. 调用初始化方法
8. 调用BeanPostProcessor的初始化后的方法，在这里会进行AOP
9. 如果当前创建的bean是单例的则会把bean放入单例池
10. 使用bean
11. Spring容器关闭时调用DisposableBean中destory()方法

  

## 你是怎么理解Spring中的IOC的？

IOC是Spring Framework中众多特性中的一个特性，表示控制反转，Spring相当于项目里的管家，管理项目中的对象，控制反转，表示对象的控制权本来是在程序员手中的，现在交给了Spring，所以Spring获得了对象的控制权，比如，Spring负责去进行实例化得到对象，Spring负责通过反射去给对象中的属性进行赋值，这些动作都不需要程序员去做，Spring自动帮程序员做了。

  

  

## 你是怎么理解Spring中的AOP的？

AOP表示面向切面编程，是Spring Framework中众多特性中的一个特性，AOP可以对某个对象或某些对象的功能进行增加，比如对象中的方法进行增加，可以在执行某个方法之前额外的做一些事情，在某个方法执行之后额外的做一些事情，通常，我们会利用AOP机制来实现权限控制，日志记录，缓存，包括Spring中的事务也是通过AOP来实现的。在Spring中，AOP是通过动态代理来实现的。

## Spring中的@Autowired注解的工作原理是怎样的？

@Autowired注解表示自动注入，是Spring体系中Java Config取代xml中的一种，因为在使用xml时也可以设置是否需要自动注入，只不过Spring默认是关闭的，所以不为人所知。

  

而@Autowired注解则取代了xml中的自动注入功能，并进行了优化，使得Spring中的自动注入功能更加方便使用。

  

@Autowired注解可以写在属性上，构造方法上，普通方法上，表示Spring在进行生命周期的过程中可以通过这些属性和方法进行属性的自动填充，比如写在属性上，那么Spring就会先根据属性的类型（byType）去Spring容器找对应类型的bean，如果找到一个则通过反射赋值给该属性，如果找到多个则再根据属性的名字确定其中一个bean，如果根据名字没有找到则报错，如果找到了，则把这个bean也是通过反射的方式赋值给这个属性。

  

如果@Autowired注解是普通方法上，也就是我们平时说的setter方法上，那么Spring会根据setter方法的参数类型去找bean，找到多个再根据根据属性的名字去进行筛选，找到了bean之后再调用set方法进行赋值。

  

## Spring中的@Transactional注解的工作原理是怎样的？

在使用Spring框架时，可以有两种使用事务的方式，一种是编程式的，一种是申明式的，@Transactional注解就是申明式的。

  

首先，事务这个概念是数据库层面的，Spring只是基于数据库中的事务进行了扩展，以及提供了一些能让程序员更加方便操作事务的方式。

  

比如我们可以通过在某个方法上增加@Transactional注解，就可以开启事务，这个方法中所有的sql都会在一个事务中执行，统一成功或失败。

  

在一个方法上加了@Transactional注解后，Spring会基于这个类生成一个代理对象，会将这个代理对象作为bean，当在使用这个代理对象的方法时，如果这个方法上存在@Transactional注解，那么代理逻辑会先把事务的自动提交设置为false，然后再去执行原本的业务逻辑方法，如果执行业务逻辑方法没有出现异常，那么代理逻辑中就会将事务进行提交，如果执行业务逻辑方法出现了异常，那么则会将事务进行回滚。

  

当然，针对哪些异常回滚事务是可以配置的，可以利用@Transactional注解中的rollbackFor属性进行配置，默认情况下会对RuntimeException和Error进行回滚。

  

## Spring中Bean的后置处理器是什么意思？

Spring中Bean的后置处理器是Spring中提供的一个扩展点，允许程序员自己去定义一个Bean的后置处理器，同时因为Spring中设计了这个机制，在Spring源码的内部也利用了Bean的后置处理器机制，比如AutowiredAnnotationBeanPostProcessor就是一个Bean的后置处理器，它主要用来处理Bean中的Autowired注解，比如给某个属性赋值。

  

Spring的后置处理器，可以理解为，工厂中的流水线，比如生产一个杯子，首先会生产一个原始的杯子，然后再去给这个杯子刷漆，再去给这个杯子画图案，再去给这个杯子做其他的事情，这个例子里面的杯子就是Spring通过构造方法反射实例化出来的Bean，刷漆，画图案就是Bean的后置处理器。

  

同时Spring中的AOP功能，就是通过Bean的后置处理器来实现的，实现类是AnnotationAwareAspectJAutoProxyCreator，它也是一个Bean的后置处理器。可以去生成一个代理对象。

  

如果定义了多个Bean的后置处理器，可以通过实现Ordered接口来控制Bean的后置处理器的执行顺序。

  

## Spring中的BeanFactory的后置处理器是什么意思？

Spring中的BeanFactory的后置处理器是Spring中提供的一个扩展点，允许程序员自己去定义一个BeanFactory的后置处理器，因为Spring中设计了这个机制，在Spring源码的内部也利用了BeanFactory的后置处理器，比如ConfigurationClassPostProcessor，它就是一个BeanFactory的后置处理器，它负责解析配置类，完成扫描，把扫描得到的BeanDefinition注册到BeanFactory中。

  

BeanFactory的后置处理器中可以拿到BeanFactory，而拿到BeanFactory之后就可以使用BeanFactory中存储的东西了，比如BeanDefinition，比如可以创建Bean。

  

如果定义了多个BeanFactory的后置处理器，可以通过实现Ordered接口来控制BeanFactory的后置处理器的执行顺序。

  

## Spring容器启动过程有哪些步骤？

1. 初始化一个Reader和Scanner，Reader可以用来注册单个BeanDefinition，Scanner用来扫描得到BeanDefinition，
2. 通过Reader把配置类注册为一个BeanDefinition
3. 调用refresh方法，开始启动Spring容器
4. 先获取一个Bean工厂
5. 预先往Bean工厂中添加一些Bean后置处理器，和一些单例bean，和一些其他的配置
6. 执行Bean工厂的后置处理器，这里会进行扫描，扫描bean和bean的后置处理器
7. 实例化bean的后置处理器并且排序，然后添加到Bean工厂中去
8. 初始化用来进行国际化的MessageSource
9. 初始化事件广播器
10. 注册事件监听器
11. 开始实例化非懒加载的单例bean
12. 发布ContextRefreshedEvent事件

  

## Spring中有哪些扩展点？

1. BeanDefinitionRegistryPostProcessor: 在Spring启动的过程中可以用来注册、移除、修改BeanDefinition
2. BeanFactoryPostProcessor: 在Spring启动的过程中可以用来操作BeanFactory
3. BeanPostProcessor：在创建Bean的过程中可以对实例化及其前后进行干涉，初始化及其前后进行干涉
4. Aware接口：比如BeanNameAware， BeanFactoryAware等等，Aware表示回调，Spring会回调Aware接口中的方法，而程序员就可以在Aware接口的方法中去进行干涉
5. 事件机制：Spring在不同的阶段会发布不同的事件，程序员可以定义监听器来监听这些事件
6. FactoryBean：允许程序员自定义一个bean对象

  

## Spring中有哪些依赖注入的方式？

首先分两种：

1. 手动注入，通常使用XML的方式定义Bean的时候就会通过手动方式给属性进行赋值
2. 自动注入，利用@Autowired注解利用Spring自动给属性进行赋值

  

手动注入分为：

1. 手动指定值
2. 手动指定bean的名字
3. 实例工厂方法得到bean
4. 静态工厂方法得到bean

  

手动注入站在底层原理角度分为：

1. 通过构造方法注入
2. 通过set方法注入

  

自动注入分为：

1. 通过属性自动注入
2. 通过set方法自动注入
3. 通过构造方法自动注入

  

## Spring中为什么要用三级缓存来解决循环依赖？

Spring中之所以会出现循环依赖跟Bean的生命周期有关系，在创建一个Bean的过程中如果依赖的另外一个Bean还没有创建，就会需要去创建依赖的那个Bean，而如果两个Bean相互依赖的话，就会出现循环依赖的问题。

  

Spring使用三级缓存解决了循环依赖的问题：

1. 第一级缓存是单例池**singletonObjects**：它是用来保存经过了完整生命周期之后的bean。
2. 第二级缓存是**earlySingletonObjects**：它是用来保存暂时还没有经过完整生命周期的bean。
3. 第三级缓存是**singletonFactories**：它是用来保存提前进行AOP的工厂，它的作用是预先准备一个工厂，**这个工厂是在需要时才执行**

太复杂了，看周瑜老师的视频课吧