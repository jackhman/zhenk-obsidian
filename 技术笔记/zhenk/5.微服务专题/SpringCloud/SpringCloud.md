参考资料：[SpingCloud\_无奈的码农的博客-CSDN博客](https://blog.csdn.net/qq_27566167/category_12194748.html)

[JavaRain/docs/SpringCloud/SpringCloud.md at edcd4f35b39039259a631b9684a76511d2463b59 · ChaseRain/JavaRain · GitHub](https://github.com/ChaseRain/JavaRain/blob/edcd4f35b39039259a631b9684a76511d2463b59/docs/SpringCloud/SpringCloud.md)
# 1、SpringCloud入门概述

## 1.1 SpringCloud是什么

springcloud官网： https://spring.io/projects/spring-cloud#learn



![image-20210201211026978](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201211026978.png>)



![image-20210201211150517](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201211150517.png>)

## 1.2 SpringBoot与SpringCloud的关系

![image-20210201211354609](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201211354609.png>)

## 1.3 Dubbo 和 SpringCloud技术选型

### 1、分布式+服务治理Dubbo

目前成熟的互联网架构:应用服务化拆分＋消息中间件

![image-20210201212331080](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201212331080.png>)





### 2、Dubbo 和 SpringCloud对比



可以看一下社区活跃度

https://github.com/dubbo

https://github.com/springcloud



![image-20210201212745280](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201212745280.png>)



![image-20210201212830068](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201212830068.png>)

![image-20210201213109728](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201213109728.png>)



## 1.4 SpringCloud能干什么

![image-20210201213607037](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201213607037.png>)



## 1.5 SpringCloud在哪下

官网 ： https://spring.io/projects/spring-cloud/

![image-20210201213917897](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201213917897.png>)



![image-20210201213933327](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201213933327.png>)

![image-20210201213945729](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201213945729.png>)



# 2、总体介绍

![image-20210201214803071](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201214803071.png>)

## 2.1SpringCloud版本选择



![image-20210201214850789](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201214850789.png>)

![image-20210201215047918](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201215047918.png>)

![image-20210201214945469](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201214945469.png>)

# 3、创建父工程



直接创建一个名为SpringCloud的Maven空项目即可



**然后后面全部的项目都是父工程的一个子模块，并且都是maven的空项目**



建立一个数据库：db01

![image-20210202221055411](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202221055411.png>)

## pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.wu</groupId>
    <artifactId>SpringCloud</artifactId>
    <version>1.0-SNAPSHOT</version>
   
    <!--打包方式-->
    <packaging>pom</packaging>

    <!--定义版本号-->
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <junit.version>4.12</junit.version>
        <lombok.version>1.18.16</lombok.version>
        <log4j.version>1.2.17</log4j.version>
        <logback-core.version>1.2.3</logback-core.version>
        <mysql-connector-java.version>8.0.21</mysql-connector-java.version>
        <druid.version>1.1.23</druid.version>
        <mybatis-spring-boot-starter.version>2.1.4</mybatis-spring-boot-starter.version>
        <spring-boot-dependencies.version>2.3.8.RELEASE</spring-boot-dependencies.version>
        <spring-cloud-dependencies.version>Hoxton.SR9</spring-cloud-dependencies.version>
    </properties>

	<!--这只是依赖管理，如果子项目需要用到依赖，只是省略了版本号而已，实际上还是要导依赖-->
    <dependencyManagement>
        <dependencies>
            <!--很重要的包：springcloud的依赖-->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud-dependencies.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <!--springboot-->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-dependencies</artifactId>
                <version>${spring-boot-dependencies.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
            <!--数据库-->
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version>${mysql-connector-java.version}</version>
            </dependency>
            <!--数据源-->
            <dependency>
                <groupId>com.alibaba</groupId>
                <artifactId>druid</artifactId>
                <version>${druid.version}</version>
            </dependency>
            <!--mybatis的springboot启动器-->
            <dependency>
                <groupId>org.mybatis.spring.boot</groupId>
                <artifactId>mybatis-spring-boot-starter</artifactId>
                <version>${mybatis-spring-boot-starter.version}</version>
            </dependency>
            <!--日志测试-->
            <!--junit-->
            <dependency>
                <groupId>junit</groupId>
                <artifactId>junit</artifactId>
                <version>${junit.version}</version>
            </dependency>
            <!--lombok-->
            <dependency>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>${lombok.version}</version>
            </dependency>
            <!--log4j-->
            <dependency>
                <groupId>log4j</groupId>
                <artifactId>log4j</artifactId>
                <version>${log4j.version}</version>
            </dependency>
            <dependency>
                <groupId>ch.qos.logback</groupId>
                <artifactId>logback-core</artifactId>
                <version>${logback-core.version}</version>
            </dependency>
        </dependencies>
    </dependencyManagement>
    <build>
        <!--打包插件-->
    </build>

</project>
```





# 4、pojo管理：springcloud-api

现在这个api拆分出来只管pojo，这个微服务就写完了

![image-20210201233314885](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201233314885.png>)

### pom.xml

```xml
<!--当前的Module自己需要的依赖，如果父依赖中已经配置了，这里就不用写了-->
<dependencies>
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
    </dependency>
</dependencies>  
```

### Dept.java

```java
@Data
@NoArgsConstructor
@Accessors(chain = true)  //链式写法
//所有的实体类务必实现序列化,通讯需求
public class Dept implements Serializable {//Dept,实体类 orm 类表关系映射
    private static final long serialVersionUID = 708560364349809174L;
    private Long deptno; //主键
    private String dname;

    //看下这个数据存在哪个数据库的字段~ 微服务 ，一个服务对应一个数据库
    //同一个信息可能存在不同的数据库
    private String db_source;

    public Dept(String dname) {
        this.dname = dname;
    }

}
```

# 5、服务提供者：springcloud-provider-dept-8001

![image-20210201233640050](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210201233640050.png>)





### pom.xml

```xml
<dependencies>
    <!--我们需要拿到实体类，所以要配置api module-->
    <dependency>
        <groupId>com.wu</groupId>
        <artifactId>springcloud-api</artifactId>
        <version>1.0-SNAPSHOT</version>
    </dependency>
    <!--junit-->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
    </dependency>
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>druid</artifactId>
    </dependency>
    <!--日志门面-->
    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-core</artifactId>
    </dependency>
    <dependency>
        <groupId>org.mybatis.spring.boot</groupId>
        <artifactId>mybatis-spring-boot-starter</artifactId>
    </dependency>
    <!--test-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-test</artifactId>
    </dependency>
    <!--web-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <!--jetty：尝试着用这个当应用服务器，与Tomcat没什么区别-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jetty</artifactId>
    </dependency>
    <!--热部署工具-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
    </dependency>
</dependencies>
```

### DeptMapper

```java
@Mapper
@Repository
public interface DeptMapper {
    //添加部门
    boolean addDept(Dept dept);

    //根据ID查询部门
    Dept queryById(@Param("deptno") long id);

    //查询全部部门
    List<Dept> queryall();
}
```

### DeptService

```java
public interface DeptService {
    boolean addDept(Dept dept);

    Dept queryById(long id);

    List<Dept> queryall();

}
```

### DeptServiceImpl

```java
@Service
public class DeptServiceImpl implements DeptService {

    @Autowired
    private DeptMapper deptMapper;

    @Override
    public boolean addDept(Dept dept) {
        return deptMapper.addDept(dept);
    }

    @Override
    public Dept queryById(long id) {
        return deptMapper.queryById(id);
    }

    @Override
    public List<Dept> queryall() {
        return deptMapper.queryall();
    }
}
```



### DeptMapper.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.wu.springcloud.mapper.DeptMapper">
    <insert id="addDept" parameterType="Dept">
        insert into dept(dname,db_source)
        values (#{dname},DATABASE());
    </insert>

    <select id="queryById" resultType="Dept" parameterType="Long">
        select * from dept where deptno = #{deptno};
    </select>

    <select id="queryall" resultType="Dept">
        select * from dept;
    </select>
</mapper>
```



### mybatis-config.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<!-- configuration核心配置文件 -->
<configuration>
    <settings>
        <!--开启二级缓存-->
        <setting name="cacheEnabled" value="true"/>
    </settings>
</configuration>
```



### application.yml

```yml
server:
  port: 8001

#mybatis配置
mybatis:
  type-aliases-package: com.wu.springcloud.pojo
  config-location: classpath:mybatis/mybatis-config.xml
  mapper-locations: classpath:mybatis/mapper/*.xml

#spring的配置
spring:
  application:
    name: springcloud-provider-dept  # 3个服务名称一致是前提
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource  #数据源
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://127.0.0.1:3306/db01?useUnicode=true&characterEncoding=UTF-8&useSSL=true&serverTimezone=UTC
    username: root
    password: Wl123456
```



### DeptController

```java
//提供Restfull服务!!
@RestController
public class DeptController {

    @Autowired
    private DeptServiceImpl deptService;

    @PostMapping("/dept/add")
    public boolean addDept(Dept dept) {
        return deptService.addDept(dept);
    }


    @GetMapping("/dept/get/{id}")
    public Dept getDept(@PathVariable("id") Long id) {
        Dept dept = deptService.queryById(id);
        if (dept == null) {
            throw new RuntimeException("Fail");
        }
        return dept;
    }

    @GetMapping("/dept/list")
    public List<Dept> queryAll() {
        return deptService.queryall();
    }

}
```



### 主启动类DeptProvider_8001

```java
//启动类
@SpringBootApplication
public class DeptProvider_8001 {
    public static void main(String[] args) {
        SpringApplication.run(DeptProvider_8001.class, args);
    }
}
```

最后启动项目访问Controller里面的接口测试即可，这个pojo类在别的项目里面，我们照样可以拿到，这就是微服务的简单拆分的一个小例子

# 6、服务消费者：springcloud-consumer-dept-80



![image-20210202201457445](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202201457445.png>)



### pom.xml

```xml
<!--消费者只需要  实体类  +  Web 依赖即可-->
<dependencies>
    <dependency>
        <groupId>com.wu</groupId>
        <artifactId>springcloud-api</artifactId>
        <version>1.0-SNAPSHOT</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <!--热部署工具-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
    </dependency>
</dependencies>
```

这里要用到  `RestTemplate` ,但是它的类中没有Bean，所以我们要把它注册到Bean中

### ConfigBean

```java
@Configuration
public class ConfigBean {  //@Configuration ... 相当于spring中的配置文件 applicationContext.xml文件
    @Bean
    public RestTemplate getRestTemplate() {
        return new RestTemplate();
    }
}
```



### DeptConsumerController

```java
@Controller
public class DeptConsumerController {

    //消费者 : 不因该有service层
    //RestTemplate  有很多方法给我们直接调用  !  它的类中没有Bean所以要我们自己把它注册到Bean中
    //(url, 实体：Map, Class<T> responseType)
    @Autowired
    private RestTemplate restTemplate;  //提供多种便捷访问远程http服务的方法，简单的restful服务模板

    private static final String REST_URL_PREFIX = "http://localhost:8001";

    @RequestMapping("/consumer/dept/get/{id}")
    @ResponseBody
    public Dept getDept(@PathVariable("id") Long id) {
        //service不在本项目中，所以要去远程项目获取
        //远程只能用  get 方式请求，那么这里也只能通过 get 方式获取
        return restTemplate.getForObject(REST_URL_PREFIX + "/dept/get/" + id, Dept.class);
    }

    @RequestMapping("/consumer/dept/add")
    @ResponseBody
    public boolean add(Dept dept) {
        //远程只能用  post 方式请求，那么这里也只能通过 post 方式获取
        return restTemplate.postForObject(REST_URL_PREFIX + "/dept/add", dept, Boolean.class);
    }

    @RequestMapping("/consumer/dept/list")
    @ResponseBody
    public List<Dept> queryAll() {
        return restTemplate.getForObject(REST_URL_PREFIX + "/dept/list", List.class);
    }

}
```

然后你会发现，原来远程的post请求直接在url是拒绝访问的，但是在这个里面可以访问，只是结果为null

### application.yml

```yml
server:
  port: 80
```





### 主启动类DeptConsumer_80

```java
@SpringBootApplication
public class DeptConsumer_80 {
    public static void main(String[] args) {
        SpringApplication.run(DeptConsumer_80.class, args);
    }
}
```



最后启动服务提供者  springcloud-provider-dept-8001

然后启动服务消费者 springcloud-consumer-dept-80

通过服务消费者的url请求去获取服务提供者对应的请求，照样可以拿到



# 7、Eureka服务注册与发现

## 7.1、什么是Eureka

![image-20210202194106171](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202194106171.png>)

![image-20210202194635513](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202194635513.png>)





## 7.2、原理讲解

![image-20210202194819584](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202194819584.png>)

![image-20210202194844907](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202194844907.png>)

![image-20210202194857876](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202194857876.png>)



![image-20210202194917865](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202194917865.png>)

![image-20210202195102974](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202195102974.png>)

![image-20210202195011174](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202195011174.png>)



![image-20210202195004133](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202195004133.png>)





## 7.3、springcloud-eureka-7001

### pom.xml

```xml
<!--导包~-->
<dependencies>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-eureka-server</artifactId>
        <version>1.4.7.RELEASE</version>
    </dependency>
    <!--热部署工具-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
    </dependency>
</dependencies>
```



### application.yml

```yml
server:
  port: 7001
  servlet:
    context-path: /eureka

#Eureka配置
eureka:
  instance:
    hostname: localhost # Eureka服务端实例的名字
  client:
    register-with-eureka: false  # 表示是否向Eureka注册中心注册自己
    fetch-registry: false #如果为false，则表示自己为注册中心
    service-url: # 监控页面地址
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
```



### 主启动类：EurekaServer_7001

```java
@SpringBootApplication
@EnableEurekaServer //EnableEurekaServer表示服务端的启动类，可以接收别人注册进来
public class EurekaServer_7001 {
    public static void main(String[] args) {
        SpringApplication.run(ConfigEurekaServer_7001.class, args);
    }
}
```



启动之后访问 http://localhost:7001/

![image-20210202201258376](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202201258376.png>)



## Eureka的自我保护机制

![image-20210202204307917](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202204307917.png>)

![image-20210202204328410](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202204328410.png>)

## 7.4、8001服务注册与发现

springcloud-provider-dept-8001

首先肯定是要导入对应的依赖

### pom.xml

```xml
<!--Eureka-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-eureka</artifactId>
    <version>1.4.7.RELEASE</version>
</dependency>
```

然后在配置文件中添加对应的Eureka注册配置

### application.yml

```yml
#eureka 的配置，服务注册到哪里
eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka/
```

最后在主启动类上添加注解

```java
@EnableEurekaClient  //在服务启动后自动注册到Eureka中
```

启动springcloud-config-eureka-7001，启动完毕后再启动下面的服务

启动springcloud-provider-dept-8001，等一会再次访问 http://localhost:7001/



![image-20210202210301741](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202210301741.png>)



但是你点击服务状态信息会跳到一个页面

![image-20210202210434537](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202210434537.png>)

### actuator完善监控信息

所以这个时候我们应该是少了什么东西，然后我们继续在 8001 里面添加依赖

```xml
<!--actuator完善监控信息-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```



重启8001项目再次点击服务状态信息，跳到了一个页面，但是里面什么都没有，这个时候我们就要配置一些信息了，这个信息只是在团队开发的时候别人会通过这个信息来了解这个服务是谁写的

现在我们在8001项目的配置文件中添加一些配置

```yml
#eureka 的配置，服务注册到哪里
eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka/
  instance:
    instance-id: springcloud-provider-dept8001  #修改Eureka上的默认的状态名字

#info配置（点击状态信息会返回的东西，可以百度）
info:
  app.name: wulei-springcloud    
  company.name: blog.wulei2921625957.com
```

然后你重启8001项目，再次点击项目状态信息会返回你在上面添加的信息



那如何通过代码来让别人发现自己呢？

### 服务发现

在8001项目的controller里面添加

```java
import org.springframework.cloud.client.discovery.DiscoveryClient;

//获取一些配置的信息，得到一些具体微服务
@Autowired
private DiscoveryClient client;

//注册进来的微服务~ ，获取一些信息
@GetMapping("/dept/discovery")
public Object discovery() {
    //获取微服务列表的清单
    List<String> services = client.getServices();
    System.out.println("discovery=>services:" + services);

    //得到一个具体的微服务信息,通过具体的微服务ID applicationName
    List<ServiceInstance> instances = client.getInstances("SPRINGCLOUD-PROVIDER-DEPT");
    for (ServiceInstance instance : instances) {
        System.out.println(
            instance.getHost() + "\t" +
            instance.getPort() + "\t" +
            instance.getUri() + "\t" +
            instance.getServiceId()
        );
    }
    return instances;
}
```

然后在8001项目主启动类上添加服务发现注解即可

这个注解我试了一下，不加也可以访问上面的接口返回信息

```java
@EnableDiscoveryClient //服务发现
```

重启8001项目并访问 http://localhost:8001/dept/discovery

![image-20210202211355622](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202211355622.png>)

# 8、Eureka集群的搭建 

![image-20210202212154668](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202212154668.png>)





## 8.1、修改域名映射

为了体验集群搭载在不同的电脑上，我们进入`C:\Windows\System32\drivers\etc`里面修改hosts文件，在文件的末尾添加下面几行

```xml
127.0.0.1       eureka7001.com
127.0.0.1       eureka7002.com
127.0.0.1       eureka7003.com
```

## 8.2、修改7001配置文件

### application.yml

```yml
server:
  port: 7002
  servlet:
    context-path: /eureka

#Eureka配置
eureka:
  instance:
    #    hostname: localhost # Eureka服务端实例的名字
    hostname: eureka7001.com # Eureka服务端实例的名字
  client:
    register-with-eureka: false  # 表示是否向Eureka注册中心注册自己
    fetch-registry: false #如果为false，则表示自己为注册中心
    service-url: # 监控页面地址
      # 单机模式下配置自己一个就够了：defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
      # 集群（关联）: 我们需要在7001里面去挂载7002和7003
      defaultZone: http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
```





## 8.3 、springcloud-eureka-7002

创建Eureka注册中心7002项目（和7001一模一样）

### pom.xml

依赖和7001一样

### EurekaServer_7002

主启动类

```java
//启动之后访问 http://localhost:7002/
@SpringBootApplication
@EnableEurekaServer //EnableEurekaServer表示服务端的启动类，可以接收别人注册进来
public class EurekaServer_7002 {
    public static void main(String[] args) {
        SpringApplication.run(ConfigEurekaServer_7002.class, args);
    }
}
```

### application.yml

```yml
server:
  port: 7003
  servlet:
    context-path: /eureka

#Eureka配置
eureka:
  instance:
    #    hostname: localhost # Eureka服务端实例的名字
    hostname: eureka7002.com # Eureka服务端实例的名字
  client:
    register-with-eureka: false  # 表示是否向Eureka注册中心注册自己
    fetch-registry: false #如果为false，则表示自己为注册中心
    service-url: # 监控页面地址
      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7003.com:7003/eureka/
```





## 8.4 、springcloud-eureka-7003

创建Eureka注册中心7003项目（和7001一模一样）

### pom.xml

依赖和7001一样

### EurekaServer_7003

主启动类

```java
//启动之后访问 http://localhost:7003/
@SpringBootApplication
@EnableEurekaServer //EnableEurekaServer表示服务端的启动类，可以接收别人注册进来
public class EurekaServer_7003 {
    public static void main(String[] args) {
        SpringApplication.run(ConfigEurekaServer_7003.class, args);
    }
}
```

### application.yml

```yml
server:
  port: 7003

#Eureka配置
eureka:
  instance:
    #    hostname: localhost # Eureka服务端实例的名字
    hostname: eureka7003.com # Eureka服务端实例的名字
  client:
    register-with-eureka: false  # 表示是否向Eureka注册中心注册自己
    fetch-registry: false #如果为false，则表示自己为注册中心
    service-url: # 监控页面地址
      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/
```



然后启动7001、7002、7003项目

然后访问：http://localhost:7001/  、http://localhost:7002/  、http://localhost:7003/ 



![image-20210202214950627](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202214950627.png>)



然后你可以停掉一个集群，然后又启动停掉的那个集群，发现它会自动注册上去



## 8.5、8001项目注册多个注册中心

要把8001项目注册到多个注册中心上去，其实很简单，只需要改动配置文件即可

### application.yml（8001）

```yml
# ...

#eureka 的配置，服务注册到哪里
eureka:
  client:
    service-url:
      # defaultZone: http://localhost:7001/eureka/
      # 然而现在服务发布要发布到3个注册中心上面去
      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
# ...
```

然后启动8001项目，刷新http://localhost:7001/  、http://localhost:7002/  、http://localhost:7003/ 即可发现

![image-20210202215512999](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202215512999.png>)





# 9、CAP原则及对比Zookeeper

![image-20210202215831461](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202215831461.png>)

![image-20210202215941127](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202215941127.png>)



## 作为服务注册中心，Eureka比Zookeeper好在那里？



![image-20210202220131502](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202220131502.png>)

![image-20210202220226349](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202220226349.png>)

![image-20210202220451883](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202220451883.png>)

# 10、Ribbon负载均衡

## ribbon是什么？

![image-20210202221241417](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202221241417.png>)

<img src="D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202221729868.png" alt="image-20210202221729868" style="zoom:50%;" />



## ribbon能干什么？

![image-20210202222340405](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210202222340405.png>)

## 10.1、springcloud-consumer-dept-80使用Ribbon

首先80项目要添加两个依赖

### pom.xml

```xml
<!--Ribbon-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-ribbon</artifactId>
    <version>1.4.7.RELEASE</version>
</dependency>
<!--导入Ribbon的同时要导入erueka，因为它要发现服务从那里来-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-eureka</artifactId>
    <version>1.4.7.RELEASE</version>
</dependency>
```

由于我们消费者客户端是利用RestTemplate来进行服务的读取，所以我们让RestTemplate实现负载均衡，只需要加一个注解即可`@LoadBalanced`

### ConfigBean

```java
@Bean
@LoadBalanced  //Ribbon,只要加了这个注解，这个RestTemplate就变成了负载均衡
public RestTemplate getRestTemplate() {
    return new RestTemplate();
}
```

由于我们导入了Eureka，所以我们要配置Eureka

### application.yml

```yml
server:
  port: 80

#Eureka配置
eureka:
  client:
    register-with-eureka: false #不向eureka中注册自己
    service-url:
      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/

```



### DeptConsumer_80

```java
//Ribbon和 Eureka整合以后，客户端可以直接调用，不用关心IP地址和端口号
@SpringBootApplication
//@EnableEurekaClient  //在服务启动后自动注册到Eureka中
public class DeptConsumer_80 {
    public static void main(String[] args) {
        SpringApplication.run(DeptConsumer_80.class, args);
    }
}
```

最后还有一个问题，就是我们的RestTemplate实现了负载均衡，那么怎么体现它呢？我们现在就只是在它身上加了一个注解，那肯定是不行的，我们还要改变RestTemplate的请求路径，让其自动选择，而不是写死

### DeptConsumerController

```java
//private static final String REST_URL_PREFIX = "http://localhost:8001";
//用Ribbon做负载均衡的时候不应该写它，不应该写死,地址应该是一个变量,通过服务名来访问
private static final String REST_URL_PREFIX = "http://SPRINGCLOUD-PROVIDER-DEPT";
```

最后启动7001、7002、7003项目后再启动8001项目，等8001项目注册到它们3个中后启动80项目

然后访问 http://localhost/consumer/dept/list  可以看到正常返回结果，当然了，在这里也看不出负载均衡，所以下面会配置多个服务提供者和多个数据库，来测试负载均衡的效果。



## 10.2、使用Ribbon实现负载均衡

![image-20210203102021127](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203102021127.png>)



### 创建另外两个数据库：db02、db03

![image-20210203102251057](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203102251057.png>)



<img src="D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203102338828.png" alt="image-20210203102338828" style="zoom:67%;" /><img src="D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203102346731.png" alt="image-20210203102346731" style="zoom:67%;" />



### 创建另外两个服务提供者：8002、8003

直接新建两个子model，然后把8001的所有文件全部拷贝（提供相同的服务），一摸一样的，然后更改一下配置文件即可

- pom.xml依赖

- application.yml的端口号，对应的数据库，还有instance-id，例如：instance-id: springcloud-provider-dept8002

- 注意：下面的这个服务ID不要改

- ```yml
  
  ```yml
  spring:
    application:
      name: springcloud-provider-dept  # 3个服务名称一致是前提
    ```
现在的项目预览

![image-20210203105058120](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203105058120.png>)



然后，启动

- springcloud-config-eureka-7001
- springcloud-config-eureka-7002
- springcloud-config-eureka-7003
- springcloud-provider-dept-8001
- springcloud-provider-dept-8002
- springcloud-provider-dept-8003
- springcloud-consumer-dept-80

![image-20210203120141132](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203120141132.png>)



然后访问http://localhost/consumer/dept/list ，多访问几次，查询的数据没变，但是数据库变了

![image-20210203120244511](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203120244511.png>)



![image-20210203120251365](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203120251365.png>)



![image-20210203120306639](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203120306639.png>)



你会发现是轮询，就是每个服务轮流来，这也Ribbon的默认算法

### Ribbon自定义均衡算法

里面有个接口非常重要：IRule，基本上全部的均衡算法都实现了这个接口

![image-20210203133008139](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203133008139.png>)

里面有这么多均衡算法，因为默认是轮询算法，也就是RoundRobinRule，那我们要怎么使用别的算法呢？

只需要在**80项目**的config类里面注册Bean即可

```java
//IRule
//RoundRobinRule:轮询
//RandomRule：随机
//AvailabilityFilteringRule：会先过滤掉跳闸、访问故障的服务~，对剩下的进行轮询
//RetryRule：会先按照轮询获取服务，如果服务获取失败，则会在指定的时间内进行重试
@Bean
public IRule myRule() {
    return new RandomRule(); //默认为轮询，现在我们使用随机的
}
```

然后启动80项目，访问http://localhost/consumer/dept/list，多访问几次，发现每次出现的数据库都没规律可循

我们要学会自定义负载均衡算法，为了体现我们使用了自定义的负载均衡算法，我们建包不建在主启动类的同级目录（官方建议）

![image-20210203133505705](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203133505705.png>)

把刚刚写在ConfigBean里面的Bean注释掉，我们来模仿它的算法写一个自己的算法

#### WuRandomRule

```java
public class WuRandomRule extends AbstractLoadBalancerRule {

    //每个机器，访问5次，换下一个服务（总共3个）
    //total = 0 默认=0，如果=5，我们指向下一个服务结点
    //index = 0 默认=0，如果total=5，那么index+1，

    private int total = 0; //被调用的次数
    private int currentIndex = 0; //当前是谁在提供服务

    public Server choose(ILoadBalancer lb, Object key) {
        if (lb == null) {
            return null;
        }
        Server server = null;

        while (server == null) {
            if (Thread.interrupted()) {
                return null;
            }
            List<Server> upList = lb.getReachableServers(); //获得还活着的服务
            List<Server> allList = lb.getAllServers();  //获得全部的服务

            int serverCount = allList.size();
            if (serverCount == 0) {
                return null;
            }

            //=============================================================

            if (total < 5) {
                total++;
            } else {
                total = 0;
                currentIndex++;
                if (currentIndex >= serverCount) {
                    currentIndex = 0;
                }
            }
            server = upList.get(currentIndex);
            //=============================================================
            if (server == null) {
                Thread.yield();
                continue;
            }

            if (server.isAlive()) {
                return (server);
            }
            server = null;
            Thread.yield();
        }

        return server;

    }

    protected int chooseRandomInt(int serverCount) {
        return ThreadLocalRandom.current().nextInt(serverCount);
    }

    @Override
    public Server choose(Object key) {
        return choose(getLoadBalancer(), key);
    }

    @Override
    public void initWithNiwsConfig(IClientConfig clientConfig>) {

    }
}
```

#### WuRule

```java
@Configuration
public class WuRule {
    
    @Bean
    public IRule myRule() {
        return new WuRandomRule(); //默认为轮询，现在试使用自己自定义的
    }
}
```

最后还要在主启动类添加扫描注解，在微服务启动的时候就能去加载我们自定义的Ribbon类

#### DeptConsumer_80

```java
//Ribbon和 Eureka整合以后，客户端可以直接调用，不用关心IP地址和端口号
@SpringBootApplication
@EnableEurekaClient  //在服务启动后自动注册到Eureka中
//在微服务启动的时候就能去加载我们自定义的Ribbon类
@RibbonClient(name = "SPRINGCLOUD-PROVIDER-DEPT", configuration = WuRule.class)
public class DeptConsumer_80 {
    public static void main(String[] args) {
        SpringApplication.run(DeptConsumer_80.class, args);
    }
}
```

然后重启80项目，访问http://localhost/consumer/dept/list，多访问几次，可以发现访问的服务每5次切换一下





# 11、Feign负载均衡

## 11.1、简介

![image-20210203144856775](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203144856775.png>)

## 11.2、Feign能干什么？

![image-20210203145419179](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203145419179.png>)

## 11.3、Feign集成了Ribbon

![image-20210203145526394](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203145526394.png>)

## 11.4 springcloud-consumer-dept-feign

![image-20210203163502138](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203163502138.png>)



创建一个springcloud-consumer-dept-feign空maven的空项目，这也是一个消费者，端口也是80，只是这个消费者使用Feign实现的负载均衡

![image-20210203161515728](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203161515728.png>)



### pom.xml

```xml
<dependencies>
    <!--feign-->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-feign</artifactId>
        <version>1.4.7.RELEASE</version>
    </dependency>
    <!--Ribbon-->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-ribbon</artifactId>
        <version>1.4.7.RELEASE</version>
    </dependency>
    <!--导入Ribbon的同时要导入erueka，因为它要发现服务从那里来-->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-eureka</artifactId>
        <version>1.4.7.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>com.wu</groupId>
        <artifactId>springcloud-api</artifactId>
        <version>1.0-SNAPSHOT</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <!--热部署工具-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
    </dependency>
</dependencies>
```





### application.yml

和springcloud-consumer-dept-80项目的一摸一样



### 修改springcloud-api

- 添加依赖

- ```xml
  <!--feign-->
  <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-feign</artifactId>
      <version>1.4.7.RELEASE</version>
  </dependency>
  ```

- 从前面了解到，Feign是通过注解接口，而Ribbon是通过微服务名字，那么下面给springcloud-api添加一个service包

![image-20210203162236532](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203162236532.png>)



- 并写上几个注解
```java
 @Component
  //Feign客户端的服务名
  @FeignClient(value = "SPRINGCLOUD-PROVIDER-DEPT")
  public interface DeptClientService {
  	
      @GetMapping("/dept/get/{id}")
      Dept queryById(@PathVariable("id") Long id);
  
      @PostMapping("/dept/add")
      boolean addDept(Dept dept);
  
      @RequestMapping("/dept/list")
      List<Dept> queryAll();
  
  }
```


然后在springcloud-consumer-dept-feign项目的controller也要做相应的修改

### DeptConsumerController

```java
@Controller
public class DeptConsumerController {
	
    //这里直接把springcloud-api的DeptClientService接口注入进来
    @Autowired
    private DeptClientService deptClientService = null;
	//然后通过接口来调用方法，调用方法后，它会调用上面类对应的方法，最后调用其服务名字的接口
    @RequestMapping("/consumer/dept/get/{id}")
    @ResponseBody
    public Dept queryById(@PathVariable("id") Long id) {
        return this.deptClientService.queryById(id);
    }

    @RequestMapping("/consumer/dept/add")
    @ResponseBody
    public boolean add(Dept dept) {
        return this.deptClientService.addDept(dept);
    }

    @RequestMapping("/consumer/dept/list")
    @ResponseBody
    public List<Dept> queryAll() {
        return this.deptClientService.queryAll();
    }

}
```

最后还要在启动类上添加FeignClient注解

### FeignDeptConsumer_80

```java
@SpringBootApplication
@EnableFeignClients(basePackages = {"com.wu.springcloud"})
public class FeignDeptConsumer_80 {
    public static void main(String[] args) {
        SpringApplication.run(FeignDeptConsumer_80.class, args);
    }
}
```

最后启动7001、...  、8001、...  、feign的80项目，测试

# 12、Hystrix服务熔断
## 分布式系统面临的问题

复杂分布式体系结构中的应用程序有数十个依赖关系，每个依赖关系在某些时候将不可避免的失败!
## 服务雪崩

![image-20210203163720422](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203163720422.png>)

## 什么是Hystrix
![image-20210203163739837](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203163739837.png>)


![image-20210203163823198](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203163823198.png>)


**官网资料**
https://github.com/Netflix/Hystrix/wiki


## 服务熔断

![image-20210203165129902](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203165129902.png>)

### springcloud-provider-dept-hystrix-8001

创建一个带有服务熔断的服务提供者8001，把之前的8001项目原封不动的拷贝就行，改以下几个位置

#### pom.xml

添加依赖

```xml
<!--hystrix-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-hystrix</artifactId>
    <version>1.4.7.RELEASE</version>
</dependency>
```



#### application.yml

```yml
  instance:
    instance-id: springcloud-provider-dept-hystrix-8001  #修改Eureka上的默认描述信息
    prefer-ip-address: true  # 为true可以显示服务的ip地址
```



#### DeptController

在方法上加入@HystrixCommand即可，这里做一个演示，就写一个方法做测试

```java
//提供Restfull服务!!
@RestController
public class DeptController {

    @Autowired
    private DeptServiceImpl deptService;


    @GetMapping("/dept/get/{id}")
    @HystrixCommand(fallbackMethod = "hystrixGetDept") //失败了就会调用下面的这个备选方案
    public Dept getDept(@PathVariable("id") Long id) {
        Dept dept = deptService.queryById(id);
        if (dept == null) {
            throw new RuntimeException("id-->" + id + "不存在该用户，或者信息无法找到");
        }
        return dept;
    }

    //备选方案
    public Dept hystrixGetDept(@PathVariable("id") Long id) {
        return new Dept()
                .setDeptno(id)
                .setDname("id=>" + id + "没有对应的信息，null---@hystrix")
                .setDb_source("not this database in MySQL");
    }

}
```

然后在主启动类上添加对熔断的支持  启用断路器



#### DeptProviderHystrix_8001

```java
//启动类
@SpringBootApplication
@EnableEurekaClient  //在服务启动后自动注册到Eureka中
@EnableCircuitBreaker //添加对熔断的支持  启用断路器
public class DeptProviderHystrix_8001 {
    public static void main(String[] args) {
        SpringApplication.run(DeptProviderHystrix_8001.class, args);
    }
}
```

启动集群，启动springcloud-provider-dept-hystrix-8001，启动80项目（普通的，不是feign的80项目）

- 访问正常请求http://localhost/consumer/dept/get/1
- ![image-20210203192738511](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203192738511.png>)

- 访问不正常请求，http://localhost/consumer/dept/get/10不会显示500错误，而是显示我们备选方案的返回结果
- ![image-20210203192838069](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203192838069.png>)

## 服务降级



服务降级，当服务器压力剧增的情况下，根据当前业务情况及流量对一些服务和页面有策略的降级，以此释放服务器资源以保证核心任务的正常运行。比如电商平台，在针对618、双11等高峰情形下采用部分服务不出现或者延时出现的情形。

```xml
服务熔断：针对服务器的，某个服务连接超时或者异常的时候，引起熔断
服务降级：针对客户端，从整体网站请求负载考虑，当某个服务熔断或则关闭时，服务不在被调用，此时在客户端，我们可以准备一个FallbackFactory，返回一个默认的值，整体的服务水平下降了，好歹能用，比直接挂掉强
```

在springcloud-api项目的service包下建立DeptClientServiceFallbackFactory

### DeptClientServiceFallbackFactory

```java
//服务降级
@Component
//失败回调
public class DeptClientServiceFallbackFactory implements FallbackFactory {

    @Override
    public DeptClientService create(Throwable throwable) {
        return new DeptClientService() {
            @Override
            public Dept queryById(Long id) {
                return new Dept()
                        .setDeptno(id)
                        .setDname("id=>" + id + "，没有对应的信息，客户端提供了降级的信息，这个服务现在已经被关闭了")
                        .setDb_source("没有数据");
            }

            @Override
            public boolean addDept(Dept dept) {
                //...
                return false;
            }

            @Override
            public List<Dept> queryAll() {
                //...
                return null;
            }

        };
    }
}
```

然后怎么去体现它呢？还是一样的，在  springcloud-api 项目的DeptClientService接口上添加即可

### DeptClientService

失败回调工厂，参数就是上面配置的工厂类，只针对客户端

```java
@FeignClient(value = "SPRINGCLOUD-PROVIDER-DEPT", fallbackFactory = DeptClientServiceFallbackFactory.class)
```

启动7001项目、启动8001项目（正常的，不是Hystrix的那个）、然后再启动feign的80项目

- 正常访问 http://localhost/consumer/dept/get/1
- ![image-20210203201206830](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203201206830.png>)
- 访问一个不存在的数据
- ![image-20210203201222674](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203201222674.png>)

- 把8001服务提供者关闭，再次访问http://localhost/consumer/dept/get/1
- ![image-20210203201329756](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203201329756.png>)

说明了什么？说明了服务熔断是被动的，服务降级是手动的，但是开启服务降级后，没有关闭服务，访问一个不存在的数据，也会返回一个客户端自定义的返回结果，当把服务关闭后，访问任何请求都是有客户端自定义的结果。





## Dashboard流监控



还是老规矩，新建一个项目

### springcloud-consumer-hystrix-dashborad	

![image-20210203212212785](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203212212785.png>)

#### pom.xml

```xml
<dependencies>
    <!--dashboard监控页面-->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-hystrix-dashboard</artifactId>
        <version>1.4.7.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

#### application.yml

```yml
server:
  port: 9001
hystrix:
  dashboard:
    proxy-stream-allow-list: "*"
```



#### DeptConsumerDashboard_9001

```java
@SpringBootApplication
//服务端必须都要有监控依赖actuator
@EnableHystrixDashboard  //开启监控页面  http://localhost:9001/hystrix
public class DeptConsumerDashboard_9001 {
    public static void main(String[] args) {
        SpringApplication.run(DeptConsumerDashboard_9001.class, args);
    }
}
```

然后启动9001项目，直接访问http://localhost:9001/hystrix

![image-20210203212343244](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203212343244.png>)



现在监控页面搭载完成

我们要如何监控呢？监控什么呢？

我们监控的是实现了熔断支持的类（主启动类上加了@EnableCircuitBreaker注解），这里我们刚好有一个项目springcloud-provider-dept-hystrix-8001，还有一个前提，服务类必须添加actuator依赖

然后我们修改springcloud-provider-dept-hystrix-8001项目的主启动类，添加一个Servlet，为了配合监控使用



#### DeptProviderHystrix_8001

```java
//启动类
@SpringBootApplication
@EnableEurekaClient  //在服务启动后自动注册到Eureka中
@EnableCircuitBreaker //添加对熔断的支持  启用断路器
public class DeptProviderHystrix_8001 {
    public static void main(String[] args) {
        SpringApplication.run(DeptProviderHystrix_8001.class, args);
    }

    //为了配合监控使用
    //增加一个Servlet
    @Bean
    public ServletRegistrationBean hystrixMetricsStreamServlet() {
        ServletRegistrationBean registrationBean = new ServletRegistrationBean(new HystrixMetricsStreamServlet());
        registrationBean.addUrlMappings("/actuator/hystrix.stream");
        return registrationBean;
    }
}
```



启动7001项目，启动9001项目，启动hystrix的8001项目，然后访问http://localhost:8001/dept/get/1，有返回数据即可

然后访问http://localhost:8001/actuator/hystrix.stream，会得到一些数据流

![image-20210203212928778](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203212928778.png>)



然后http://localhost:9001/hystrix，填入以下信息即可

![image-20210203213133217](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203213133217.png>)



![image-20210203213146971](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203213146971.png>)

![image-20210203213353062](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203213353062.png>)



![image-20210203211148860](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203211148860.png>)



![image-20210203211216136](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203211216136.png>)

![image-20210203211249535](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203211249535.png>)







![image-20210203211325136](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203211325136.png>)



![image-20210203211459377](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203211459377.png>)



# 13、Zuul 路由网关

## 概述

### 什么是Zuul

![image-20210203213518093](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203213518093.png>)



### Zuul能干吗

- 路由
- 过滤



**官网** ： https://github.com/netflix/zuul



直接搭建项目：springcloud-zuul-9527

## springcloud-zuul-9527

先在自己的hosts文件添加域名映射来模仿网站

C:\Windows\System32\drivers\etc\hosts

![image-20210203221937360](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203221937360.png>)

![image-20210203221949006](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203221949006.png>)



### pom.xml

```xml
<dependencies>
    <!--zuul-->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-zuul</artifactId>
        <version>1.4.7.RELEASE</version>
    </dependency>
    <!--erueka-->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-eureka</artifactId>
        <version>1.4.7.RELEASE</version>
    </dependency>
    <!--actuator完善监控信息-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```



然后第二步肯定是配置文件

### application.yml

```yml
server:
  port: 9527
spring:
  application:
    name: springcloud-zuul
# eureka 配置
eureka:
  client:
    service-url:
      defaultZone: http://eureka7001.com:7001/eureka/,http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
  instance:
    instance-id: zuul9527.com  #修改Eureka上的默认描述信息
    prefer-ip-address: true  # 为true可以显示服务的ip地址
info:
  app.name: wu-springcloud
  company.name: blog.wulei2921625957.com

#zuul配置
zuul:
  routes:
    mydept.serviceId: springcloud-provider-dept  # 原来的id 
    mydept.path: /mydept/**  # serviceId 和 path 是配套使用的，前面的mydept可以随便
  ignored-services: 
    - springcloud-provider-dept  #不能再使用这个路径访问了  这是yml的数组表示方式
    # 没有加上面的忽略配置可以直接通过http://www.wu.com:9527/springcloud-provider-dept/dept/get/1访问
  prefix: /wu     # 这个是前缀  比如： http://www.wu.com:9527/wu/mydept/dept/get/1
```



最后是主启动类

### ZuulApplication_9527

```java
@SpringBootApplication
@EnableZuulProxy  //加上zuul代理注解即可
public class ZuulApplication_9527 {
    public static void main(String[] args) {
        SpringApplication.run(ZuulApplication_9527.class, args);
    }
}
```

总共就是这3步

然后启动项目 7001、8001、9527

访问http://www.wu.com:9527/wu/mydept/dept/get/1 即可得到结果



# 14、SpringCloud config 分布式配置



## 14.1、概述

### 分布式系统面临的-配置文件的问题

![image-20210203223410133](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203223410133.png>)

### 什么是SpringCloud config分布式配置中心

![image-20210203223457210](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203223457210.png>)

![image-20210203225513223](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210203225513223.png>)



## 14.2、环境搭建

我这里使用的码云：https://gitee.com/，在国内访问速度快一点，Githup有点慢就没用它



然后还是为了方便理解，重新建立项目



先建立连接码云长仓库的server端

### springcloud-config-server-3344

![image-20210204134502863](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210204134502863.png>)

#### pom.xml

```xml
<!--config-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-config-server</artifactId>
    <version>2.2.6.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<!--actuator完善监控信息-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

#### application.yml

```yml
server:
  port: 3344


spring:
  application:
    name: springcloud-config-server
  # 连接远程仓库，先把连接远程配置写在这里
  cloud:
    config:
      server:
        git:
          uri: https://gitee.com/wuleiaizb/springcloud-config.git  #https的
```



#### Config_Server_3344

```java
@SpringBootApplication
@EnableConfigServer  //开启注解
public class Config_Server_3344 {
    public static void main(String[] args) {
        SpringApplication.run(Config_Server_3344.class, args);
    }
}
```

然后你码云或者Githup里面要有一个 **application.yml** 文件

```yml
# 这个3344项目只是为了读取配置，不干别的事，我这里配了 2 套环境为了测试，

spring:
  profiles: dev
  application:
    name: springcloud-config-dev
    
---
spring:
  profiles: test
  application:
    name: springcloud-config-test
```

然后

![image-20210204135650578](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210204135650578.png>)

所以上面项目里面的配置文件的uri就是这个仓库的https链接

启动3344项目，访问

- http://localhost:3344/application-dev.yml
- http://localhost:3344/application-test.yml
- http://localhost:3344/application/dev/master
- http://localhost:3344/master/application-dev.yml
- ![image-20210204135951533](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210204135951533.png>)

都可以获取到，说明配置成功，那么可以进入下一步

### springcloud-config-eureka-7001

先在码云或者Githup上新建一个文件**config-eureka.yml**

```yml
spring:
  profiles:
    active: dev


---

server:
  port: 7001
spring:
  profiles: dev
  application:
    name: springcloud-config-eureka-dev

# C:\Windows\System32\drivers\etc\hosts  更改

#Eureka配置
eureka:
  instance:
    hostname: eureka7001.com #eureska服务端的实例名称    ，如果这个名字一样，他会当作是同一个集群，导致集群失败，所以我还是改回来了，知道即可
  client:
    register-with-eureka: false # 表示是否向eureka注册中心注册自己
    fetch-registry: false #表示如果为false则表示自己为注册中心 "defaultZone", "http://localhost:8761/eureka/"
    service-url:  # 监控页面
      #单机：
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
      #集群（关联）
      #defaultZone: http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
      
 
---
server:
  port: 7001

spring:
  profiles: test
  application:
    name: springcloud-config-eureka-test

# C:\Windows\System32\drivers\etc\host  更改

#Eureka配置
eureka:
  instance:
    hostname: eureka7001.com #eureka服务端的实例名称    ，如果这个名字一样，他会当作是同一个集群，导致集群失败，所以我还是改回来了，知道即可
  client:
    register-with-eureka: false # 表示是否向eureka注册中心注册自己
    fetch-registry: false #表示如果为false则表示自己为注册中心 "defaultZone", "http://localhost:8761/eureka/"
    service-url:  # 监控页面
      #单机： 
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
      #集群（关联）
      #defaultZone: http://eureka7002.com:7002/eureka/,http://eureka7003.com:7003/eureka/
```

然后创建项目 springcloud-config-eureka-7001

![image-20210204140713943](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210204140713943.png>)



#### pom.xml

```xml
<dependencies>
    <!--config-->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-config</artifactId>
        <version>2.2.6.RELEASE</version>
    </dependency>
    <!--erueka  server-->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-eureka-server</artifactId>
        <version>1.4.7.RELEASE</version>
    </dependency>
    <!--热部署工具-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
    </dependency>
</dependencies>
```



#### ConfigEurekaServer_7001

```java
//启动之后访问 http://localhost:7001/
@SpringBootApplication
@EnableEurekaServer //EnableEurekaServer表示服务端的启动类，可以接收别人注册进来
public class ConfigEurekaServer_7001 {
    public static void main(String[] args) {
        SpringApplication.run(ConfigEurekaServer_7001.class, args);
    }
}
```



接下来要接触一个新的配置文件 **bootstrap.yml** ，这个是系统级别的，它的配置可以覆盖 **application.yml**

#### bootstrap.yml

```yml
# 系统级别
spring:
  cloud:
    config:
      uri: http://localhost:3344  #直接使用上一个项目来获取配置文件即可
      name: config-eureka # 需要从git上读取的资源名称，不要要后缀
      profile: dev  # 使用的开发环境
      label: master  # 使用分支，默认为主分支
```

#### application.yml

```yml
#用户级别
spring:
  application:
    name: springcloud-config-eureka-7001
```

然后在3344项目启动的情况下启动这个项目

访问 http://localhost:7001/ 显示正常页面即可

然后我们看它读取的配置 http://localhost:3344/master/config-eureka-dev.yml

![image-20210204141719967](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210204141719967.png>)

最后我们来个服务提供者，也是新建一个项目

### springcloud-config-dept-8001

第一步也是先在码云或者Githup上新建文件**config-dept.yml**

```yml
# 两套环境的数据库不一样
spting:
  profiles:
    active: dev
    
---

server:
  port: 8001

#mybatis配置
mybatis:
  type-aliases-package: com.wu.springcloud.pojo
  config-location: classpath:mybatis/mybatis-config.xml
  mapper-locations: classpath:mybatis/mapper/*.xml

#spring的配置
spring:
  profiles: dev
  application:
    name: springcloud-provider-config-dept  # 3个服务名称一致是前提
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource  #数据源
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://127.0.0.1:3306/db01?useUnicode=true&characterEncoding=UTF-8&useSSL=true&serverTimezone=UTC
    username: root
    password: Wl123456

#eureka 的配置，服务注册到哪里
eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka/
  instance:
    instance-id: springcloud-provider-dept8001  #修改Eureka上的默认描述信息
    prefer-ip-address: true  # 为true可以显示服务的ip地址

#info配置
info:
  app.name: wulei-springcloud
  company.name: blog.wulei2921625957.com
  
  
---

server:
  port: 8001

#mybatis配置
mybatis:
  type-aliases-package: com.wu.springcloud.pojo
  config-location: classpath:mybatis/mybatis-config.xml
  mapper-locations: classpath:mybatis/mapper/*.xml

#spring的配置
spring:
  profiles: test
  application:
    name: springcloud-provider-config-dept  # 3个服务名称一致是前提
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource  #数据源
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://127.0.0.1:3306/db02?useUnicode=true&characterEncoding=UTF-8&useSSL=true&serverTimezone=UTC
    username: root
    password: Wl123456

#eureka 的配置，服务注册到哪里
eureka:
  client:
    service-url:
      defaultZone: http://localhost:7001/eureka/
  instance:
    instance-id: springcloud-provider-dept8001  #修改Eureka上的默认描述信息
    prefer-ip-address: true  # 为true可以显示服务的ip地址

#info配置
info:
  app.name: wulei-springcloud
  company.name: blog.wulei2921625957.com
```

然后把原来普通的8001项目的文件原封不动的拷贝到这个项目，改以下几个位置即可

#### pom.xml

```xml
<!--添加依赖-->
<!--config-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-config</artifactId>
    <version>2.2.6.RELEASE</version>
</dependency>
```

#### bootstrap.yml

```yml
spring:
  cloud:
    config:
      uri: http://localhost:3344
      name: config-dept # 需要从git上读取的资源名称，不要要后缀
      label: master
      profile: dev
```

#### application.yml

```yml
spring:
  application:
    name: springcloud-config-dept-8001
```

然后在前两个项目启动的情况下启动此项目

访问正常的业务还是可以访问

![image-20210204142520033](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210204142520033.png>)



### 小结

- Spring Cloud Config 说白了就是把配置文件放到云端托管，而且有利于多人合作开发
- 如果在项目启动后更改了云端的配置文件，要重启项目







# 项目全部结构
E:\IdeaProjects\2_study\SpringCloud_kuangstudy
![[image-20240413202354688.png]]

![image-20210204142827790](<D:\Documents\学习\000 Note\zhenk-obsidian\技术笔记\zhenk\5.微服务专题\SpringCloud\imag\SpringCloud.assets\image-20210204142827790.png>)

# SpringCloud基本框架
![[image-20240413180610227.png]]

## 服务注册与发现
**Eureka**：AP,可配支持服务健康检查,以HTTP协议对外暴露接口
**Consul**：CP,支持服务健康检查,以HTTP/DNS协议对外暴露接口
**Zookeeper**：CP,支持服务健康检查,以客户端形式对外暴露接口
### Eureka(停更)
### Consul
#### 数据持久化
```shell
@echo.服务启动......  

@echo off  

@sc create Consul binpath= "D:\devSoft\consul_1.17.0_windows_386\consul.exe agent -server -ui -bind=127.0.0.1 -client=0.0.0.0 -bootstrap-expect  1  -data-dir D:\devSoft\consul_1.17.0_windows_386\mydata   "

@net start Consul

@sc config Consul start= AUTO  

@echo.Consul start is OK......success

@pause
```

### Etcd
### Nacos

## 服务调用和负载均衡
### Ribbon(停更)
Spring Cloud Ribbon是基于Netflix Ribbon实现的一套**客户端 负载均衡**的工具。

简单的说，Ribbon是Netflix发布的开源项目，主要功能是**提供客户端的软件负载均衡算法和服务调用**。Ribbon客户端组件提供一系列完善的配置项如连接超时，重试等。简单的说，就是在配置文件中列出Load Balancer（简称LB）后面所有的机器，Ribbon会自动的帮助你基于某种规则（如简单轮询，随机连接等）去连接这些机器。我们很容易使用Ribbon实现自定义的负载均衡算法。

### OpenFeign
openfeign是一个声明式的Web服务客户端，只需创建一个Rest接口并在该接口上添加注解@FeignClient即可;OpenFeign基本上就是当前微服务之间调用的事实标准

OpenFeign能干什么

前面在使用**SpringCloud LoadBalancer**+RestTemplate时，利用RestTemplate对http请求的封装处理形成了一套模版化的调用方法。**_但是在实际开发中，_**

由于对服务依赖的调用可能不止一处，往往一个接口会被多处调用，所以通常都会针对每个微服务自行封装一些客户端类来包装这些依赖服务的调用。所以，OpenFeign在此基础上做了进一步封装，由他来帮助我们定义和实现依赖服务接口的定义。在OpenFeign的实现下，我们只需创建一个接口并使用注解的方式来配置它(在一个微服务接口上面标注一个**_@FeignClient_**注解即可)，即可完成对服务提供方的接口绑定，统一对外暴露可以被调用的接口方法，大大简化和降低了调用客户端的开发量，也即由服务提供者给出调用接口清单，消费者直接通过OpenFeign调用即可，O(∩_∩)O。

OpenFeign同时还集成SpringCloud LoadBalancer

可以在使用OpenFeign时提供Http客户端的负载均衡，也可以集成阿里巴巴Sentinel来提供熔断、降级等功能。而与SpringCloud LoadBalancer不同的是，通过OpenFeign只需要定义服务绑定接口且以声明式的方法，优雅而简单的实现了服务调用。
### LoadBalancer
> [!TIP] **LB负载均衡(Load Balance)是什么**
> 简单的说就是将用户的请求平摊的分配到多个服务上，从而达到系统的HA（高可用），常见的负载均衡有软件Nginx，LVS，硬件 F5等

**spring-cloud-starter-loadbalancer组件是什么**

Spring Cloud LoadBalancer是由SpringCloud官方提供的一个开源的、简单易用的**客户端负载均衡器**，它包含在SpringCloud-commons中用它来替换了以前的Ribbon组件。相比较于Ribbon，SpringCloud LoadBalancer不仅能够支持RestTemplate，还支持WebClient（WeClient是Spring Web Flux中提供的功能，可以实现响应式异步请求）

#### loadbalancer本地负载均衡客户端 VS Nginx服务端负载均衡区别

* <font color = red>Nginx是服务器负载均衡</font>，客户端所有请求都会交给nginx，然后由nginx实现转发请求，即负载均衡是由服务端实现的。
* <font color = red>loadbalancer本地负载均衡</font>，在调用微服务接口时候，会在注册中心上获取注册信息服务列表之后缓存到JVM本地，从而在本地实现RPC远程服务调用技术。

#### 工作步骤
![[loadbalancer工作流程.png]]

LoadBalancer 在工作时分成两步：

1. **第一步**，先选择ConsulServer从服务端查询并拉取服务列表，知道了它有多个服务(上图3个服务)，这3个实现是完全一样的，默认轮询调用谁都可以正常执行。类似生活中求医挂号，某个科室今日出诊的全部医生，客户端你自己选一个。

2. **第二步**，按照指定的负载均衡策略从server取到的服务注册列表中由客户端自己选择一个地址，所以LoadBalancer是一个**客户端的**负载均衡器。

#### 负载均衡算法
##### 轮询
负载均衡算法：rest接口第几次请求数 % 服务器集群总数量 = 实际调用服务器位置下标  ，每次服务重启动后rest接口计数从1开始。
ReactorServiceInstanceLoadBalancer
```java
public class RoundRobinLoadBalancer implements​ ReactorServiceInstanceLoadBalancer{

}
List<ServiceInstance> instances = discoveryClient.getInstances("cloud-payment-service");
/**如：   List [0] instances = 127.0.0.1:8002
　　　 List [1] instances = 127.0.0.1:8001**/
```

##### 随机
```java
public class RandomLoadBalancer implements​ ReactorServiceInstanceLoadBalancer{

}
```

算法切换
`org.springframework.cloud.client.loadbalancer.reactive.ReactiveLoadBalancer
`
接口ReactiveLoadBalancer
## 分布式事务
### Seata
### LCN
### Hmily
## 服务熔断和降级
### Hystrix(停更)
Hystrix是一个用于处理分布式系统的延迟和容错的开源库，在分布式系统里，许多依赖不可避免的会调用失败，比如超时、异常等，Hystrix能够保证在一个依赖出问题的情况下，不会导致整体服务失败，避免级联故障，以提高分布式系统的弹性。

了解一下即可，2024年了不再使用Hystrix

![[Hystrix停更介绍.png]]

### Circuit Breaker
> Circuit Breaker只是一套规范和接口，落地实现者是Resilience4J
> 

CircuitBreaker的目的是保护分布式系统免受故障和异常，提高系统的可用性和健壮性。

当一个组件或服务出现故障时，CircuitBreaker会迅速切换到开放OPEN状态(保险丝跳闸断电)，阻止请求发送到该组件或服务从而避免更多的请求发送到该组件或服务。这可以减少对该组件或服务的负载，防止该组件或服务进一步崩溃，并使整个系统能够继续正常运行。同时，CircuitBreaker还可以提高系统的可用性和健壮性，因为它可以在分布式系统的各个组件之间自动切换，从而避免单点故障的问题。
![[Circuit Breaker官网介绍.png]]

![[Circuit Breaker断路器滑动窗口.png]]

#### Resilience4J
* Resilience4J 是一个专为函数式编程设计的轻量级容库。Resilience4J 提供高阶函数(装饰器)，以通过断路器、速率限制器、重试或隔板增强任何功能接口、lambda 表达式或方法引用，您可以在任何函数式接口、lambda 表达式或方法引用上堆叠多个装饰器。优点是您可以选择您需要的装饰器，而没有其他选择。
* Resilience4J2 需要Java 17.
![[image-20240410210434255.png]]

##### 熔断+降级(CircuitBreaker)
###### 断路器所有配置参数参考
![[image-20240410205514600.png]]

![[image-20240410205939836.png]]
![[image-20240410205955972.png]]
![[image-20240410210010130.png]]
![[image-20240410210018650.png]]
![[image-20240410205821319.png]]

| 参数                                               | 说明                                                                                                                                                                                        |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **failure-rate-threshold**                       | **以百分比配置失败率峰值**                                                                                                                                                                           |
| **sliding-window-type**                          | **断路器的滑动窗口期类型  <br>可以基于“次数”（COUNT_BASED）或者“时间”（TIME_BASED）进行熔断，默认是COUNT_BASED。**                                                                                                          |
| **sliding-window-size**                          | **若COUNT_BASED，则10次调用中有50%失败（即5次）打开熔断断路器；**<br><br>**若为TIME_BASED则，此时还有额外的两个设置属性，含义为：在N秒内（sliding-window-size）100%（slow-call-rate-threshold）的请求超过N秒（slow-call-duration-threshold）打开断路器。** |
| **slowCallRateThreshold**                        | **以百分比的方式配置，断路器把调用时间大于slowCallDurationThreshold的调用视为慢调用，当慢调用比例大于等于峰值时，断路器开启，并进入服务降级。**                                                                                                    |
| **slowCallDurationThreshold**                    | **配置调用时间的峰值，高于该峰值的视为慢调用。**                                                                                                                                                                |
| **permitted-number-of-calls-in-half-open-state** | **运行断路器在HALF_OPEN状态下时进行N次调用，如果故障或慢速调用仍然高于阈值，断路器再次进入打开状态。**                                                                                                                                |
| **minimum-number-of-calls**                      | **在每个滑动窗口期样本数，配置断路器计算错误率或者慢调用率的最小调用数。比如设置为5意味着，在计算故障率之前，必须至少调用5次。如果只记录了4次，即使4次都失败了，断路器也不会进入到打开状态。**                                                                                       |
| **wait-duration-in-open-state**                  | **从OPEN到HALF_OPEN状态需要等待的时间**                                                                                                                                                              |

###### 熔断+降级案例需求说明
* 6次访问中当执行方法的失败率达到50%时CircuitBreaker将进入开启**OPEN**状态(保险丝跳闸断电)拒绝所有请求。  
* 等待5秒后，CircuitBreaker将自动从开启**OPEN**状态过渡到半开**HALF_OPEN**状态，允许一些请求通过以测试服务是否恢复正常。  
* 如还是异常CircuitBreaker将重新进入开启**OPEN**状态；如正常将进入关闭**CLOSE**闭合状态恢复正常处理请求。

具体时间和频次等属性见具体实际案例，这里只是作为case举例讲解，最下面笔记面试题概览，闲聊大厂面试
![[image-20240410221226223.png]]

###### 基于时间的滑动窗口
![[image-20240410221923160.png]]

###### 总结
1. 当满足一定的峰值和失败率达到一定条件后，断路器将会进入OPEN状态(保险丝跳闸)，服务熔断
2. 当OPEN的时候，所有请求都不会调用主业务逻辑方法，而是直接走fallbackmetnod兜底背锅方法，服务降级
3. 一段时间之后，这个时候断路器会从OPEN进入到HALF_OPEN半开状态，会放几个请求过去探探链路是否通？如成功，断路器会关闭CLOSE(类似保险丝闭合，恢复可用)；如失败，继续开启。重复上述

##### 隔离(BulkHead)
限并发
**依赖隔离&负载保护**：用来限制对于下游服务的最大并发数量的限制

###### 两种实现方式
- `SemaphoreBulkhead`使用了信号量
1. 当信号量有空闲时，进入系统的请求会直接获取信号量并开始业务处理。
2. 当信号量全被占用时，接下来的请求将会进入阻塞状态，SemaphoreBulkhead提供了一个阻塞计时器，如果阻塞状态的请求在阻塞计时内无法获取到信号量则系统会拒绝这些请求。
3. 若请求在阻塞计时内获取到了信号量，那将直接获取信号量并执行相应的业务处理。
- `FixedThreadPoolBulkhead`使用了有界队列和固定大小线程池
当线程池中存在空闲时，则此时进入系统的请求将直接进入线程池开启新线程或使用空闲线程来处理请求。

当线程池中无空闲时时，接下来的请求将进入等待队列，若等待队列仍然无剩余空间时接下来的请求将直接被拒绝，在队列中的请求等待线程池出现空闲时，将进入线程池进行业务处理。

另外：ThreadPoolBulkhead只对CompletableFuture方法有效，所以我们必创建返回CompletableFuture类型的方法

##### 限流(RateLimiter)
###### 常用限流算法
1. **漏斗算法(Leaky Bucket)**
一个固定容量的漏桶，按照设定常量固定速率流出水滴，类似医院打吊针，不管你源头流量多大，我设定匀速流出。 

如果流入水滴超出了桶的容量，则流入的水滴将会溢出了(被丢弃)，而漏桶容量是不变的。
![[漏斗限流算法.png]]
**缺点**
这里有两个变量，一个是桶的大小，支持流量突发增多时可以存多少的水（burst），另一个是水桶漏洞的大小（rate）。因为漏桶的漏出速率是固定的参数，所以，即使网络中不存在资源冲突（没有发生拥塞），漏桶算法也不能使流突发（burst）到端口速率。因此，漏桶算法对于存在突发特性的流量来说缺乏效率。
![[image-20240412144922646.png]]


2. **令牌桶算法(Token Bucket)**
![[image-20240412144951326.png]]

3. **滚动时间窗口算法(tumbling time window)**
允许固定数量的请求进入(比如1秒取4个数据相加，超过25值就over)超过数量就拒绝或者排队，等下一个时间段进入。

由于是在一个时间间隔内进行限制，如果用户在上个时间间隔结束前请求（但没有超过限制），同时在当前时间间隔刚开始请求（同样没超过限制），在各自的时间间隔内，这些请求都是正常的。下图统计了3次，but......
![[image-20240412145037165.png]]
**缺点**：间隔临界的一段时间内的请求就会超过系统限制，可能导致系统被压垮

4. **滑动时间窗口算法**
顾名思义，该时间窗口是滑动的。所以，从概念上讲，这里有两个方面的概念需要理解： 
- 窗口：需要定义窗口的大小
- 滑动：需要定义在窗口中滑动的大小，但理论上讲滑动的大小不能超过窗口大小

滑动窗口算法是把固定时间片进行划分并且随着时间移动，移动方式为开始时间点变为时间列表中的第2个时间点，结束时间点增加一个时间点，不断重复，通过这种方式可以巧妙的避开计数器的临界点的问题。下图统计了5次
![[image-20240412145713996.png]]


### Sentinel

## 服务链路跟踪
行业内比较成熟的其它分布式链路追踪技术解决方案
![[image-20240412152249594.png]]

那么一条链路追踪会在每个服务调用的时候加上Trace ID 和 Span ID

链路通过TraceId唯一标识，Span标识发起的请求信息，各span通过parent id 关联起来 (Span:表示调用链路来源，通俗的理解span就是一次请求信息)
![[image-20240412152850854.png]]

### Sleuth(停更)+Zipkin
### Micrometer Tracing+Zipkin
Tracing **数据采集**
Zipkin是一种分布式链路跟踪系统**图形化**的工具，Zipkin 是 Twitter 开源的分布式跟踪系统，能够收集微服务运行过程中的实时调用链路信息，并能够将这些调用链路信息展示到Web图形化界面上供开发人员分析，开发人员能够从ZipKin中分析出调用链路中的性能瓶颈，识别出存在问题的应用程序，进而定位问题和解决问题。

## 服务网关
### Zuul(停更)
### Gate Way

## 分布式配置管理
### Config+Bus(停更)
### Consul
### Nacos

## Spring Cloud Alibaba
![[image-20240412195311449.png]]

Github文档:[Spring Cloud Alibaba 参考文档](https://spring-cloud-alibaba-group.github.io/github-pages/2022/zh-cn/2022.0.0.0-RC2.html)
官网:[SpringCloudAlibaba | Spring Cloud Alibaba](https://sca.aliyun.com/zh-cn/)
### 主要功能

- **服务限流降级**：默认支持 WebServlet、WebFlux、OpenFeign、RestTemplate、Spring Cloud Gateway、Dubbo 和 RocketMQ 限流降级功能的接入，可以在运行时通过控制台实时修改限流降级规则，还支持查看限流降级 Metrics 监控。
- **服务注册与发现**：适配 Spring Cloud 服务注册与发现标准，默认集成对应 Spring Cloud 版本所支持的负载均衡组件的适配。
- **分布式配置管理**：支持分布式系统中的外部化配置，配置更改时自动刷新。
- **消息驱动能力**：基于 Spring Cloud Stream 为微服务应用构建消息驱动能力。
- **分布式事务**：使用 @GlobalTransactional 注解， 高效并且对业务零侵入地解决分布式事务问题。
- **阿里云对象存储**：阿里云提供的海量、安全、低成本、高可靠的云存储服务。支持在任何应用、任何时间、任何地点存储和访问任意类型的数据。
- **分布式任务调度**：提供秒级、精准、高可靠、高可用的定时（基于 Cron 表达式）任务调度服务。同时提供分布式的任务执行模型，如网格任务。网格任务支持海量子任务均匀分配到所有 Worker（schedulerx-client）上执行。
- **阿里云短信服务**：覆盖全球的短信服务，友好、高效、智能的互联化通讯能力，帮助企业迅速搭建客户触达通道。
### 组件

**[Sentinel](https://github.com/alibaba/Sentinel)**：把流量作为切入点，从流量控制、熔断降级、系统负载保护等多个维度保护服务的稳定性。

**[Nacos](https://github.com/alibaba/Nacos)**：一个更易于构建云原生应用的动态服务发现、配置管理和服务管理平台。

**[RocketMQ](https://rocketmq.apache.org/)**：一款开源的分布式消息系统，基于高可用分布式集群技术，提供低延时的、高可靠的消息发布与订阅服务。

**[Seata](https://github.com/apache/incubator-seata)**：阿里巴巴开源产品，一个易于使用的高性能微服务分布式事务解决方案。

**[Alibaba Cloud OSS](https://www.aliyun.com/product/oss)**: 阿里云对象存储服务（Object Storage Service，简称 OSS），是阿里云提供的海量、安全、低成本、高可靠的云存储服务。您可以在任何应用、任何时间、任何地点存储和访问任意类型的数据。

**[Alibaba Cloud SchedulerX](https://cn.aliyun.com/aliware/schedulerx)**: 阿里中间件团队开发的一款分布式任务调度产品，提供秒级、精准、高可靠、高可用的定时（基于 Cron 表达式）任务调度服务。

**[Alibaba Cloud SMS](https://www.aliyun.com/product/sms)**: 覆盖全球的短信服务，友好、高效、智能的互联化通讯能力，帮助企业迅速搭建客户触达通道。

### Nacos
#### 注册中心
##### Provider 应用
1. pom中新增依赖
```xml
<!--nacos-discovery-->  
<dependency>  
    <groupId>com.alibaba.cloud</groupId>  
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>  
</dependency>
```
2. SpringBootMain启动类中加上@EnableDiscoveryClient
3. 在yml配置文件中
```yml
spring:  
  application:  
    name: nacos-payment-provider  
  cloud:  
    nacos:  
      discovery:  
        server-addr: localhost:8848 #配置Nacos地址
# 如果不想使用 Nacos 作为您的服务注册与发现，可以将 `spring.cloud.nacos.discovery` 设置为 `false`。
```

##### Consumer 应用
Consumer 应用可能还没像启动一个 Provider 应用那么简单。因为在 Consumer 端需要去调用 Provider 端提供的REST 服务。例子中我们使用最原始的一种方式， 即显示的使用 LoadBalanceClient 和 RestTemplate 结合的方式来访问
1. 新增loadbalancer负载均衡
```xml
<!--nacos-discovery-->  
<dependency>  
    <groupId>com.alibaba.cloud</groupId>  
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>  
</dependency>  
<!--loadbalancer-->  
<dependency>  
    <groupId>org.springframework.cloud</groupId>  
    <artifactId>spring-cloud-starter-loadbalancer</artifactId>  
</dependency>
```
2. 配置负载均衡配置类
```java
//实例化 RestTemplate 实例 
@Configuration  
public class RestTemplateConfig {  
    @Bean  
    @LoadBalanced //赋予RestTemplate负载均衡的能力  
    public RestTemplate restTemplate() {  
        return new RestTemplate();  
    }  
}
```
3. controller类中
```java
@Resource  
private RestTemplate restTemplate;  
  
@Value("${service-url.nacos-user-service}")  
private String serverURL;  
  
@GetMapping(value = "/consumer/pay/nacos/{id}")  
public String paymentInfo(@PathVariable("id") Integer id) {  
    String result = restTemplate.getForObject(serverURL + "/pay/nacos/" + id, String.class);  
    return result + "\t" + "    我是OrderNacosController83调用者。。。。。。";  
}
```

或者@LoadBalanced不加的平替方法
```java
@RestController  
public class NacosController {  
  
    @Autowired  
    private LoadBalancerClient loadBalancerClient;  
    @Autowired  
    private RestTemplate restTemplate;  
  
    @Value("${spring.application.name}")  
    private String appName;  
  
    @GetMapping("/echo/app-name")  
    public String echoAppName() {  
        //使用 LoadBalanceClient 和 RestTemplate 结合的方式来访问  
        ServiceInstance serviceInstance = loadBalancerClient.choose("nacos-provider");  
        String url = String.format("http://%s:%s/echo/%s", serviceInstance.getHost(), serviceInstance.getPort(), appName);  
        System.out.println("request url:" + url);  
        return restTemplate.getForObject(url, String.class);  
    }  
}
```

#### 配置中心
1. pom.xml
```xml
<!--spring cloud alibaba nacos 本地配置文件application.yml  和下面的bootstrap.yml-->  
<!--bootstrap-->  
<dependency>  
    <groupId>org.springframework.cloud</groupId>  
    <artifactId>spring-cloud-starter-bootstrap</artifactId>  
</dependency>  
<!--nacos-config-->  
<dependency>  
    <groupId>com.alibaba.cloud</groupId>  
    <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>  
</dependency>  
<!--nacos-discovery-->  
<dependency>  
    <groupId>com.alibaba.cloud</groupId>  
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>  
</dependency>
```
2. 需要配置两个yml
Nacos同Consul一样，在项目初始化时，要保证先从配置中心进行配置拉取，拉取配置之后，才能保证项目的正常启动，为了满足动态刷新和全局广播通知springboot中配置文件的加载是存在优先级顺序的，bootstrap优先级高于application

```yml
# nacos配置   bootstrap.yml
spring:  
  application:  
    name: nacos-config-client  
  cloud:  
    nacos:  
      discovery:  
        server-addr: localhost:8848 #Nacos服务注册中心地址  
      config:  
        server-addr: localhost:8848 #Nacos作为配置中心地址  
        file-extension: yaml #指定yaml格式的配置  
        group: PROD_GROUP  
        namespace: Prod_Namespace  
  
# nacos端配置文件DataId的命名规则是：  
# ${spring.application.name}-${spring.profiles.active}.${spring.cloud.nacos.config.file-extension}  
# 本案例的DataID是:nacos-config-client-dev.yaml  nacos-config-client-test.yaml
```

```yml
# nacos配置   application.yml
server:  
  port: 3377  
  
spring:  
  profiles:  
    #active: dev # 表示开发环境  
    active: prod # 表示生产环境  
    #active: test # 表示测试环境
```

3. 在控制器类加入@RefreshScope注解使当前类下的配置支持Nacos的动态刷新功能。
4. nacos端配置文件DataId的命名规则：`${spring.application.name}-${spring.profiles.active}.${spring.cloud.nacos.config.file-extension}`
### Sentinel
面向分布式、多语言异构化服务架构的流量治理组件
[quick-start | Sentinel](https://sentinelguard.io/zh-cn/docs/quick-start.html)
从流量路由、流量控制、流量整形、熔断降级、系统自适应过载保护、热点流量防护等多个维度来帮助开发者保障微服务的稳定性
#### Sentinel的特征
1. **丰富的应用场景**：Sentinel 承接了阿里巴巴近 10 年的双十一大促流量的核心场景，例如秒杀（即突发流量控制在系统容量可以承受的范围）、消息削峰填谷、集群流量控制、实时熔断下游不可用应用等。

2. **完备的实时监控**：Sentinel 同时提供实时的监控功能。您可以在控制台中看到接入应用的单台机器秒级数据，甚至 500 台以下规模的集群的汇总运行情况。

3. **广泛的开源生态**：Sentinel 提供开箱即用的与其它开源框架/库的整合模块，例如与 Spring Cloud、Apache Dubbo、gRPC、Quarkus 的整合。您只需要引入相应的依赖并进行简单的配置即可快速地接入 Sentinel。同时 Sentinel 提供 Java/Go/C++ 等多语言的原生实现。

4. **完善的 SPI 扩展机制**：Sentinel 提供简单易用、完善的 SPI 扩展接口。您可以通过实现扩展接口来快速地定制逻辑。例如定制规则管理、适配动态数据源等。

![[image-20240412214514315.png]]

#### 相关问题
##### 服务雪崩
多个微服务之间调用的时候，假设微服务A调用微服务B和微服务C，微服务B和微服务C又调用其它的微服务，这就是所谓的“扇出”。如果扇出的链路上某个微服务的调用响应时间过长或者不可用，对微服务A的调用就会占用越来越多的系统资源，进而引起系统崩溃，所谓的“雪崩效应”。对于高流量的应用来说，单一的后端依赖可能会导致所有服务器上的所有资源都在几秒钟内饱和。比失败更糟糕的是，这些应用程序还可能导致服务之间的延迟增加，备份队列，线程和其他系统资源紧张，导致整个系统发生更多的级联故障。这些都表示需要对故障和延迟进行隔离和管理，以便单个依赖关系的失败，不能取消整个应用程序或系统。

所以，通常当你发现一个模块下的某个实例失败后，这时候这个模块依然还会接收流量，然后这个有问题的模块还调用了其他的模块，这样就会发生级联故障，或者叫雪崩。复杂分布式体系结构中的应用程序有数十个依赖关系，每个依赖关系在某些时候将不可避免地失败。
![[image-20240412220040865.png]]

##### 服务降级
服务降级，说白了就是一种服务托底方案，如果服务无法完成正常的调用流程，就使用默认的托底方案来返回数据。

例如，在商品详情页一般都会展示商品的介绍信息，一旦商品详情页系统出现故障无法调用时，会直接获取缓存中的商品介绍信息返回给前端页面。

##### 服务熔断
在分布式与微服务系统中，如果下游服务因为访问压力过大导致响应很慢或者一直调用失败时，上游服务为了保证系统的整体可用性，会暂时断开与下游服务的调用连接。这种方式就是熔断。类比保险丝达到最大服务访问后，直接拒绝访问，拉闸限电，然后调用服务降级的方法并返回友好提示。

服务熔断一般情况下会有三种状态：闭合、开启和半熔断;

闭合状态(保险丝闭合通电OK)：服务一切正常，没有故障时，上游服务调用下游服务时，不会有任何限制。

##### 服务限流
服务限流就是限制进入系统的流量，以防止进入系统的流量过大而压垮系统。其主要的作用就是保护服务节点或者集群后面的数据节点，防止瞬时流量过大使服务和数据崩溃（如前端缓存大量实效），造成不可用；还可用于平滑请求，类似秒杀高并发等操作，严禁一窝蜂的过来拥挤，大家排队，一秒钟N个，有序进行。

限流算法有两种，一种就是简单的请求总量计数，一种就是时间窗口限流（一般为1s），如令牌桶算法和漏牌桶算法就是时间窗口的限流算法。

##### 服务隔离
有点类似于系统的垂直拆分，就按照一定的规则将系统划分成多个服务模块，并且每个服务模块之间是互相独立的，不会存在强依赖的关系。如果某个拆分后的服务发生故障后，能够将故障产生的影响限制在某个具体的服务内，不会向其他服务扩散，自然也就不会对整体服务产生致命的影响。

互联网行业常用的服务隔离方式有：线程池隔离和信号量隔离。

##### 服务超时
整个系统采用分布式和微服务架构后，系统被拆分成一个个小服务，就会存在服务与服务之间互相调用的现象，从而形成一个个调用链。

  

形成调用链关系的两个服务中，主动调用其他服务接口的服务处于调用链的上游，提供接口供其他服务调用的服务处于调用链的下游。服务超时就是在上游服务调用下游服务时，设置一个最大响应时间，如果超过这个最大响应时间下游服务还未返回结果，则断开上游服务与下游服务之间的请求连接，释放资源。

#### 流控规则
##### 流控模式
###### 直接
###### 关联
###### 链路
来自不同链路的请求对同一个目标访问时，实施针对性的不同限流措施，比如C请求来访问就限流，D请求来访问就是OK
1. 添加配置
```yml
spring:  
  application:  
    name: cloud-alibaba-sentinel-service  
  cloud:
    sentinel:
      web-context-unify: false # controller层的方法对service层调用不认为是同一个根链路
```

#### 热点规则
> 设置了某个参数索引值【参数例外项】，当url地址参数为此设置的约定值是不进行限流，url此参数为其他值只要到达阈值都被限流。

* **普通正常限流**：含有P1参数，超过1秒钟一个后，达到阈值1后马上被限流
* **例外特殊限流**：我们期望p1参数当它是某个特殊值时，到达某个约定值后【普通正常限流】规则突然例外、失效了，它的限流值和平时不一样
![[image-20240413090128023.png]]



#### 授权规则
在某些场景下，需要根据调用接口的来源判断是否允许执行本次请求。此时就可以使用Sentinel提供的授权规则来实现，Sentinel的授权规则能够根据请求的来源判断是否允许本次请求通过。

在Sentinel的授权规则中，提供了 白名单与黑名单 两种授权类型。白放行、黑禁止
[黑白名单控制 · alibaba/Sentinel Wiki · GitHub](https://github.com/alibaba/Sentinel/wiki/%E9%BB%91%E7%99%BD%E5%90%8D%E5%8D%95%E6%8E%A7%E5%88%B6)

来源访问控制根据资源的请求来源（`origin`）限制资源是否通过，若配置白名单则只有请求来源位于白名单内时才可通过；若配置黑名单则请求来源位于黑名单时不通过，其余的请求通过。

> 调用方信息通过 `ContextUtil.enter(resourceName, origin)` 方法中的 `origin` 参数传入。

##### 规则配置

来源访问控制规则（`AuthorityRule`）非常简单，主要有以下配置项：

- `resource`：资源名，即限流规则的作用对象。
- `limitApp`：对应的黑名单/白名单，不同 origin 用 `,` 分隔，如 `appA,appB`。
- `strategy`：限制模式，`AUTHORITY_WHITE` 为白名单模式，`AUTHORITY_BLACK` 为黑名单模式，默认为白名单模式。
例子
```java
public class AuthorityDemo {  
  
    private static final String RESOURCE_NAME = "testABC";  
  
    public static void main(String[] args) {  
        System.out.println("========Testing for black list========");  
        initBlackRules();  
        testFor(RESOURCE_NAME, "appA");  
        testFor(RESOURCE_NAME, "appB");  
        testFor(RESOURCE_NAME, "appC");  
        testFor(RESOURCE_NAME, "appE");  
  
        System.out.println("========Testing for white list========");  
        initWhiteRules();  
        testFor(RESOURCE_NAME, "appA");  
        testFor(RESOURCE_NAME, "appB");  
        testFor(RESOURCE_NAME, "appC");  
        testFor(RESOURCE_NAME, "appE");  
    }  
  
    private static void testFor(/*@NonNull*/ String resource, /*@NonNull*/ String origin) {  
        ContextUtil.enter(resource, origin);  
        Entry entry = null;  
        try {  
            entry = SphU.entry(resource);  
            System.out.println(String.format("Passed for resource %s, origin is %s", resource, origin));  
        } catch (BlockException ex) {  
            System.err.println(String.format("Blocked for resource %s, origin is %s", resource, origin));  
        } finally {  
            if (entry != null) {  
                entry.exit();  
            }  
            ContextUtil.exit();  
        }  
    }  
  
    private static void initWhiteRules() {  
        AuthorityRule rule = new AuthorityRule();  
        rule.setResource(RESOURCE_NAME);  
        rule.setStrategy(RuleConstant.AUTHORITY_WHITE);  
        rule.setLimitApp("appA,appE");  
        AuthorityRuleManager.loadRules(Collections.singletonList(rule));  
    }  
  
    /**  
     * 来源访问控制规则（AuthorityRule）非常简单，主要有以下配置项：  
     * resource：资源名，即限流规则的作用对象。  
     * limitApp：对应的黑名单/白名单，不同 origin 用 , 分隔，如 appA,appB。  
     * strategy：限制模式，AUTHORITY_WHITE 为白名单模式，AUTHORITY_BLACK 为黑名单模式，默认为白名单模式。  
     * 示例  
     */  
    private static void initBlackRules() {  
        AuthorityRule rule = new AuthorityRule();  
        rule.setResource(RESOURCE_NAME);  
        rule.setStrategy(RuleConstant.AUTHORITY_BLACK);  
        rule.setLimitApp("appA,appB");  
        AuthorityRuleManager.loadRules(Collections.singletonList(rule));  
    }  
}
```
##### 步骤
1. 添加拦截器
```java
@Component  
public class MyRequestOriginParser implements RequestOriginParser {  
    @Override  
    public String parseOrigin(HttpServletRequest httpServletRequest) {  
        return httpServletRequest.getParameter("serverName");  
    }  
}
```

2. 在sentinel中添加黑名单配置
![[image-20240413090838859.png]]
其中流量应用为参数的值


cloudalibaba-consumer-nacos-order83   通过OpenFeign调用    cloudalibaba-provider-payment9001

1. 83   通过OpenFeign调用  9001微服务，正常访问OK
2. 83   通过OpenFeign调用  9001微服务，异常访问error

  访问者要有fallback服务降级的情况，不要持续访问9001加大微服务负担，但是通过feign接口调用的又方法各自不同，

  如果每个不同方法都加一个fallback配对方法，会导致代码膨胀不好管理，工程埋雷....../(ㄒoㄒ)/~~

3. **public** @**interface** FeignClient

   通过fallback属性进行统一配置，feign接口里面定义的全部方法都走统一的服务降级，**一个搞定即可**。

4. 9001微服务自身还带着sentinel内部配置的流控规则，如果满足也会被触发，也即本例有2个Case
	1. OpenFeign接口的统一fallback服务降级处理
	2. Sentinel访问触发了自定义的限流配置,在注解@SentinelResource里面配置的blockHandler方法。

### Seata
Seata 是一款开源的分布式事务解决方案，致力于提供高性能和简单易用的分布式事务服务。Seata 将为用户提供了 AT、TCC、SAGA 和 XA 事务模式，为用户打造一站式的分布式解决方案。
![[seata业务逻辑.png]]

#### 三个角色
##### 事务协调者(TC)
维护全局和分支事务的状态，驱动全局事务提交或回滚。
##### 事务管理者(TM)
> 定义全局事务的范围：开始全局事务、提交或回滚全局事务。

**标注全局@GlobalTransactional启动入口动作的微服务模块(比如订单模块)**，它是事务的发起者，负责定义全局事务的范围，并根据​TC 维护的全局事务和分支事务状态，做出开始事务、提交事务、回滚事务的决议。

##### 资源管理者(RM)
管理分支事务处理的资源，与TC交谈以注册分支事务和报告分支事务的状态，并驱动分支事务提交或回滚。
**就是mysql数据库本身**，可以是多个RM，负责管理分支事务上的资源，向 TC​注册分支事务，汇报分支事务状态，驱动分支事务的提交或回滚

#### 流程
Seata对分布式事务的协调和控制就是1个XID+3个角色之间的协调控制
* XID是全局事务的唯一标识，它可以在服务的调用链路中传递，绑定到服务的事务上下文中
三个组件相互协作，TC以Seata 服务器(Server)形式独立部署，TM和RM则是以Seata Client的形式集成在微服务中运行，流程如下：
![[Seata的工作流程.png]]
1. TM 向 TC 申请开启一个全局事务，全局事务创建成功并生成一个全局唯一的 XID；
2. XID 在微服务调用链路的上下文中传播；
3. RM 向 TC 注册分支事务，将其纳入 XID 对应全局事务的管辖；
4. TM 向 TC 发起针对 XID 的全局提交或回滚决议；
5. TC 调度 XID 下管辖的全部分支事务完成提交或回滚请求。

#### AT 模式

##### 前提

- 基于支持本地 ACID 事务的关系型数据库。
- Java 应用，通过 JDBC 访问数据库。

##### 如何做到对业务的无侵入

##### 整体机制

两阶段提交协议的演变：

- 一阶段：业务数据和回滚日志记录在同一个本地事务中提交，释放本地锁和连接资源。
	* 在一阶段，Seata 会拦截“业务 SQL”，1)解析 SQL 语义，找到“业务 SQL”要更新的业务数据，在业务数据被更新前，将其保存成“before image”，2)执行“业务 SQL”更新业务数据，在业务数据更新之后，3)其保存成“after image”，最后生成行锁。
	* 以上操作全部在一个数据库事务内完成，这样保证了一阶段操作的原子性。![[image-20240413175208454.png]]

- 二阶段：
    - 提交异步化，非常快速地完成。
    - 回滚通过一阶段的回滚日志进行反向补偿。
> 二阶段如是顺利提交的话，因为“业务 SQL”在一阶段已经提交至数据库，所以Seata框架只需将一阶段保存的快照数据和行锁删掉，完成数据清理即可。
![[image-20240413175619502.png]]

> 二阶段如果是回滚的话，Seata 就需要回滚一阶段已经执行的“业务 SQL”，还原业务数据。
> 回滚方式便是用“before image”还原业务数据；但在还原前要首先要校验脏写，对比“数据库当前业务数据”和 “after image”，如果两份数据完全一致就说明没有脏写，可以还原业务数据，如果不一致就说明有脏写，出现脏写就需要转人工处理。
![[image-20240413175710178.png]]


##### 写隔离

- 一阶段本地事务提交前，需要确保先拿到 **全局锁** 。
- 拿不到 **全局锁** ，不能提交本地事务。
- 拿 **全局锁** 的尝试被限制在一定范围内，超出范围将放弃，并回滚本地事务，释放本地锁。

以一个示例来说明：

两个全局事务 tx1 和 tx2，分别对 a 表的 m 字段进行更新操作，m 的初始值 1000。

tx1 先开始，开启本地事务，拿到本地锁，更新操作 m = 1000 - 100 = 900。本地事务提交前，先拿到该记录的 **全局锁** ，本地提交释放本地锁。 tx2 后开始，开启本地事务，拿到本地锁，更新操作 m = 900 - 100 = 800。本地事务提交前，尝试拿该记录的 **全局锁** ，tx1 全局提交前，该记录的全局锁被 tx1 持有，tx2 需要重试等待 **全局锁** 。

![Write-Isolation: Commit](https://img.alicdn.com/tfs/TB1zaknwVY7gK0jSZKzXXaikpXa-702-521.png)

tx1 二阶段全局提交，释放 **全局锁** 。tx2 拿到 **全局锁** 提交本地事务。

![Write-Isolation: Rollback](https://img.alicdn.com/tfs/TB1xW0UwubviK0jSZFNXXaApXXa-718-521.png)

如果 tx1 的二阶段全局回滚，则 tx1 需要重新获取该数据的本地锁，进行反向补偿的更新操作，实现分支的回滚。

此时，如果 tx2 仍在等待该数据的 **全局锁**，同时持有本地锁，则 tx1 的分支回滚会失败。分支的回滚会一直重试，直到 tx2 的 **全局锁** 等锁超时，放弃 **全局锁** 并回滚本地事务释放本地锁，tx1 的分支回滚最终成功。

因为整个过程 **全局锁** 在 tx1 结束前一直是被 tx1 持有的，所以不会发生 **脏写** 的问题。

##### 读隔离

在数据库本地事务隔离级别 **读已提交（Read Committed）** 或以上的基础上，Seata（AT 模式）的默认全局隔离级别是 **读未提交（Read Uncommitted）** 。

如果应用在特定场景下，必需要求全局的 **读已提交** ，目前 Seata 的方式是通过 SELECT FOR UPDATE 语句的代理。

![Read Isolation: SELECT FOR UPDATE](https://img.alicdn.com/tfs/TB138wuwYj1gK0jSZFuXXcrHpXa-724-521.png)

SELECT FOR UPDATE 语句的执行会申请 **全局锁** ，如果 **全局锁** 被其他事务持有，则释放本地锁（回滚 SELECT FOR UPDATE 语句的本地执行）并重试。这个过程中，查询是被 block 住的，直到 **全局锁** 拿到，即读取的相关数据是 **已提交** 的，才返回。

出于总体性能上的考虑，Seata 目前的方案并没有对所有 SELECT 语句都进行代理，仅针对 FOR UPDATE 的 SELECT 语句。

##### 工作机制

以一个示例来说明整个 AT 分支的工作过程。

业务表：`product`

|Field|Type|Key|
|---|---|---|
|id|bigint(20)|PRI|
|name|varchar(100)||
|since|varchar(100)||

AT 分支事务的业务逻辑：

```sql
update product set name = 'GTS' where name = 'TXC';
```

###### 一阶段

过程：
1. 解析 SQL：得到 SQL 的类型（UPDATE），表（product），条件（where name = 'TXC'）等相关的信息。
2. 查询前镜像：根据解析得到的条件信息，生成查询语句，定位数据。

```sql
select id, name, since from product where name = 'TXC';
```

得到前镜像：

|id|name|since|
|---|---|---|
|1|TXC|2014|

3. 执行业务 SQL：更新这条记录的 name 为 'GTS'。
4. 查询后镜像：根据前镜像的结果，通过 **主键** 定位数据。

```sql
select id, name, since from product where id = 1;
```

得到后镜像：

|id|name|since|
|---|---|---|
|1|GTS|2014|

5. 插入回滚日志：把前后镜像数据以及业务 SQL 相关的信息组成一条回滚日志记录，插入到 `UNDO_LOG` 表中。

```
{	"branchId": 641789253,	"undoItems": [{		"afterImage": {			"rows": [{				"fields": [{					"name": "id",					"type": 4,					"value": 1				}, {					"name": "name",					"type": 12,					"value": "GTS"				}, {					"name": "since",					"type": 12,					"value": "2014"				}]			}],			"tableName": "product"		},		"beforeImage": {			"rows": [{				"fields": [{					"name": "id",					"type": 4,					"value": 1				}, {					"name": "name",					"type": 12,					"value": "TXC"				}, {					"name": "since",					"type": 12,					"value": "2014"				}]			}],			"tableName": "product"		},		"sqlType": "UPDATE"	}],	"xid": "xid:xxx"}
```

6. 提交前，向 TC 注册分支：申请 `product` 表中，主键值等于 1 的记录的 **全局锁** 。
7. 本地事务提交：业务数据的更新和前面步骤中生成的 UNDO LOG 一并提交。
8. 将本地事务提交的结果上报给 TC。

###### 二阶段-回滚

1. 收到 TC 的分支回滚请求，开启一个本地事务，执行如下操作。
2. 通过 XID 和 Branch ID 查找到相应的 UNDO LOG 记录。
3. 数据校验：拿 UNDO LOG 中的后镜与当前数据进行比较，如果有不同，说明数据被当前全局事务之外的动作做了修改。这种情况，需要根据配置策略来做处理，详细的说明在另外的文档中介绍。
4. 根据 UNDO LOG 中的前镜像和业务 SQL 的相关信息生成并执行回滚的语句：

```
update product set name = 'TXC' where id = 1;
```

5. 提交本地事务。并把本地事务的执行结果（即分支事务回滚的结果）上报给 TC。

###### 二阶段-提交

1. 收到 TC 的分支提交请求，把请求放入一个异步任务的队列中，马上返回提交成功的结果给 TC。
2. 异步任务阶段的分支提交请求将异步和批量地删除相应 UNDO LOG 记录。

#### 附录

##### 回滚日志表

UNDO_LOG Table：不同数据库在类型上会略有差别。

以 MySQL 为例：

|Field|Type|
|---|---|
|branch_id|bigint PK|
|xid|varchar(100)|
|context|varchar(128)|
|rollback_info|longblob|
|log_status|tinyint|
|log_created|datetime|
|log_modified|datetime|

```sql
-- 注意此处0.7.0+ 增加字段 context
CREATE TABLE `undo_log` (  `id` bigint(20) NOT NULL AUTO_INCREMENT,  `branch_id` bigint(20) NOT NULL,  `xid` varchar(100) NOT NULL,  `context` varchar(128) NOT NULL,  `rollback_info` longblob NOT NULL,  `log_status` int(11) NOT NULL,  `log_created` datetime NOT NULL,  `log_modified` datetime NOT NULL,  PRIMARY KEY (`id`),  UNIQUE KEY `ux_undo_log` (`xid`,`branch_id`)) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```

#### TCC 模式

回顾总览中的描述：一个分布式的全局事务，整体是 **两阶段提交** 的模型。全局事务是由若干分支事务组成的，分支事务要满足 **两阶段提交** 的模型要求，即需要每个分支事务都具备自己的：

- 一阶段 prepare 行为
- 二阶段 commit 或 rollback 行为

![Overview of a global transaction](https://img.alicdn.com/tfs/TB14Kguw1H2gK0jSZJnXXaT1FXa-853-482.png)

根据两阶段行为模式的不同，我们将分支事务划分为 **Automatic (Branch) Transaction Mode** 和 **Manual (Branch) Transaction Mode**.

AT 模式基于 **支持本地 ACID 事务** 的 **关系型数据库**：

- 一阶段 prepare 行为：在本地事务中，一并提交业务数据更新和相应回滚日志记录。
- 二阶段 commit 行为：马上成功结束，**自动** 异步批量清理回滚日志。
- 二阶段 rollback 行为：通过回滚日志，**自动** 生成补偿操作，完成数据回滚。

相应的，TCC 模式，不依赖于底层数据资源的事务支持：

- 一阶段 prepare 行为：调用 **自定义** 的 prepare 逻辑。
- 二阶段 commit 行为：调用 **自定义** 的 commit 逻辑。
- 二阶段 rollback 行为：调用 **自定义** 的 rollback 逻辑。

所谓 TCC 模式，是指支持把 **自定义** 的分支事务纳入到全局事务的管理中。

#### Saga 模式

Saga模式是SEATA提供的长事务解决方案，在Saga模式中，业务流程中每个参与者都提交本地事务，当出现某一个参与者失败则补偿前面已经成功的参与者，一阶段正向服务和二阶段补偿服务都由业务开发实现。

![Saga模式示意图](https://img.alicdn.com/tfs/TB1Y2kuw7T2gK0jSZFkXXcIQFXa-445-444.png)

理论基础：Hector & Kenneth 发表论⽂ Sagas （1987）

##### 适用场景

- 业务流程长、业务流程多
- 参与者包含其它公司或遗留系统服务，无法提供 TCC 模式要求的三个接口

##### 优势

- 一阶段提交本地事务，无锁，高性能
- 事件驱动架构，参与者可异步执行，高吞吐
- 补偿服务易于实现

##### 缺点

- 不保证隔离性（应对方案见[用户文档](https://seata.apache.org/zh-cn/docs/user/mode/saga)）