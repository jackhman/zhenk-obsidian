

# 目录

[TOC]

## 生成自己的Gitbook

```bash
$ npm install gitbook-cli -g
$ git clone https://github.com/xianyunyh/PHP-Interview
$ cd PHP-Interview
$ gitbook serve # 本地预览
$ gitbook build # 生成静态的html
```



# 前端笔记

## 原生ajax jq跨域

1. 原生js封装ajax

```javascript
//创建XmlhttpRequest对象function createXHR(){
    var xhr=null;
    if(XMLHttpRequest){
        xhr=new XMLHttpRequest();
    }else{
        xhr=new ActiveXObject("Microsoft.XMLHTTP");
    }
    return xhr;
}

function ajax(data){
    var xhr=createXHR();
    //初始化 准备配置参数    var type,async;
    type=data.type=='post'?'post':'get';
    async=data.async?true:false;
  xhr.open(type,data.url,async);
    //如果是post，设置请求头 执行发送动作    if(type=='get'){
        xhr.send(null);
    }
   else if(type=='post'){
        xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
        xhr.send(data.data);
    }
    //这段代码在xhr.send();执行完之后才能执行 指定回调函数    xhr.onreadystatechange=function(){
        if(xhr.readyState==4){
            if(xhr.status==200){
                if(typeof data.success=='function'){
                    var d=data.dataType=='xml'?xhr.responseXML:xhr.responseText;
                    data.success(d);
                }
            }else{
                if(typeof data.error=='function'){
                    data.error();
                }
            }

       }
    }

}

```

2.jq ajax使用

```javascript
ajax({
    type:"get",//请求类型 默认get
    url:"php/01-gettime.php",//地址
   dataType:”json”,//返回数据类型
    async:true,//是否异步 默认true
    data:null, //参数
    success: function (data) {
        alert(data);
    },
    error: function () {
        alert("错误");
    }

})
//JSONP : 服务器把json数据包装到一个方法中

//客户端提供一个对应的方法，可以处理服务器返回的数据
3.js跨域
window.onload = function () {
    //动态创建script标签
    var script = document.createElement("script");
    document.body.appendChild(script);
    script.src = "http://v.juhe.cn/weather/index?format=1&cityname=%E5%8C%97%E4%BA%AC&key=e982f3629ae77eb7345b7e42f29b62ae&dtype=jsonp&callback=handle";
}

//返回一个函数callback后面handle（）函数

//jsonp对应的方法

function handle(data) {
    alert(data.resultcode);
}
```

```javascript
4.jq跨域
        $(function () {
            $.ajax({
                type:"get",
             async：true, 
url:"http://v.juhe.cn/weather/index?format=1&cityname=%E5%8C%97%E4%BA%AC&key=e982f3629ae77eb7345b7e42f29b62ae&dtype=jsonp",
                dataType:"jsonp",
//                jsonp:"cb",     //将来会替换掉地址中的  callback
//                jsonpCallback:"handle",   //生成一个全局的方法  handle
                success: function (data) {
                    alert(data.resultcode);
                },
                error: function () {
                    alert("error");
                }
            });
        })
```



1. Get和post区别

GET请求的数据会附在URL之后（就是把数据放置在HTTP协议头中），以?分割URL和传输数据，参数之间以&相连，如：``login.action?name=hyddd&password=idontknow&verify=%E4%BD%A0%E5%A5%BD``。

POST把提交的数据则放置在是HTTP包的包体中。

GET方式提交的数据最多只能是1024字节, 这个限制是特定的浏览器及服务器对它的限制

理论上讲，POST是没有大小限制的，HTTP协议规范也没有进行大小限制

Get是向服务器发索取数据的一种请求，而Post是向服务器提交数据的一种请求

1. 中文乱码

js 程序代码：``url=encodeURI(url)``

1. Function函数

```javascript
//函数定义，可以先调用，后定义
Function fn(){
Console.log(111)
}

//函数表达式，不可以先调用
Var fn=function(){
Console.log(111)
}

//javascript 代码运行分连个阶段：
// 1、预解析  --- 把所有的函数定义提前，所有的变量声明提前，变量的赋值不提前
// 2、执行  --- 从上到下执行  （setTimeout，setInterval,ajax中的回调函数，事件中的函数需要触发执行）
```

1. js 跨域
2. jq 跨域jsonp使用



# JAVA知识点

## MAVEN仓库配置

在mavan里面添加

```xml
<mirrors>
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>        
    </mirror>
</mirrors>
```

在pom.xml里面添加

```xml
<repositories>
        <repository>
            <id>maven-ali</id>
            <url>http://maven.aliyun.com/nexus/content/groups/public//</url>
            <releases>
                <enabled>true</enabled>
            </releases>
            <snapshots>
                <enabled>true</enabled>
                <updatePolicy>always</updatePolicy>
                <checksumPolicy>fail</checksumPolicy>
            </snapshots>
        </repository>
</repositories>
```



## github生成SSH秘钥

ssh-keygen -t rsa -C "shengxu19910830@163.com"

## Github上创建Maven私有仓库

### 整个pom.xml相关配置

```xml
<!-- 当上传成功后，需要在项目中使用发布到github上的jar包，只需要在项目中的pom.xml中添加github仓库，如下代码表示 **注意** 最需要注意的是上传的分支路径，下面的截图我是将分支更改为了master，所以使用的地址是https://raw.github.com/sxjlinux/mvn-repo/master/，如果在mvn-repo有一个test的分支，则网址则写为：https://raw.github.com/sxjlinux/mvn-repo/test/即可。 -->
<repository>
    <id>maven-repo-master</id>
    <url>https://raw.github.com/jackhman/maven-repo/master/</url>
    <snapshots>
        <enabled>true</enabled>
        <updatePolicy>always</updatePolicy>
    </snapshots>
</repository>

<!-- 用于上传项目到github的maven仓库 -->
<plugin>
    <artifactId>maven-deploy-plugin</artifactId>
    <configuration>                                                                     <altDeploymentRepository>internal.repo::default::file://${project.build.directory}/mvn-repo</altDeploymentRepository>
    </configuration>
</plugin>
<!-- 本地仓库中发布到远程的github指定的仓库中，以添加修改插件的方式写入项目中 -->
<plugin>
    <groupId>com.github.github</groupId>
    <artifactId>site-maven-plugin</artifactId>
    <version>0.12</version>
    <configuration>
        <message>Maven artifacts for ${project.version}</message>
        <noJekyll>true</noJekyll>
        <outputDirectory>${project.build.directory}/mvn-repo</outputDirectory><!--本地jar地址 -->
        <branch>refs/heads/master</branch><!--分支 branch必须是refs/heads/开头的，后边跟分支名称 必须添加refs,不然执行mvn clean deploy报错-->
        <merge>true</merge>
        <includes>
            <include>**/*</include>
        </includes>
        <repositoryName>maven-repo</repositoryName><!--对应github上创建的仓库名称 name -->
        <repositoryOwner>jackhman</repositoryOwner><!--github 仓库所有者 -->
    </configuration>
    <executions>
        <execution>
            <goals>
                <goal>site</goal>
            </goals>
            <phase>deploy</phase>
        </execution>
    </executions>
</plugin>
```

### maven中的setting.xml相关配置

```xml
<server>
    <id>github</id>
    <username>github登录名</username>
    <password>github登录密码</password>
</server>
```

1. 首先在Github仓库中创建一个自己的仓库，仓库名称为：mvn-repo，如下图所示：

   ![img](image/82a7c1f834994a989ec8f52da71c2aa0.png)

2. 然后在mvn工具的配置文件settings.xml中（在window中配置文件会在Maven的安装目录下的conf文件夹下），找到servers标签，添加一个server，如：

   ```xml
   <server>
       <id>githubid>
       <username>guihub登录的用户名<username>
       <password>guihub登录的用户密码<password>
   <server>
   ```

如图所示:

![img](image/7cab43b47acb433ab2fef30c55c90814.png)

1. 在maven项目的pom.xml中添加入下代码，将本地的jar发布到本地仓库中。

```xml
<!-- 用于上传项目到github的maven仓库 -->
<plugin>
    <artifactId>maven-deploy-plugin</artifactId>
    <configuration>                                                                     <altDeploymentRepository>internal.repo::default::file://${project.build.directory}/mvn-repo</altDeploymentRepository>
    </configuration>
</plugin>
```

如下图所示:

![img](D:/Documents/%E5%AD%A6%E4%B9%A0/a-%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91/%E7%AC%94%E8%AE%B0/Study-Notes/image/06160448280245cab36f65eea2007603.png)

1. 然后输入：**mvn clean deploy** 命令，如下图所示***bulid***成功即可将jar发布到了本地仓库中了：

![img](image/484dc0d899b9485f82dd150bc75cfd4a.png)

![img](image/71e74b617552409e815dded1f861cf5b.png)

1. 将本地仓库中发布到远程的github指定的仓库中，添加修改插件，如下代码：

```xml
<!-- 本地仓库中发布到远程的github指定的仓库中，以添加修改插件的方式写入项目中 -->
<plugin>
    <groupId>com.github.github</groupId>
    <artifactId>site-maven-plugin</artifactId>
    <version>0.12</version>
    <configuration>
        <message>Maven artifacts for ${project.version}</message>
        <noJekyll>true</noJekyll>
        <outputDirectory>${project.build.directory}/mvn-repo</outputDirectory><!--本地jar地址 -->
        <branch>refs/heads/master</branch><!--分支 branch必须是refs/heads/开头的，后边跟分支名称-->
        <merge>true</merge>
        <includes>
            <include>**/*</include>
        </includes>
        <repositoryName>maven-repo</repositoryName><!--对应github上创建的仓库名称 name -->
        <repositoryOwner>jackhman</repositoryOwner><!--github 仓库所有者 -->
    </configuration>
    <executions>
        <execution>
            <goals>
                <goal>site</goal>
            </goals>
            <phase>deploy</phase>
        </execution>
    </executions>
</plugin>
```

***注意***:  *branch*必须是refs/heads/开头的，后边跟分支名称，我们在网页上查看到mvn-repo下有一个master的分支，如下图所示：

1. 加入如下代码，配置远程的github服务

```xml
<properties>
  <github.global.server>github<github.global.server>
<properties>
```

如下图所示:

![img](image/885251ef638945dd879b10c38b46cfb1.png)

整个pom.xml如下:

```xml
<xml version="1.0" encoding="UTF-8" ?>
	<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
		<parent>
			<artifactId>pubmodel</artifactId>
			<groupId>com.wincom.publicmodel</groupId>
			<version>2.0</version>
		</parent>
		<modelVersion>4.0.0</modelVersion>
		<version>2.0</version>
		<artifactId>path</artifactId>
		<build>
			<plugins>
				<plugin>
					<artifactId>maven-deploy-plugin</artifactId>
					<version>2.8.1</version>
					<configuration>
						<altDeploymentRepository>internal.repo::default::file://${project.build.directory}/mvn-repo</altDeploymentRepository>
					</configuration>
				</plugin>
				<plugin>
					<groupId>com.github.github</groupId>
					<artifactId>site-maven-plugin</artifactId>
					<version>0.12</version>
					<configuration>
						<message>Maven artifacts for ${project.version}</message>
						<noJekyll>true</noJekyll>
						<outputDirectory>${project.build.directory}/mvn-repo</outputDirectory>
						<branch>refs/heads/master</branch>
						<merge>true</merge>
						<includes>
							<include>**/*</include>
						</includes>
						<repositoryName>mvn-repo</repositoryName>
						<repositoryOwner>sxjlinux</repositoryOwner>
					</configuration>
					<executions>
						<execution>
							<goals>
								<goal>site</goal>
							</goals>
							<phase>deploy</phase>
						</execution>
					</executions>
				</plugin>
			</plugins>
		</build>
		<properties>
			<github.global.server>
				github
			</github.global.server>
		</properties>
	</project>
```

1. 输入： **mvn clean deploy**命令会提示错误，此错误主要是因为在github中没有设置自己的姓名

![img](image/57b7aeb36ade4a0fa2003ddb884ab133.png)

1. 登录到github中，然后点击Settings，如下图所示：

![img](image/d1ddb884bc334acca9f7d464038e1d83.png)

1. 输入自己的姓名

![img](image/ea41c35241284f01a11f3836559ed2aa.png)

1. 点击update

![img](image/9bb4fbd963d24c248827d494f27f649b.png)

1. 在次使用mvn clean deploy命令，此时就会上传成功，如下图所示

![img](image/3784498f921b4652a69d50a62ad130c3.png)

1. 然后刷新github网页查看，如下图所示：

![img](image/0ef9155d94134a98af4d034f50a810aa.png)

1. 以上都是在子模块中进行的，如果有多个子模块，可以将上边用到的build统一放在项目的根目录中的pom.xml中，而子模块不需要放置build,直接在根目录执行mvn clean deploy命令，mvn会自动将所有子模块打包上传到github中的
2. 当上传成功后，需要在项目中使用发布到github上的jar包，只需要在项目中的pom.xml中添加github仓库，如下代码表示

### 新建Maven项目的时候只需要在pom.xml中添加

```xml
<repositories>
    <repository>
        <id>maven-repo-master</id>
        <url>https://raw.github.com/jackhman/maven-repo/master/</url>
        <snapshots>
            <enabled>true</enabled>
            <updatePolicy>always</updatePolicy>
        </snapshots>
    </repository>
</repositories>
<dependencies>
    <dependency>
        <groupId>com.xzsoft.xip</groupId>
        <artifactId>xip-parent</artifactId>
        <version>0.0.1-SNAPSHOT</version>
    </dependency>
</dependencies>
```

#### 注意

1. 执行mvn clean deploy命令出现错误，意思是github的仓库分支必须是以refs/开头

![img](image/03cf5b68328a437a992cd1d08d915a9b.png)

![img](image/86d4133ad2fc4d8c9fe94da6b2927600.png)

1. 只需要在branch标签的mvn-repo的前边加上refs/即可，如下图所示：![img](image/452911030083480f92242f014f279ead.png)
2. 再次执行mvn clean deploy命令即可编译成功并上传，如下图所示：

![img](image/06dc4e75472c438aa68e812177197fd3.png)

1. 此时发现github仓库中是空的，需要更改配置路径将refs/mvn-repo更改为refs/heads/mvn-repo，如图所示：![img](image/a866e4d1afc44755851cc5bc762a7a66.png)



1. 登录Github管网就可以在mvn-repo分支下看到上传的jar项目

## 使用GitHub LFS让git处理大文件

1. 安装[Git](https://git-scm.com/)
   进入官网[GitHub LFS](https://git-lfs.github.com/)下载并安装**GitHub LFS**

2. 进入Github的本地仓库目录初始化LFS

   ```shell
   git init
   git lfs install
   ```

3. 用git lfs管理大文件
   用git lfs track命令跟踪特定后缀的大文件，或者也可以直接编辑.gitattributes，类似于.gitignore文件的编写，在此我只处理.bz2文件：

   ```shell
   git lfs track "*.bz2"
   ```

然后将.gitattributes文件添加进git仓库：

``git config lfs.contenttype false``   # 禁用自动内容类型检测

```shell
git add .gitattributes
```

1. 接下来就可以像平时使用git那样正常使用了，可以将大文件提交到GitHub了

   ```shell
   git add xxx
   git commit -m "update"
   git push origin master
   ```

## 基于Github Pages + docsify搭建个人博客

### 使用docsify命令生成文档站点

#### 安装docsify-cli 工具

推荐安装 docsify-cli 工具，可以方便创建及本地预览文档网站。

```
npm i docsify-cli -g
```

因为我们已经安装了node环境，所以直接打开CMD窗口执行上面的命令就好了。

#### 初始化一个项目

然后我们选择一个目录，作为我们的博客站点目录。也就是项目要生成的目录。

比如我在E盘下新建了一个myblogs的目录

![在这里插入图片描述](image/20200105134122889.png)

打开CMD黑框，cd到该目录，执行如下命令：

```
docsify init ./docs
```

![在这里插入图片描述](image/20200105134302117.png)

执行完成后，目录结构就会变成这样

![在这里插入图片描述](image/20200105134324585.png)

可以看到，多了一个docs文件夹，其实这个文件夹就是将来我们存放MD格式的博客文件的地方。

与此同时，docs目录下会生成几个文件。

![在这里插入图片描述](image/20200105134355178.png)

- index.html 入口文件
- README.md 会做为主页内容渲染
- .nojekyll 用于阻止 GitHub Pages 会忽略掉下划线开头的文件

#### 启动项目，预览效果

到这里，就可以启动项目，然后看下效果了。

使用下面命令启动项目：

```
docsify serve docs
```

![在这里插入图片描述](image/20200105134816523.png)

流程器输入：[http://localhost:3000](http://localhost:3000/)

![在这里插入图片描述](image/2020010513494279.png)

看着有点简陋，不过框架已经搭好了，接下来就是一些配置了。

#### 增加一些配置，变身成真正的blogsite

这里我们主要配置一下封面、左侧导航栏和首页，其他的配置可以参考docsify官网。

**1、配置左侧导航栏**

在 `E:\myblogs\docs`目录下新建一个`_sidebar.md` 的md文件，内容如下：

```
- 设计模式

  - [第一章节](desgin-pattern/Java面试必备：手写单例模式.md)
  - [工厂模式](desgin-pattern/工厂模式超详解（代码示例）.md)
  - [原型模式](desgin-pattern/设计模式之原型模式.md)
  - [代理模式](desgin-pattern/设计模式之代理模式.md)

- Spring框架

  - [初识spring框架](spring/【10分钟学Spring】：（一）初识Spring框架.md)
  - [依赖注入及示例](spring/【10分钟学Spring】：（二）一文搞懂spring依赖注入（DI）.md)
  - [spring的条件化装配](spring/【10分钟学Spring】：（三）你了解spring的高级装配吗_条件化装配bean.md)

- 数据库
```

这其实就是最基本的md文件，里面写了一些链接而已。

当然了我们诸如 `desgin-pattern/Java面试必备：手写单例模式.md` 是相对路径，目录下也要放 `Java面试必备：手写单例模式.md` 文件才行。

![在这里插入图片描述](image/2020010514065643.png)

只有上面的`_sidebar.md` 文件是不行滴，还需要在index.html文件中配置一下。在内嵌的js脚本中加上下面这句：

```
loadSidebar: true
```

![在这里插入图片描述](image/20200105141053778.png)

好了，我们来看下效果。

注意，无需我们重新启动docsify serve，保存刚才添加和修改的文件就行。

![在这里插入图片描述](image/20200105141312381.png)

**2、配置个封面**

套路和上面配置左侧导航栏是一样的。

首先新建一个 `_coverpage.md` 的md文件，这里面的内容就是你封面的内容。

```
# Myblogs


> 我要开始装逼了


[CSDN](https://blog.csdn.net/m0_37965018)
[滚动鼠标](#introduction)
```

然后在index.xml文件中修改js脚本配置，添加一句：

```
coverpage: true
```

![在这里插入图片描述](image/20200105141937426.png)

看下效果

![在这里插入图片描述](image/20200105142017986.png)

**3、配置一个首页**

最后我们来配置下首页，也就是封面完了之后，第一个看到的界面。

其实就是 `E:\myblogs\docs` 目录下`README.md` 文件的内容。

我们一直没有管他，默认就是这个样子的：

![在这里插入图片描述](image/20200105142433933.png)

改一下，放上自己牛逼的经历或者是标签。

```
# 最迷人的二营长

> [个人博客](https://blog.csdn.net/m0_37965018)


> [GitHub](https://github.com/Corefo/ "github")
```

看下效果

![在这里插入图片描述](image/20200105142733890.png)

### 部署到Github上

没有域名 + 服务器怎么办，不用担心，我们有Github啊，通过Github Pages的功能，我们可以将个人站点托管到github上。

#### 登录github账号，创建仓库

登录github的官网，创建一个仓库，起个名字吧，就叫myblogs。

![在这里插入图片描述](image/20200105143404136.png)

仓库创建好了，我们使用第二种方式导入一个本地仓库（本地仓库还没有创建，接下来会建一个）。

![在这里插入图片描述](image/20200105143534220.png)

#### 创建本地仓库，推送到github

首先我们进入我们的本地博客站点目录，也就是 `E:\myblogs`

右键`Git Bash Here` 打开git命令行初始化一个仓库，并提交所有的博客文件到git本地仓库。

涉及命令如下：

```
git init // 初始化一个仓库
git add -A // 添加所有文件到暂存区，也就是交给由git管理着
git commit -m "myblogs first commit" // 提交到git仓库，-m后面是注释
git remote add origin https://github.com/Corefo/myblogs.git
git push -u origin master // 推送到远程myblogs仓库
```

按上面的命令顺序操作，不出意外的话，我们的本地myblogs已经同步到了github上面了。

刷新github的页面来看下。

![在这里插入图片描述](image/20200105144816401.png)

#### 使用Github Pages功能建立站点

这一步相当简单，简单到令人发指！！

在myblogs仓库下，选中 `Settings` 选项，

![在这里插入图片描述](image/20200105145128951.png)

然后鼠标一直向下滚动，直到看到 `GitHub Pages` 页签，在Source下面选择`master branch / docs folder` 选项。

![在这里插入图片描述](image/20200105145523112.png)

好了，ok了，完美了，“wocao，这么简单”。

同时，还会提示你在哪里去访问你的站点。

![在这里插入图片描述](image/20200105145643175.png)

按照提示，我们访问看看：

![在这里插入图片描述](image/20200105145852248.png)



## git创建空白分支

1. [复制github地址](http://jingyan.baidu.com/album/f71d6037cc20301ab641d181.html?picindex=10)

   [![git创建空白分支](https://imgsa.baidu.com/exp/w=500/sign=0735bcd6084f78f0800b9af349300a83/e824b899a9014c0892de0a27017b02087af4f44f.jpg)](http://jingyan.baidu.com/album/f71d6037cc20301ab641d181.html?picindex=1)

2. 

   clone 项目，进入项目目录

   [![git创建空白分支](https://imgsa.baidu.com/exp/w=500/sign=76a841fc9958d109c4e3a9b2e15accd0/c2cec3fdfc0392457d74c38d8c94a4c27c1e256a.jpg)](http://jingyan.baidu.com/album/f71d6037cc20301ab641d181.html?picindex=2)

3. 

   git checkout --orphan <新的分支名> #创建新的空白分支

   \#如果提示error: The following untracked working tree files would be overwritten by checkout:，执行第四步到第五步

   [![git创建空白分支](https://imgsa.baidu.com/exp/w=500/sign=0eeb165b3201213fcf334edc64e536f8/dc54564e9258d10930258b30da58ccbf6d814d69.jpg)](http://jingyan.baidu.com/album/f71d6037cc20301ab641d181.html?picindex=3)

4. 

   git clean -d -fx #会清除所有git clone下的所有文件，只剩.git

   [![git创建空白分支](https://imgsa.baidu.com/exp/w=500/sign=781112e7b819ebc4c0787699b227cf79/0b7b02087bf40ad163f9ea615c2c11dfa9ecce16.jpg)](http://jingyan.baidu.com/album/f71d6037cc20301ab641d181.html?picindex=4)

5. 

   重新执行git checkout --orphan <新的分支名>

   [![git创建空白分支](https://imgsa.baidu.com/exp/w=500/sign=de026abc07f3d7ca0cf63f76c21ebe3c/b17eca8065380cd7d7038f6faa44ad3459828116.jpg)](http://jingyan.baidu.com/album/f71d6037cc20301ab641d181.html?picindex=5)

6. 

   git rm -rf . #清除所有git文件历史，为了空白分支

   git commit -m "提交信息"

   [![git创建空白分支](https://imgsa.baidu.com/exp/w=500/sign=70aa1801042442a7ae0efda5e141ad95/377adab44aed2e73652fa4ae8c01a18b86d6fa6a.jpg)](http://jingyan.baidu.com/album/f71d6037cc20301ab641d181.html?picindex=6)

7. 

   git push origin <新的分支名> #推送远程分支

   \#提示该错误error: src refspec hexo does not match any.

   \#解决因为不能提交空分支，重新添加文件，提交分支

   [![git创建空白分支](https://imgsa.baidu.com/exp/w=500/sign=44c1cf7870cb0a4685228b395b62f63e/64380cd7912397dde976b5865282b2b7d0a28720.jpg)](http://jingyan.baidu.com/album/f71d6037cc20301ab641d181.html?picindex=7)

   [![git创建空白分支](https://imgsa.baidu.com/exp/w=500/sign=d2fc2d413187e9504217f36c203a531b/b8389b504fc2d562e1c9f26fec1190ef77c66c6a.jpg)](http://jingyan.baidu.com/album/f71d6037cc20301ab641d181.html?picindex=8)

8. 

   git add README.md

   git commit -m "提交信息"

   git push origin <新的分支名> #推送远程分支

   [![git创建空白分支](https://imgsa.baidu.com/exp/w=500/sign=55f8c97aac86c91708035239f93c70c6/962bd40735fae6cdbbbb86e304b30f2442a70f20.jpg)](http://jingyan.baidu.com/album/f71d6037cc20301ab641d181.html?picindex=9)

9. 

   新的空白分支就有了

   [![git创建空白分支](image/b8389b504fc2d562e606fd6fec1190ef76c66c21.jpg)](http://jingyan.baidu.com/album/f71d6037cc20301ab641d181.html?picindex=10)



## Git常用命令

Git 全局设置:

```
git config --global user.name "真壳"
git config --global user.email "shengxu19910830@163.com"
```

创建 git 仓库:

```shell
mkdir test
cd test
git init
touch README.md
git add README.md#git add .
git commit -m "first commit"#git cm -m "add a"
git remote add origin git@gitee.com:zhenksoft/test.git
git push -u origin master#git push上传到当前目录下的分支远程仓库
```

已有仓库?

```
cd existing_git_repo
git remote add origin git@gitee.com:zhenksoft/test.git
git push -u origin master
```

  

```shell
git remote add zhenk https://gitee.com/zhenksoft/myBook.git

git subtree add --prefix=docs https://gitee.com/zhenksoft/myBook.git docs
git subtree add --prefix=docs zhenk docs

git subtree pull --prefix=docs  https://gitee.com/zhenksoft/myBook.git docs --squash

git subtree split --rejoin --prefix=docs --branch zhenk

git subtree push --prefix=docs  https://gitee.com/zhenksoft/myBook.git docs


#创建空的分支
git checkout --orphan 新的分支名
git clean -d -fx #会清除所有git clone下的所有文件，只剩.git
git checkout --orphan <新的分支名>
git rm -rf . #清除所有git文件历史，为了空白分支
git commit -m "提交信息"
git push origin <新的分支名> #推送远程分支
touch README.md
git add README.md
git commit -m "提交信息"
git push origin <新的分支名> #推送远程分支

```



## Gitbook和Gitee整合

``` shell
git subtree add --prefix=docs https://gitee.com/zhenksoft/myBook.git docs

gitbook build . docs

git subtree pull --prefix=docs  https://gitee.com/zhenksoft/myBook.git docs --squash

git subtree push --prefix=docs  https://gitee.com/zhenksoft/myBook.git docs
```

#### 整合时出现的问题

> git log命令获取提交的历史找到需要回滚到的提交点

查看git提交记录:``git log``

```shell
git reset --hard 1398ec3813e11575b432f7eb777b638d3a72a74b
git push origin HEAD --force
```

##### Git出现|MERGING解决

输入命令可以正常跳转：git reset --hard head

![img](image/20180814111412983.png)

再进行merge如何push即可：

```shell
He-NingQiu@LAPTOP-HTU50PHP MINGW64 /f/MyItem_git/OurTeam_git/Match (hnq)
$ git merge hnq
Already up to date.

He-NingQiu@LAPTOP-HTU50PHP MINGW64 /f/MyItem_git/OurTeam_git/Match (hnq)
$ git push origin hnq
Counting objects: 9, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (9/9), done.
Writing objects: 100% (9/9), 20.37 KiB | 4.07 MiB/s, done.
Total 9 (delta 6), reused 0 (delta 0)
remote: Powered by Gitee.com
To https://gitee.com/serchief/Match.git

- [new branch]        hnq -> hnq
```



 



## JVM

![1566474781929](image/1566474781929.png)

![1566474841785](image/1566474841785.png)

![1567154061540](image/1567154061540.png)

![1567154109833](image/1567154109833.png)

![1569382136491](image/1569382136491.png)

用jstack导出线程堆栈

基本有两种情况会导致cpu高
1：FGC次数过多
2：线程中有特别消耗时间的计算



1：jmap命令dump出文件
2：mat工具进行分析，能看到具体什么对象在不断产生
3：排查代码中System.gc()有没有


PSYound + ParallelOld的组合

1：dump会写到一个文件，你们的堆有10G，所有会比较耗时
2:   dump期间，jira可能会暂停
所以 1：确认硬盘空间够用
​         2：暂停，但并不会导致数据丢失
​	 
​	 
1：禁止ExplicitGC
2：定期产生dump文件
3:   使用CMS代替 PS组合





### 类加载器

![1572744309341](image/1572744309341.png)

![1572745303665](image/1572745303665.png)

双亲委派





![1572749876057](image/1572749876057.png)

本地代码: C++/C编译完后格式为exe或者elf



LinkedTransferQueue就是追加字节到64字节



### Java内存区域与内存溢出异常

#### 运行时数据区域

![img](image/cc05d812de39a460690be8188c2bbb5e5fa.jpg)

运行时数据区包括：

- 程序计数器（Program Counter Register）
- Java虚拟机栈（VM Stack）
- 本地方法栈（Native Method Stack）
- 方法区（method area）
- 堆（heap）





##### 1、程序计数器

程序计数器是一块较小的内存空间，可以看作当前线程所执行的字节码行号指示器。需要注意以下几点内容：

- 程序计数器是线程私有，各线程之间互不影响
- 如果正在执行java方法，计数器记录的是正在执行的虚拟机字节码指令地址
- 如果执行native方法，这个计数器为null
- 程序计数器也是在Java虚拟机规范中唯一没有规定任何OutOfMemoryError异常情况的区域





##### 2、Java虚拟机栈

虚拟机栈即我们平时经常说的栈内存，也是线程私有，是Java方法执行时的内存模型，每个方法在执行时都会创建一个栈帧用于储存以下内容：

- **局部变量表**：32位变量槽，存放了编译期可知的各种基本数据类型、对象引用、returnAddress类型。
- **操作数栈**：基于栈的执行引擎，虚拟机把操作数栈作为它的工作区，大多数指令都要从这里弹出数据、执行运算，然后把结果压回操作数栈。
- **动态连接**：每个栈帧都包含一个指向运行时常量池（方法区的一部分）中该栈帧所属方法的引用。持有这个引用是为了支持方法调用过程中的动态连接。Class文件的常量池中有大量的符号引用，字节码中的方法调用指令就以常量池中指向方法的符号引用为参数。这些符号引用一部分会在类加载阶段或第一次使用的时候转化为直接引用，这种转化称为静态解析。另一部分将在每一次的运行期间转化为直接应用，这部分称为动态连接。
- **方法出口**：返回方法被调用的位置，恢复上层方法的局部变量和操作数栈，如果无返回值，则把它压入调用者的操作数栈。

每一个方法从调用直至执行完成的过程，就对应着一个栈帧在虚拟机栈中入栈到出栈的过程。在Java虚拟机规范中，对这个区域规定了两种异常状况：如果线程请求的栈深度大于虚拟机所允许的深度，将抛出StackOverflowError异常；如果虚拟机栈可以动态扩展并且扩展时无法申请到足够的内存，就会抛出OutOfMemoryError异常。





##### 3、堆（heap）

Java堆是JVM中最大的一块区域，线程共享，虚拟机启动是创建，此区唯一的目的就是存放对象实例，几乎所有对象实例都在这里分配，但是随着JIT编译器及逃逸分析技术的发展，栈上分配、标量替换优化技术将会导致一些微妙的变化，所有对象都分配在堆上也渐渐变的不是那么绝对。Java堆也是垃圾回收的主要区域，因此也称为“GC堆”。可以细分为：新生代和老年代。

- **新生代**：包括Eden区、From Survivor区、To Survivor区，系统默认大小Eden:Survivor=8:1
- **老年代**：在年轻代中经历了N次垃圾回收后仍然存活的对象，就会被放到年老代中。因此，可以认为年老代中存放的都是一些生命周期较长的对象。

堆大小是可扩展的，通过-Xmx和-Xms参数控制，当对象无法申请到足够的内存空间并且堆空间无法再扩展时就会抛出OutOfMemoryError异常。





##### 4、方法区

方法区（Method Area）与Java堆一样，是各个线程共享的内存区域，它用于存储已被虚拟机加载的类信息、常量、静态变量、以及编译器编译后的代码等。别名“非堆”。与垃圾回收关系不大，但不是没有垃圾回收，这个区域的内存回收目标主要是针对常量池的回收和对类型的卸载。空间无法满足需求时就会抛出OutOfMemoryError异常。





##### 5、运行时常量池

运行时常量池（Runtime Constant Pool）是方法区的一部分。Class文件中除了有类的版本、字段、方法、接口等描述信息外，还有一项信息是常量池（Constant Pool Table），用于存放编译期生成的各种字面量和符号引用，这部分内容将在类加载后进入方法区的运行时常量池中存放。受到方法区的内存限制，空间无法满足需求时就会抛出OutOfMemoryError异常。





#### Java对象的创建

1、当虚拟机遇到内存创建的指令（new、克隆、反序列化）的时候，首先去检查这个指令的参数是否能在方法区常量池中定位到一个类的符号引用并且检查这个符号引用代表的类是否已被加载、解析和初始化过（如若没有则进行这一系列操作）。
2、类检查通过后，虚拟机将为新生对象分配内存，分配内存分为**指针碰撞**和**空闲列表**两种方式；分配内存还要要保证**并发安全**，有两种方式：CAS和本地线程分配缓冲（TLAB）。
指针碰撞：前提是堆内存中的空闲空间十分的规整，使用与未使用的空间全部为连续，只需将指针移动与对象大小相等的距离就可以了；
空闲列表：针对堆内存中已使用与未使用的空间零散交错的存在，虚拟机维护着一个列表，记录着哪些被分配了，哪些还空闲；
3、分配完内存后，虚拟机需要将分配到的内存空间初始化为零值（不包含对象头）。
4、之后对该对象进行必要的设置，如对象的头（Object Header）进行初始化，包括：该对象对应类的元数据、对象的哈希码、该对象的GC分代年龄等信息
5、最后，从虚拟机的角度看，一个新对象已经产生，但从Java代码看，对象的创建刚开始—<init>方法还没执行，所有的字段都为零值。接下来就会执行<init>方法，按照对象初始化代码顺序执行，一个真正可用的对象才算创建完成。





#### Java对象的内存布局

对象在内存中存储的布局可以分为3块区域：对象头、实例数据和对齐填充。

**对象头**：在对象头中包含类型指针、哈希码、GC分代年龄、锁状态标志等；
**实例数据**：实例数据存放的是一些对 Java 使用者真正有效的信息，也就是类中定义的各个字段内容，其中还包括从父类继承的字段。
**对齐填充**：对齐填充并不是必然存在，起着占位符的作用。这段内存段存在与否取决于实例数据的长度，为了保证对象内存模型的长度为 8 字节的整数倍，当实例数据部分没有对齐时，就使用对齐填充来补全。





#### Java对象的访问定位

句柄：在堆中维护一个句柄池，句柄中包含了对象地址，当对象改变的时候，只需改变句柄，不需要改变栈中本地变量表的引用

![img](image/4536d65a7bbe34f9acf02fca231d3e47241.jpg)

直接指针：对象的地址直接存储在栈中，这样做的好处就是访问速度变快

![img](image/2370cdb8458ebbd90fc05ec29d6288eb0f3.jpg)

Sum Hotspot采用的直接指针访问对象， 减少第二次指针定位的时间开销。





####  OutOfMemoryError异常

##### 堆内存溢出

-Xms：JVM初始分配的堆内存
-Xmx：JVM最大允许分配的堆内存，与-Xms一致表示不允许堆自动扩展
-XX:+HeapDumpOnOutOfMemoryError：在内存溢出时Dump出当前的内存堆转储快照以便事后分析

##### 虚拟机栈和本地方法栈溢出

-Xss：设置栈大小
如果线程请求的栈深度大于虚拟机所允许的最大深度，将抛出StackOverflowError。
如果虚拟机在扩展栈时无法申请到足够的内存空间，则抛出OutOfMemoryError。
每个线程分配到的栈容量越大，可以建立的线程数量就越小，建立线程时越容易吧剩下的内存耗尽。通过增大最大堆或减少栈容量来换取更多的线程数。

##### 方法区和运行时常量池溢出

-XX:PermSize：JVM初始分配的非堆内存
-XX:MaxPermSize：JVM最大允许分配的非堆内存

##### 本机直接内存溢出

-XX:MaxDirectMemorySize：指定DirectByteBuffer能分配的空间的限额，如果没有显示指定这个参数启动jvm，默认值是-Xmx对应的值。



### 对象引用与回收判断

#### 1、引用计数算法

​         给对象中添加一个引用计数器，每当有一个地方引用它时，计数器值就加1；当引用失效计数器值就减1；任何时刻计数器都为0的对象就是不可能再被使用的。Java语言并没有选用引用计数器算法来管理内存，其中最主要的原因就是它很难解决对象之间相互循环引用的问题。



#### 2、可达性分析算法

Java通过一系列的名为“GC Root”的对象作为起始点，从这些节点开始向下搜索，搜索所走过的路径称为引用链（Reference Chain），当一个对象到GC Roots没有任何引用链相连（用图论的话来说就是从GC Roots到这个对象不可达）时，则证明此对象是不可引用的，所以它们将会被判定为可回收对象。在Java语言中可作为GC Roots的对象包括下面几种：
虚拟机栈（栈帧中的本地变量表）中的引用的对象；
1)、 方法区中的类静态属性引用的对象；
2)、运行时常量池中的对象引用；
3)、方法区中的常量引用的对象；
4)、本地方法栈中JNI（即一般所说的native方法）引用的对象。

对象引用：JDK1.2之后，Java将引用分为四种，这四种引用强度依次逐渐减弱
强引用(Strong Reference)：显示引用（例如：Object o = new Obje();），只要强引用还存在，垃圾收集器永远不会回收掉被引用的对象；
软引用(Soft Reference)：有用但非必须的引用，当内存不足时， 此类引用的对象会被回收，jdk1.2之后提供了SoftReference类来实现；
弱引用(Weak Reference)：非必须的引用，进行垃圾回收时，此类对象会被回收，jdk1.2之后提供了WeakReference类来实现；
虚引用(Plantom Reference)：虚引用不对对象生存时间构成影响，无法通过此类引用获取对象实例，使用目的是对象被回收时收到一个系统通知，jdk1.2之后提供了PlantomReference类来实现。



#### 3、生存还是死亡

要宣告一个对象死亡，至少要经历两次标记过程：
1)、如果可达性分析后没有与GC Roots相连接的引用链，会被第一次标记并进行一次筛选（筛选的条件是此对象有否有必要执行finalize()方法，当对象覆盖了finalize()方法并且该对象的finalize()方法被虚拟机调用过， 才有必要执行该对象的finalize()方法，任何对象的finalize()方法只会被被虚拟机调用一次。如果有必要执行该对象的finalize()方法，该对象将会被放置在F-Queue队列中，稍后由低优先级的Finalize线程去执行该对象的finalize()方法 ，finalize()方法是对象最后自我拯救的机会）；
2)、之后GC将对F-Queue队列中的对象进行第二次小规模的标记，确定最终是否回收该对象。





#### 4、回收方法区

方法区的垃圾回收性价比不高，主要回收废弃的常量和无用的类，回收常量与回收堆中的对象类似，回收无用的类需要类满足三个条件，而是否对类进行回收，虚拟机提供了-Xnoclassgc参数进行控制。
1)、该类所有的实例都已经被回收；
2)、加载该类的ClassLoader已经被回收，
3)、该类对应的java.lang.Class对象没有任何地方被引用，无法在任何地方通过反射访问该类的方法。



### 垃圾收集算法

#### 1、标记-清除算法

标记-清除算法是最基础的收集算法，分为标记和清除两个阶段，首先标记处需要回收的对象，标记完成后统一回收所有被标记的对象。有两个主要的缺点：效率不高，会产生内存碎片。

#### 2、复制算法

复制算法可以解决效率的问题，适合在存活大小较少时使用，基本的思想将可用内存分为大小相等的两块A和B，每次只使用其中一块。当其中一块A用完，就将存活的对象直接复制到另一块B空间中，把原来的那一块空间A全部清空，使用B来支撑程序正常执行，如此循环交替。这种算法的好处在于：不用考虑内存碎片，实现简单，运行高效。代价在于内存空间缩小为原来的一半。
实际上，Hotspot虚拟机将新生代内存空间分为一块较大的Eden空间和两块较小的Survivor(s0,s1)空间，每次使用Eden空间和其中一块Survivor空间，当进行垃圾回收时，将正在使用的Eden和Survivor空间中存活的对象复制到另外一块空闲的Survivor空间，同时清空掉刚才使用的Eden和Survivor空间，再使用Eden和另一块Survivor。**默认情况下Eden和Survivor的大小比例是8:1**，当Survivor空间不够用时，需要使用内存担保机制（依赖其他内存如老年代进行分配担保，直接进入老年代）。

#### 3、标记-整理算法

标记-整理算法核心思想是让所有存活的对象向空间一端移动，然后直接清理掉边界以外的空间。主要是针对对象成活率较高，只有少数对象被回收的情况，适合老年代使用，不会出现内存碎片问题。

#### 4、分代回收算法

分代回收算法将根据对象存活周期的长短，将堆分为新生代和老年代，并采用不同的算法。新生代中，每次垃圾收集都会有大量对象被回收，只有少量对象存活，适合采用复制收集算法；老年代中，对象存活率高，适合采用标记-整理算法。
Minnor GC和Full GC的不同：
新生代GC（Minnor GC）：发生在新生代的垃圾收集动作，对象存活期短，Minnor GC非常频繁，速度也比较快。
老年代GC（Major GC/Full GC）：发生在老年代的垃圾收集动作，对象存活期长，Major GC比Minnor GC慢很多（10倍以上）。



### 垃圾回收器参数配置

#### 通用配置

| 选项                               | 描述                                                         | 使用示例                                          |
| ---------------------------------- | ------------------------------------------------------------ | ------------------------------------------------- |
| -Xms                               | 设置Java堆的初始大小。当可用的Java堆区内存小于40%时，JVM就会将内存调整到选项-Xmx所允许的最大值 | -Xms100M                                          |
| -Xmx                               | 设置Java堆的最大值。当可用的Java堆区内存大于70%时，JVM就会将内存调整到选项-Xms所指定的初始值。与-Xms设置为一样的话可以避免堆自动扩展带来的性能开销。 | -Xmx300M                                          |
| -Xss                               | 设置栈容量大小。每个线程都拥有一个栈，生命周期与线程相同，每个方法的调用都会创建一个栈帧。在堆容量确定的情况下，栈容量越大意味着能建立的线程越少。 | -Xss2M                                            |
| -Xmn                               | 设置新生代的大小。-Xmn的内存大小为Eden+2个Surivivor空间的值，官方建议配置为整个堆的3/8。 | -Xmn100M                                          |
| -XX:NewSize                        | 设置新生代的初始大小。和-Xmn等价，推荐使用-Xmn，相当于一次性设定了NewSize与MaxNewSize的内存大小。 | -XX:NewSize=100M                                  |
| -XX:MaxNewSize                     | 设置新生代的最大值                                           | -XX:MaxNewSize=100M                               |
| -XX:NewRatio                       | 新生代(Eden+2个Surivivor空间)与老年代(不包括永久代)的比值    | -XX:NewRatio=4，表示新生代与老年代所占的比值为1:4 |
| -XX:SurivivorRatio                 | Eden与一个Surivivor的比值大小。默认为8:1，即Eden占8/10。     | -XX:SurvivorRatio=8                               |
| -XX:PermSize                       | 设置非堆内存(方法区，永久代)的初始大小。方法区主要存放Class相关信息，如类名、访问修饰符、常量池、字段描述等。 | -XX:PermSize=10M                                  |
| -XX:MaxPermSize                    | 设置非堆内存(方法区，永久代)的最大值                         | -XX:MaxPermSize=50M                               |
| -XX:MaxDirectMemorySize            | 设置本机直接内存大小。一般通过Unsalf类来操作直接内存。       | -XX:MaxDirectMemorySize=100M                      |
| -XX:PretenureSizeThreshold         | 设置对象超过指定字节大小时直接分配到老年代                   | -XX:PretenureSizeThreshold=3145728                |
| -XX:+HandlePromotionFailure        | 是否允许新生代收集担保失败。 进行一次minor gc后, 另一块Survivor空间不足时，将直接会在老年代中保留 | -XX:+HandlePromotionFailure                       |
| -XX:ParallelGCThreads              | 设置并行GC进行内存回收的线程数                               | -XX:ParallelGCThreads=4                           |
| -XX:MaxTenuringThreshold           | 晋升到老年代的对象年龄。每次Minor GC之后，存活年龄就加1，当超过这个值时进入老年代。默认为15 | -XX:MaxTenuringThreshold=15                       |
| -XX:+HeapDumpOnOutOfMemoryError    | 内存溢出时Dump出当前的内存堆转储快照以便事后进行分析         | -XX:+HeapDumpOnOutOfMemoryError                   |
| -XX:+PrintGCDetails                | 发生垃圾收集时打印详细回收日志， 并且在退出的时候输出当前内存区域分配情况。 | -XX:+PrintGCDetails                               |
| XX:+PrintGCDateStamps              | 输出GC时的时间戳                                             | XX:+PrintGCDateStamps                             |
| XX:+PrintHeapAtGC                  | 在进行GC的前后打印出堆的信息                                 | XX:+PrintHeapAtGC                                 |
| -XX:+PrintGCApplicationStoppedTime | 输出GC造成应用暂停的时间                                     | -XX:+PrintGCApplicationStoppedTime                |
| -Xloggc                            | 日志文件的输出路径                                           | -Xloggc:./logs/gc.log                             |
| -XX:+DisableExplicitGC             | 是否关闭手动System.gc                                        | -XX:+DisableExplicitGC                            |





#### Serial收集器

| 选项             | 描述                                                         | 使用示例         |
| ---------------- | ------------------------------------------------------------ | ---------------- |
| -XX:+UseSerialGC | 开启Serial收集器。 年轻代收集，单线程收集，采用复制算法，默认Client模式默认收集器，对于单核CPU和堆内存小使用效率比较好。 缺点是Stop-the-world。 | -XX:+UseSerialGC |





#### ParNew收集器

| 选项             | 描述                                                         | 使用示例         |
| ---------------- | ------------------------------------------------------------ | ---------------- |
| -XX:+UseParNewGC | 开启ParNew收集器。 年轻代收集，多线程，采用复制算法，好处是速度快，可开启多个垃圾线程收集， 优点是可并行运行，缺点单核CPU下效率不比Serial收集器快。 除了Serial收集器外，目前只有它能和CMS收集器配合工作。 它也是使用CMS收集器时默认的新生代收集器。 | -XX:+UseParNewGC |





#### Parallel Scavenge收集器

| 选项                       | 描述                                                         | 使用示例                   |
| -------------------------- | ------------------------------------------------------------ | -------------------------- |
| -XX:+UseParallelGC         | 开启Parallel Scavenge收集器。 年轻代收集，采用复制算法，可并行多线程收集器， 优点是注重吞吐量，缺点是停顿时间较长，用户体验不太好。 | -XX:+UseParallelGC         |
| -XX:MaxGCPauseMillis       | 最大GC停顿时间（毫秒），虚拟机将尽可能保证回收停顿时间不超过设定值。 | -XX:MaxGCPauseMillis=10    |
| -XX:GCTimeRatio            | 垃圾收集时间占总时间的比值，相当于吞吐量的倒数。 例如设置吞吐量19，那最大GC时间就占总时间5%(1/(1+19)),默认值99。 | -XX:GCTimeRatio=99         |
| -XX:+UseAdaptiveSizePolicy | 自适应调节策略，当打开这个参数之后， JVM会根据运行情况收集性能监控信息， 将动态调整这些参数(如-Xmn，-XX:SurivivorRatio，-XX:PretenureSizeThreshold等) | -XX:+UseAdaptiveSizePolicy |





#### Serial Old收集器

| 选项                | 描述                                                         | 使用示例            |
| ------------------- | ------------------------------------------------------------ | ------------------- |
| -XX:+UseSerialOldGC | 开启Serial Old收集器。 老年代收集，单线程，采用标记整理算法，优缺点和Serial收集器类似。 | -XX:+UseSerialOldGC |





#### Parallel Old收集器

| 选项                  | 描述                                                         | 使用示例              |
| --------------------- | ------------------------------------------------------------ | --------------------- |
| -XX:+UseParallelOldGC | 开启Parallel Old收集器。 老年代收集，多线程，采用标记整理算法。 优缺点和Parallel Scavenge收集器一样，只是之前老年代收集只有Serial Old收集， 所以Parallel Scavenge收集和Serial Old收集组合一起发挥不了吞吐量的优势， 所以出现了该收集器。 注重吞吐量以及CPU资源敏感的场合，优先考虑Parallel Scavenge+Parallel Old收集器。 | -XX:+UseParallelOldGC |





#### CMS收集器

| 选项                               | 描述                                                         | 使用示例                              |
| ---------------------------------- | ------------------------------------------------------------ | ------------------------------------- |
| -XX:+UseConcMarkSweepGC            | 开启CMS收集器。 老年代收集，多线程，采用标记清除算法， 优点是可并行并发处理，注重停顿时间，用户体验更快， 缺点是产生浮动垃圾，内存碎片，吞吐量会下降。 | -XX:+UseConcMarkSweepGC               |
| -XX:CMSInitiatingOccupancyFraction | 由于CMS收集存在浮动垃圾，CMS不能等到老年代用尽才进行回收， 而是使用率达到设定值就触发垃圾回收。不能设置太高， 否则会出现“Concurrent Mode Failure”错误而 临时启用Serial Old收集器导致停顿时间加长。 | -XX:CMSInitiatingOccupancyFraction=70 |
| -XX:+UseCMSInitiatingOccupancyOnly | 开启固定老年代使用率的回收阈值， 如果不指定，JVM仅在第一次使用设定值，后续则自动调整。 | -XX:+UseCMSInitiatingOccupancyOnly    |
| -XX:+UseCMSCompactAtFullCollection | 开启对老年代空间进行压缩整理（默认开启）。 由于CMS收集会产生内存碎片，所以需要对老年代空间进行压缩整理。 | -XX:+UseCMSCompactAtFullCollection    |
| -XX:CMSFullGCsBeforeCompaction     | 设置执行多少次不压缩的Full GC后，紧接着就进行一次压缩整理 （默认为0，每次都进行压缩整理）。 | -XX:CMSFullGCsBeforeCompaction=5      |
| -XX:+CMSScavengeBeforeRemark       | 执行CMS 重新标记（remark）之前进行一次Young GC， 这样能有效降低remark时间。 | -XX:+CMSScavengeBeforeRemark          |





#### G1 收集器

| 选项                               | 描述                                                         | 使用示例                              |
| ---------------------------------- | ------------------------------------------------------------ | ------------------------------------- |
| -XX:+UseG1GC                       | 开启G1收集器。 年轻代和老年代共用，多线程处理，采用标记整理算法， 优点是可并行并发处理、分代收集，空间整合、有点回收垃圾多的区域、可预测低停顿； G1收集分四个步骤：初始标记==>并发标记==>最终标记==>筛选回收； G1收集做法是将堆划分大小一样的Region区域，针对具体的区域回收， 通过Remembered Set方式避免全堆扫描，每个Region都有对应的Remembered Set， 每次Reference类型数据写操作时，JVM产生一个Write Barries进行终端， 检查Reference引用的对象是否处于不同的Region之间， 如果是，通过Card Table把相关引用信息记录到被引用对象的Remembered Set中， 那么进行可达性分析时加入Remembered set记性扫描。 | -XX:+UseG1GC                          |
| -XX:MaxGCPauseMillis               | 设置最大GC停顿时间。这是一个软性指标, JVM 会尽量去达成这个指标。 | -XX:MaxGCPauseMillis=10               |
| -XX:InitiatingHeapOccupancyPercent | 启动并发GC周期时的堆内存占用百分比。G1用它来触发并发GC周期，基于整个堆的使用率而不只是某一代内存的使用比。 值为 0 则表示"一直执行GC循环"， 默认值为 45。 | -XX:InitiatingHeapOccupancyPercent=70 |
| -XX:ParallelGCThreads              | 设置垃圾收集器在并行阶段使用的线程数，默认值随JVM运行的平台不同而不同。 | -XX:ParallelGCThreads=4               |
| -XX:ConcGCThreads                  | 并发垃圾收集器使用的线程数量。默认值随JVM运行的平台不同而不同。 | -XX:ConcGCThreads=4                   |
| -XX:G1ReservePercent               | 设置预留堆大小百分比，防止晋升失败，默认值是 10。            | -XX:G1ReservePercent=20               |
| -XX:G1HeapRegionSize               | 指定每个heap区的大小，默认值将根据 heap size 算出最优解。 最小值为 1Mb，最大值为 32Mb。 | -XX:G1HeapRegionSize=16M              |
| -XX:InitialSurvivorRatio           | 设置Survivor区的比例，默认为5。                              | -XX:InitialSurvivorRatio=10           |
| -XX:+PrintAdaptiveSizePolicy       | 打印自适应收集的大小。默认关闭。                             | -XX:+PrintAdaptiveSizePolicy          |
| -XX:G1MixedGCCountTarget           | 混合GC数量，默认为8。 减少该值可以解决晋升失败的问题(代价是混合式GC周期的停顿时间会更长)。 | -XX:G1MixedGCCountTarget=8            |

 

###  虚拟机命令监控命令工具

#### jps

列出正在运行的虚拟机进程，命令格式：jps [ options ] [ hostid ]
options 参数说明：

| -q   | 只输出进程 ID                               |
| ---- | ------------------------------------------- |
| -m   | 输出传入 main 方法的参数                    |
| -l   | 输出完全的包名，应用主类名，jar的完全路径名 |
| -v   | 输出jvm启动时参数                           |

#### jstat

用于监视虚拟机各种运行状态信息，可以显示本地以及远程虚拟机进程中的类装载、内存、垃圾回收、JIT编译等运行数据。命令格式：jstat [ option vmid [interval [s|ms] [count]] ]。
options 参数说明：

| -class            | 监视类装载、卸载数量、总空间及类装载所耗费的时间             |
| ----------------- | ------------------------------------------------------------ |
| -compiler         | 输出JIT编译器编译过的方法、耗时等信息                        |
| -gc               | 监视Java堆状况，包括Eden区、2个Survivor区、老年代、永久代等的容量、 已用空间、GC时间合计等信息 |
| -gccapacity       | 监视内容与-gc基本相同，但输出主要关注Java堆各个区域使用到的最大和最小空间 |
| -gcnew            | 显示新生代GC状况                                             |
| -gcnewcapacity    | 监视内容与-gcnew基本相同，输出主要关注使用到的最大和最小空间 |
| -gcold            | 显示老年代GC状况                                             |
| -gcoldcapacity    | 监视内容与-gcold基本相同，输出主要关注使用到的最大和最小空间 |
| -gcutil           | 监视内容与-gc基本相同，但输出主要关注已使用空间占总空间的百分比 |
| -gccause          | 与-gcutil功能一样，但是会额外输出导致上一次GC产生的原因      |
| -gpermcapacity    | 输出永久代使用到的最大、最小空间                             |
| -printcompilation | 输出JIT编译的方法信息                                        |

例如：jatst -gc 27121 1000 2，表示监视进程为27121的垃圾收集情况，每一秒一次，一共2次。如下图：

```
>jatst -gc 27121 1000 2
S0C      S1C      S0U    S1U      EC       EU        OC         OU       MC     MU       CCSC    CCSU     YGC   YGCT    FGC    FGCT     GCT
10240.0  10240.0  0.0   7214.5  81920.0  43781.2   204800.0   22096.5   44796.0 42870.5  6032.0  5620.4    9    0.066   4      0.030    0.096
10240.0  10240.0  0.0   7214.5  81920.0  43781.2   204800.0   22096.5   44796.0 42870.5  6032.0  5620.4    9    0.066   4      0.030    0.096
```

- S0C：第一个survivor区的容量
- S1C：第二个survivor区的容量
- S0U ：第一个survivor区目前已使用空间 
- S1U ：第二个survivor区目前已使用空间
- EC ：Eden区的容量
- EU ：Eden区目前已使用空间 
- OC ：Old代的容量
- OU ：Old代目前已使用空间
- MC：metaspace(元空间)的容量
- MU：metaspace(元空间)目前已使用空间
- YGC ：从应用程序启动到采样时年轻代中gc次数
- YGCT ：从应用程序启动到采样时年轻代中gc所用时间(s)
- FGC ：从应用程序启动到采样时old代full gc次数
- FGCT ：从应用程序启动到采样时old代full gc所用时间(s)
- GCT：从应用程序启动到采样时gc用的总时间(s)





#### jinfo

用于实时查看和调整虚拟机的各项参数，命令格式：jinfo [ option ] pid。
options 参数说明：

| -flag name       | 输出对应名称的参数         |
| ---------------- | -------------------------- |
| -flag [+\|-]name | 开启或者关闭对应名称的参数 |
| -flag name=value | 设定对应名称的参数         |
| -flags           | 输出全部的参数             |
| -sysprops        | 输出系统属性               |



#### jmap

用于生成堆转储快照以及显示堆信息，命令格式为：jmap [ option ] vmid。
options 参数说明：

| -dump          | 生成Java堆转储快照。格式为：-dump:[live,]format=b,file=<filename>，其中live子参数表示是否只dump出存活对象。 |
| -------------- | ------------------------------------------------------------ |
| -finalizerinfo | 显示在F-Queue中等待Finalizer线程执行finalize方法的对象。只在Linux/Solaris平台下有效。 |
| -heap          | 显示Java堆栈信息，如使用哪种回收器、参数配置、分代状况等。只在Linux/Solaris平台下有效。 |
| -histo         | 显示堆中对象统计信息，包括类、实例数量、合计容量             |
| -permstat      | 以ClassLoader为统计入口显示永久代的内存状态。只在Linux/Solaris平台下有效。 |
| -F             | 当虚拟机进程对-dump选项没有响应时，可使用这个选项强制生成dump快照。只在Linux/Solaris平台下有效。 |

#### jstack

用于生成当前虚拟机线程快照。命令格式为：jstack [ option ] vmid。
options 参数说明：

| -F   | 当正常请求不被响应时，强制输出线程堆栈    |
| ---- | ----------------------------------------- |
| -l   | 除线程堆栈外，显示关于锁的附加信息        |
| -m   | 如果调用本地方法的话，可以显示C/C++的堆栈 |

#### 可视化工具

- JConsole

![jconsole远程连接线程](image/jconsole远程连接.png)

- VisualVM
- Eclipse-Mat-MemoryAnalyzer



### 类文件结构

> Java虚拟机不和包括Java在内的任何语言绑定，它只与“Class文件”这种特定的二进制文件格式所关联，Class文件屮包含了 Java虚拟机指令集和符号表以及若干其他辅助信息。
>
> 基于安全方面的考虑，Java虚拟机规范要求在Class文件中使用许多强制性的语法和结构化约束，但任一门功能性语言都可以表示为一个能被Java虚拟机所接受的有效的Class文件。
>
> 作为一个通用的、机器无关的执行平台，任何其他语言的实现者都可以将Java虚拟机作为语言的产品交付媒介。
>
> 例如，使用Java编译器可以把Java代码编译为存储字节码的Class文件，使用JRuby等其他语言的编译器一样可以把程序代码编译成Class文件，虚拟机并不关心Class的来源是何种语言，Java提供的语言无关性如下：



![img](image/2303ad6c26580a03291e5eff53d32bb591b.jpg)





#### Class文件结构

- 魔数：每个Class文件的头4个字节称为魔数(Magic Number)，它的唯一作用就是确定这个文件是否是一个能被虚拟机接受的Class文件。这魔数很具有浪漫气息，为：0xCAFEBABE(咖啡宝贝?)

- 版本号：紧接着魔数的4个字节是Class文件的版本号：第5和第6字节是次版本号，第7和第8字节是主版本号。

- 常量池：版本号之后是常量池入口，可以理解为Class文件中的资源仓库，它是Class文件结构中与其他项目关联最多的数据类型，也是占用Class文件空间最大的数据项目之一，常量池中主要存放字面量和符号引用，由于常量池中常量的数量是不固定的，所以在常量池的入口需要放置一项u2类型的数据代表常量池容量计数值。

- 访问标志：常量池结束之后，紧接着的2个字节代表访问标志，这个标志用于识别一些类或者接口层次的访问信息，包括：这个Class是类还是接口；是否定义为public/abstract类型；如果是类的话，是否被声明为final等。

- 索引集合：包括类索引、父类索引、接口索引

- 字段表集合：描述接口或类中声明的变量，但不包括方法内部的局部变量。根据描述符规则，基本类型

  （byte、char、double、float、int、long、short、boolean)以及代表无返回值的void类型都用一个大写字符来表示，而对象类型则用字符L加对象的全限定名来表示，如表。

  | 标识字符 | 含 义          | 标识字符 | 含 义                         |
  | -------- | -------------- | -------- | ----------------------------- |
  | B        | 基本类型byte   | J        | 基本类型long                  |
  | C        | 基本类型char   | S        | 基本炎型short                 |
  | D        | 基本类勒double | Z        | 基本类期boolean               |
  | F        | 基本类型float  | V        | 特殊类型void                  |
  | I        | 基本类型int    | L        | 对象类型，如Ljava/lang/Object |

  对于数组类型，每一维度将使用一个前置的“[”字符来描述，如一个定义为“java.lang. String[][]”

  类型的二维数组，将被记录为：

  > “[[Ljava/lang/String;”，一个整型数组“int[]”将被记 录为“[I”。

  > 用描述符来描述方法时，按照先参数列表，后返冋值的顺序描述，参数列表按照参数的严格顺序放在一组小括号“()”之内。如方法void inc()的描述符为“()V”，方法java.lang.String toString()的描述符为 “（)Ljava/lang/String;”，方法 int indexOf(char[] source，int sourceOffset，int sourceCount, char[]target，int targetOffset，int targetCount, int fromlndex)的描述 符为 “([CII[CIII)I。

- 方法表集合：代码在方法表中的属性集合“Code”属性集合中。方法表的结构如同字段表一样，依次包括了访问标志（access_flags)、名称索引(name_index)、描述符索引(descriptor_index)、属性表集合（attributes)几项。与字段表集合相对应的，如果父类方法在子类中没有被重写（Override)，方法表集合中就不会出现来自父类的方法信息。但同样的，有可能会出现由编译器自动添加的方法，最典型的便是类构造器“<clinit>”方法和实例构造器“<init>”方法。

- 属性表集合：在Class文件、字段表、方法表都可以携带自己的属性表集合，以用于描述某些场景专用信息。



#### 字节码指令

Java虚拟机的指令由一个字节长度的、代表着某种特定操作含义的数字（称为操作码， Opcode)以及跟随其后的零至多个代表此操作所需参数（称为操作数，Operands)而构成。由于Java虚拟机采用面向操作数栈而不是寄存器的架构，所以大多数的指令都不包含操作数，只有一个操作码。

字节码指令集是一种具有鲜明特点、优劣势都很突出的指令集架构，由于限制了Java虚拟机操作码的长度为一个字节（即0〜255)，这意味着指令集的操作码总数不可能超过256条；又由于Class文件格式放弃了编译后代码的操作数长度对齐，这就意味着虚拟机处理那些超过一个字节数据的时候，不得不在运行时从字节中重建出具体数据的结构，如果要将一个16位长度的无符号整数使用两个无符号字节存储起来（将它们命名为bytel和byte2)，那它们的值应该是这样的：(byte l << 8) | byte2。

这种操作在某种程度上会导致解释执行字节码时损失一些性能。

但这样做的优势也非常明显，放弃了操作数长度对齐，就意味着可以省略很多填充和间隔符号；用一个字节来代表操作码，也是为了尽可能获得短小精干的编译代码。这种追求尽可能小数据量、高传输效率的设计是由Java语言设计之初面向网络、智能家电的技术背景所决定的，并一直沿用至今。



#### 方法调用和返回指令

- invokevirtual：用于调用对象的实例方法，根据对象的实际类型进行分派（虚方法分派），这也是Java语言中最常见的方法分派方式。
- invokeinterface：用于调用接口方法，它会在运行吋搜索一个实现了这个接口方法的对象，找出适合的方法进行调用。
- invokespecial：用于调用一些需要特殊处理的实例方法，包括实例构造器<init>方法、私有方法和父类方法。
- invokestatic：用于调用类方法（static方法）。
- invokedynamic：用于在运行时动态解析出调用点限定符所引用的方法，并执行该方法。前面4条调用指令的分派逻辑都固化在Java虚拟机内部，而invokedynamic指令的分派逻辑是由用户所设定的引导方法决定的。

只要能被invokestatic和invokespecial指令调用的方法，都可以在解析阶段中确定唯一的调用版本，符合这个条件的有静态方法、私有方法、实例构造器、父类方法4类，它们在类加载的时候就会把符号引用解析为该方法的直接引用。

这些方法可以称为非虚方法，与之相反，其他方法称为虚方法（除去final方法）。除了使用invokestatic、invokespecial调用的方法之外还有一种，就是被final修饰的方法。

虽然final方法是使用invokevirtual指令来调用的，但是由于它无法被覆盖，没有其他版本，所以也无须对方法接收者进行多态选择，又或者说多态选择的结果肯定是唯一的。

在Java语言规范中明确说明了final方法是一种非虚方法。解析调用一定是个静态的过程，在编译期间就完全确定，在类装载的解析阶段就会把涉及的符号引用全部转变为可确定的直接引用，不会延迟到运行期再去完成。而分派(Dispatch)调用则可能是静态的也可能是动态的，根据分派依据的宗量数可分为单分派和多分派。这两类分派方式的两两组合就构成了静态单分派、静态多分派、动态单分派、动态多分派4种分派组合情况。

方法调用指令与数据类型无关，而方法返回指令是根据返回值的类型区分的，包括 iretum (当返回值是 boolean、byte、char、short 和 int 类型时使用）、lretum、fretum、dreturn 和areturn，另外还有一条return指令供声明为void的方法、实例初始化方法以及类和接口的类初始化方法使用。



#### 异常处理指令

在Java程序中显式抛出异常的操作（throw语句）都由athrow指令来实现，除了用 throw语句显式抛出异常情况之外，Java虚拟机规范还规定了许多运行时异常会在其他Java 虚拟机指令检测到异常状况时自动拋出。

例如，在前面介绍的整数运算中，当除数为零时, 虚拟机会在idiv或ldiv指令中抛出ArithmeticException异常。而在Java虚拟机中，处理异常（catch语句）不是由字节码指令来实现的，而是采用异常表来完成的。

#### 同步指令

Java虚拟机可以支持方法级的同步和方法内部一段指令序列的同步，这两种同步结构都 是使用管程（Monitor)来支持的。

同步一段指令集序列通常是由Java语言中的synchronized语句块来表示的，Java虚拟机 的指令集中有monitorenter和monitorexit两条指令来支持synchronized关键字的语义，正确实现synchronized关键字需要Javac编译器与Java虚拟机两者共同协作支持。

编译器必须确保无论方法通过何种方式完成，方法中调用过的每条monitorenter指令都 必须执行其对应的monhorexit指令，而无论这个方法是正常结束还是异常结束。

为了保证在方法异常完成时monitorenter和 monitorexit指令依然可以正确配对执行，编译器会自动产生一个异常处理器，这个异常处理器声明可处理所有的异常，它的目的就是用来执行monitorexit指令。



### 虚拟机类加载机制

虚拟机把描述类的数据从Class文件加载到内存，并对数据进行校验、转换解析和初始化，最终形成可以被虚拟机直接使用的Java类型，这就是虚拟机的类加载机制。与那些在编译时需要进行连接工作的语言不同，在Java语言里面，类型的加载、连接和初始化过程都是在程序运行期间完成的，这种策略虽然会令类加载时稍微增加一些性能开销，但是会为Java应用程序提供高度的灵活性，Java里天生可以动态扩展的语言特性就是依赖运行期动态加载和动态连接这个特点实现的。



#### 类加载时机

类从被加载到虚拟机内存中开始，到卸载出内存为止，它的整个生命周期包括：加载（Loading)、验证（Verification)、准备（Preparation)、解析（Resolution)、初始化(Initialization)、使(Using)和卸载（Unloading)7个阶段。其屮验证、准备、解析3个部分统称为连接（Linking)，这7个阶段的发生顺序如图所示。
![img](image/5f3d921e55e1c8863c710813fc5a72b636b.jpg)
加载、验证、准备、初始化和卸载这5个阶段的顺序是确定的，类的加载过程必须按照这种顺序按部就班地开始，而解析阶段则不一定：它在某些情况下可以在初始化阶段之后再开始，这是为了支持Java语言的运行时绑定。
对于初始化阶段，虚拟机规范则是严格规定了有且只有5种情况必须立即对类进行“初始化”（而加载、验证、准备自然需要在此之前开始）：
1) 遇到new、getstatic、putstatic或invokestatic这4条字节码指令时，如果类没有进行过初始化，则需要先触发其初始化。生成这4条指令的最常见的java代码场景是：使用new关键字实例化对象的时候、读取或设置一个类的静态字段（被final修饰、已在编译期把结果放人常量池的静态字段除外）的时候，以及调用一个类的静态方法的时候。
2) 使用java.lang.reflect包的方法对类进行反射调用的时候，如果类没有进行过初始化，则需要先触发其初始化。
3) 当初始化一个类的时候，如果发现其父类还没有进行过初始化，则需要先触发其父类的初始化。
4) 当虚拟机启动时，用户需要指定一个要执行的主类（包含main()方法的那个类），虚拟机会先初始化这个主类。
5) 当使用JDK1.7的动态语言支持时，如果一个java.lang.invoke.MethodHandk实例最后的解析结果REF_getStatic、REF_putStatic、REF_invokeStatic的方法句柄，并且这个方法句柄所对应的类没有进行过初始化，则需要先触发其初始化。

对于静态字段，只有直接定义这个字段的类才会被初始化，因此通过其子类来引用父类中定义的静态字段，只会触发父类的初始化而不会触发子类的初始化。通过数组定义来引用类，不会触发此类的初始化。常量在编译阶段会存入调用类的常量池中，本质上并没有直接引用到定义常量的类，因此不会触发定义常常量的类的初始化。
当一个类在初始化时，要求其父类全部都已经初始化过了，但是一个接口在初始化时，并不要求其父接口全部都完成了初始化，只有在真正使用到父接口的时候（如引用接口屮定义的常量）才会初始化。



#### 类加载器

类加载阶段中的“通过一个类的全限定名来获取描述此类的二进制字节流”这个动作放到Java虚拟机外部去实现，以便让应用程序自己决定如何去获取所需要的类。实现这个动作的代码模块称为“类加载器”。
类加载器虽然只用于实现类的加载动作，但它在Java程序中起到的作用却远远不限于类加载阶段。对于任意一个类，都需要由加载它的类加载器和这个类本身一同确立其在Java虚拟机中的唯一性，每一个类加载器，都拥有一个独立的类名称空间。这句话可以表达得更通俗一些：比较两个类是否“相等”，只有在这两个类是由同一个类加载器加载的前提下才有意义，否则，即使这两个类来源于同一个Class文件，被同一个虚拟机加载，只要加载它们的类加载器不同，那这两个类就必定不相等。



#### 双亲委派机制

从Java虚拟机的角度来讲，只存在两种不同的类加载器：一种是启动类加载器(Bootstrap ClassLoader)，这个类加载器使用C++语言实现，是虚拟机自身的一部分；另一种就是所有其他的类加载器，这些类加载器都由Java语言实现，独立于虚拟机外部，并且全都继承自抽象类java.lang.ClassLoader。从Java开发人员的角度来看，类加载器还可以划分得更细致一些，绝大部分java程序都会使用到以下3种系统提供的类加载器。

- 启动类加载器（Bootstrap ClassLoader)：这个类将器负责将存放在<JAVA_HOME>\lib目录中的，或者被-Xbootclasspath参数所指定的路径中的，并且是虚拟机识别的（仅按照文件名识别，如rt.jar，名字不符合的类库即使放在lib目录中也不会被加载）类库加载到虚拟机内存中。启动类加载器无法被Java程序直接引用，用户在编写自定义类加载器时，如果需要把加载请求委派给引导类加载器，那直接使用null代替即可。
- 扩展类加载器（Extension ClassLoader)：这个加载器由sun.misc.Launcher$ExtClassLoader实现，它负责加载<JAVA_HOME>\lib\ext目录中的，或者被java.ext.dirs系统变量所指定的路径中的所有类库，开发者可以直接使用扩展类加载器。
- 应用程序类加载器（Application ClassLoader)：这个类加载器由sun.misc.Launcher$AppClassLoader实现。由于这个类加载器是ClassLoader中的getSystemClassLoader()方法的返回值，所以一般也称它为系统类加载器。它负责加载用户类路径（ClassPath)上所指定的类库，开发者可以直接使用这个类加载器，如果应用程序中没有自定义过自己的类加载器，一般情况下这个就是程序中默认的类加载器。

我们的应用程序都是由这3种类加载器互相配合进行加载的，如果有必要，还可以加入自己定义的类加载器。这些类加载器之间的关系一般如下图所示：
![img](image/e0fb414f8155b27b7320d1443b7615b0c96.jpg)
图中展示的类加载器之间的这种层次关系，称为类加载器的双亲委派模型（Parents DelegationModel)。双亲委派模型要求除了顶层的启动类加载器外，其余的类加载器都应当有自己的父类加载器。这里类加载器之间的父子关系一般不会以继承（Inheritance)的关系来实现，而是都使用组合（Composition)关系来复用父加载器的代码。
双亲委派模型的工作过程是：如果一个类加载器收到了类加载的请求，它首先不会自己去尝试加载这个类，而是把这个请求委派给父类加载器去完成，每一个层次的类加载器都是如此，因此所有的加载请求最终都应该传送到顶层的启动类加载器中，只有当父加载器反馈自己无法完成这个加载请求（它的搜索范围中没有找到所需的类）时，子加载器才会尝试自己去加载。
双亲委派模型对于保证Java程序的稳定运作很重要，但它的实现却非常简单，实现双亲委派的代码都集中在java.lang.ClassLoader的loadClass()方法之中，如代码清单所示，逻辑清晰易懂：先检査是否已经被加载过，若没有加载则调用父加载器的loadClass()方法，若父加载器为空则默认使用启动类加载器作为父加载器。如果父类加载失败，拋出ClassNotFoundException异常后，再调用自己的findClass()方法进行加载。


```java
protected synchronized Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
    //首先 ， 检查请求的类是否已经被加载过了
    Class c = findLoadedClass(name);
    if (c == null) {
        try {
            if (parent != null) {
                c = parent.loadClass(name, false);
            } else {
                c = findBootstrapClassOrNull(name);
            }
        } catch (ClassNotFoundException e) {
            //如果父类加载器拋出ClassNotFoundException,说明父类加载器无法完成加载请求
        }
        if (c == null) {
            //在父类加载器无法加载的时候,再调用本身的findClass方法来进行类加载
            c = flndClass(name);
        }
    }
    if (resolve) {
        resolveClass(c);
    }
    return c;
}
```

 

### GC



![1564735490467](image/1564735490467.png)

![并发标记](image/并发标记.png)

![复制回收](image/复制回收.png)

![1564735998871](image/1564735998871.png)

#### JIT编译器 

当虚拟机发现某个方法或代码块的运行特别频繁时，就会把这些代码认定为“热点代码”（Hot Spot Code)。为了提高热点代码的执行效率，在运行时，虚拟机将会把这些代码编译成与本地平台相关的机器码，并进行各种层次的优化，完成这个任务的编译器称为即时编译器（JIT编译器，Just In Time Compiler）。

即时编译器编译性能的好坏、代码优化程度的高低却是衡量一款商用虚拟机优秀与否的最关键的指标之一，它也是虚拟机中最核心且最能体现虚拟机技术水平的部分。

HotSpot虚拟机中内置了两个即时编译器，分别称为Client Compiler(C1编译器)和Server Compiler(C2编译器)。目前主流的HotSpot虚拟机中，默认采用解释器与其中一个编译器直接配合的方式工作，程序使用哪个编泽器，取决于虚拟机运行的模式，HotSpot虚拟机会根据自身版本与宿主机器的硬件性能自动选择运行模式，用户也可以使用“-client”或“-server”参数去强制指定虚拟机运行在Client模式或Server模式。用Client Compiler获取更髙的编译速度，用Server Compiler来获取更好的编译质量，在解释执行的时候也无须再承担收集性能监控信息的任务。

在HotSpot虚拟机中使用的是基于计数器的热点探测方法，因此它为每个方法准备了两类汁数器：方法调用计数器（Invocation Counter)和回边计数器（BackEdgeCounter)。在确定虚拟机运行参数的前提下，这两个计数器都有一个确定的阈值，当计数器超过阈值溢出了，就会触发JIT编译。

方法调用计数器，用于统计方法被调用的次数，它的默认阈值在Client模式下是1500次，在Server模式下是10000次，这个阈值可以通过虚拟机参数-XX:CompileThreshold来人为设定。



### JMM

![1573354867501](image/1573354867501.png)

![1573952654660](image/1573952654660.png)

![1573953244850](image/1573953244850.png)

![1573959763981](image/1573959763981.png)



### 垃圾收集器

![img](image/6b2485c95530b238d734f12f4dbc06d6e46.jpg)
jdk1.8以及之前所有的垃圾收集器如图，
图中包含7中不同分代的收集器，
两者之间的连线表示可以搭配使用，
收集器所处的区域则表示能对该区域进行垃圾收集。



#### 新生代收集器



##### 1、Serial收集器

Serial收集器进行垃圾收集时，必须暂停其他所有的工作线程，直到它收集结束。它是运行在Client模式下的默认新生代收集器。对于单个CPU机器而言，Serial收集器没有线程交互的开销，专心做垃圾收集自然可以获得最高的单线程收集效率。Serial收集器运行的过程如下：

![img](image/bcfb3d63abbca917d3d73cf4326bba986e5.jpg)



##### 2、ParNew收集器

ParNew收集器是Serial收集器的多线程版本，除使用多条线程进行垃圾收集之外，其余行为包括控制参数、收集算法、Stop The World、对象分配规则、回收策略等都与Serial收集器完全一样，在实现上，这两种收集器也共用了相当多的代码。ParNew收集器运行的过程如下：

ParNew收集器是许多运行在Server模式下的首选**新生代**收集器，其中有一个与性能无关但很重要的原因是，除了Serial收集器外，目前只有它能与CMS收集器配合工作。



##### 3、Parallel Scavenge收集器

Parallel Scavenge收集器是一个**并行**的多线程**年轻代**收集器，它使用复制算法，被称为吞吐量优先收集器。表面上ParNew一样，但是它又和ParNew有很大的不同点：
Parallel Scavenge收集器和其他收集器的关注点不同。其他收集器，比如ParNew和CMS这些收集器，它们主要关注的是如何缩短垃圾收集的时间。而Parallel Scavenge收集器关注的是如何控制系统运行的吞吐量。这里说的吞吐量（吞吐量 = 代码运行时间 / (代码运行时间 + 垃圾收集时间)）。高吞吐量可以高效率的利用CPU时间，尽快完成运算任务，只要适合在后台运算而不需要太多交互的任务。
Parallel Scavenge收集器提供了两个参数用于控制吞吐量。*-XX:MaxGCPauseMillis*用于控制最大垃圾收集停顿时间，*-XX:GCTimeRatio*用于直接控制吞吐量的大小。MaxGCPauseMillis参数的值允许是一个大于0的整数，表示毫秒数，收集器会尽可能的保证每次垃圾收集耗费的时间不超过这个设定值。但是如果这个这个值设定的过小，那么Parallel Scavenge收集器为了保证每次垃圾收集的时间不超过这个限定值，会导致垃圾收集的次数增加和增加年轻代的空间大小，垃圾收集的吞吐量也会随之下降。GCTimeRatio这个参数的值应该是一个0-100之间的整数，表示应用程序运行时间和垃圾收集时间的比值。默认值为99，即最大允许1%(1 / (1 + 99) = 1%)的垃圾收集时间。
Parallel Scavenge收集器还有一个参数：*-XX:UseAdaptiveSizePolicy，*这是一个开关参数，当开启这个参数以后，就不需要手动指定新生代的内存大小(-Xmn)、Eden区和Survivor区的比值(*-XX:SurvivorRatio*)以及晋升到老年代的对象的大小(*-XX:PretenureSizeThreshold*)等参数了，虚拟机会根据当前系统的运行情况动态调整合适的设置值来达到合适的停顿时间和合适的吞吐量，这种方式称为GC自适应调节策略。



#### 老年代收集器



##### 1、Serial Old收集器

Serial Old收集器是Serial收集器的老年代版本，它也是一款使用"标记-整理"算法的单线程的垃圾收集器。这款收集器主要用于给Client模式下的虚拟机使用，也可以作为服务端应用程序的垃圾收集器，当它用于服务端应用系统中的时候，主要是在JDK1.5版本之前和Parallel Scavenge年轻代收集器配合使用，或者作为CMS收集器的后备收集器。Serial Old收集器运行的过程如下：
![img](https://oscimg.oschina.net/oscnet/bcfb3d63abbca917d3d73cf4326bba986e5.jpg)



##### 2、Parallel Old收集器

　　Parallel Old收集器是Parallel Scavenge收集器的老年代版本，使用"标记-整理"算法。注重吞吐量以及CPU资源敏感的场合，都可以优先考虑Parallel Scavenge加Parallel Old收集器一起配合使用。Parallel Old收集器运行的过程如下：
![img](image/acb4606c9e4186f57309291c9562a4cb08e.jpg)



##### 3、CMS收集器

CMS（Concurrent Mark Sweep）收集器是一个以获取最短停顿时间为目标的老年代收集器，基于"标记-清除"算法的并发收集器。由于现代互联网中的应用，比较重视服务的响应速度和系统的停顿时间，所以CMS收集器非常适合在这种场景下使用。运行的过程如下：
![CMS收集器](image/CMS收集器.jpg)
CMS收集器的运行过程相对其他收集器要复杂一些，整个收集过程分为4个阶段：

- **初始标记**(CMS initial mark)：用户线程会被停止，标记GC Roots可以直接关联到的对象，速度很快。（STW时间较短）
- **并发标记**(CMS concurrent mark)：从GC Roots 出发，标记出所有可达的对象，这个过程可能会花费相对比较长的时间，但是由于在这个阶段GC线程和用户线程是可以一起运行的，所以不会影响到系统的运行。（花费时间较长）
- **重新标记**(CMS remark)：用户线程会被停止，对并发标记期间因用户程序运行而导致标记变动的那部分记录进行修正，重新标记阶段耗时一般比初始标记稍长，但是远小于并发标记阶段。（STW时间较短）
- **并发清除**(CMS concurrent sweep)：不会停止系统的运行，所以即使相对耗时，也不会对系统运行产生大的影响。在清理过程中还会产生新的垃圾为浮动垃圾，等下一次CMS进行清理。

　　由于并发标记和并发清理阶段是和应用系统一起执行的，而初始标记和重新标记相对来说耗时很短，所以可以认为CMS收集器在运行过程中，是和应用程序是并发执行的。由于CMS收集器是一款并发收集和低停顿的垃圾收集器，所以CMS收集器也被称为并发低停顿收集器。虽然CMS收集器可以是实现低延迟并发收集，但是也存在3个明显的缺点：

- **对CPU资源非常敏感。**在并发阶段，由于占用一部分的线程，或者说CPU资源，导致应用程序变慢，总吞吐量降低。
- **无法处理浮动垃圾。**并发清理阶段，由于清理线程和用户线程一起运行，如果在清理过程中，用户线程产生了垃圾对象，这些垃圾对象就成为了浮动垃圾。
- **产生大量内存碎片。**由于使用“标记-清除“算法，在进行垃圾清理以后，会出现很多内存碎片，过多的内存碎片会影响大对象的分配。

虽然CMS收集器存在上面提到的这些问题，但是毫无疑问，CMS当前仍然是非常优秀的垃圾收集器。



##### 4、G1收集器

G1（Garbage First)垃圾收集器是以关注延迟为目标、服务器端应用的垃圾收集器，被HotSpot团队寄予取代CMS的使命，是一个非常具有调优潜力的垃圾收集器。虽然G1也有类似CMS的收集动作：初始标记、并发标记、重新标记、清除、转移回收，并且也以一个串行收集器做担保机制，但单纯地以类似前三种的过程描述显得并不是很妥当。事实上，G1收集与以往的收集器有很大不同：

1. G1的设计原则是"首先收集尽可能多的垃圾(Garbage First)"。因此，G1并不会等内存耗尽(串行、并行)或者快耗尽(CMS)的时候开始垃圾收集，而是在内部采用了启发式算法，在老年代找出具有高收集收益的分区进行收集。同时G1可以根据用户设置的暂停时间目标自动调整年轻代和总堆大小，暂停目标越短年轻代空间越小、总空间就越大；
2. G1采用内存分区(Region)的思路，将内存划分为一个个相等大小的内存分区，回收时则以分区为单位进行回收，存活的对象复制到另一个空闲分区中。由于都是以相等大小的分区为单位进行操作，因此G1天然就是一种压缩方案(局部压缩)；
3. G1虽然也是分代收集器，但整个内存分区不存在物理上的年轻代与老年代的区别，也不需要完全独立的survivor(to space)堆做复制准备。G1只有逻辑上的分代概念，或者说每个分区都可能随G1的运行在不同代之间前后切换；
4. G1的收集都是STW的，但年轻代和老年代的收集界限比较模糊，采用了混合(mixed)收集的方式。即每次收集既可能只收集年轻代分区(年轻代收集)，也可能在收集年轻代的同时，包含部分老年代分区(混合收集)，这样即使堆内存很大时，也可以限制收集范围，从而降低停顿。

另外，G1与其他收集器相比，具有如下特点：

1. 并行与并发
2. 分带收集
3. 空间整合：G1从整体来看是“标记-整理”算法实现的，因而不会产生内存碎片；
4. 可预测的停顿：G1跟踪各个Region的垃圾堆积的量，在后台维护一个优先列表，每次根据允许的收集时间，依次优先收集垃圾价值最大的Region来保证在有限的时间内可以获得尽可能的回收效率（这就是Garbage First名称的由来）。

在G1之前的垃圾收集器，将堆区主要划分了Eden区，Old区，Survivor区。其中对于Eden，Survivor对回收过程来说叫做“新生代垃圾收集”，并且新生代和老年代都分别是连续的内存空间(PS：在java 8中，持久代也移动到了普通的堆内存空间中，改为元空间)。 
取而代之的是，G1算法将堆划分为若干个区域（Region），它仍然属于分代收集器。不过，这些区域的一部分包含新生代，新生代的垃圾收集依然采用STW的方式，将存活对象拷贝到老年代或者Survivor空间；老年代也分成很多区域，G1收集器通过将对象从一个区域复制到另外一个区域，完成了清理工作。这就意味着，在正常的处理过程中，G1完成了堆的压缩（至少是部分堆的压缩），这样也就不会有cms内存碎片问题的存在了。


关于分区有几个重要的概念：

- 通过上图可以看出，分区可以有效利用内存空间，因为收集整体是使用“标记-整理”，Region之间基于“复制”算法，GC后会将存活对象复制到可用分区（未分配的分区），所以不会产生空间碎片。
- G1还是采用分代回收，但是不同的分代之间内存不一定是连续的，不同分代的Region的占用数也不一定是固定的（不建议通过相关选项显式设置新生代大小，会覆盖暂停时间目标），新生代的Eden，Survivor数量会随着每一次GC发生相应的改变。
- 分区是不固定属于哪个分代的，所以比如一次ygc过后，原来的Eden的分区就会变成空闲的可用分区，随后也可能被用作分配巨型对象，成为H区等。
- G1中的巨型对象是指，占用了Region容量的50%以上的一个对象。Humongous区，就专门用来存储巨型对象。如果一个H区装不下一个巨型对象，则会通过连续的若干H分区来存储。因为巨型对象的转移会影响GC效率，所以并发标记阶段发现巨型对象不再存活时，会将其直接回收。young gc也会在某些情况下对巨型对象进行回收。
- G1类似CMS，也会在比如一次full gc中基于堆尺寸的计算重新调整（增加）堆的空间。但是相较于执行full gc，G1 GC会在无法分配对象或者巨型对象无法获得连续分区来分配空间时，优先尝试扩展堆空间来获得更多的可用分区。原则上就是G1会计算执行GC的时间，并且极力减少花在GC上的时间（包括young gc，mix gc），如果可能，会通过不断扩展堆空间来满足对象分配、转移的需要。
- 因为G1提供了“可预测的暂停时间”，也是基于G1的启发式算法，所以G1会估算年轻代需要多少分区，以及还有多少分区要被回收。young gc触发的契机就是在Eden分区数量达到上限时。一次young gc会回收所有的Eden和survivor区，其中存活的对象会被转移到另一个新的survivor区或者old区。

**G1的内存数据模型**

TLAB(Thread Local Allocation Buffer)本地线程缓冲区：G1 会默认会启用TLAB优化。其作用就是在并发情况下，基于CAS的独享线程(mutator threads)可以优先将对象分配在一块内存区域（属于Java堆的Eden中)，只是因为是Java线程独享的内存区，没有锁竞争，所以分配速度更快，每个Tlab都是一个线程独享的。如果待分配的对象被判断是巨型对象，则不使用TLAB。

PLAB(Promotion Local Allocation Buffer) 晋升本地分配缓冲区：在young gc中，对象会将全部Eden区的对象转移（复制）到Survivor分区，也会存在Survivor区对象晋升（Promotion）到老年代。这个决定晋升的阀值可以通过MaxTenuringThreshold设定。晋升的过程无论是晋升到Survivor还是Old区，都是在GC线程的PLAB中进行。每个GC线程都有一个PLAB。

Collection Sets(CSets)待收集集合：GC中待回收的region的集合。CSet中可能存放着各个分代的Region。CSet中的存活对象会在gc中被移动（复制）。GC后CSet中的region会成为可用分区。

Remembered Sets(RSets)已记忆集合：RSet在每个分区中都存在，并且每个分区只有一个RSet。其中存储着其他分区中的对象对本分区对象的引用。young gc和mixed gc的时候，只要扫描RSet中的其他old区对象对于本young区的引用，不需要扫描所有old区，提高了GC效率。因为每次GC都会扫描所有young区对象，所以RSet只有在扫描old引用young，old引用old时会被使用。 
为了防止RSet溢出，对于一些比较“Hot”的RSet会通过存储粒度级别来控制。RSet有三种粒度，对于“Hot”的RSet在存储时，根据细粒度的存储阀值，可能会采取粗粒度。 

Card Table：老年代中有一块区域用来记录指向新生代的引用，如果引用的对象很多，赋值器需要对每个引用做处理，赋值器开销会很大，为了解决赋值器开销这个问题，在G1 中又引入了另外一个概念：卡表（Card Table）。一个Card Table将一个分区在逻辑上划分为固定大小的连续区域，每个区域称之为卡。卡通常较小，介于128到512字节之间。Card Table通常为字节数组，由Card的索引（即数组下标）来标识每个分区的空间地址。当一个地址空间被引用时，这个地址空间对应的数组索引的值被标记为”0″，即标记为脏被引用，此外RSet也将这个数组下标记录下来。一般情况下，这个RSet其实是一个Hash Table，Key是别的Region的起始地址，Value是一个集合，里面的元素是Card Table的Index。

**G1的三种收集模式**

1. Young GC年轻代收集
   Young GC主要是对Eden区进行GC，它在Eden空间耗尽时会被触发。在这种情况下，Eden空间的数据移动到Survivor空间中，如果Survivor空间不够，Eden空间的部分数据会直接晋升到年老代空间。Survivor区的数据移动到新的Survivor区中，也有部分数据晋升到老年代空间中。由于YoungGC会进行根扫描，所以会STW。最终Eden空间的数据为空，GC停止工作，应用线程继续执行。
   ![img](image/29bc101470e5827fe6f4dee588d54593201.jpg)
2. Mix GC混合收集
   MixedGC是G1 特有的，跟Full GC不同的是Mixed GC只回收部分老年代的Region。哪些old region能够放到CSet里面，有很多参数可以控制。比如G1HeapWastePercent参数，在一次young gc之后，可以允许的堆垃圾百占比，超过这个值就会触发mixed GC。Mixed GC一般会发生在一次Young GC后面。为了提高效率，Mixed GC会复用Young GC的全局的根扫描结果，因为STW过程是必须的，整体上来说缩短了暂停时间。
3. FullGC
   G1在对象复制/转移失败或者没法分配足够内存（比如巨型对象没有足够的连续分区分配）时，会触发FullGC。FullGC使用的是STW的单线程的Serial Old模式，所以一旦触发Full GC则会STW应用线程，并且执行效率很慢。由于G1的应用场合往往堆内存都比较大，所以Full GC的收集代价非常昂贵，应该避免Full GC的发生。

总体来讲，如果不计算维护Remember Set的操作，G1的运作可划分为以下几个步骤：

- 初始标记
- 并发标记
- 最终标记
- 筛选回收：根据允许的收集时间，回收垃圾价值最大的Region来保证在有限的时间内可以获得尽可能的回收效率。
  ![img](image/7c72471ec9cbdbf67bd18afbd3223bc29ba.jpg)

G1是一款非常优秀的垃圾收集器，不仅适合堆内存大的应用，同时也简化了调优的工作。通过主要的参数初始和最大堆空间、以及最大容忍的GC暂停目标，就能得到不错的性能；同时，我们也看到G1对内存空间的浪费较高，但通过“Garbage First“这个设计原则，可以及时发现过期对象，从而让内存占用处于合理的水平。



#### 垃圾收集器比较

| 垃圾收集器            | 算法            | 方式 | 堆区域   | 机制                 | 特点                                                         |
| --------------------- | --------------- | ---- | -------- | -------------------- | ------------------------------------------------------------ |
| **Serial**            | 复制            | 串行 | 新生代   | Stop-the-World       | Client模式下的默认新生代收集器，单CPU机器效率高              |
| **ParNew**            | 复制            | 并行 | 新生代   | Stop-the-World       | Serial收集器的多线程版本；Server模式下的首选新生代收集器；能与CMS收集器配合工作 |
| **Parallel Scavenge** | 复制            | 并行 | 新生代   | 吞吐量优先           | 吞吐量优先                                                   |
| **Serial Old**        | 标记-整理       | 串行 | 老年代   | Stop-the-World       | Client模式下的默认新生代收集器，单CPU机器效率高              |
| **Parallel Old**      | 标记-整理       | 并行 | 老年代   | Stop-the-World       | Parallel Scavenge收集器的老年代版本， 注重吞吐量以及CPU资源敏感的场合， 可以优先考虑Parallel Scavenge加Parallel Old收集器一起配合使用 |
| **CMS**               | 标记-清除       | 并行 | 老年代   | Stop-the-World，并发 | 获取最短停顿时间为目标的老年代收集器；CPU资源非常敏感； 无法处理浮动垃圾；产生大量内存碎片 |
| **G1**                | 标记-整理；复制 | 并行 | 整个堆区 | Stop-the-World，并发 | 不存在严格的Eden区，Old区，Survivor区，取而代之的是区域（Region）； 可预测的停顿；不会有内存碎片； |

 



#### 几个重要的概念



##### 对象提升规则

- 对象优先分配在Eden区，Eden区满时进行一次Minor GC；
- 长期存活的对象进入老年代。对象进行一次MinorGC后进入到Survior区，之后每进行一次MinorGC对象年龄加1。对于大于阈值的对象进入到老年代，Threshold默认值为15；
- 对象年龄动态判断。Survior区中相同年龄的对象大小的总和大于Survior大小的一半时，大于等于该年龄的对象进入到老年代。



##### Full GC 触发条件

- 老年代空间不足；
- 永久代空间满OOM：PermGen Space（Java8 之前）；
- 统计到升到老年代的对象的大小大大于老年代剩余的空间大小；
- CMS GC时出现Promotion Faield和Concurrent Model Failure；
- G1 GC对象复制/转移失败或者没法分配足够内存（比如巨型对象没有足够的连续分区分配）时。



## 多线程与高并发

### 线程池

![1570864427203](image/1570864427203.png)



**纤程**:是运行在用户态的多线程

![1565276875132](image/1565276875132.png)

![1565537953153](image/1565537953153.png)

![1565538024945](image/1565538024945.png)

08中断:软中断,系统调整到内核态

![1565538110508](image/1565538110508.png)

wait/notify 线程同步

![1565339964961](image/1565339964961.png)

![1565600430104](image/1565600430104.png)

![1565601310777](image/1565601310777.png)

**服务器的瓶颈**:  连接池，是socketIO这块的，线程池，是评估你业务代码这块的，如果频繁调用外部资源，有阻塞，就把线程池开大点，如果业务代码比较精炼，local的，就开小点，核心数量，网卡吞吐，内存大小，这些不同，代表这台服务器的瓶颈水平不同

* 计算机的规划者，很多点做决策，如果2个cpu，如果2线程，但是线程中的代码不能避免阻塞，就多抛出线程，要进行评估，切换的损耗，小于阻塞的浪费
* 线程不能太多，如果太多，一定是权衡了有阻塞代价大于切换代价



### 2019-09-22马士兵架构课

![1569111998203](image/1569111998203.png)



![1569638557019](image/1569638557019.png)



### UnSafe

#### 主要功能

Unsafe的功能如下图：



![img](image/11963487-607a966eba2eed13.png)



## JAVA SE

![1566043803003](image/1566043803003.png)

![1566376063843](image/1566376063843.png)

![1566377565598](image/1566377565598.png)

![1569056410241](image/1569056410241.png)

![1569056546112](image/1569056546112.png)

## Java 引用类型

* 强引用

* 软引用

当内存溢出时垃圾回收软引用对象（非必要对象）。使用与缓存

![1567522394572](image/1567522394572.png)

![1567522681234](image/1567522681234.png)

* 弱引用

只剩弱引用就回收

其中的部分强引用干掉的时候，软引用ThreadLocal的key遇到gc时编程null，value就会出现溢出。

![1567523097134](image/1567523097134.png)

![1567524341105](image/1567524341105.png)

![1567523250996](image/1567523250996.png)

* 虚引用

跟踪GC

![1567524517891](image/1567524517891.png)

![1567524662790](image/1567524662790.png)

![1567524790710](image/1567524790710.png)



## 安装JAVA

### 安装Open-JDK

```shell
#查看Linux中安装的jdk
yum list installed |grep java

yum -y list java*  #列出yum相关的java的rpm
yum -y remove 
```



# Docker

## Centos7 安装Docker

```shell
#安装yum工具类(简化安装docker时设置安装源配置过程)和数据存储的驱动包(docker内部容器要进行存储数据的时候,通过device-mapper-persistent-data |vm2 这两个包进行数据存储)
yum install -y yum-utils device-mapper-persistent-data lvm2

#上面安装的yum-utils后使用的命令,设置修改yum的安装源,--add-repo设置新的yum安装源
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

#自动检测那个安装源速度是最快的
yum makecache fast
#查看Docker版本：
yum list docker-ce --showduplicates
#马士兵教育视频安装的离线版本是3:18.09.5-3.el7
#安装开源社区版本Docker
yum install -y docker-ce

#安装较旧版本（比如Docker 17.03.2) 时需要指定完整的rpm包的包名，并且加上--setopt=obsoletes=0 参数：
# Install docker
# on a new system with yum repo defined, forcing older version and ignoring obsoletes introduced by 17.06.0
yum install -y --setopt=obsoletes=0 \
   docker-ce-3:18.09.5-3.el7.x86_64 \
   docker-ce-selinux-3:18.09.5-3.el7.noarch


# Start docker service
systemctl enable docker
systemctl start docker

#创建Dockerfile
[root@pinyoyougou-docker docker_run]# vi Dockerfile

FROM centos
RUN ["echo","image running!!!"]
CMD ["echo","container starting.."]

docker build -t zhenksoft.com/docker_run .

```

![1577297078865](image/1577297078865.png)

## 开启远程访问API

###  在远程机Docker配置

```shell
vim /usr/lib/systemd/system/docker.service
## 在ExecStart=/usr/bin/dockerd-current 后面加上
-H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock \
## 重新加载配置文件和启动：
systemctl daemon-reload
systemctl start docker
```

```shell
##  查看进程
yum install net-tools
netstat -tulp

##  防火墙开放2375端口号
firewall-cmd --zone=public --add-port=2375/tcp --permanent
##  重启防火墙
firewall-cmd --reload

##  访问另一台docker的守护进程
curl http://192.168.10.140:2375/info

docker -H tcp://192.168.10.140:2375 info

##  使用Docker客户端命令选项
-H tcp://host:port
   unix:///path/to/socket
   fd://* or fd://socketfd
## 客户端默认配置:
-H unix://var/run/docker.sock
```

![img](image/1353814-20180816164759441-1222583147.png)

### 配置项目中pom.xml

```xml
<build>
    <finalName>${project.artifactId}</finalName>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <fork>true</fork>
            </configuration>
        </plugin>
        <!-- 跳过单元测试 -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <configuration>
                <skipTests>true</skipTests>
            </configuration>
        </plugin>
        <!--使用docker-maven-plugin插件-->
        <plugin>
            <groupId>com.spotify</groupId>
            <artifactId>docker-maven-plugin</artifactId>
            <version>1.0.0</version>
            <!--将插件绑定在某个phase执行-->
            <executions>
                <execution>
                    <id>build-image</id>
                    <!--用户只需执行mvn package ，就会自动执行mvn docker:build-->
                    <phase>package</phase>
                    <goals>
                        <goal>build</goal>
                    </goals>
                </execution>
            </executions>
            <configuration>
                <!--指定生成的镜像名-->
                <imageName>fred/${project.artifactId}</imageName>
                <!--指定标签-->
                <imageTags>
                    <imageTag>latest</imageTag>
                </imageTags>
                <!-- 指定 Dockerfile 路径-->
                <dockerDirectory>${project.basedir}</dockerDirectory>
                <!--指定远程 docker api地址-->
                <dockerHost>http://192.168.10.140:2375</dockerHost>
                <!-- 这里是复制 jar 包到 docker 容器指定目录配置 -->
                <resources>
                    <resource>
                        <targetPath>/</targetPath>
                        <!--jar 包所在的路径  此处配置的 即对应 target 目录-->
                        <directory>${project.build.directory}</directory>
                        <!-- 需要包含的 jar包 ，这里对应的是 Dockerfile中添加的文件名　-->
                        <include>${project.build.finalName}.jar</include>
                    </resource>
                </resources>
            </configuration>
        </plugin>
    </plugins>
</build>
```

### 在根目录下编写Dockerfile

```dockerfile
# FROM指定使用哪个镜像作为基准
FROM openjdk:8-jdk-alpine
# VOLUME为挂载路径  -v
VOLUME /tmp
# ADD为复制文件到镜像中
ADD springboot-docker.jar app.jar
# RUN为初始化时运行的命令  touch更新app.jar
RUN sh -c 'touch /app.jar'
# ENV为设置环境变量
ENV JAVA_OPTS=""
# ENTRYPOINT为启动时运行的命令
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]
```

### 点击maven的package进行构建

![img](image/1160339-20190121163555728-2111745716.png)





## Docker安装Shadowsocks

docker 启动容器报错：Error response from daemon: oci runtime error: container_linux.go:247: starting container process caused "write parent: broken pipe"

其实原因还是，linux与docker版本的兼容性问题

第一步：通过**uname -r**命令查看你当前的内核版本

```powershell
uname -r
```

第二步：使用 `root` 权限登录 Centos。确保 yum 包更新到最新。

```powershell
sudo yum update
```

第三步：卸载旧版本(如果安装过旧版本的话)

```shell
sudo yum remove docker  docker-common docker-selinux dockesr-engine
```

第四步：安装需要的软件包， yum-util 提供yum-config-manager功能，另外两个是devicemapper驱动依赖的

```shell
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

第五步：设置yum源

```shell
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

第六步：可以查看所有仓库中所有docker版本，并选择特定版本安装

```shell
yum list docker-ce --showduplicates | sort -r
```

第七步：安装docker

```shell
sudo yum install docker-ce
```

第八步：启动并加入开机启动

```shell
sudo systemctl start docker
sudo systemctl enable docker
```

第九步：验证安装是否成功(有client和service两部分表示docker安装启动都成功了)

```shell
 docker version
```

```shell
docker pull oddrationale/docker-shadowsocks

docker run -d -p 1984:1984 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 1984 -k paaassswwword -m aes-256-cfb

```



## 常用命令

```shell
#-d表示非阻塞运行tomcat,-p表示宿主机和容器之间通信时端口映射
docker run -p 8000:8080 -d tomcat

#强制删除 -f
docker rm -f 容器id
docker rmi 镜像id

#在容器中执行命令,exec在对应容器中执行命令,-it采用交互式执行命令
docker exec [-it] 容器id 命令

# 暂停容器/重启容器
docker pause|unpause 容器id

#使用阿里镜像加速器
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://20uq8p52.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker


#自动创建不存在的目录,尽量使用绝对路径
WORKDIR /usr/local/newdir 

#ADD除了复制,还具备添加远程文件功能
#复制到跟路径
ADD hello /
#复制到跟路径并解压
ADD test.tar.gz /

#ENV 设置环境常量
ENV JAVA_HOME /usr/local/openjdk8
RUN ${JAVA_HOME}/bin/java -jar test.jar


[root@pinyoyougou-docker docker_run]# cat Dockerfile 
FROM centos
MAINTAINER zhenksoft.com
LABEL version="1.0"
LABEL descirption = "真壳管理软件"
RUN ["echo","image running!!!"]
CMD ["echo","container starting.."]

#创建镜像并运行
docker build -t zhenksof/docker_run .

#运行镜像,ls会替换RUN中的exec命令
docker run -t zhenksoft.com/docker_run ls


```



### Dockerfile语法

```shell
[root@pinyoyougou-docker docker_run]# cat Dockerfile 
FROM centos
MAINTAINER zhenksoft.com
LABEL version="1.0"
LABEL descirption = "真壳管理软件"
RUN ["echo","image running!!!"]
CMD ["echo","container starting.."]


#自动创建不存在的目录,尽量使用绝对路径
WORKDIR /usr/local/newdir 

#ADD除了复制,还具备添加远程文件功能
#复制到跟路径
ADD hello /
#复制到跟路径并解压
ADD test.tar.gz /

#ENV 设置环境常量
ENV JAVA_HOME /usr/local/openjdk8
RUN ${JAVA_HOME}/bin/java -jar test.jar
```

### Docker命令

```shell
#docker命令后面的参数
-i 保持stdin打开
-t 分配一个伪终端(tty)
-d 后台运行
-w 容器内的工作目录
/bin/bash 运行容器中的 /bin/bash 脚本
```



## 构建Redis镜像

```shell
#vi Dockerfile
FROM centos
RUN ["yum" , "install" , "-y" , "gcc" , "gcc-c++" , "net-tools" , "make"]
WORKDIIR /usr/local
ADD redis-4.0.14.tar.gz .
WORKDIR /usr/local/redis-4.0.14/scr
RUN make && make install
WORKDIR /usr/local/redis-4.0.14
ADD redis-7000.conf .
#对外开放端口为7000
EXPOSE 7000
CMD ["redis-server","redis-7000.conf"]

#镜像构建
docker build -t zhenksoft.com/docker-redis
#进入docker路径
docker exec -it 镜像id /bin/bash

```



## 单向双向通信和共享数据

> 1. 单向通信:在run创建运行时加上**--link** 指向另一个容器名(不是容器id),就可以在此容器内命令中ping 另一容器名
>
> 2. 双向通信:创建网桥,容器都往此网桥进行绑定 docker network connect my-bridge 容器名
>
> 3. 共享数据:在宿主机中开辟一个空间来创建一个数据卷**volume**,各个容器的数据都存在宿主机中的volume容器,数据卷中的数据都被其他容器进行共享数据
>
>    ①通过设置**-v**挂载宿主机目录
>
>    ②docker create创建共享容器,create只创建容器没有执行和启动容器,然后

```shell
#--link database表示在tomcat容器内部ping database
#--link命令可以进行容器单向通信
docker run -d --name web --link database tomcat
#centos在创建的时候会自动退出容器,需保持在容器内部和在/bin/bash路径下,加上-it和 /bin/bash
#-d表示后台运行容器
docker run -d --name database -it centos /bin/bash

#可查看容器内部配置信息中查看NetworkSettings中的分配的IPAddress的ip
docker inspect 容器id

#查看docker网卡列表
docker network ls
#创建自己的网桥
docker network create -d bridge my-bridge
#n创建的网桥绑定容器
docker network connect my-bridge web
docker network connect my-bridge database

#创建一个数据卷,通过这个宿主机路径写错了就可能挂载失败
docker run --name 容器名 -v 宿主机路径:容器内挂载路径 镜像名
docker run --name t1 -p 8000:8080 -t -d 

#/bin/true中true只是表示一个占位符
docker create --name webpage -v /opt/study/www/:/usr/local/tomcat/webapps tomcat /bin/true
docker run -p 8002:8080 --volumes-from webpage --name t3 -d tomcat
```



![1577263799780](image/1577263799780.png)

![1577263830149](image/1577263830149.png)



## 阿里镜像加速器

```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://20uq8p52.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```



# k8s

```shell
#启动节点的k8s服务
systemctl start kubelet
#开机自启
systemctl enable kubelet

#通过命令行工具kubectl 获取异常容器
kubectl get pods -n kube-system | grep -v Running
#查找pod问题
kubectl describe pod prometheus-tim-3864503240-rwpq5 -n kube-system 
#查看异常日志
kubectl logs prometheus-tim-3864503240-rwpq5 -n kube-system 
#删除掉异常pod
kubectl delete pod prometheus-tim-3864503240-rwpq5 -n kube-system

#查看创建的服务
kubectl get pods
#查看pods明细
kubectl describe pod pod名
kubectl describe service service名

#查看pod应用日志[前一个应用]
kubectl logs pod名 [--previous]
kubectl create -f 部署yml文件 #创建部署,并不确定pod内部容器已创建成功
kubectl get deployment #查看所有的部署
kubectl delete deployment 部署的应用名 #删除部署,pod也删除掉了,容器也删除掉
kubectl apply -f 部署yml文件 #更新部署配置
kubectl get pod[-o wide] #查看已部署pod
kubectl describe pod pod名称 # 查看Pod详细信息
kubectl logs [-f] pod名称 [--previous] # 查看pod[实时更新]输出日志[前一个pod]



#重新加载pod
kubectl get pod beiqin-app-deploy-596fd7c4dd-gfdqs -n default -o yaml | kubectl replace --force -f -
```

## 常用命令

```shell
kubectl get pod -o wide|yaml
kubectl delete pod pod名
```



## pod

> pod应用



## yml配置文件管理资源

tomcat-deploy.yml

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata: 
  name: tomcat-deploy
spec:
  replicas: 2 
  template: 
    metadata:
      labels:
        app: tomcat-cluster
    spec:
    #挂载卷
      volumes: 
      - name: web-app
      #设置宿主机原始目录
        hostPath:
          path: /mnt
      containers:
      - name: tomcat-cluster
        image: tomcat:latest
        resources:
          requests:
            cpu: 0.5
            memory: 200Mi
          limits:
            cpu: 1
            memory: 512Mi
        ports:
        - containerPort: 8080
        #挂载点(镜像中路径)
        volumeMounts:
        - name: web-app
          mountPath: /usr/local/tomcat/webapps
```



## service服务用于对外暴露应用

![1577350062476](image/1577350062476.png)

> service也是一个pod,也有自己虚拟的ip,相当于在k8s内置一个负载均衡器,可以设置对外暴露宿主机的端口
>
> 配置文件如下:
>
> 注释掉NodePort

```shell
apiVersion: v1
kind: Service
metadata:
  name: tomcat-service
  labels:
    app: tomcat-service
spec:
#  type: NodePort
  selector:
    app: tomcat-cluster
  ports:
  - port: 8000
    targetPort: 8080
#    nodePort: 32500
```

## Rinted

> **使用Rinted对外提供service负载均衡**





## 基于NFS服务实现集群文件共享

### 搭建NFS服务

```shell
#在master安装
[root@szy-k8s-master /]# yum install -y nfs-utils rpcbind
#在每个node安装
[root@szy-k8s-node1 /]# yum install -y nfs-utils

#NFS服务的配置文件  /etc/exports。 这个文件可能不会存在，需要新建
[root@szy-k8s-master /]# cat /etc/exports
/nfs/prometheus/data/ 10.10.31.0/24(rw,no_root_squash,no_all_squash,sync)
#exports中的配置的内容，需要创建下/nfs/prometheus/data/
[root@szy-k8s-master /]# mkdir -p  /nfs/prometheus/data/
#修改权限
[root@szy-k8s-master /]# chmod -R 777 /nfs/prometheus/data/
#验证配置的/nfs/prometheus/data/是否正确
[root@szy-k8s-master /]# exportfs -r
#重载/etc/exports配置文件
[root@szy-k8s-master /]# exportfs -arv
```

> 10.10.31.0/24：这个是运行访问NFS的IP范围，也就是10.10.31开头的IP，24是掩码长度。 根据自己的k8s主机网段设置。
> (rw,no_root_squash,no_all_squash,sync)：
> 可以设定的参数主要有以下这些：
>
> rw：可读写的权限；
> ro：只读的权限；
> no_root_squash：登入到NFS主机的用户如果是root，该用户即拥有root权限；
> root_squash：登入NFS主机的用户如果是root，该用户权限将被限定为匿名使用者nobody；
> all_squash：不管登陆NFS主机的用户是何权限都会被重新设定为匿名使用者nobody。
> anonuid：将登入NFS主机的用户都设定成指定的user id，此ID必须存在于/etc/passwd中。
> anongid：同anonuid，但是变成group ID就是了！
> sync：资料同步写入存储器中。
> async：资料会先暂时存放在内存中，不会直接写入硬盘。
> insecure：允许从这台机器过来的非授权访问。



### 启动服务

```shell
#启动服务：
[root@szy-k8s-master /]# systemctl start rpcbind
[root@szy-k8s-master /]# systemctl start nfs.service
[root@szy-k8s-master /]# systemctl status rpcbind

#在node节点上启动服务
[root@node01 mnt]# systemctl start rpcbind
[root@node01 mnt]# systemctl start nfs.service
[root@node01 mnt]# systemctl enable nfs.service
Created symlink from /etc/systemd/system/multi-user.target.wants/nfs-server.service to /usr/lib/systemd/system/nfs-server.service.
[root@node01 mnt]# systemctl enable rpcbind

mount 192.168.10.200:/usr/local/beiqin/sql /usr/local/beiqin-sql

```

node节点上挂载目录

```shell
#在node节点上挂载目录

```



# 设计模式

## pipeline（管道）设计模式

![img](image/20140414084255859.jpg)





# 数据结构与算法

![1563191791900](image/1563191791900.png)

![1563191816894](image/1563191816894.png)



## MySQL数据结构

![1565957208080](image/1565957208080.png)

![1567497212713](image/1567497212713.png)

![1567499560565](image/1567499560565.png)

# 面试

![1565537569843](image/1565537569843.png)

![面试题01](/image/面试题01.png)

![面试题02](/image/面试题02.png)



------

# 马士兵VIP课堂笔记

## 架构师

### Spring源码解析

#### Spring原理

![img](image/20190530152219673.png)[图上链接](<https://img-blog.csdnimg.cn/20190530152219673.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3NsZzE5ODg=,size_16,color_FFFFFF,t_70>)

![Spring原理图](image/spring-overview.png "Spring原理图")

![1563673122032](image/1563673122032.png)

![1570931572010](image/1570931572010.png)

![1570931610773](image/1570931610773.png)

接口继承:

Spring和SpringMvc的bean容器:父子容器.

1. controller注入到springmvc容器中;dao,service注入到spring容器中

```java
int a=1;
int *b=&a;//获取a的地址符
```

![1564799747172](image/1564799747172.png)

![1564800748988](image/1564800748988.png)



2. 父容器不能访问子容器中的bean

因为子容器有的没有父容器对子容器的引用。



classpath*:可以加载jar类文件

classpath:

![1565402390654](image/1565402390654.png)



addShutdown



Spring的所有生命周期

![1565405683008](image/1565405683008.png)

![1566696727437](image/1566696727437.png)

![1566696830824](image/1566696830824.png)

**ResourceLoader**:提供默认实现类

![1567857467748](image/1567857467748.png)

![1567857570627](image/1567857570627.png)

![1567857521180](image/1567857521180.png)



![1567819670715](image/1567819670715.png)

链表转换成红黑树:

------

### Nginx

------

#### Nginx安装步骤

##### 系统环境要求

安装系统相关依赖组件: ``yum install gcc openssl-devel pcre-devel zlib-devel``

安装软件目录:``/usr/local/tengine``

因为在``/etc/init.d/nginx``脚本文件有相关安装Nginx软件的目录配置

##### 编译安装

```shell
./ configure --prefix=/安装路径

make && make install
```

##### 脚本启动 

```shell
vi /etc/init.d/nginx
chmod 777 nginx
```



``/etc/init.d/nginx``脚本文件如下:

```shell
#!/bin/sh
#
# nginx - this script starts and stops the nginx daemon
#
# chkconfig:   - 85 15 
# description:  Nginx is an HTTP(S) server, HTTP(S) reverse /
#               proxy and IMAP/POP3 proxy server
# processname: nginx
# config:      /etc/nginx/nginx.conf
# config:      /etc/sysconfig/nginx
# pidfile:     /var/run/nginx.pid
 
# Source function library.
. /etc/rc.d/init.d/functions
 
# Source networking configuration.
. /etc/sysconfig/network
 
# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0
 
nginx="/usr/local/tengine/sbin/nginx"
prog=$(basename $nginx)
 
NGINX_CONF_FILE="/usr/local/tengine/conf/nginx.conf"
 
[ -f /etc/sysconfig/nginx ] && . /etc/sysconfig/nginx
 
lockfile=/var/lock/subsys/nginx
 
make_dirs() {
   # make required directories
   user=`nginx -V 2>&1 | grep "configure arguments:" | sed 's/[^*]*--user=/([^ ]*/).*//1/g' -`
   options=`$nginx -V 2>&1 | grep 'configure arguments:'`
   for opt in $options; do
       if [ `echo $opt | grep '.*-temp-path'` ]; then
           value=`echo $opt | cut -d "=" -f 2`
           if [ ! -d "$value" ]; then
               # echo "creating" $value
               mkdir -p $value && chown -R $user $value
           fi
       fi
   done
}
 
start() {
    [ -x $nginx ] || exit 5
    [ -f $NGINX_CONF_FILE ] || exit 6
    make_dirs
    echo -n $"Starting $prog: "
    daemon $nginx -c $NGINX_CONF_FILE
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}
 
stop() {
    echo -n $"Stopping $prog: "
    killproc $prog -QUIT
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}
 
restart() {
    configtest || return $?
    stop
    sleep 1
    start
}
 
reload() {
    configtest || return $?
    echo -n $"Reloading $prog: "
    killproc $nginx -HUP
    RETVAL=$?
    echo
}
 
force_reload() {
    restart
}
 
configtest() {
  $nginx -t -c $NGINX_CONF_FILE
}
 
rh_status() {
    status $prog
}
 
rh_status_q() {
    rh_status >/dev/null 2>&1
}
 
case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart|configtest)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
            ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
        exit 2
esac

```

##### 相关Nginx脚本操作命令

``service Nginx start``  启动服务

``service Nginx stop`` 停止

``service Nginx status`` 状态

``service Nginx reload`` 动态重载配置文件



##### 常用错误

1. 安装nginx，修改完配置文件后，使用 ``sudo nginx -s reload``重新启动nginx时，报**[error] invalid PID number "" in "/usr/local/var/run/nginx/nginx.pid**错误

发生这个错误的原因是，nginx读取配置文件时出错，需要指定一个特定的nginx配置文件，所以解决这个问题需要先执行

```shell
sudo nginx -c /usr/local/etc/nginx/nginx.conf
```

然后执行 

```shell
sudo nginx -s reload
```



#### NGINX

##### location

```shell
location /baidu {
   ##进行跳转,当后面的网站没有加入https时,URL地址不会改变,但访问的内容是跳转后的页面,静态页面不能
    proxy_pass https://baidu.com/;
}
```

##### [如何给网站添加SSL证书（免费）](https://www.cnblogs.com/eternalness/p/8321827.html)



上篇讲了如何将网站部署到服务器上，这篇就讲如何给网站添加SSL证书。

1.先到腾讯云ssl证书认证那里申请一个证书

 ![img](image/1165093-20180120201822178-54481069.png)

![img](image/1165093-20180120201903443-934147116.png)

![img](image/1165093-20180120201922178-1378246207.png)

2.DNS认证

 ![img](image/1165093-20180120201931271-1180068479.png)

 ![img](image/1165093-20180120201949974-597867666.png)

3.下载解压nginx里面的文件

 ![img](image/1165093-20180120201959803-2085731871.png)

 ![img](image/1165093-20180120202005396-127449608.png)

\4. 在服务器上/www目录下创建文件夹ssl，将解压的文件上传到ssl

 ![img](image/1165093-20180120202014318-810502637.png)

5.进入cd /etc/nginx/conf.d/下面修改网站的.conf后缀名文件

![img](image/1165093-20180120202034896-1506011481.png)

 ![img](image/1165093-20180120202023849-1594600624.png)

6.检查文件是否成功和重启

 ![img](image/1165093-20180120202051303-1473220222.png)

7.认证成功

![img](image/1165093-20180120202106724-446949767.png)

结语：过程总是遇到很多问题，不过一步步来还是能够解决的。

```
Node+mongodb线上部署到阿里云
```

### FastDFS

### TCP/IP

![1563799221364](image/1563799221364.png)

![1563799287591](image/1563799287591.png)

exed 8<$

![1563799743355](image/1563799743355.png)

``arp -an``   IP地址和网卡地址映射,链路层

路由表中写路由条目

![1563804596370](image/1563804596370.png)



![1563971494330](image/1563971494330.png)

route add -host 192.168.88.88 gw 192.168.150.13

- TCP建立在会送确认号。。所以不会丢

![1563976957781](image/1563976957781.png)

- 隐藏VIP,对外隐藏,对内可见:经过负载均衡器中添加链路层中目标服务器的mac地址.

![1563976804114](image/1563976804114.png)



- DNAT 方式RIP机器为啥不直接修改source IP 为VIP然后直接返回给CIP，这样CIP不是也是认为是VIP发的，也不用经过VIP过一遍了

![1564144891733](image/1564144891733.png)



- node01 :lvs

  ``ifconfig eth0:2 down``

  修改协议

  ![1564148908980](image/1564148908980.png)

  ![1564148995778](image/1564148995778.png)

- 虚拟网卡和物理网卡,虚拟网卡较近

- 

  ![1564149246936](image/1564149246936.png)

- ``ipvsadm -lnc``



### DNS

|DNS名称|DNS地址|DNS类型|
|-------|-----|-------|
|**Public DNS+**(腾讯云)|首选：119.29.29.29|IPv4 地址|
|**AliDNS 阿里公共 DNS**|首选：223.5.5.5<br/>备用：223.6.6.6|IPv4 地址|
|**114 DNS**|常规公共 DNS (干净无劫持)<br/>首选：114.114.114.114 、备选：114.114.115.115
拦截钓鱼病毒木马网站 (保护上网安全)
首选：114.114.114.119、备用：114.114.115.119
拦截色情网站 (保护儿童)
首选：114.114.114.110、备用：114.114.115.110|IPv4 地址|
|**百度 BaiduDNS**|180.76.76.76<br/>2400:da00::6666|IPv4 地址<br/>IPv6 地址|
|**Google Public DNS**|首选：8.8.8.8<br/>备用：8.8.4.4<br/><br />首选：2001:4860:4860::8888<br/>备用：2001:4860:4860::8844|IPv4 地址<br/>IPv6 地址|
|**浙能 DNS**|首选：10.165.25.142<br/>备选：10.165.25.143|IPv4 地址|
|**Cloudflare与APNIC DNS**|1.1.1.1<br />1.0.0.1||





### LVS

#### [相关网上资料](https://www.sundayle.com/lvs/)



#### node01上vip为什么要重新开一个接口ip做vip呢？直接用eth0那个网卡的ip不行吗？

node01上的两个IP干的事情不一样。eth0的ip是DIP，和RIP通信，不能作为VIP，你想如果node01上只有eth0的ip，那么会有一个现象，node01用arp请求node02
的RIP的mac地址的时候，源地址是eth0的ip，如果这个ip还是vip，那么node02是不是也隐藏了这个ip，那么就不能给node01返回 了

换成我们的案例，，，，node01只有150.11  是DIP，同时又是VIP，那么node02的lo:3 上面配置的也是150.11.。。。那么node01如果和node02通信，数据包就是有去无回了。。。



dip是在vip的包上套了一层改变Mac地址通过吓一跳发给了rip然后rip发现里面有vip就给自己隐藏的vip处理了，然后vip抛给上层的软服务处理



#### LVS-DR之VIP、DIP跨网段实例



#### Keepalived

![1564404501733](image/1564404501733.png)



```conf
! Configuration File for keepalived

global_defs {
   notification_email {
     acassen@firewall.loc
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   notification_email_from Alexandre.Cassen@firewall.loc
   smtp_server 192.168.200.1
   smtp_connect_timeout 30
   router_id LVS_DEVEL
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.10.200/24 dev eth0 label eth0:2
    }
}

virtual_server 192.168.10.200 80 {
    delay_loop 6
    lb_algo rr
    lb_kind DR
    nat_mask 255.255.255.0
    persistence_timeout 0
    protocol TCP

    real_server 192.168.10.134 80 {
        weight 1
        HTTP_GET {
            url {
              path /
              status_code 200
            }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
    }
    real_server 192.168.10.135 80 {
        weight 1
        HTTP_GET {
            url {
              path /
              status_code 200
            }
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
        }
    }
}
```



### AKF扩展立方体

> **AKF扩展立方体（Scalability Cube）**，是《架构即未来》一书中提出的可扩展模型，这个立方体有三个轴线，每个轴线描述扩展性的一个维度，他们分别是产品、流程和团队：
>
> X轴 —— 代表无差别的克隆服务和数据，工作可以很均匀的分散在不同的服务实例上；<复制,负载均衡>
>
> * 数据复制是指在数据存储层进行绝对平等地数据迁移，用于解决存储层I/O瓶颈以及可用性上的问题。由于存在多个复制品存储，为了使得每个复制品提供无差异的数据服务，我们需要在复制品之间同步或异步地复制数据。数据复制的方式包括了主从同步（常见的读/写分离），双主同步等。因为数据存储天生就是有状态的，数据复制的难点在于 **一致性** 的保证上，为了一致性的保证，从而也衍生了很多复杂的技术，比如**Paxos选举算法**等。
>
> * 负载均衡就是将用户的访问请求通过负载均衡器，均衡分配到由各个“复制品”组成的集群中去。当某个复制品出现故障，也能轻易地将相应“工作”转移给其它的复制品来“代为完成”。这中间涉及到的工程技术点包括了反向代理，DNS轮询，哈希负载均衡算法（一致性哈希），动态节点负载均衡（如按CPU，I/O）等。它的难点在于要求集群中的“复制品”是不共享任何内容，也就是我们常说的 **无状态** 。
>
> Y轴 —— 关注应用中职责的划分，比如数据类型，交易执行类型的划分；
>
> Z轴 —— 关注服务和数据的优先级划分，如分地域划分。



![img](https:////upload-images.jianshu.io/upload_images/1915385-a362576e9107479e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/682/format/webp)

​                                                         AKF扩展立方体

![1566390383281](image/1566390383281.png)

**1. 为扩展分割应用**

X轴：从单体系统或服务，水平克隆出许多系统，通过负载均衡平均分配请求；

Y轴 ：面向服务分割，基于功能或者服务分割，例如电商网站可以将登陆、搜索、下单等服务进行Y轴的拆分，每一组服务再进行X轴的扩展；

Z轴 ：面向查找分割，基于用户、请求或者数据分割，例如可以将不同产品的SKU分到不同的搜索服务，可以将用户哈希到不同的服务等。

**2. 为扩展分割数据库** 

X轴：从单库，水平克隆为多个库上读，一个库写，通过数据库的自我复制实现，要允许一定的读写时延；

Y轴 ：根据不同的信息类型，分割为不同的数据库，即分库，例如产品库，用户库等；

Z轴 ：按照一定算法，进行分片，例如将搜索按照MapReduce的原理进行分片，把SKU的数据按照不同的哈希值进行分片存储，每个分片再进行X轴冗余。

**3. 为扩展而缓存**

在理想情况下，处理大流量最好的方法是通过高速缓存来避免处理它。从架构层面看，我们能控制的主要有以下三个层次的缓存：

对象缓存：对象缓存用来存储应用的对象以供重复使用，一般在系统内部，通过使用应用缓存可以帮助数据库和应用层卸载负载。

应用缓存：应用缓存包括代理缓存和反向代理缓存，一个在用户端，一个在服务端，目标是提高性能或减少资源的使用量。

内容交付网络缓存：CDN的总原则是将内容推送到尽可能接近用户终端的地方，通过不同地区使用不同ISP的网关缓存，达到更快的响应时间和对源服务的更少请求。

**4. 位扩展而异步**

同步改异步：同步调用，由于调用间的同步依赖关系，有可能会导致雪崩效应，出现一系列的连锁故障，进而导致整个系统出现问题，所以在进行系统设计时，要尽可能的考虑异步调用方式，邮件系统就是一个非常好的异步调用例子。

应用无状态：当进行AKF扩展立方体的任何一个轴上的扩展时，都要首先解决应用的状态问题，即会话的管理，可以通过避免、集中和分散的方式进行解决。



![1566393645923](image/1566393645923.png)



### 服务网格(Service Mash)

通信中心

### [网络IO和磁盘IO详解](https://www.cnblogs.com/sunsky303/p/8962628.html)

### Redis

![1566823367638](image/1566823367638.png)

二进制 安全:

单线程单进程:保证性能高一致性.

Redis是按照一个一个字节来读取.

```shell
## 关闭aof日志,默认只有RDB
appendonly no
## 在前台阻塞式输出日志信息,动作的一些特征,默认
daemonize no
## 关闭日志文件前面加上#
# logfile /var/log/redis_6379.log
```



**一. Redis底层实现语言:C语言**

**二.纯内存访问**

Redis将所有数据放在内存中，非数据同步正常工作中，是不需要从磁盘读取数据的，0次IO。内存响应时间大约为100纳秒，这是Redis速度快的重要基础。先看看CPU的速度：

![Redis为什么这么快？到底快在哪里？ 目录 前言 一.开发语言 二.纯内存访问 三.单线程 四.非阻塞多路I/O复用机制（图1）](image/c0997276ea4742d3bfde57bf5de8495c.jpg)

拿我的电脑来说，主频是3.1G，也就是说每秒可以执行3.1*10^9个指令。所以说CPU看世界是非常非常慢的，内存比它慢百倍，磁盘比他慢百万倍，你说快不快？

借了一张《深入理解计算机》的图，展示了一个典型的存储器层次结构，在L0层，CPU可以在一个时钟周期访问到，基于SRAM的高速缓存春续期，可以在几个CPU时钟周期访问到，是基于DRAM的主存，可以在几十到几百个时钟周期访问到他们。

![Redis为什么这么快？到底快在哪里？ 目录 前言 一.开发语言 二.纯内存访问 三.单线程 四.非阻塞多路I/O复用机制（图2）](image/8a128441281e4c729b943ea8c3c6c76e.jpg)

**三.单线程**

第一，单线程简化算法的实现，并发的数据结构实现不但困难且也麻烦。第二，单线程避免了线程切换以及加锁释放锁带来的消耗，对于服务端来说，锁和线程切换通常是性能。当然了，单线程也会有它的缺点，也是Redis的噩梦：阻塞。如果执行一个命令过长，那么会造成其他命令的阻塞，对于Redis是十分致命的，所以Redis是面向快速执行场景的数据库。

除了Redis之外，Node.js也是单线程，Nginx也是单线程，但他们都是高性能的典范。

**四.非阻塞多路I/O复用机制**

在这之前先要说一下传统的阻塞I/O是如何工作的：当使用read或者write对某一文件描述符（File Descriptor FD）进行读写的时候，如果数据没有收到，那么该线程会被挂起，直到收到数据。阻塞模型虽然易于理解，但是在需要处理多个客户端任务的时候，不会使用阻塞模型。

![Redis为什么这么快？到底快在哪里？ 目录 前言 一.开发语言 二.纯内存访问 三.单线程 四.非阻塞多路I/O复用机制（图3）](image/1ed7f5eb2b2847058b388e7289b95ff5.jpg)

I/O多路复用实际上是指多个连接的可以在同一进程。多路是指网络连接，复用只是同一个线程。在网络服务中，I/O多路复用起的作用是一次性把多个连接的事件业务代码处理，处理的方式由业务代码来决定。在I/O多路复用模型中，最重要的函数调用就是I/O 多路复用函数，该方法能同时监控多个文件描述符（fd）的读写情况，当其中的某些fd可读/写时，该方法就会返回可读/写的fd个数。

![Redis为什么这么快？到底快在哪里？ 目录 前言 一.开发语言 二.纯内存访问 三.单线程 四.非阻塞多路I/O复用机制（图4）](image/8f0c8f813c4348f1a71de72528fa8a8c.jpg)

Redis使用epoll作为I/O多路复用技术的实现，再加上Redis自身的事件处理模型将epoll的read、write、close等都转换成事件，不在网络I/O上浪费过多的时间。实现对多个FD读写的监控，提高性能。

![Redis为什么这么快？到底快在哪里？ 目录 前言 一.开发语言 二.纯内存访问 三.单线程 四.非阻塞多路I/O复用机制（图5）](image/8f0a9a685b6b4ec1a47323482c713aac.jpg)

举个形象的例子吧。比如一个tcp处理20个客户端socket。A方案：顺序处理，如果第一个socket因为网卡读数据处理慢了，一阻塞后面都玩蛋去。B方案：每个socket请求都创建一个分身子进程来处理，不说每个进程消耗大量资源，光是进程切换就够操作累的了。C方案（I/O复用模型，epoll）将用户socket对应的fd注册进epoll（实际上和操作之间传递的不是socket的fd而是fd_set的数据结构）epoll只告诉哪些需要读/写的socket，只需要处理那些活跃的、有变化的socket fd的就好了。这样，整个过程只在调用epoll的时候才会阻塞，收发客户是不会阻塞的。

-Xms1024m
-Xmx2048m
-XX:ReservedCodeCacheSize=1024m
-XX:+UseCompressedOops
-Dfile.encoding=UTF-8
-XX:+UseConcMarkSweepGC
-XX:SoftRefLRUPolicyMSPerMB=50
-ea
-Dsun.io.useCanonCaches=false
-Djava.net.preferIPv4Stack=true
-Djdk.http.auth.tunneling.disabledSchemes=""
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-Xverify:none
-XX:ErrorFile=$USER_HOME/java_error_in_idea_%p.log
-XX:HeapDumpPath=$USER_HOME/java_error_in_idea.hprof



ls -l /etc/ | more

![1567599659661](image/1567599659661.png)

*((num++)) | echo ok*

#### 跳跃表

随机造层

##### 为什么选择跳表

目前经常使用的平衡数据结构有：B树，红黑树，AVL树，Splay Tree, Treep等。

想象一下，给你一张草稿纸，一只笔，一个编辑器，你能立即实现一颗红黑树，或者AVL树出来吗？ 很难吧，这需要时间，要考虑很多细节，要参考一堆算法与数据结构之类的树，还要参考网上的代码，相当麻烦。

用跳表吧，跳表是一种随机化的数据结构，目前开源软件 Redis 和 LevelDB 都有用到它，它的效率和红黑树以及 AVL 树不相上下，但跳表的原理相当简单，只要你能熟练操作链表，就能轻松实现一个 SkipList。

##### 有序表的搜索

考虑一个有序表： 
![这里写图片描述](image/20160906223329182) 
从该有序表中搜索元素 < 23, 43, 59 > ，需要比较的次数分别为 < 2, 4, 6 >，总共比较的次数为 2 + 4 + 6 = 12 次。有没有优化的算法吗? 链表是有序的，但不能使用二分查找。类似二叉搜索树，我们把一些节点提取出来，作为索引。得到如下结构：

![这里写图片描述](image/20160906223251963)

提取出来作为一级索引，这样搜索的时候就可以减少比较次数了。 
我们还可以再从一级索引提取一些元素出来，作为二级索引，三级索引… 
![这里写图片描述](image/20160906223151681) 
这里元素不多，体现不出优势，如果元素足够多，这种索引结构就能体现出优势来了。

##### 跳表

下面的结构是就是跳表： 
其中 -1 表示 INT_MIN， 链表的最小值，1 表示 INT_MAX，链表的最大值。

![这里写图片描述](image/20160906222654630)

跳表具有如下性质： 
(1) 由很多层结构组成 
(2) 每一层都是一个有序的链表 
(3) 最底层(Level 1)的链表包含所有元素 
(4) 如果一个元素出现在 Level i 的链表中，则它在 Level i 之下的链表也都会出现。 
(5) 每个节点包含两个指针，一个指向同一链表中的下一个元素，一个指向下面一层的元素。

###### 跳表的搜索

![这里写图片描述](image/20160906222733148)

例子：查找元素 117 
(1) 比较 21， 比 21 大，往后面找 
(2) 比较 37, 比 37大，比链表最大值小，从 37 的下面一层开始找 
(3) 比较 71, 比 71 大，比链表最大值小，从 71 的下面一层开始找 
(4) 比较 85， 比 85 大，从后面找 
(5) 比较 117， 等于 117， 找到了节点。

具体的搜索算法如下：

```java
/* 如果存在 x, 返回 x 所在的节点， 
 * 否则返回 x 的后继节点 */  
find(x)   
{  
    p = top;  
    while (1) {  
        while (p->next->key < x)  
            p = p->next;  
        if (p->down == NULL)   
            return p->next;  
        p = p->down;  
    }  
}  
```

###### 跳表的插入

先确定该元素要占据的层数 K（采用丢硬币的方式，这完全是随机的） 
然后在 Level 1 … Level K 各个层的链表都插入元素。 
例子：插入 119， K = 2 
![这里写图片描述](image/20160906222813944)

如果 K 大于链表的层数，则要添加新的层。 
例子：插入 119， K = 4

![这里写图片描述](image/20160906222836993)

丢硬币决定 K 
插入元素的时候，元素所占有的层数完全是随机的，通过一下随机算法产生：

```java
int random_level()  
{  
    K = 1;  

    while (random(0,1))  
        K++;  

    return K;  
}  
```

相当与做一次丢硬币的实验，如果遇到正面，继续丢，遇到反面，则停止， 
用实验中丢硬币的次数 K 作为元素占有的层数。显然随机变量 K 满足参数为 p = 1/2 的几何分布， 
K 的期望值 E[K] = 1/p = 2. 就是说，各个元素的层数，期望值是 2 层。

跳表的高度。 
n 个元素的跳表，每个元素插入的时候都要做一次实验，用来决定元素占据的层数 K， 
跳表的高度等于这 n 次实验中产生的最大 K，待续。。。

跳表的空间复杂度分析 
根据上面的分析，每个元素的期望高度为 2， 一个大小为 n 的跳表，其节点数目的 
期望值是 2n。

###### 跳表的删除

在各个层中找到包含 x 的节点，使用标准的 delete from list 方法删除该节点。 
例子：删除 71

![这里写图片描述](image/20160906222950196)



#### 零拷贝

数据从磁盘传输到socket要经过以下几个步骤：

![这里写图片描述](image/20170512093639736.png)

1. 操作系统将数据从磁盘读入到内核空间的页缓存

2. 应用程序将数据从内核空间读入到用户空间缓存中

3. 应用程序将数据写回到内核空间到socket缓存中

4. 操作系统将数据从socket缓冲区复制到网卡缓冲区，以便将数据经网络发出

这里有四次拷贝，两次系统调用，这是非常低效的做法。如果使用sendfile，只需要一次拷贝就行：允许操作系统将数据直接从页缓存发送到网络上。所以在这个优化的路径中，只有最后一步将数据拷贝到网卡缓存中是需要的。

![这里写图片描述](image/20170512093639737.png)

### 多线程高并发

#### 面试题

①**写一个固定容量同步容器，拥有put和get方法，以及getCount方法，能够支持多个生产者和多个消费者线程拥塞调用。**



②**实现一个容器，提供两个方法，add,size。写两个线程，线程 1 添加 10 个元素到容器中，线程 2 实现监控元素的个数，当个数到 5 个时，线程 2 给出提示并结束。**

* 可以semaphore+cyclicBarrier  因为cyclicBarrier可重用

* CountLatch --state

#### 笔记

lock指令前缀 自带内存屏障



### Zookeeper

1. 所有的线程在启动的时候都去创建**临时顺序节点**,创建成功后然后在回调的方法中获取父节点的子节点的所有锁,这些临时节点会进行排序,只有第一个节点回获取锁,而其他节点进行对前一节点做exist判断回调,临时顺序节点会一直到调用exist判断函数;当前节点调用exist(判断前一节点是否存在的回调函数)来判断前一节点是否存在,如果存在就加上一把锁,如果前一节点不存在就会重新getChildrenNode对这些临时节点进行排序
2. 除第一个节点，后面的每一个节点对前面一个进行exist的监听，  在exist的回调里，判定一下它所监听的前一个节点是否确实在此时是实实在在存在的， 如果不存在，需要重新走一遍getchildren的逻辑， 来重新让当前节点 对上一个节点再次进行exist监听    这样保证了 它的上一个节点确实是存在的，这个事件是可以被触发的
3. 所有节点创建成功之后在成功的回调里面获取父节点所有锁，然后找出当时节点的前一个锁，并做一个exist判断，在它的结果回调里面，如果存在的话加监听，不存在的话，再获取所有锁进行排序，找出当前节点的前一个节点进行监听



### 微服务

![1565079802588](image/1565079802588.png)

#### Eureka

![img](image/20190617220916180.png)                                                                                                       

​                                                                          Eureka架构图

从架构图中可知，Eureka具有如下功能：

服务注册
获取注册表信息
服务续约
服务下线(服务销毁)

pom.xml配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	
	<modelVersion>4.0.0</modelVersion>
	
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>2.1.7.RELEASE</version>
		<relativePath/>
	</parent>
	
	<groupId>com.online.taxi.eureka</groupId>
	<artifactId>eureka</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>eureka</name>
	<description>Demo project for Spring Boot</description>

	<properties>
		<java.version>1.8</java.version>
		<spring-cloud.version>Greenwich.SR2</spring-cloud.version>
		<maven-jar-plugin.version>3.1.1</maven-jar-plugin.version>
	</properties>

	<dependencies>
		<!-- web -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
		
		
		<!-- 安全认证 -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-security</artifactId>
		</dependency>
		
		<!-- 测试 -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
	</dependencies>

	<dependencyManagement>
		<dependencies>
			<dependency>
				<groupId>org.springframework.cloud</groupId>
				<artifactId>spring-cloud-dependencies</artifactId>
				<version>${spring-cloud.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
		</dependencies>
	</dependencyManagement>

	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>

</project>
```



##### 发现组件Eureka Client

- 拉取Eureka Server中的全量注册表
- 注册自身实例InstanceInfo至Eureka Server
- 初始化定时任务　

```
　　　　心跳（续约）任务
　　　　拉取增量注册表更新本地注册表缓存（默认30s）
　　　　按需注册任务
　　　　　　定时检测InstanceInfo是否发生变化，变化则重新向Eureka Server发起注册
　　　　　　监听（Linsten）status，发生变化则重新向Eureka Server发起注册
```

pom.xml配置文件

```xml
        <!-- eureka 客户端 -->
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
		</dependency>
```

application.yml配置

```yml
eureka:
  instance:
    hostname: client
  client:
    serviceUrl:
      defaultZone: http://localhost:8761/eureka
server:
  port: 8765
spring:
  application:
    name: eureka-client
```

启动类:

```java
package com.bruce.eureka;
 
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;
 
@EnableDiscoveryClient
@SpringBootApplication
public class EurekaApplication {
 
    public static void main(String[] args) {
        SpringApplication.run(EurekaApplication.class, args);
    }
}
```

###### 抓取注册表

**eureka client全量抓取注册表：**

```java
private boolean fetchRegistry(boolean forceFullRegistryFetch) {

        Applications applications = getApplications();
        //先从本地拉取注册表
        if(//本地没有注册表){
          //全量拉取注册表
          getAndStoreFullRegistry();
        }else {
            //增量拉取注册表
            getAndUpdateDelta(applications);
        }
        applications.setAppsHashCode(applications.getReconcileHashCode());
        logTotalInstances();
    } 
    return true;
}
private void getAndStoreFullRegistry() throws Throwable {
    Applications apps = null;
    EurekaHttpResponse<Applications> httpResponse = clientConfig.getRegistryRefreshSingleVipAddress() == null
            ? eurekaTransport.queryClient.getApplications(remoteRegionsRef.get())
            : eurekaTransport.queryClient.getVip(clientConfig.getRegistryRefreshSingleVipAddress(), remoteRegionsRef.get());
}
```

通过EurekaHttpClient的实现类AbstractJersey2EurekaHttpClient的getApplicationsInternal方法发送GET请求到ApplicationsResource类的getContainers方法，由此方法处理请求。
会从responseCache的实现类responseCacheImpl获取到注册表并返回，先在本地存一份，然后直接返回给eureka client。

```java
String get(final Key key, boolean useReadOnlyCache) {
    //先从读缓存中获取
    Value payload = getValue(key, useReadOnlyCache);
    if (payload == null || payload.getPayload().equals(EMPTY_PAYLOAD)) {
        return null;
    } else {
        return payload.getPayload();
    }
}
123456789
Value getValue(final Key key, boolean useReadOnlyCache) {
    Value payload = null;
    try {
        if (useReadOnlyCache) {
            final Value currentPayload = readOnlyCacheMap.get(key);
            if (currentPayload != null) {
                payload = currentPayload;
            } else {
                //如果读缓存没，会从读写缓存中获取
                payload = readWriteCacheMap.get(key);
                readOnlyCacheMap.put(key, payload);
            }
        } else {
            payload = readWriteCacheMap.get(key);
        }
    } catch (Throwable t) {
        logger.error("Cannot get value for key : {}", key, t);
    }
    return payload;
}
```

如果读写缓存也没有，则会调用初始化readWriteCacheMap时的generatePayload方法从eureka server的注册表中去读取 。

```java
if (ALL_APPS.equals(key.getName())) {
    if (isRemoteRegionRequested) {
        tracer = serializeAllAppsWithRemoteRegionTimer.start();
        payload = getPayLoad(key, registry.getApplicationsFromMultipleRegions(key.getRegions()));
    } else {
        tracer = serializeAllAppsTimer.start();
        payload = getPayLoad(key, registry.getApplications());
    }
}
```

从注册表中获取所有的Applications，ServerCodecs，json序列化的组件，将Applications对象序列化为了一个json字符串，将注册表中读取出来的Applications，放入读写缓存，接着放入只读缓存中去。

**eureka server注册表多级缓存过期机制：**
1、主动过期：有新的服务实例发生注册、下线、故障的时候，就会去刷新readWriteCacheMap。

2、定时过期：readWriteCacheMap在构建的时候，指定了一个自动过期的时间，默认值就是180秒，所以你往readWriteCacheMap中放入一个数据过后，自动会等180秒过后，就将这个数据给他过期了。

3、被动过期：默认是每隔30秒，执行一个定时调度的线程任务，TimerTask，有一个逻辑，会每隔30秒，对readOnlyCacheMap和readWriteCacheMap中的数据进行一个比对，如果两块数据是不一致的，那么就将readWriteCacheMap中的数据放到readOnlyCacheMap中来。

**eureka client增量抓取注册表：**

```java
private void getAndUpdateDelta(Applications applications) throws Throwable {

    Applications delta = null;
    EurekaHttpResponse<Applications> httpResponse = eurekaTransport.queryClient.getDelta(remoteRegionsRef.get());
    if (httpResponse.getStatusCode() == Status.OK.getStatusCode()) {
        delta = httpResponse.getEntity();
        //将抓取到的注册表跟本地的注册表进行合并，完成服务实例的增删改 
        updateDelta(delta);
        //计算eureka client端的合并完的注册表的hash值
        reconcileHashCode = getReconcileHashCode(applications);
	   //将合并完的hash值和eureka server端的全量注册表的hash值对比，不一致时需要拉取全量的注册表到本地来更新到缓存里去
         if (!reconcileHashCode.equals(delta.getAppsHashCode()) || clientConfig.shouldLogDeltaDiff()) {
           reconcileAndLogDifference(delta, reconcileHashCode);  // this makes a remoteCall
      }
}
```

通过EurekaHttpClient的实现类AbstractJersey2EurekaHttpClient的getDelta方法发送GET请求到ApplicationsResource类的getContainerDifferential方法，由此方法处理请求。
从ResponseCacheImpl类中获取注册表的缓存，构造readWriteCacheMap时会执行generatePayload方法。

```java
else if (ALL_APPS_DELTA.equals(key.getName())) {
    if (isRemoteRegionRequested) {
        tracer = serializeDeltaAppsWithRemoteRegionTimer.start();
        versionDeltaWithRegions.incrementAndGet();
        versionDeltaWithRegionsLegacy.incrementAndGet();
        payload = getPayLoad(key,
                registry.getApplicationDeltasFromMultipleRegions(key.getRegions()));
    } else {
        tracer = serializeDeltaAppsTimer.start();
        versionDelta.incrementAndGet();
        versionDeltaLegacy.incrementAndGet();
        payload = getPayLoad(key, registry.getApplicationDeltas());
    }
} 
1234567891011121314
public Applications getApplicationDeltasFromMultipleRegions(String[] remoteRegions) {

    Applications apps = new Applications();
    Map<String, Application> applicationInstancesMap = new HashMap<String, Application>();
    try {
        write.lock();
        //recentlyChangedQueue:感知最近有变化的服务实例（新注册、下线的，或者是其他）
//在Registry构造的时候，有一个定时调度的任务getDeltaRetentionTask，默认是30秒一次，得到服务实例的变更记录，判断是否在队列里停留了超过180s（3分钟），如果超过了3分钟，就会从队列里将这个服务实例变更记录给移除掉；这个queue，就保留最近3分钟的服务实例变更记录。 
        Iterator<RecentlyChangedItem> iter = this.recentlyChangedQueue.iterator();
       
        while (iter.hasNext()) {
            Lease<InstanceInfo> lease = iter.next().getLeaseInfo();
            InstanceInfo instanceInfo = lease.getHolder();
           
            Application app = applicationInstancesMap.get(instanceInfo.getAppName());
            if (app == null) {
                app = new Application(instanceInfo.getAppName());
                applicationInstancesMap.put(instanceInfo.getAppName(), app);
                apps.addApplication(app);
            }
            app.addInstance(new InstanceInfo(decorateInstanceInfo(lease)));
        }
    }
}
        Applications allApps = getApplicationsFromMultipleRegions(remoteRegions);
        apps.setAppsHashCode(allApps.getReconcileHashCode());
        return apps;
    } finally {
        write.unlock();
    }
}
```

**eureka client抓取注册表：**
![在这里插入图片描述](image/c55e8659df839778a6f3593c304f5c32.png)

[原图地址](http://images1.pianshen.com/26/c5/c55e8659df839778a6f3593c304f5c32.png)

###### 生命周期

![img](image/20190618193900517.png)



其中启动阶段中的**从Eureka Server中拉取注册表信息并缓存到本地**为<font color=#FF0000>**全量拉取注册表**</font>

执行节点中的某个定时任务:**从Eureka Server中拉取注册表信息,并更新本地注册表缓存**为<font color=#FF0000 >**增量拉取注册表**</font>



###### 服务调用

* 使用springcloud提供的**ribbon**和**feign**进行服务调用:**feign**是RequestTemplate的一个封装,封装rest功能。

* 微服务之间隔离并进行服务调用



##### Eureka Server

- 启动从其它节点（peer）拉取注册表信息　
- Eureka Server每次操作本地注册表时，同时同步到其它节点（同步操作有 Heartbeat/Register/Cancel/StatusUpdate，DeleteStatusOverride）



###### 服务端接收注册

- 获取读锁
- 在注册表中查询InstanceInfo中的各个服务实例元数据
- 判断租约(**实例元数据**)是否存在
  - 如果不存在的话就会创建新的租约
  - 如果存在的话会判断InstanceInfo最后更新时间,新的用户服务比老的小就会扔掉新的,大的就会获取最新时间戳同步注册中心的时间,设置上线时间使之计算租约有效性。
- 释放锁

服务注册在调用initScheduledTasks()方法时，里面有个InstanceInfoReplicator组件，这个就是服务实例信息复制组件，来负责服务的注册。

```java
instanceInfoReplicator = new InstanceInfoReplicator(
        this,
        instanceInfo,
        clientConfig.getInstanceInfoReplicationIntervalSeconds(),
        2); 
//启动调度服务实例副本传播器任务   
instanceInfoReplicator.start(clientConfig.getInitialInstanceInfoReplicationIntervalSeconds());
public void run() {
    try {
        //刷新服务实例的配置，将更新后的服务状态设置到了ApplicationInfoManager中去
        discoveryClient.refreshInstanceInfo();

        Long dirtyTimestamp = instanceInfo.isDirtyWithTime();
        if (dirtyTimestamp != null) {
            //服务注册
            discoveryClient.register();
            instanceInfo.unsetIsDirty(dirtyTimestamp);
        }
    } catch (Throwable t) {
        logger.warn("There was a problem with the instance info replicator", t);
    } finally {
        Future next = scheduler.schedule(this, replicationIntervalSeconds, TimeUnit.SECONDS);
        scheduledPeriodicRef.set(next);
    }
}
boolean register() throws Throwable {
    httpResponse = eurekaTransport.registrationClient.register(instanceInfo);
    return httpResponse.getStatusCode() == Status.NO_CONTENT.getStatusCode();
}
```

通过EurekaHttpClient的实现类AbstractJersey2EurekaHttpClient发送POST请求，调用eureka server的addInstance方法（eureka-core，resources包，ApplicationResource类中）。
调用PeerAwareInstanceRegistry的register方法，最后调用AbstractInstanceRegistry的register方法。

```java
public void register(InstanceInfo registrant, int leaseDuration, boolean isReplication) {
    try {
        //读锁
        read.lock();
        //注册表结构Map
        Map<String, Lease<InstanceInfo>> gMap = registry.get(registrant.getAppName());
        if (gMap == null) {
            final ConcurrentHashMap<String, Lease<InstanceInfo>> gNewMap = new ConcurrentHashMap<String, Lease<InstanceInfo>>();
            gMap = registry.putIfAbsent(registrant.getAppName(), gNewMap);
            if (gMap == null) {
                gMap = gNewMap;
            }
        }
        //Lease：契约，维护了一个服务实例跟当前注册中心之间的联系，包括了心跳的时间、创建时间
        Lease<InstanceInfo> existingLease = gMap.get(registrant.getId());
       
        if (existingLease != null && (existingLease.getHolder() != null)) {
            Long existingLastDirtyTimestamp = existingLease.getHolder().getLastDirtyTimestamp();
            Long registrationLastDirtyTimestamp = registrant.getLastDirtyTimestamp();
        } else {
     	    //契约不存在，说明是第一次注册
            synchronized (lock) {
                if (this.expectedNumberOfClientsSendingRenews > 0) {
                    //期望的服务实例数+1
                    this.expectedNumberOfClientsSendingRenews = this.expectedNumberOfClientsSendingRenews + 1;
                    //更新1分钟应该收到多少次心跳数
                    updateRenewsPerMinThreshold();
                }
            }
        }
        Lease<InstanceInfo> lease = new Lease<InstanceInfo>(registrant, leaseDuration);

        gMap.put(registrant.getId(), lease);
        //把新注册的实例添加进一个队列中（保存最近3分钟发生变化的服务实例的队列）
        synchronized (recentRegisteredQueue) {
            recentRegisteredQueue.add(new Pair<Long, String>(
                    System.currentTimeMillis(),
                    registrant.getAppName() + "(" + registrant.getId() + ")"));
        }
    } finally {
        read.unlock();
    }
}
```

**eureka的服务注册流程图：**
![eureka的服务注册流程图](image/be66b39b1154ede440d2e694cfb41503.png)



###### 服务端接收心跳

![1570868580399](image/1570868580399.png)

###### 服务端剔除服务

**自我保护机制时期服务端是不能剔除服务的**

**统计下线列表**是为了别的节点增量拉取注册表信息

```java
//AbstractInstanceRegistry
    public void evict(long additionalLeaseMs) {
        logger.debug("Running the evict task");

        if (!isLeaseExpirationEnabled()) {
            logger.debug("DS: lease expiration is currently disabled.");
            return;
        }

        // We collect first all expired items, to evict them in random order. For large eviction sets,
        // if we do not that, we might wipe out whole apps before self preservation kicks in. By randomizing it,
        // the impact should be evenly distributed across all applications.
        List<Lease<InstanceInfo>> expiredLeases = new ArrayList<>();
        for (Entry<String, Map<String, Lease<InstanceInfo>>> groupEntry : registry.entrySet()) {
            Map<String, Lease<InstanceInfo>> leaseMap = groupEntry.getValue();
            if (leaseMap != null) {
                for (Entry<String, Lease<InstanceInfo>> leaseEntry : leaseMap.entrySet()) {
                    Lease<InstanceInfo> lease = leaseEntry.getValue();
                    if (lease.isExpired(additionalLeaseMs) && lease.getHolder() != null) {
                        expiredLeases.add(lease);
                    }
                }
            }
        }

        // To compensate for GC pauses or drifting local time, we need to use current registry size as a base for
        // triggering self-preservation. Without that we would wipe out full registry.
        int registrySize = (int) getLocalRegistrySize();
        //实例数*getRenewalPercentThreshold为续租百分比0.85
        int registrySizeThreshold = (int) (registrySize * serverConfig.getRenewalPercentThreshold());
        
        //剔除界限=实例数-实例阈值
        int evictionLimit = registrySize - registrySizeThreshold;

        //期满的租约数和剔除界限取最小值
        int toEvict = Math.min(expiredLeases.size(), evictionLimit);
        if (toEvict > 0) {
            logger.info("Evicting {} items (expired={}, evictionLimit={})", toEvict, expiredLeases.size(), evictionLimit);

            //逐个剔除失效租约
            Random random = new Random(System.currentTimeMillis());
            for (int i = 0; i < toEvict; i++) {
                // Pick a random item (Knuth shuffle algorithm)
                int next = i + random.nextInt(expiredLeases.size() - i);
                Collections.swap(expiredLeases, i, next);
                Lease<InstanceInfo> lease = expiredLeases.get(i);

                String appName = lease.getHolder().getAppName();
                String id = lease.getHolder().getId();
                EXPIRED.increment();
                logger.warn("DS: Registry: expired lease for {}/{}", appName, id);
                internalCancel(appName, id, false);
            }
        }
    }
```



###### 服务端集群同步

* 当A注册给B和C的时候,A就叫做B和C的peer角色
* 每个节点在启动的时候都会往peer拉取注册表信息,并缓存到自己的注册表中
* 注册表中的实例元数据有变动的时候,通过replicateToPeers()方法来进行同步到其他节点。
* 由于集群间的同步复制是通过HTTP的方式进行的,基于网络是不可靠的,所以j集群中的Eureka Server间的注册表信息难免会存在不同步的时间节点,不满足CAP中的C(数据一致性)。





 pom.xml配置

```xml
        <!-- eureka 服务端 -->
		<dependency>
			<groupId>org.springframework.cloud</groupId>
			<artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
		</dependency>
```

application.yml配置

```yml
server:
  port: 8761
eureka:
  instance:
    hostname: localhost
  client:
    registerWithEureka: false #先不向Eureka Server注册自己的信息
    fetchRegistry: false #不向Eureka Server获取注册信息
    serviceUrl: #Eureka Server注册中心地址
      defaultZone: http://localhost:8761/eureka/
spring:
  application:
    name: eureka-service
```

启动类

```java
package com.bruce.eureka.server;
 
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;
 
@EnableEurekaServer
@SpringBootApplication
public class EurekaApplication {
 
    public static void main(String[] args) {
        SpringApplication.run(EurekaApplication.class, args);
    }
}
```

##### Eureka服务治理体系

* 服务治理通过抽将服务消费者和服务提供者进行隔离。
* 



###### 失效剔除

有些时候，我们的服务实例并不一定会正常下线，可能由于内存溢出、网络故障等原因使服务不能正常运作。而服务注册中心并未收到“服务下线”的请求，为了从服务列表中将这些无法提供服务的实例剔除，Eureka Server在启动的时候会创建一个定时任务，默认每隔一段时间（默认为60秒）将当前清单中超时（默认为90秒）没有续约的服务剔除出去。

###### 自我保护

服务注册到Eureka Server后，会维护一个心跳连接，告诉Eureka Server自己还活着。Eureka Server在运行期间会统计心跳失败的比例在15分钟以之内是否低于85%，如果出现低于的情况，Eureka Server会将当前实例注册信息保护起来，让这些实例不会过期。这样做会使客户端很容易拿到实际已经不存在的服务实例，会出现调用失败的情况。因此客户端要有容错机制，比如请求重试、断路器。

以下是自我保护相关的属性：

eureka.server.enableSelfPreservation=true. 可以设置改参数值为false，以确保注册中心将不可用的实例删除



###### region(地域)与zone(可用区)
region和zone（或者Availability Zone）均是AWS的概念。在非AWS环境下，我们可以简单地将region理解为地域，zone理解成机房。一个region可以包含多个zone，可以理解为一个地域内的多个不同的机房。不同地域的距离很远，一个地域的不同zone间距离往往较近，也可能在同一个机房内。

region可以通过配置文件进行配置，如果不配置，会默认使用us-east-1。同样Zone也可以配置，如果不配置，会默认使用defaultZone。

Eureka Server通过eureka.client.serviceUrl.defaultZone属性设置Eureka的服务注册中心的位置。

指定region和zone的属性如下：

（1）eureka.client.availabilityZones.myregion=myzone# myregion是region

（2）eureka.client.region=myregion

     Ribbon的默认策略会优先访问通客户端处于同一个region中的服务端实例，只有当同一个zone中没有可用服务端实例的时候才会访问其他zone中的实例。所以通过zone属性的定义，配合实际部署的物理结构，我们就可以设计出应对区域性故障的容错集群。

###### 安全验证
我们启动了Eureka Server，然后在浏览器中输入http://localhost:8761/后，直接回车，就进入了spring cloud的服务治理页面，这么做在生产环境是极不安全的，下面，我们就给Eureka Server加上安全的用户认证.



###### 负载均衡

* 客户端负载均衡和服务端负载均衡的区别：

  * **服务清单所存储的位置**。

  * **服务端负载均衡**：Nginx的负载均衡为服务端负载均衡，服务端负载均衡在服务器上安装一些具有负载均衡功能的软件来完成请求分发（**通过负载均衡算法，在多个服务器之间选择一个进行访问**）进而实现负载均衡。在服务器端再进行负载均衡算法分配
  * **客户端负载均衡**：所有的客户端节点都有一份自己要访问的服务端清单(**注册列表**)，这些清单统统都是从Eureka服务注册中心获取的,并在客户端就进行负载均衡算法分配。在Spring Cloud中我们如果想要使用客户端负载均衡，方法很简单，开启`@LoadBalanced`注解即可，这样客户端在发起请求的时候会先通过`RandonRobin`方法轮询选择服务器后向服务端发起请求，从而实现负载均衡。





（1）pom文件中引入依赖

```xml
 <dependency> 
   <groupId>org.springframework.boot</groupId> 
   <artifactId>spring-boot-starter-security</artifactId> 
</dependency> 
```

（2）serviceurl中加入安全校验信息

```xml
eureka.client.serviceUrl.defaultZone=http://<username>:<password>@${eureka.instance.hostname}:${server.port}/eureka/
```



#### 网关

* 统一接入:智能路由,灰度测试(发布),AB测试,日志埋点
  * **灰度测试(发布)**:灰度测试(发布)是通过切换线上并存版本之间的路由权重，逐步从一个版本切换为另一个版本的过程
  * **AB测试**:侧重的是从A版本或者B版本之间的差异，并根据这个结果进行决策。最终选择一个版本进行部署。因此和灰度发布相比，AB测试更倾向于去决策，和金丝雀发布相比，AB测试在权重和流量的切换上更灵活。
  * **蓝绿发布**:在发布的过程中用户无感知服务的重启，通常情况下是通过新旧版本并存的方式实现，也就是说在发布的流程中，新的版本和旧的版本是相互热备的，通过切换路由权重的方式（非0即100）实现不同的应用的上线或者下线。
  * **金丝雀发布**:通过在线上运行的服务中，新加入少量的新版本的服务，然后从这少量的新版本中快速获得反馈，根据反馈决定最后的交付形态。
* 流量监控:限流处理
* 安全防护:鉴权,网络物理隔离



## 大数据

```sql
SQL>explain plan for SELECT *
FROM crmdw.irsl_renew_user a, crmdw.irsl_renew_tmp_user b, crmdw.on_cor_table t
 WHERE     a.irsl_date = '2015-09-25'
AND b.irsl_date = '2015-09-25'
AND TO_CHAR (t.end_date, 'yyyy-mm-dd') = '9999-12-31'
AND b.IS_BW = 1
AND b.seach_sign_comp IN (1, 2, 3)
AND a.providerid = b.providerid
AND t.providerid = a.providerid;
PLAN_TABLE_OUTPUT
```



| Id   |           Operation           |            Name             | Rows  | Bytes | Cost (%CPU) |   Time   |
| ---- | :---------------------------: | :-------------------------: | :---: | :---: | :---------: | :------: |
| 0    |       SELECT STATEMENT        |                             |   1   | 2145  | 88436   (4) | 00:17:42 |
| 1    |   TEMP TABLE TRANSFORMATION   |                             |       |       |             |          |
| 2    |        LOAD AS SELECT         | SYS_TEMP_0FD9D66A2_D73DA0B4 |       |       |             |          |
| *  3 |       TABLE ACCESS FULL       |        ON_COR_TABLE         | 6242  |  10M  | 34723   (1) | 00:06:57 |
| 4    |        LOAD AS SELECT         | SYS_TEMP_0FD9D66A2_D73DA0B4 |       |       |             |          |
| 5    |  TABLE ACCESS BY INDEX ROWID  |     IRSL_RENEW_TMP_USER     | 10803 | 2342K | 1801   (1)  | 00:00:22 |
| *  6 |       INDEX RANGE SCAN        |  IND_RENEW_IRSLDATE_IB_SSC  | 11359 |       |  702   (1)  | 00:00:09 |
| *  7 |           HASH JOIN           |                             |   1   | 2145  | 51912   (7) | 00:10:23 |
| *  8 |           HASH JOIN           |                             |  15   | 28620 | 51839   (7) | 00:10:23 |
| 9    |  TABLE ACCESS BY INDEX ROWID  |       IRSL_RENEW_USER       |  292  | 48307 | 51556   (7) | 00:10:19 |
| 10   |  BITMAP CONVERSION TO ROWIDS  |                             |       |       |             |          |
| 11   |          BITMAP AND           |                             |       |       |             |          |
| 12   | BITMAP CONVERSION FROM ROWIDS |                             |       |       |             |          |
| * 13 |       INDEX RANGE SCAN        |     IDX_RENEW_IRSLDATE      |       |       |  707   (1)  | 00:00:09 |
| 14   |         BITMAP MERGE          |                             |       |       |             |          |
| 15   |     BITMAP KEY ITERATION      |                             |       |       |             |          |
| 16   |       TABLE ACCESS FULL       | SYS_TEMP_0FD9D66A2_D73DA0B4 |   1   |  13   |   2   (0)   | 00:00:01 |
| 17   | BITMAP CONVERSION FROM ROWIDS |                             |       |       |             |          |
| * 18 |       INDEX RANGE SCAN        |    IDX_RENEW_PROVIDERID     |       |       |   3   (0)   | 00:00:01 |
| 19   |         BITMAP MERGE          |                             |       |       |             |          |
| 20   |     BITMAP KEY ITERATION      |                             |       |       |             |          |
| 21   |       TABLE ACCESS FULL       | SYS_TEMP_0FD9D66A1_D73DA0B4 |   1   |  13   |   2   (0)   | 00:00:01 |
| 22   | BITMAP CONVERSION FROM ROWIDS |                             |       |       |             |          |
| * 23 |       INDEX RANGE SCAN        |    IDX_RENEW_PROVIDERID     |       |       |   3   (0)   | 00:00:01 |
| 24   |       TABLE ACCESS FULL       | SYS_TEMP_0FD9D66A1_D73DA0B4 | 6242  |  10M  |  282   (1)  | 00:00:04 |
| 25   |       TABLE ACCESS FULL       | SYS_TEMP_0FD9D66A2_D73DA0B4 | 10803 | 2500K |  73   (2)   | 00:00:01 |

原SQL:

```SQL
SQL> explain plan for SELECT *
  2    FROM crmdw.irsl_renew_user a, crmdw.irsl_renew_tmp_user b, crmdw.on_cor_table t
  3   WHERE     a.irsl_date = '2015-09-25'
  4         AND b.irsl_date = '2015-09-25'
  5         AND TO_CHAR (t.end_date, 'yyyy-mm-dd') = '9999-12-31'
  6         AND b.IS_BW = 1
  7         AND b.seach_sign_comp IN (1, 2, 3)
  8         AND a.providerid = b.providerid
  9         AND t.providerid = a.providerid;
PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Plan hash value: 2509217529
---------------------------------------------------------------------------------------------------------------------
| Id  | Operation                             | Name                        | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                      |                             |     1 |  2145 | 88436   (4)| 00:17:42 |
|   1 |  TEMP TABLE TRANSFORMATION            |                             |       |       |            |          |
|   2 |   LOAD AS SELECT                      | SYS_TEMP_0FD9D66A2_D73DA0B4 |       |       |            |          |
|*  3 |    TABLE ACCESS FULL                  | ON_COR_TABLE                |  6242 |    10M| 34723   (1)| 00:06:57 |
|   4 |   LOAD AS SELECT                      | SYS_TEMP_0FD9D66A2_D73DA0B4 |       |       |            |          |
|   5 |    TABLE ACCESS BY INDEX ROWID        | IRSL_RENEW_TMP_USER         | 10803 |  2342K|  1801   (1)| 00:00:22 |
|*  6 |     INDEX RANGE SCAN                  | IND_RENEW_IRSLDATE_IB_SSC   | 11359 |       |   702   (1)| 00:00:09 |
|*  7 |   HASH JOIN                           |                             |     1 |  2145 | 51912   (7)| 00:10:23 |
|*  8 |    HASH JOIN                          |                             |    15 | 28620 | 51839   (7)| 00:10:23 |
|   9 |     TABLE ACCESS BY INDEX ROWID       | IRSL_RENEW_USER             |   292 | 48307 | 51556   (7)| 00:10:19 |
|  10 |      BITMAP CONVERSION TO ROWIDS      |                             |       |       |            |          |
|  11 |       BITMAP AND                      |                             |       |       |            |          |
|  12 |        BITMAP CONVERSION FROM ROWIDS  |                             |       |       |            |          |
|* 13 |         INDEX RANGE SCAN              | IDX_RENEW_IRSLDATE          |       |       |   707   (1)| 00:00:09 |
|  14 |        BITMAP MERGE                   |                             |       |       |            |          |
|  15 |         BITMAP KEY ITERATION          |                             |       |       |            |          |
|  16 |          TABLE ACCESS FULL            | SYS_TEMP_0FD9D66A2_D73DA0B4 |     1 |    13 |     2   (0)| 00:00:01 |
|  17 |          BITMAP CONVERSION FROM ROWIDS|                             |       |       |            |          |
|* 18 |           INDEX RANGE SCAN            | IDX_RENEW_PROVIDERID        |       |       |     3   (0)| 00:00:01 |
|  19 |        BITMAP MERGE                   |                             |       |       |            |          |
|  20 |         BITMAP KEY ITERATION          |                             |       |       |            |          |
|  21 |          TABLE ACCESS FULL            | SYS_TEMP_0FD9D66A1_D73DA0B4 |     1 |    13 |     2   (0)| 00:00:01 |
|  22 |          BITMAP CONVERSION FROM ROWIDS|                             |       |       |            |          |
|* 23 |           INDEX RANGE SCAN            | IDX_RENEW_PROVIDERID        |       |       |     3   (0)| 00:00:01 |
|  24 |     TABLE ACCESS FULL                 | SYS_TEMP_0FD9D66A1_D73DA0B4 |  6242 |    10M|   282   (1)| 00:00:04 |
|  25 |    TABLE ACCESS FULL                  | SYS_TEMP_0FD9D66A2_D73DA0B4 | 10803 |  2500K|    73   (2)| 00:00:01 |
---------------------------------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   3 - filter(TO_CHAR(INTERNAL_FUNCTION("T"."END_DATE"),'yyyy-mm-dd')='9999-12-31')
   6 - access("B"."IRSL_DATE"='2015-09-25')
       filter(TO_NUMBER("B"."IS_BW")=1 AND (TO_NUMBER("B"."SEACH_SIGN_COMP")=2 OR
              TO_NUMBER("B"."SEACH_SIGN_COMP")=3 OR TO_NUMBER("B"."SEACH_SIGN_COMP")=1))
   7 - access("A"."PROVIDERID"="C0")
   8 - access("C0"="A"."PROVIDERID")
  13 - access("A"."IRSL_DATE"='2015-09-25')
  18 - access("A"."PROVIDERID"="C0")
  23 - access("A"."PROVIDERID"="C0")
Note
-----
   - star transformation used for this statement
```

改写后:

```SQL
explain plan for select *
  from (select /*+ no_merge */ b.*
          from crmdw.irsl_renew_user a, crmdw.irsl_renew_tmp_user b
         where a.irsl_date = '2015-09-25'
           and a.providerid = b.providerid
           and b.irsl_date = '2015-09-25'
           and b.IS_BW = 1
           and b.seach_sign_comp in (1, 2, 3)) ab,
       crmdw.on_cor_table t
 where t.providerid = ab.providerid
   and to_char(t.end_date, 'yyyy-mm-dd') = '9999-12-31';       
   
--------------------------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name                      | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                           |       |       |       | 68569 (100)|          |
|*  1 |  HASH JOIN                     |                           |  6242 |   171M|    10M| 68569   (1)| 00:13:43 |
|*  2 |   TABLE ACCESS FULL            | ON_COR_TABLE              |  6242 |    10M|       | 34723   (1)| 00:06:57 |
|   3 |   VIEW                         |                           | 19403 |   502M|       |  8425   (1)| 00:01:42 |
|*  4 |    HASH JOIN                   |                           | 19403 |  4566K|  2472K|  8425   (1)| 00:01:42 |
|   5 |     TABLE ACCESS BY INDEX ROWID| IRSL_RENEW_TMP_USER       | 10803 |  2342K|       |  1801   (1)| 00:00:22 |
|*  6 |      INDEX RANGE SCAN          | IND_RENEW_IRSLDATE_IB_SSC | 11359 |       |       |   702   (1)| 00:00:09 |
|   7 |     TABLE ACCESS BY INDEX ROWID| IRSL_RENEW_USER           |   220K|  4088K|       |  6177   (1)| 00:01:15 |
|*  8 |      INDEX RANGE SCAN          | IDX_RENEW_IRSLDATE        |   228K|       |       |   707   (1)| 00:00:09 |
--------------------------------------------------------------------------------------------------------------------   
Predicate Information (identified by operation id):
---------------------------------------------------
   1 - access("T"."PROVIDERID"="AB"."PROVIDERID")
   2 - filter(TO_CHAR(INTERNAL_FUNCTION("T"."END_DATE"),'yyyy-mm-dd')='9999-12-31')
   4 - access("A"."PROVIDERID"="B"."PROVIDERID")
   6 - access("B"."IRSL_DATE"='2015-09-25')
       filter((TO_NUMBER("B"."IS_BW")=1 AND (TO_NUMBER("B"."SEACH_SIGN_COMP")=2 OR
              TO_NUMBER("B"."SEACH_SIGN_COMP")=3 OR TO_NUMBER("B"."SEACH_SIGN_COMP")=1)))
   8 - access("A"."IRSL_DATE"='2015-09-25')
```

------

### HAOOP

#### 大数据启蒙

##### 分治思想

###### ①如何从1W个数中找到想要的那个数  线性表中

顺序查找时间复杂度为O(n) 如何把复杂度降低为O(4)? 哈希表，2500个链长度为4 的链表 `x.hashcode%2500`不考虑倾斜问题。

###### ②如何从一个大文件(1T)中找到重复的位置未知的两行 单机纯JavaSE内存很少

- 前提：生产上用的SSD 读取速度500MB/s   读一遍这个文件得2000s  数据均匀 每台拉取一批小文件 最终并行各自判断自己的数据 
- TIPS：内存速度是磁盘的10万倍
- 最笨的办法：拿出第一行来然后遍历其余所有行进行比对 最复杂的情况，最后两行重复，循环遍历需要N次IO时间。
- **分治思想**：readline().hashcode()%2500  结果分别放在一个一个的小文件中。最后会散列成2500个小文件(需要一次全量IO)。相同的行被取哈希值模后一定会散列到同一个小文件中。这个小文件能一下load到内存中。再来一次全量IO，就能找出来重复行了。分治思想只需要2次IO时间，模值越大越好去到的文件就越小（文件存储的数据越少）就能一次缓存到内存中。
- **集群分布式处理大数据**：当每天都有1T数据的产生,增量一年的时间单台上传文件时间也在成倍数的增加，而分布式上传文件每天生成的1T文件还是使用原来分发上传的时间。

###### ③如何进行全排序，1T的文件里

- hashcode不能用了，会改变数据的特征。

- `readLine if(x>0 && x<100)`根据范围 散列成小文件。这时候这些小文件是**内部无序外部有序**的，来一次全量IO，把每个小文件进行排序就完成了全排序。

- 上述方法 每次都有逻辑判断，有CPU运算过程。

- 对数据结构熟悉的话，第一次全量IO时，一次读取50MB到内存中进行一次排序然后扔到一个小文件，中得到的小文件们特点是**`内部有序外部无序，同时引出归并排序算法`**

  ![归并排序](https://user-gold-cdn.xitu.io/2019/6/22/16b7d33077c72d93?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

###### ④如何将上面时间变为分钟、秒级

- 单机处理大数据的瓶颈在IO上
- 如果给2000台机器，1T文件分成2000份给这些机器，每台机器都处理500MB数据，并行计算。每台机器1s就能读500MB
- 每台readline.hashcode%2000 散列成2000个小文件
- 让每台机器的0号文件 1号文件...相遇，这牵扯到了网络IO。然后2000台每台上面都是1~2000号小文件 每个文件500MB ，并行计算 各自算自己的文件中的重复行。
- 坑：把1T文件散列到2000台 需要时间  而且是走网络IO。
- 移动数据的成本很高。将计算向数据移动。
- 分布式真的会快吗? 辩证



###### ⑤用例

* Redis集群

* ElasticSearch

* Hbase

* HADOOP生态无处不在



###### ⑥结论

- 分而治之
- 并行计算：每台机器都运行大数据所涉及的计算。
- 计算向数据移动
- 数据本地化读取



#### 包含四大模块

- **Hadoop Common**: The common utilities that support the other Hadoop modules.
- **Hadoop Distributed File System (HDFS™)**: A distributed file system that provides high-throughput access to application data.
- **Hadoop YARN**: A framework for job scheduling and cluster resource management.
- **Hadoop MapReduce**: A YARN-based system for parallel processing of large data sets.



#### HDFS

##### HDFS分布式文件系统特性

> * Hadoop Distributed File System
> * 更好的支持分布式计算，计算层，或者应用层
> * 进行增删改查操作的对象是面向文件File而不是块block。
> * HDFS可以暴露block的位置信息(location)和偏移量(offset),可以读取文件的任意位置



##### HDFS安装步骤

> DN把block存成文件存入本地磁盘系统
>
> NN会把内存元数据以快照/日志形式写入本次磁盘系统

###### 伪分布式[^单节点]

1基础设施：
​	设置网络：
​	设置IP
​		*  大家自己看看自己的vm的编辑->虚拟网络编辑器->观察 NAT模式的地址 
​	vi /etc/sysconfig/network-scripts/ifcfg-eth0
​	​	DEVICE=eth0
​	​	#HWADDR=00:0C:29:42:15:C2
​	​	TYPE=Ethernet
​	​	ONBOOT=yes
​	​	NM_CONTROLLED=yes
​	​	BOOTPROTO=static
​	​	IPADDR=192.168.150.11
​	​	NETMASK=255.255.255.0
​	​	GATEWAY=192.168.150.2
​	​	DNS1=223.5.5.5
​	​	DNS2=114.114.114.114
​	设置主机名
​	vi /etc/sysconfig/network
​	​	NETWORKING=yes
​	​	HOSTNAME=node01
​	设置本机的ip到主机名的映射关系
​	vi /etc/hosts
​	​	192.168.150.11 node01
​	​	192.168.150.12 node02
​	

	关闭防火墙
	service iptables stop
	chkconfig iptables off
	关闭 selinux
	vi /etc/selinux/config
		SELINUX=disabled
	
	做时间同步
	yum install ntp  -y
	vi /etc/ntp.conf
		server ntp1.aliyun.com
	service ntpd start
	chkconfig ntpd on
	
	安装JDK：
	rpm -i   jdk-8u181-linux-x64.rpm	
		*有一些软件只认：/usr/java/default
	vi /etc/profile     
		export  JAVA_HOME=/usr/java/default
		export PATH=$PATH:$JAVA_HOME/bin
	source /etc/profile   |  .    /etc/profile
	 
	ssh免密：  ssh  localhost  1,验证自己还没免密  2,被动生成了  /root/.ssh
		ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
		cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
		如果A 想  免密的登陆到B：
			A：
				ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
			B：
				cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
		结论：B包含了A的公钥，A就可以免密的登陆
			你去陌生人家里得撬锁
			去女朋友家里：拿钥匙开门
2，Hadoop的配置（应用的搭建过程）

```shell
	规划路径：
	mkdir /opt/bigdata
	tar xf hadoop-2.6.5.tar.gz
	mv hadoop-2.6.5  /opt/bigdata/
	pwd
		/opt/bigdata/hadoop-2.6.5
vi /etc/profile	
	export  JAVA_HOME=/usr/java/default
	export HADOOP_HOME=/opt/bigdata/hadoop-2.6.5
	export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
source /etc/profile

<!-- 配置hadoop的角色：-->
cd   $HADOOP_HOME/etc/hadoop
	<!-- 必须给hadoop配置javahome要不ssh远程另一节点找不到-->
vi hadoop-env.sh
	export JAVA_HOME=/usr/java/default
	<!-- 给出NN角色在哪里启动 -->
vi core-site.xml
	    <property>
			<name>fs.defaultFS</name>
			<value>hdfs://node01:9000</value>
		</property>
	<!-- 配置hdfs  副本数为1.。。。-->
vi hdfs-site.xml
	    <property>
			<name>dfs.replication</name>
			<value>1</value>
		</property>
		<!-- NN元数据存储的磁盘系统路径在hdfs namenode -format  时会自动创建 -->
		<property>
			<name>dfs.namenode.name.dir</name>
			<value>/var/bigdata/hadoop/local/dfs/name</value>
		</property>
		<!-- 在启动hdfs的时候会自动创建 -->
		<property>
			<name>dfs.datanode.data.dir</name>
			<value>/var/bigdata/hadoop/local/dfs/data</value>
		</property>
		<property>
			<name>dfs.namenode.secondary.http-address</name>
			<value>node01:50090</value>
		</property>
		<property>
			<name>dfs.namenode.checkpoint.dir</name>
			<value>/var/bigdata/hadoop/local/dfs/secondary</value>
		</property>
```


```shell
	配置DN这个角色在哪里启动
vi slaves
	node01
```
3,初始化&启动：
​	hdfs namenode -format  

​		创建目录
​		并初始化一个空的fsimage和一个fsimage.md5
​		VERSION
​			CID来区分各个集群中的每个节点的DN/NN/SNN具有相同ID,就可以进行连接
​	

```shell
start-dfs.sh
	#第一次：datanode和secondary角色会初始化创建自己的数据目录
	
http://node01:50070
	#修改windows： C:\Windows\System32\drivers\etc\hosts
		192.168.150.11 node01
		192.168.150.12 node02
		192.168.150.13 node03
		192.168.150.14 node04
```

4，简单使用：
​	hdfs dfs -mkdir /bigdata
​	hdfs dfs -mkdir  -p  /user/root



5,验证知识点：


```shell
cd   /var/bigdata/hadoop/local/dfs/name/current
#观察 editlog的id是不是再fsimage的后边
cd /var/bigdata/hadoop/local/dfs/secondary/current
#SNN 只需要从NN拷贝最后时点的FSimage和增量的Editlog
hdfs dfs -put hadoop*.tar.gz  /user/root
cd  /var/bigdata/hadoop/local/dfs/data/current/BP-281147636-192.168.150.11-1560691854170/current/finalized/subdir0/subdir0
```


```shell
for i in `seq 100000`;do  echo "hello hadoop $i"  >>  data.txt  ;done
hdfs dfs -D dfs.blocksize=1048576  -put  data.txt  /user/root
cd  /var/bigdata/hadoop/local/dfs/data/current/BP-281147636-192.168.150.11-1560691854170/current/finalized/subdir0/subdir0
#检查data.txt被切割的块，他们数据什么样子
```

-put 文件的时候默认家目录/user/root



###### 完全分布式[^多个节点,一个NN]

- [x] 

###### HA模式[^多个NN]





##### 存储模型

> 理论逻辑思维

- 文件线性(顺序)按**字节**切分成block块后也可以拼接起来，**所有的文件都是一堆字节数组**，块具有offset,id
- 每个文件的block大小可以不一样
- 一个文件除了最后一个block，其他的block大小一致
- block的大小根据硬件IO调整：1.x版本-64M，2.x版本-128M，后面版本-264M（默认）
- block被分散(打散)到集群的节点中,具有location(再次拉取文件的时候就可以知道在哪个位置哪个节点上)，起到分治效果，计算就可以散布到块所在的节点上。移动数据一定比移动计算慢。
- block具有副本 副本没有主从， 副本不能在同一节点上
- 副本满足可靠性和性能，副本数多 计算效率提高（容错性）
- 文件上传指定block大小和副本数，上传之后只能修改副本数不能修改块的大小
- 一次写入多次读取，**不支持修改**。当某个块就行进行修改后放回节点各个block之间的offset就不会吻合在一起，就必须把每个block中的数据向后面的block进行迁移导致数据的泛洪操作(集群上很多节点的CPU内存网卡会参与因为一个小小的数据修改而造成的资源高度使用网络一直被疯狂的传入数据，所有的计算机都在算自己应该拿多少记录多少数据)。**数据倾斜**。     
- append追加数据（最后一个块）

##### 架构设计

- 主从架构 (和主备两回事儿)：主从两个都是活动的,主从之间有通信有协作来做一件事情有互相调用；主备一般用在高可用环境下，备服务器一般不在做逻辑运算操作，当主服务器挂了备用服务器才会切换进行逻辑操作。
- 一个NN+多个DN，角色即jvm进程
- 面向文件：文件数据(Data)和文件元数据(Metadata,在window下一般叫做文件属性)
- NN负责存储和管理文件元数据(记账)和文件内容无关的一些数据，维护了一个层次型的文件目录树(不是物理操作系统目录树)
- DN存储文件数据(block) 并且提供block的读写
- DN和NN维持心跳，并汇报自己block的信息
- client和NN交互文件元数据，和DN交互block

![HDFS架构设计](image/2895a2618d0f8d7d.png)

##### 角色(进程)功能

###### NameNode[^**NN**]

> NN是对Client提供元数据的增删改查。

- 完全基于内存存储(快速提供服务)文件元数据、目录结构、文件block的映射
- 内存存储就牵扯到了 持久化保证了数据可靠性
- 提供**副本放置策略**

###### DataNode[^**DN**]

- 基于本地磁盘存储block(文本的形式)
- 保存block的校验(客户端拿到block会算出校验和 和 DN的校验和比对)和数据可以保证block的可靠性
- 与NN保持心跳，汇报block信息列表状态

###### SecondaryNameNode[^SNN]

> SNN不和Client任何交互，SNN一般是独立的节点。

- 它不是NN的备份（但可以做备份），它主要工作是帮助NN的**Editslog向FsImage合并**，减少EditLog大小，滚动更新FsImage时间点，减少NN启动时间。

- 执行合并时机: 

  1)  根据配置文件设置的时间间隔fs.checkpoint.period默认3600秒；

  2) 根据配置文件设置edits log大小fs.checkpoint.size规定edit文件的最大值默认64MB。

- 当删除一个文件的时候其实并不是马上删除，而是在edits log中记录，到一定时间与fsimage通过SNN进行合并的时候进行删除。由于涉及大多的IO和消耗CPU，所以在NN中不做数据操作的合并，而是让另一个机器的CPU去计算实现SNN根据时间来不断合并各个NN，这样用户体验感比较好，速度也是比较快。

- 那么通过SNN合并之后的新的FSimage和edits log会被推送到NN中并且替换原来的FSimage和edits log，这样NN 里面隔段时间就是新的数据。

- SNN合并流程：

```
首先是NN中的Fsimage和edits文件通过网络拷贝，到达SNN服务器中，拷贝的同时，用户的实时在操作数据，那么NN中就会从新生成一个edits来记录用户的操作，而另一边的SＮＮ将拷贝过来的edits和fsimage进行合并，合并之后就替换NN中的fsimage。之后NN根据fsimage进行操作（当然每隔一段时间就进行替换合并，循环）。当然新的edits与合并之后传输过来的fsimage会在下一次时间内又进行合并。

```

![img](image/u=2595312416,1894060992&fm=173&app=49&f=JPEG.jpg)

①由于同步数据会用到edits与fsimage两个文件，所以先将这两个文件通过网络复制到SSN上面。这时SSN将两个文件load到内存中进行合并。

②考虑到这时可能有客户端来访问所以在edits拷贝到SSN的时候也会在NN上面创建一个edits.new的文件用来写入这一段时间的日志。

③SNN将文件合并完毕然后将合并后的文件fsimage.ckpt通过网络赋值到NN上，然后fsimage.ckpt重命名为fsimage同时edits.new重命名为edits。

④同步完成

从上面我们不难发现SNN并不是为了NN的备份而产生的，只是为了同步数据。但是它有一个副作用就是能够帮助NN在崩溃的时候恢复部分数据。

1. **SNN(非HA模式下)**

   > 合并日志

- SNN独立的节点，周期完成editslog向fsimage的合并

- fs.checkpoint.period 默认3600s 就是一小时合并一次fsimage合并

- fs.checkpoint.size 最大值64mb  就是editslog 到64mb开始想fsimage合并 

- SNN在集群启动以后不会合并EditsLog和fsimage,会一直放入日志到editslog;

- 在集群启动的时候,NN在**启动流程**的时候会加载fsimage和增量editslog,合并后对外提供服务之前会把合并内存状态写入到新的fsimage,启动成功后就一直不会做合并操作,所以接下来有另一台节点中的SNN来合并simage和editslog,因为在合并Fsimage和Editslog会消耗大量的I/O,所以专门一个节点作为SNN来做合并FsImage和EditsLog操作。

  ![SNN](https://user-gold-cdn.xitu.io/2019/6/22/16b7db3bad8538e7?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

  2. SNN(HA模式)

     > 多个NN，主备

##### 元数据持久化

> * 任何对文件系统元数据产生修改的操，NameNode都会使用一种称为Editslog的事务日志记录下来
> * 使用FsImage存储所有的元数据状态
> * 使用本地磁盘保存Editslog和FsImage
> * Editslog具有完整性，数据丢失少，但恢复速度慢，并具有体积膨胀风险
> * FsImage具有恢复速度快，体积与内存数据相当，但不能实时保存，数据丢失多
> * NameNode使用了FsImage+Editslog整合的方案：
>   * 滚动将增量的EditsLog更新到FsImage，以保证更近时点的FsImage和更小的EditsLog体积
>   * FsImage时点是怎么滚动更新的：



世界上有两种方式持久化：

- **日志文件**：记录实时发生的增删改操作。完整性(每个操作都不会丢失)比较好。加载恢复数据慢、占空间  文本文件,是追加日志。
  * 二进制文件：存储数据类型编码的文件叫二进制文件。
- **镜像、快照、dump、db、序列化**：间隔(小数，天，10分钟等)的，内存全量数据基于某一个时间点做的向磁盘的溢写--I/O溢写慢。恢复速度快，但是因为是间隔的容易丢失一部分数据。
- hdfs：editslog 日志    fsimage 镜像，滚动更新
- 最近时点(9点)的fsimage + 增量(比如9~10点之间)的editslog，内存就可得到关机前的全量数据。



##### 安全模式

> NameNode存元数据：文件属性/每个块存在哪个DN上，在持久化时，文件属性会持久化，而文件的每一块位置信息不会持久化。在恢复的时候，NN会丢失块的位置信息，现在分布式时代，数据一致性最重要，所以要有安全模式存在的时候NN等待DN和其建立心跳检查，接收到的DN汇报的快信息，在等到NN中所有快信息一致的时候才向外提供服务。
>
> 属性：path  /a/b/c.txt 32G root:root rwxrwxrwx
>
> 块位置信息：blk01 node01 node03
>
> ​                       blk02 node02 node04

- 搭建HDFS会格式化，格式化时会产生一个空的FsImage
- NN启动时，从硬盘中读取editslog和fsimage
- 将editslog的事务作用到内存中的fsimage上
- 将这个一个新的fsimage从内存保存到本地磁盘上
- 删除旧的editlog，已经没用了。fsimage已经包含它了
- 文件的属性会持久化，**但是块的信息不会持久化**，说白了恢复的时候NN不知道块的信息。等DN和NN心跳 汇报块的信息。
- NN启动会进入安全模式，等待和DN的通信收集块的信息。
- 处于安全模式的NameNode是不会进行数据块的复制和增删改操作
- NameNode从所有的DataNode接收心跳信号和块状态报告
- 每当NameNode检测确认某个数据块的副本数目达到这个最小值，那么该数据块就会被认为是副本安全(safely replicated)
- 在一定百分比(这个参数课配置)的数据库被NameNode检测确认是安全后(加上一个额外的30秒等待时间)，NameNode将退出安全模式状态
- 接下来会确定还有哪些数据块的副本没有达到指定数目，并将这些数据块复制到其他DataNode上

##### HA模式

> 主从集群:结构相对简单,主与从协作
>
> 主:单点,数据一致性更好把握
>
> 问题:
>
> - 单点故障,集群整体就会不可用
> - 压力过大,内存受限

![1563690176935](image/1563690176935.png)

NN只有一个节点的时候会发生:

**CA(最容易实现)：**关系型数据REDMS，事务、单机、日志、可靠性、持久化性质，如果MySQL做主备的时候就会出现分区容忍性差问题，因为在同步的时候一定会出现延迟和不一致现象。

CP：

**P-分区容忍性**(脑裂):系统部分节点出现故障后，连接正常节点还可以使用系统提供的服务。

![1563691371156](image/1563691371156.png)

**单点故障**,导致**集群整体不可用**:black_heart::

- 高可用方案,HA(Hight Available)
- 多个NN,主备切换

**压力过大，内存受限**。

- **[联邦机制](#联邦机制)**：Federation(元数据分片)
- 多个NN,管理不同的元数据

HADOOP 2.x只支持HA的一主一备,不支持一主多备

HADOOP 3.x 可支持HA一主五备,官方推荐一主三备

![1564037325135](image/1564037325135.png)

![1564071939104](image/1564071939104.png)

> ​         HA分布式时要强一致性破坏NN对外服务的可用性(**CP**),HA通过client操作来实现数据同步，添加NN备份节点就是为了规避单点NN对外服务的的不可用性。
>
>  HA采用的是**弱一致性或者最终一致性**。



初始化的时候要手动选举那个NN为Active,当一个NN宕机的时候,Standby的那个NN升级成为Active的NN。

###### 解决思路

- 分布式节点明确;
- 节点权重明确,主从集群来自我协调。
  - 手动进行节点的权重值分配,然后根据权重进行选择那个是主节点那个是从节点; 
  - 初始化的时候会从集群中拿出ip值,主机自己里面的某个值推算出某个值,这个值一定是不冲突的
- 过半通过可以和中一致性和可用性，没有过半约束或者切换不完全的时候会出现**脑裂现象**,系统是不是出现这现象（分区是可以出现这情况）。
  - JN集群中获取最新版本那个节点选举主节点
  - <font color="red"  face="楷体">如果最新版本的那个ID可能一样的话,就会随机生成ID来比较那个最大的就选举为主节点</font>
- HA和**JN**之间消息一致性,解决方式是通过[Paxos算法](#Paxos算法)(消息传递的一致性算法)
- **ZKFC**
  - NN(Active-对外提供服务)是在同一个物理机上如果不在同一主机的话由网络进行连接的都有些相对不可靠性(**ZKFC对NN的健康检查就会出现不可靠性**)，NN(Active)也是一个进程。<font color="red"  face="楷体">**Monitor Health  Of NN,OS,HW**</font>
  - 向ZK定期发送心跳，使自己可以被选举。
  - ZKFC(Standby)进行就会在ZK中拿到ZKFC(Active)进程所在的主机宕机时所释放的锁,并使NN(Active)降级
- ZK 和JN
  - ZK是一个可靠的**分布式协调集群**,是对NN的角色分配
    - 好多技术在早期都是强依赖Zookeeper,最后都会尽量分离对Zookeeper技术的依赖
    - 是对事件的触发和某个事件的调用,不使用与存储
  - JN当做一个**分布式存储的消息队列集群**,是对NN的数据同步
  - ZK中也有目录树结构：

​       ZK中有一个目录树结构，其中含有一个锁，当某个ZKFC抢到该锁（在锁上注册两个的ZKFC回调函数和地址获取该锁）,里面包含了方法)后就会在同一物理机上的NN设置为Active，当NN Active挂掉同主机中的ZKFC就会在Zk之前抢到的锁删掉，这时就会**触发事件机制**(删除事件，触发事件比心跳检查锁是否存在更快，实时性强)->callback里面的方法和watch监控。就会触发跟NN Standby同主机的ZKFC中的回调函数方法，并重新抢锁。



**故障案例**：

* 当ZKFC(Active)进程不能和ZK进行通信也不能和NN(Standby)进行网络通信,但可以跟NN,Client进行通信：

  这时就会释放ZKFC(Active)在ZK上的锁,然后ZKFC(Standby)就会立马抢到ZK上面的锁,可以通过**串口通信**把所在的服务器进行断电和降级,把NN(Standby)升级成为Active。运维问题---网络不通，出现问题于以太网。可做冗余电路。

  > 什么通信时可靠：在某个物理机除了网线还有串口总线(九针接口,点对点,另一端接到对方电源上),每台主机都同串口上拉出一根信号线搭在对方的电源模块上。

  ![1584632645931](image/1584632645931.png)

 

1. FailoverController实现下述几个功能

  (a) 监控NN的健康状态

  (b) 向ZK定期发送心跳，使自己可以被选举。

  (c) 当自己被ZK选为主时，active FailoverController通过RPC调用使相应的NN转换为active。

1. 为什么要作为一个deamon进程从NN分离出来

  (1) 防止因为NN的GC失败导致心跳受影响。

  (2) FailoverController功能的代码应该和应用的分离，提高的容错性。

  (3) 使得主备选举成为可插拔式的插件。

![img](image/261600009163275.png)

图2 FailoverController架构（从社区复制）

1. FailoverController主要包括三个组件，

  (1) HealthMonitor 监控NameNode是否处于unavailable或unhealthy状态。当前通过RPC调用NN相应的方法完成。

  (2) ActiveStandbyElector 管理和监控自己在ZK中的状态。

  (3) ZKFailoverController 它订阅HealthMonitor 和ActiveStandbyElector 的事件，并管理NameNode的状态。



###### 联邦机制

> * 把元数据切割开放入多个NN，每个NN只能看到公司元数据的1/n，不能获取全部元数据。(元数据分片)
>
> * 多个NN同时对外提供服务，每个NN分管一部分目录，每个NN共享底层DN存储(**元数据分治,复用DN存储**)
>
> * 此时每个NN都存在单点故障问题,所以需要再给Federation节点配置一个备用NN
> * 好处：单个NN内存和并发压力减小，NN彼此隔离，互不影响，元数据访问隔离性
> * DN目录隔离block
> * 应用场景：开发测试分不同NN
>   * 根据不同业务创建不同NN
>   * 根据不同需求创建不同NN

​        每个NN之间共用一套DN来存储数据，而NN来记录相对应文件的元数据，NN之间却又会不干扰，不受对方影响。企业中主机的CPU不是100%高负荷运转，其实70~80%部分时间都是低负荷运转着。这之间有一个时间差，在共享的DN中创建对应NN的相对目录；当某个NN不在运作的时候，另一个NN就使用共用的DN。NN服务器和DN服务器中的某个目录之间的关系。

​        如果要统计全量数据时，这时在每个NN外层建立一个虚拟文件系统（代理层，文件存储平台，可以当做云平台服务），对外服务也是一种文件系统，其中挂载了不同目录来映射指向不同NN，客户端就可以只需要遍历访问虚拟文件系统中的目录。虚拟文件系统中的目录可以映射不同的文件系统存储层和API调用，比如FTP，虚拟文件系统向外提供接口。

![HDFS2.0之Federation](image/HDFS2.0之Federation.jpg)

**云服务：基础级服务，平台级服务，软件级服务等**



###### Paxos算法

- 可以根据自己技术的特性选择**简化**算法实现
  * 分布式节点是否明确：在确定的条件下算法就不会随着节点的增加而变的更加复杂
  * 节点权重(条件)是否明确：最终可以把投票争抢变的有谦让式选举投票
  * 强一致性(同步阻塞通信)破坏可用性(异步非阻塞通信)，可采用**过半通过选择**来中和一致性和可用性，最后达到最终一致性或者弱一致性
  * 主的选举：明确节点数量和权重可以快速选出主节点
  * 主从的职能：
    * 主：增删改查
    * 从：查询，增删改功能传递给主，然后把增删改操作后的数据同步()到从节点
    * 主与从：过半数同步数据
- 传递：NN之间通过一个可靠的传输技术，最终数据能同步,尽量使用简化版协议。
- 假设网络等因素是稳定的，类似一种带存储能力的消息队列

在通信的时候有**同步阻塞模型**和**异步非阻塞模型**.



###### 自动触发主备选举
1. NameNode 在选举成功后，ActiveStandbyElector会在 zk 上创建了一个/hadoopha/${dfs.nameservices}/ActiveStandbyElectorLock 临时节点，而没有选举成功的备 NameNode 中的 ActiveStandbyElector会监控这个节点，通过 Watcher 来监听这个节点的状态变化事件，ZKFC 的 ActiveStandbyElector 主要关注这个节点的 NodeDeleted 事件（这部分实现跟 Kafka 中 Controller 的选举一样）。
2. 如果 Active NameNode 对应的 HealthMonitor 检测到 NameNode 的状态异常时， ZKFailoverController 会主动删除当前在 Zookeeper 上建立的临时节点 /hadoopha/{dfs.nameservices}/ActiveStandbyElectorLock，这样处于 Standby 状态的 NameNode 的 ActiveStandbyElector 注册的监听器就会收到这个节点的 NodeDeleted 事件。收到这个事件之后，会马上再次进入到创建 /hadoop-ha/{dfs.nameservices}/ActiveStandbyElectorLock 临时节点的流程，如果创建成功，这个本来处于 Standby 状态的 NameNode 就选举为主 NameNode 并随后开始切换为 Active 状态。
3. 当然，如果是 Active 状态的 NameNode 所在的机器整个宕掉的话，那么跟zookeeper连接的客户端线程也挂了,会话结束,那么根据 Zookeepe的临时节点特性，/hadoop-ha/${dfs.nameservices}/ActiveStandbyElectorLock 节点会自动被删除，从而也会自动进行一次主备切换



###### HA解决方案

* 多台NN主备模式，Active和Standby状态

  Active对外提供服务

* 增加journalnode角色(>3台)，负责同步NN的editlog

  最终一致性

* 增加zkfc角色(与NN同主机)，通过Zookeeper集群协调NN的主从选举和切换

  事件回调机制

* DN同时向NNs汇报block清单



###### HA搭建

- **Zookeeper**:zookeeper的进程在通信连接使用的时候,有两个状态:
  - 1)角色分配,主从状态的时候,即正在明确知道leader 和follower角色时,**使用角色的时候**
  - 2)leader挂掉了,无主状态下重新选举的时候,即zookeeper**动态选举**leader 和follower



1. 修改hdfs-site.xml配置文件

```xml
<configuration>
   <property>
        <name>dfs.replication</name>
        <value>2</value>
   </property>
   <property>
        <name>dfs.namenode.name.dir</name>
        <value>/var/bigdata/hadoop/ha/dfs/name</value>
   </property>
   <property>
        <name>dfs.datanode.data.dir</name>
        <value>/var/bigdata/hadoop/ha/dfs/data</value>
   </property>

   <!-- 以下是  一对多，逻辑到物理节点的映射-->
   <property>
        <name>dfs.nameservices</name>
        <value>mycluster</value>
   </property>
   <property>
        <name>dfs.ha.namenodes.mycluster</name>
        <value>nn1,nn2</value>
   </property>
   <property>
        <name>dfs.namenode.rpc-address.mycluster.nn1</name>
        <value>node01:8020</value>
   </property>
   <property>
        <name>dfs.namenode.rpc-address.mycluster.nn2</name>
        <value>node02:8020</value>
   </property>
   <property>
        <name>dfs.namenode.http-address.mycluster.nn1</name>
        <value>node01:50070</value>
   </property>
   <property>
        <name>dfs.namenode.http-address.mycluster.nn2</name>
        <value>node02:50070</value>
   </property>

   <!-- 以下是JN在哪里启动，数据存那个磁盘，共用JN,mycluster表示隔离NN集群 -->
   <property>
        <name>dfs.namenode.shared.edits.dir</name>
        <value>qjournal://node01:8485;node02:8485;node03:8485/mycluster</value>
   </property>
   <property>
        <name>dfs.journalnode.edits.dir</name>
        <value>/var/bigdata/hadoop/ha/dfs/jn</value>
   </property>

    <!-- HA角色切换的代理类和实现方法，我们用的ssh免密,企业不会在root用户下启动,用户和超级用户有绑定-->
   <property>
        <name>dfs.client.failover.proxy.provider.mycluster</name> <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
   </property>
   <property>
        <name>dfs.ha.fencing.methods</name>		 
        <value>sshfence</value>
   </property>
   <property>
        <name>dfs.ha.fencing.ssh.private-key-files</name>
        <value>/root/.ssh/id_dsa</value>
   </property>

    <!-- 开启自动化： 在执行start-dfs.sh执行脚本后,跟NN同机启动zkfc,zkfc不需要指定哪个节点。 -->
   <property>
        <name>dfs.ha.automatic-failover.enabled</name>
        <value>true</value>
   </property>
</configuration>
```

2、core-site.xml

```xml
   <property>
	  <name>fs.defaultFS</name>
	  <value>hdfs://mycluster</value>
	</property>

	 <property>
	   <name>ha.zookeeper.quorum</name>
	   <value>node02:2181,node03:2181,node04:2181</value>
	 </property>
```
node02~node04节点上

```shell
###启动zookeeper集群
zkServer.sh start
###查看zookeeper状态
zkServer.sh status
```

在node01节点上

```shell
###增量分发hadoop配置文件到node02~node04节点上
scp core-site.xml hdfs-site.xml node02:`pwd`
```

在node01~node03节点上启动JNN

```shell
hadoop-daemon.sh start journalnode
```

在node03节点上

```shell
 ###此时该目录为空
 ll /var/bigdata/hadoop/ha/dfs/jn/
```

另开一个窗口

```shell
cd $HADOOP_HOME/logs
###堵塞显示某个日志
tail -f hadoop-root-journalnode-node03.log 
```

node01格式化

```shell
hdfs namenode -format 
```

查看节点元数据信息

```shell
cat /var/bigdata/hadoop/ha/dfs/current/VERSION
```



这时在node03节点上有了

```shell
ll /var/bigdata/hadoop/ha/dfs/jn/mycluster/current
##中有文件VERSION
```

在node01上启动hadoop

```shell
hadoop-daemon.sh start namenode
```

在node02进行同步

```shell
hdfs namenode -bootstrapStandby
```

在node02查看文件

```shell
cd /var/bigdata/hadoop/ha/dfs/name/current/
cat VERSION
```

在node04节点上

```shell
###开启一个Zk客户端
zkCli.sh
```

流程：

> ​	基础设施
> ​		 ssh免密：
> ​			1）启动start-dfs.sh脚本的机器需要将公钥分发给别的节点
> ​			2）在HA模式下，每一个NN身边会启动ZKFC，NN之间也需要进行免密
> ​				ZKFC会用免密的方式控制自己和其他NN节点的NN状态
> ​	应用搭建
> ​		HA 依赖 ZK  搭建ZK集群
> ​		修改hadoop的配置文件，并集群同步
> ​	初始化启动
> ​		1）先启动JN   hadoop-daemon.sh start journalnode 
> ​		2）选择一个NN 做格式化：hdfs namenode -format   <只有第一次搭建做，以后不用做>
> ​		3)启动这个格式化的NN ，以备另外一台同步  hadoop-daemon.sh start namenode 
> ​		4)在另外一台机器中： hdfs namenode -bootstrapStandby
> ​		5)格式化zk：   hdfs zkfc  -formatZK     <只有第一次搭建做，以后不用做>
> ​		6) start-dfs.sh

使用

------实操：

		1）停止之前的集群
		2）免密：node01,node02
			node02: 
				cd ~/.ssh
				ssh-keygen -t dsa -P '' -f ./id_dsa
				cat id_dsa.pub >> authorized_keys
				scp ./id_dsa.pub  node01:`pwd`/node02.pub
			node01:
				cd ~/.ssh
				cat node02.pub >> authorized_keys
		3)zookeeper 集群搭建  java语言开发  需要jdk  部署在2,3,4
			node02:
				tar xf zook....tar.gz
				mv zoo...    /opt/bigdata
				cd /opt/bigdata/zoo....
				cd conf
				cp zoo_sample.cfg  zoo.cfg
				vi zoo.cfg
					datadir=/var/bigdata/hadoop/zk
					server.1=node02:2888:3888
					server.2=node03:2888:3888
					server.3=node04:2888:3888
				mkdir /var/bigdata/hadoop/zk
	                                               ### 配置每台的权重值到固定的myid文件中
				echo 1 >  /var/bigdata/hadoop/zk/myid 
				vi /etc/profile
					export ZOOKEEPER_HOME=/opt/bigdata/zookeeper-3.4.6
					export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$ZOOKEEPER_HOME/bin
				. /etc/profile
				cd /opt/bigdata
				scp -r ./zookeeper-3.4.6  node03:`pwd`
				scp -r ./zookeeper-3.4.6  node04:`pwd`
			node03:
				mkdir /var/bigdata/hadoop/zk
				echo 2 >  /var/bigdata/hadoop/zk/myid
				*环境变量
				. /etc/profile
			node04:
				mkdir /var/bigdata/hadoop/zk
				echo 3 >  /var/bigdata/hadoop/zk/myid
				*环境变量
				. /etc/profile
	        node02~node04:
			    zkServer.sh start
	
	4）配置hadoop的core和hdfs
	5）分发配置
		给每一台都分发
		scp core-site.xml hdfs-site.xml node02:`pwd`
		scp core-site.xml hdfs-site.xml node03:`pwd`
		scp core-site.xml hdfs-site.xml node04:`pwd`
	6）初始化：
		1）先启动JN   hadoop-daemon.sh start journalnode 
		   node01~node03:/var/bigdata/hadoop/ha/dfs/jn这个目录下为空
		2）选择一个NN 做格式化：hdfs namenode -format   <只有第一次搭建做，以后不用做>
		
		   ①初始化node01时 /var/bigdata/hadoop/ha/dfs/目录下除了jn多了name目录
		   ②node03下:tail -f  $HADOOP_HOME/logs/hadoop-root-journalnode-node03.out阻塞式查看日志
		   JN主机下的就会随着初始化node01下的JN生成node03:/var/bigdata/hadoop/ha/dfs/jn/mycluster目录
		   
		3)启动这个格式化的NN ，以备另外一台同步  hadoop-daemon.sh start namenode 
		
		4)在另外一台NN机器中： hdfs namenode -bootstrapStandby
		   node02时 /var/bigdata/hadoop/ha/dfs/目录下除了jn多了name目录
		
		5)格式化zk：   hdfs zkfc  -formatZK     <只有第一次搭建做，以后不用做>
		  作用是创建节点目录
		  node04 命令zkServer.sh下可以看到ls /hadoop-ha目录下有mycluster	   

使用验证

```shell
使用验证：
	1）去看jn的日志和目录变化：
	2）node04
		zkCli.sh 
			ls /
			格式化后可以看到hadoop-ha
			启动之后可以看到锁：
			get  /hadoop-ha/mycluster/ActiveStandbyElectorLock
	3）杀死namenode 杀死zkfc
		kill -9  xxx
		a)杀死active NN
		b)杀死active NN身边的zkfc
		c)shutdown activeNN 主机的网卡 ： ifconfig eth0 down
			2节点一直阻塞降级  查看hadoop日志 
                                                    cd $HADOOP_HOME/logs    
                                                    tail -f tail -f hadoop-root-zkfc-node02.log
			如果恢复1上的网卡   ifconfig eth0 up  
			最终 2编程active
```





###### HDFS的权限

- hdfs没有相关命令和接口去创建用户
  ​		信任客户端 <- 默认情况使用的 操作系统提供的用户
  ​				扩展 kerberos LDAP  继承第三方用户认证系统
- 有超级用户的概念
  ​		linux系统中超级用户：root
  ​		hdfs系统中超级用户： 是namenode进程的启动用户
  ​                                        查看hdfs启动是哪个用户启动的

```shell
###查看NN的进程
[root@node01 ~]# jps
5921 DFSZKFailoverController
6515 NameNode
3683 JournalNode
1592 Bootstrap
7243 Jps
####查看6515进程的用户为root也就是root用户下启动hdfs
[root@node01 ~]# ps -ef
root       6515      1  0 22:21 pts/0    00:00:38 /usr/java/default/bin/java -Dproc_namenode -Xmx1000m -Djava.net.preferIPv4Stack=true -Dhadoop.log.dir=/opt/bigdata/hadoop-2.6.5/logs -Dhadoop
```

![1564279577021](image/1564279577021.png)

- 有权限的概念

​               hdfs的权限是自己控制的 来自于hdfs的超级用户

node01~node04

```shell
useradd god
passwd god
##或者
##echo 将密码通过管道符送到 passwd,
##--stdin 参数用于获取标准输入,此处从管道符中获取标准输入后的密码,非常必要,不可省;
echo 密码 | passwd --stdin 用户名;
##给hadoop相关软件和相关log文件只赋god用户

chown -R god /opt/bigdata/hadoop-2.6.5/
chown -R god /var/bigdata/hadoop/
```

- 重新在新建的用户god下免密

  ```shell
  su god
  ssh localhost
  ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
  cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
  ###翻车---ssh localhost后还要输入密码
  rm -fr authorized_keys
  ssh-copy-id id_dsa node01
  ###正确操作,修改authorized_keys文件的权限
  chmod 600  authorized_keys
  ```



##### 副本机制

> HDFS上的文件对应的block保存多个副本，且提供容错机制，副本丢失或宕机自动回复。默认存3份副本。

###### 副本放置策略

> 塔式服务器
>
> 机架服务器
>
> 刀片服务器

- 第一个 如果客户端上有DN 那就放本地的DN,放在和DN同一节点上；如果集群外提交，则随机挑选一台磁盘不太满，CPU不太忙的节点上。
- 第二个和第一个不同的机架
- 第三个和第二个相同机架（在同一交换机下就可以减少IO成本）

之前版本的Hadoop版本，如果节点就两个的话，副本如果都在一个节点的话，如果这台节点挂的话，副本都会失效，没能起到副本应有的作用。2.x以后就要求第二个副本一定要跨节点放置。

###### 副本系数

​       (1)对于上传文件到HDFS时，当时Hadoop的副本系数是几，那么这个文件的快副本数就有几份,无论以后怎么更改系统副本系数，这个文件的副本数都不会改变。也就是说上传到HDFS系统的文件副本数是由当时的系统副本数决定的，不会受副本系数修改影响。

​       (2)在上传文件时可以指定副本系数, ``dfs.replication``是客户端属性,不指定具体的replication时采用默认副本数;文件上传后,备份数已经确定,修改df.replication不会影响以前的文件,也不会影响后面指定备份数的文件,只会影响后面采用默认备份数的文件。

​       (3) replication默认是由客户端决定的,如果客户端未设置才会去配置文件中读取

​       (4)如果在``hdfs-site.xml中``设置了 dfs.replication=1,这也并不一定就是块的备份数是1,因为可能没把 hdfs-site.xml加入到工程的 classpath里,那么我们的程序运行时取的 dfs.replication可能是 ``hdfs-default.xml``中dfs.replication的默认值3;可能这就是造成为什么 dfs.replication总是3的原因。

```shell
hadoop fs strep 3 test/test.txt
hadoop fs-Is test/test. txt
```

​     此时 test. txt的副本系数就是3了,但是重新put一个到hdfs系统中,备份块数还是1(假设默认dfs. replication的值为1)。



##### HDFS读写流程

###### HDFS文件读流程

流水线也是一种变种的并行

![hdfs读流程](image/hdfs读流程.png)

![HDFS读文件内部工作机制](image/HDFS读文件内部工作机制.jpg)

 读：能够选择块进行读！并行计算的前提。 

* 为了降低整体的带宽消耗和读取延时，HDFS会尽量让读取离程序最近的副本
* 如果在读取程序的同一个机架上有一个副本,那么就读取该副本
* 如果一个HDFS集群跨域多个数据中心,那么客户端也将首先读取本地数据中心的副本
* 语义:下载一个文件:
  * client和NN交互文件元数据获取全量fileBlockLocation
  * NN会按距离策略排序返回
  * Client尝试下载block并校验数据完整性
* 语义:下载一个文件其实是获取文件的所有的block元数据,那么子集获取某些block应该成立
  * <font color=red>HDFS支持client给出文件的offset自定义连接哪些block的DN,自定义获取数据</font>
  * <font color=red>这个是支持计算层的分治,并行计算的核心</font>

###### HDFS文件写流程

![hdfs写流程](image/hdfs写流程.png)

![hdfs写文件机制解析](image/hdfs写文件机制解析.jpg)

写：在某个时间点client在传其中一个快三个副本示意图

* client和NN连接创建文件元数据
  * client通过DistributedFileSystem上的create()方法**指明**一个欲创建的文件的文件名（第一步），DistributedFileSystem再通过RPC调用向NameNode申请创建一个新文件（第二步，这时该文件还没有分配相应的block）。
* NN判断元数据是否有效
  * NN检查是否有同名文件存在以及用户是否有相应的创建权限，如果检查通过，NN会为该文件创建一个新的记录，否则的话文件创建失败，客户端得到一个IOException异常。DistributedFileSystem返回一个FSDataOutputStream以供客户端写入数据，与FSDataInputStream类似，FSDataOutputStream封装了一个DFSOutputStream用于处理namenode与datanode之间的通信。
* NN处发副本放置策略，返回一个有序的DN列表
* Client和DN监理Pipeline连接
* Client将块分成packet（64kb，buffer），并使用chunk（512b）+chucksum（4b，校验值）填充满后再发送
* Client将packet放入发送队列dataqueue，并向第一个DN发送
* 第一个DN收到packet后本地保存（一份存入内存一份存入磁盘）并发送给第二个DN
* 第二个DN收到packet后本地保存并发送给第三个DN
* 这一个过程中，上游节点同时发送下一个packet
* <font color=red>生活中类比工厂的流水线；结论：流式其实也是变种的并行计算</font>
* HDFS使用这种传输方式，副本数对于client是透明的
* 当block传输完成，DN各自向NN汇报，同时client继续传输下一个block
* 所以，client的传输和block的汇报也是并行的



过程如下：



HDFS安装



#### [Hadoop官方文档](<http://hadoop.apache.org/docs/r1.0.4/cn/hdfs_design.html>)

#### Hadoop常用命令

```shell
### 创建一个目录
hdfs dfs -mkdir /temp
### 遍历100000条数据到data.txt文件中
for i in `seq 100000`;do echo "hello msb $i" >> data.txt;done
### 在当前目录的data.txt上传到hdfs中
hdfs dfs -D dfs.blocksize=1048576 -put data.txt
###:给目录分配一个组
hdfs dfs chgrp ooxx /temp 

hdfs dfs -chown god:ooxx /temp
```



`hdfs dfsadmin`

`hdfs`:查看hdfs命令帮助

`hdfs groups`:查看当前用户是否在ooxx组下面,因为`usermod -a -G ooxx good`只是在本地授权ooxx组给good用户,但hdfs启动类没有在hdfs上刷新权限，要在超级管理员用户god下通过`hdfs dfsadmin -refreshUserToGroupsMappings`命令来刷新到hdfs中。



#### 代码展现分治计算

读取某个块数据的时候,要通过in.seek(desired)中某个块的偏移量来分治计算自己的那个块。

```java
package com.msb.hadoop.hdfs;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.*;
import org.apache.hadoop.io.IOUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.io.*;
import java.net.URI;

public class TestHDFS {

    public Configuration conf = null;
    public FileSystem fs = null;

    //C/S
    @Before
    public void conn() throws Exception {
        conf = new Configuration(true);//true
//        fs = FileSystem.get(conf);
//       <property>
//        <name>fs.defaultFS</name>
//        <value>hdfs://mycluster</value>
//       </property>
        //去环境变量 HADOOP_USER_NAME  god
        fs = FileSystem.get(URI.create("hdfs://mycluster/"),conf,"god");
    }

    @Test
    public void mkdir() throws Exception {

        Path dir = new Path("/msb01");
        if(fs.exists(dir)){
            fs.delete(dir,true);
        }
        fs.mkdirs(dir);

    }

    @Test
    public void upload() throws Exception {

        BufferedInputStream input = new BufferedInputStream(new FileInputStream(new File("./data/hello.txt")));
        Path outfile   = new Path("/msb/out.txt");
        FSDataOutputStream output = fs.create(outfile);

        IOUtils.copyBytes(input,output,conf,true);
    }

    @Test
    public void blocks() throws Exception {

        Path file = new Path("/user/god/data.txt");
        FileStatus fss = fs.getFileStatus(file);
        BlockLocation[] blks = fs.getFileBlockLocations(fss, 0, fss.getLen());
        for (BlockLocation b : blks) {
            System.out.println(b);
        }
//        0,        1048576,        node04,node02  A
//        1048576,  540319,         node04,node03  B
        //计算向数据移动~！
        //其实用户和程序读取的是文件这个级别~！并不知道有块的概念~！
        FSDataInputStream in = fs.open(file);  //面向文件打开的输入流  无论怎么读都是从文件开始读起~！

//        blk01: he
//        blk02: llo msb 66231

        in.seek(1048576);
        //计算向数据移动后，期望的是分治，只读取自己关心（通过seek实现），同时，具备距离的概念（优先和本地的DN获取数据--框架的默认机制）
        System.out.println((char)in.readByte());
        System.out.println((char)in.readByte());
        System.out.println((char)in.readByte());
        System.out.println((char)in.readByte());
        System.out.println((char)in.readByte());
        System.out.println((char)in.readByte());
        System.out.println((char)in.readByte());
        System.out.println((char)in.readByte());
        System.out.println((char)in.readByte());
        System.out.println((char)in.readByte());
        System.out.println((char)in.readByte());
        System.out.println((char)in.readByte());
    }

    @After
    public void close() throws Exception {
        fs.close();
    }
}
```

#### MapReduce

##### 计算模型

> 在MR中组是最小粒度不可分，也就是组不能打散到不同分区里（不同ReduceTask）。
>
> 在ReduceTask中由1个ReduceTask设置N个的时候，分组不能打散到不同分区中去，相同key为一组不能对应多个分区
>
> 数据以一条记录为单位经过map方法映射成KV，相同的key为一组，这一组数据的迭代器(对象)调用一次reduce方法，在方法内迭代计算着一组数据。其实数据不是在内存而是在磁盘中，对此文件打开I/O包装成一个迭代器，迭代器HashSet有没有,like取一条就从文件中redline读出第一条接着在文件中拿出第二条。规避了大数据有可能出现的内存溢出。
>
> MR也就是分组统计计算框架，更多的是要去使用bufferIO

| block > split | split > map | map > reduce | group(key)>partition       |
| ------------- | ----------- | ------------ | -------------------------- |
| 1:1           | 1:1         | N:1          | 1:1                        |
| N:1           |             | N:N          | N:1                        |
| 1:N           |             | 1:1          | N:N                        |
|               |             | 1:N          | <font color=red>1:N</font> |

![1586050446093](image/1586050446093.png)

###### Map

  >  其实现原理为过滤,以一条记录为单位做映射。(**一条记录为单位**)
  >
  >  ​      **map阶段中并行度**由split数量确定，一个map计算对应一个split
  >
  >  ​      根据**输入格式化类format**以某一范围为单位进行某一定范围(数组)的切片来确定一行内容,根据split确定某一行记录并这条记录来调用map方法。
  >
  >  ​      一个blk中可以根据split中的format格式化类标准来确定是以换行符为一行还是以标识符为一行做为一条记录，从offset为0的位置开始累积可以做为一条记录的字节数组调用map方法计算。
  >
  >  ​      MR框架默认Map并行度数量为blk的数（一个切片对应一个blk）。

  - 过滤某条件的数据，转换码值为字典值，展开字段复合值。

    - I/O会触发调用内核,CPU计算JVM中的逻辑代码

    - 如果调用I/O的话,写的字符串要从进程写入磁盘里,CPU就不会调用用户代码,就会由**用户态转换成内核态**,会切换到内核态-操作系统的Kernel级别,Kernel才是I/O中API真正调用的实例方法,然后这时内核来读取数据并放在缓存区然后永久存在磁盘中。

      可以把数据放在buffer中,溢写后一次性调用I/O，在调用I/O之前要进行分区有序排序已文件形式存入磁盘中。

    - 任务的进程如果想访问硬件的话就叫**内核**

      ![写场景下的DirectIO和BufferIO](image/写场景下的DirectIO和BufferIO.jpg)

![å¨è¿éæå¥å¾çæè¿°](image/20181018183154271.png)

###### Reduce
> Key-Value键值对，通过相同特征来分组----也就是相同key(相同特征)的为一组来记录，最后以这一组为单位来计算。(**一组为单位**),依赖数据格式为`key:value`，不同组分布在各个节点并行计算。
>
> Reduce的并行度由客户端决定，如果按照从map进行K/V计算后的K数来确定Reduce组个数的话，就会出现资源大量浪费，这时就可能会出现一个Reduce线性计算处理多个组数据。
>
> MR框架默认Reduce数量为一个，没有达到并行，所以人为一定要设置Reduce的数量。
>
> 每个ReduceTask中有merge、reduce方法和part,每个ReduceTask中有多个组数据作为分区数据。

![1564627748307](image/1564627748307.png)

MapReduce隐藏的数据集有: 输入数据集 -> 中间数据集 -> 最终结果集 ,只给出方法的实现(**map()**)和计算的实现(**Reduce()**),没有给出API层面的数据集概念。组不可切分。

map映射reduce合并相同组。

![MapReduce各个执行阶段](image/MapReduce各个执行阶段.jpg)

![MapReduce各个执行阶段](image/MapReduce各个执行阶段.png)

###### 有了blk为啥还要split

> ​        加上split这一层是为了解耦,因为split有窗口机制表。可以根据不同项目组、不同类型**计算**来确定split的大小，此时可能等于blk固定的大小、小于甚至大于。**加一层来解耦**
>
> ​        HDFS中设置blk大小时,当大的时候可以一次性进行IO传输大部分数据,如果设置更大的话一次传输过来的数据里面含有大量业务数据时进行复杂迭代计算出结果。**这时就要控制blk和split之间计算的并行度**。
>
> ​       blk是有偏移量offset和blk大小和物理方面上真正在HDFS上进行切割，而split是逻辑方面上的切片可以复用blk的offset和blk大小，blk上有location信息(blk在哪台机器上有副本,split也可以复用其信息)split获取到副本信息决定map中的计算程序最终移动到那一台计算机中去。**更好支持计算向数据移动**
>
>
>
> [计算分两大类](#CPU密集型 VS IO密集型)：
>
> * CPU密集型<font color=red>计算</font>
>
>   进行大量的计算，消耗CPU资源
>
> *  IO密集型<font color=red>读写</font>
>
>   反复读取磁盘文件



###### 计算如何向数据移动

> 计算向数据移动，移动到DN的计算程序就是JVM进程交给**JobTracker**管理者来管理选择合适DN移动，移动的是JVM。
>
> 那JVM如何在另外节点启动，占用多少资源并管理这些任务，是否执行成功，创建拉取销毁这些计算程序（计算的角色）？计算的角色(**TaskTracker**)必须和存储的从角色(DN)是1:1比例关系，此时也必须拥有专门运行计算程序的cli
>
>
>
> * hdfs暴露数据的位置
>
> * 计算移动
>
>   * 资源管理：
>
>     集群整体节点资源管理
>
>   * 任务调度
>
>     每次计算程序不一样，每次blk是向不同节点去，调度程序按照每次提交的任务需要计算的数据分布，掌管资源情况，并向合适DN节点分发
>
> * **角色：JobTracker&TaskTracker**
>
>   JobTracker：资源管理、任务调度（主）
>
>   TaskTracker(管理启动的计算程序JVM任务进程)：任务管理、资源汇报（从）
>
> * k客户端
>  1. 会根据每次计算数据，咨询NN的元数据(block)。算:split 得到一个切片的清单
>     map的数量就有了
>
>  2. split是逻辑的，block是物理的，block身上有(offset,locatios)，split和block是有映射关系的。
>      结果：split包含偏移量，以及split对应的map任务应该移动到哪些节点(locations)
>      可以支持计算向数据移动了~!
>      生成计算程序未来运行时的文件
>
>  3. 未来的移动应该相对可靠
>
>      cli会将jar,split清单，配置xml，上传到hdfs的目录中（上传的数据，副本数为10）
>
>  4. cli会调用JobTracker，通知要启动一个计算程序了，并且告知文件都放在了hdfs的哪个地方
>



##### 输入分片（input split）

​         一个大的文件会根据block块切分成多个分片，每个输入分片会让一个map任务来处理（默认情况下，HDFS的块为128M作为一个分片）。
​       例如一个300MB的文件就会被切分问3个分片（128MB InputSplit、128MB InputSplit、44MB InputSplit），交给三个map任务去处理。

​       切片会格式化出记录，以记录为单位调用map方法



##### map任务阶段

​         由我们自己编写，最后调用 context.write(…)；
​         map输出的结果会暂且放在一个环形内存缓冲区中（`默认mapreduce.task.io.sort.mb=100M`）,当该缓冲区快要溢出时（`默认mapreduce.map.sort.spill.percent=0.8`）,会在本地文件系统中创建一个溢出文件，将该缓冲区中的数据写入这个文件；

##### partition分区阶段

- 在map中调用 context.write(k2,v2)方法输出<k2,v2>，该方法会立刻调用 Partitioner类对数据进行分区，一个分区对应一个 reduce task。
- 默认的分区实现类是 `HashPartitioner` ，根据`k2的哈希值 % numReduceTasks`，可能出现“数据倾斜”现象。
- 可以自定义 partition ，调用 job.setPartitioner(…)自己定义分区函数。

##### combiner合并阶段

   将属于同一个reduce处理的输出结果进行合并操作

- 是可选的；
- 目的有三个：1.减少Key-Value对；2.减少网络传输；3.减少Reduce的处理。

##### shuffle阶段

​      即Map和Reduce中间的这个过程

- 首先 `map` 在做输出时候会在内存里开启一个环形内存缓冲区，专门用来做输出，同时map还会启动一个守护线程；

- 如缓冲区的内存达到了阈值的80%，守护线程就会把内容写到磁盘上，这个过程叫`spill`，另外的20%内存可以继续写入要写进磁盘的数据；

- 写入磁盘和写入内存操作是互不干扰的，`如果缓存区被撑满了，那么map就会阻塞写入内存的操作`，让写入磁盘操作完成后再继续执行写入内存操作;

- 写入磁盘时会有个排序操作，如果定义了combiner函数，那么排序前还会执行combiner操作;

- 每次spill操作也就是写入磁盘操作时候就会写一个溢出文件，也就是说在做map输出有几次spill就会产生多少个溢出文件，等map输出全部做完后，map会合并这些输出文件，这个过程里还会有一个Partitioner操作（如上）

- 最后 `reduce` 就是合并map输出文件，Partitioner会找到对应的map输出文件，然后进行复制操作，复制操作时reduce会开启几个复制线程，这些线程默认个数是5个（可修改），这个复制过程和map写入磁盘过程类似，也有阈值和内存大小，阈值一样可以在配置文件里配置，而内存大小是直接使用reduce的tasktracker的内存大小，复制时候reduce还会进行排序操作和合并文件操作，这些操作完了就会进行reduce计算了。

- Shuffle阶段说明

  ![img](image/Shuffle阶段说明.jpg)

  ​        shuffle阶段主要包括map阶段的combine、group、sort、partition以及reducer阶段的合并排序。Map阶段通过shuffle后会将输出数据按照reduce的分区分文件的保存，文件内容是按照定义的sort进行排序好的。Map阶段完成后会通知ApplicationMaster，然后AM会通知Reduce进行数据的拉取，在拉取过程中进行reduce端的shuffle过程。
  ​        注意:Map阶段的输出数据是存在运行Map节点的磁盘上，是个临时文件，不是存在HDFS上，在Reduce拉取数据后，那个临时文件会删除，若是存在hdfs上，会造成存储空间的浪费（会产生三个副本）。
  **用户自定义Combiner**
  ​        Combiner可以减少Map阶段的中间输出结果数，降低网络开销。默认情况下是没有Combiner的。用户自定义的Combiner要求是Reducer的子类，以Map的输出<key,value>作为Combiner的输入<key,value>和输出<key,value>，也就是说Combiner的输入和输出必须是一样的。
  ​       可以通过job.setCombinerClass设置combiner的处理类，MapReduce框架不保证一定会调用该类的方法。
  ​       注意：如果reduce的输入和输出一样，则可以直接用reduce类作为combiner
  **用户自定义Partitioner**
  ​       Partitioner是用于确定map输出的<key,value>对应的处理reducer是那个节点。默认MapReduce任务reduce个数为1个，此时Partitioner其实没有什么效果，但是当我们将reduce个数修改为多个的时候，partitioner就会决定key所对应reduce的节点序号(从0开始)。
  ​       可以通过job.setPartitionerClass方法指定Partitioner类，默认情况下使用HashPartitioner（默认调用key的hashCode方法）。

  ![img](image/20170902212239376.png)

  **用户自定义Group**
  ​        GroupingComparator是用于将Map输出的<key,value>进行分组组合成<key,List<value>>的关键类，直白来讲就是用于确定key1和key2是否属于同一组，如果是同一组，就将map的输出value进行组合。
  要求我们自定义的类实现自接口RawComparator，可以通过job.setGroupingComparatorClass方法指定比较类。默认情况下使用WritableComparator，但是最终调用key的compareTo方法进行比较。
  **用户自定义Sort**
  ​         SortComparator是用于将Map输出的<key,value>进行key排序的关键类， 直白来讲就是用于确定key1所属组和key2所属组那个在前，那个在后。
  ​        要求我们自定义的类实现自接口RawComparator，可以通过job.setSortComparatorClass方法指定比较类。默认情况下使用WritableComparator，但是最终调用key的compareTo方法进行比较。
  **用户自定义Reducer的Shuffle**
  ​        在reduce端拉取map的输出数据的时候，会进行shuffle(合并排序)，MapReduce框架以插件模式提供了一个自定义的方式，我们可以通过实现接口ShuffleConsumerPlugin，并指定参数`mapreduce.job.reduce.shuffle.consumer.plugin.class`来指定自定义的shuffle规则，但是一般情况下，直接采用默认的类`org.apache.hadoop.mapreduce.task.reduce.Shuffle`。

- **定义**

  ​      shuffle是指**map任务输出到reduce任务输入**的过程。

- **目的**
  ​        在Hadoop集群中，大部分map任务与reduce任务在不同的节点执行。因此，reduce任务在执行时需要跨节点去获取map的输出结果。如果集群上有很多作业，那么网络资源消耗会很严重，需要最大化减少不必要的资源。另外，如果map的输出和reduce的输入只是简单的磁盘读写操作，那么磁盘IO时间将对作业完成时间产生较大影响，应该减少磁盘IO的影响。
  ​      所以，shuffle阶段的目的有两个：
  ​     <1>在跨节点获取map输出时，尽可能减少网络带宽不必要的消耗。
  ​     <2>优化内存使用，减少磁盘IO操作。

- **shuffle过程解析**

![img](image/shuffle过程解析.jpg)

- **Map输出** 

​      上图是官方给出的shuffle的流程图，但是上图中的“partition, sort amd spill to disk”过程并没有说明partition、sort和spill在哪个过程进行，难以理解。因此，我画了另外一张图，解释上图左半边的流程（map task），如图：

![img](image/Map输出.jpg)

**(1) Partition操作**
​       map的输出结果是多个键值对（key/value），将由reduce合并，而集群中有多个reduce，该由哪个reduce负责处理这些键值对？答案是MapReduce提供了Partitioner接口。
​       Partitioner接口可以根据key或value、以及reduce的数量来决定当前的map输出结果由哪个reduce处理。（默认方式是，计算key的哈希值，再对reduce数量取模。比如，计算得到的值是0，则指定第一个reduce处理）

```java
//getPartition(),Partitioner的子类HashPartitioner
(key.hashCode() & Integer.MAX_VALUE) % numReduceTasks;
```

​       所以，得到map输出后，进行partition操作，从而指定某个reduce处理该输出结果。

**(2) Spill操作**
​       map输出时使用的内存缓冲区有大小限制，默认是100MB。当输出结果很多时，内存就会被填满，因此需要将缓冲区的数据写入磁盘，然后重新使用这块缓冲区。这个从内存往磁盘写数据的过程被称为Spill（溢出写）。
​       溢出写由单独一个线程负责，不影响往缓冲区写map结果的线程。所以在溢出写的过程中，map输出结果会继续被写入内存。当缓冲区的数据达到阈值（默认是80%，由属性 io.sort.spill.percent 设定），溢出写线程启动，对这80%的内存进行溢出写操作。
​       在溢出写把map结果写到磁盘之前，需要进行两个重要的操作：sort（排序）和combine（合并）。
​       sort是把这80%的map结果按照key排序。
​       另外，因为一个map的输出结果会由不同的reduce处理（不同的key通过partition操作计算出来的值不同），所以要将属于同一个reduce处理的输出结果进行combine操作。

**(3)Merge操作**
​       每次溢出写都会在磁盘上生成一个溢出写文件，如果map输出结果很大，那么将会生成多个溢出写文件。（当map任务完成时，会把内存缓冲区中最后的结果也写到一个溢出写文件中）。为了方便后续阶段reduce来获取输出结果，这些溢出写文件将会被合并成一个文件，这就是merge操作。

最后，合并后的溢出写文件被放在TaskTracker的本地目录下，map端的工作结束。

- Reduce输入
  reduce端不断通过RPC从JobTracker获取map任务是否完成的信息。如果reduce端得到通知，shuffle的后半段就开始了。
  **(1) copy阶段**
  ​        reduce任务启动一些copy线程（默认值是5个线程，可设置mapred.reduce.parallel.copies属性），通过HTTP方式把TaskTracker目录下的map输出结果复制到内存缓冲区（这里缓冲区大小比map端灵活，是基于JVM的heap size设置的。因为在copy阶段不执行reduce操作，所以绝大部分内存都给copy线程使用）。当缓冲区中的数据达到阈值，就进行溢出写操作（与map端类似）。

  **(2) sort阶段**
  ​       其实，这里的所说的sort更恰当的说是merge，因为排序是在map端进行的，而这个阶段的任务是合并来自多个map端的输出结果。比如，有50个map输出，而合并因子是10（由io.sort.factor属性设置），那么将进行5趟合并，每趟合并10个文件。最后合并成5个文件。

  **(3) reduce阶段**
  对sort阶段生成的文件执行reduce操作，把输出结果放到HDFS。



Spark,计算框架RDD是弹式的分布式数据集



##### MR源码解析

* 两个角色： Client做了什么（**MyMapper类**和**MyReducer类**）和MR框架做了什么(MyMapper继承了Mapper类和MyReducer类继承了Reducer类)。
* 设计思想,设计原理,技术细节

```java
if ((blkLocations[i].getOffset() <= offset  < blkLocations[i].getOffset() + blkLocations[i].getLength()))
//切片的偏移量offset要大于等于块的偏移量起始位置小于块的结束位置(块的起始位置+块的大小)
 
```



###### 客户端(任务的提交与切片)

编写mapreduce程序，配置作业，提交作业的客户端 

* 没有计算的产生,**支撑了计算向数据移动和计算的并行度规划**

  * Map的并行度,分治的实现规划
  * 计算向数据移动规划
  * MR框架默认的输入格式化类: **TextInputFormat** < **FileInputFormat** < **InputFormat**


* 任务提交给资源层



**Job提交作业**

![job提交作业](image/job提交作业.jpg)

1. **Job开始提交任务**

   ![一个简单的MapReduce开始提交任务](https://img.xiaoxiaomo.com/blog%2Fimg%2Fmapreduce01.png)

2. 接下来我们进入**Job**类看一看**waitForCompletion**方法，**waitForCompletion**方法中主要调用了两个方法：`submit()`和`monitorAndPrintJob()`，如下图所示：

   ![Job类的waitForCompletion()方法](https://img.xiaoxiaomo.com/blog%2Fimg%2Fmapreduce02.png)




###### MapTask

* 一系列的并行度,假如有十个并行度(切片)的话就有十个MapTask,在十台主机或者若干台主机上启动
* 是一些JVM进程,一个任务一个Task是一个JVM进程。
* 当MapTask这些进程任务类run时，是由MyMapper类继承的Mapper类中执行run方法:[^**一般框架都会有一个run方法**]，其中执行了一次setup,循环执行map,一次cleanup方法(**其中循环执行map方法的次数由任务中计算切片记录的条数**,客户端实现map方法),`setup` 和 `cleanup` 方法，这两个方法都是只在创建Mapper对象的时候执行一次，适合做一些初始化和清理资源的工作。
* MapTask也是一个被反射类,因为资源层有一个YarnChild类,YARN在节点的container中先启动一个**YarnChild**执行完后会把MapTask或者ReduceTask反射成对象，并调用MapTask的run方法或者ReduceTask中的run方法。

![img](image/MapReduce程序运行流程分析.png)

1. 在我们写代码的时候，可以覆盖**setup**、**map**、**cleanup**方法；
2. 框架调用map的时候，是通过反射的方式产生的，然后调用实例化对象中的run()。

![Mapper方法](image/Mapper方法.png)

3. 注意我们**Mapper类**的**write()**方法，其实是调用了`org.apache.hadoop.mapreduce.Mapper.Context`

- 程序真正执行时，是启动了一个**YarnChild**类，下面我们来分析框架如何调用map task或者reduce task。

  ![YarnChild类的run(image/mapreduce23.png)方法](https://img.xiaoxiaomo.com/blog%2Fimg%2Fmapreduce23.png)

 ①看一下**taskFinal**的一个实现类是**MapTask**。

![taskFinal的一个实现类是MapTask](image/mapreduce24.png)

* 通过使用使用 `getNumReduceTasks` 获取 reduce 的数量,等于0表示没有reduces,就只有一个mapPhase节点,占用map任务环节中1.0f[^100%]
* 如果有reduces,则加上排序环节占用0.333f[^33.3%],在框架中排序可有可无,在开发后续中计算有很大的影响,如果在ReduceTask在读取数据文件在没有排序的时候会很消耗IO资源和对拉取数据进行计算的时候每组全量遍历这个文件还会重复消耗大量的IO资源。当MapTask加了一个排序sortPhase让数据有序了,在ReduceTask端处理数据的时候就是线性IO一次的过程,使之降低IO资源。

②继续分析下面的**runNewMapper()**方法

![下面跳过一部分代码截图......](image/mapreduce25.png)

![runNewMapper(image/mapreduce26.png)方法](https://img.xiaoxiaomo.com/blog%2Fimg%2Fmapreduce26.png)

在这里可以看出：

> 使用 `getNumReduceTasks` 获取 reduce 的数量,如果没有reduce task，那么map直接把<k2,v2>输出。如果有，创建排序的输出。**Reduce 的数量可以自己设置，在job中通过setNumReduceTasks 可以手动设置reduce的数量，或者在-D 后面加上k/v配置(IDEA开发工具中)**
> 在这里，output实际上是WordCountMapper类中的map()方法里面的context.write()实际调用，就是在output中调用的。

* 进入`runNewMapper()`方法,常识:在未来学习框架的时候,要先跳过先看try{}finally {}代码

```java
 private <INKEY,INVALUE,OUTKEY,OUTVALUE>
  void runNewMapper(final JobConf job,
                    final TaskSplitIndex splitIndex,
                    final TaskUmbilicalProtocol umbilical,
                    TaskReporter reporter
                    ) throws IOException, ClassNotFoundException,
                             InterruptedException {
  ......                               
    try {
        //输入初始化,也就是LineRecordReader的初始化,数据在hdfs切割,就是由于LineRecordReader的初始化才使之数据计算正确.
      input.initialize(split, mapperContext);
        //map实例对象的调用执行,调用Mapper类中的run方法,Mapper中的run方法又调用Client的MyMapper类中重写的map()方法
      mapper.run(mapperContext);
      mapPhase.complete();
        //排序
      setPhase(TaskStatus.Phase.SORT);
      statusUpdate(umbilical);
        //输入关闭
      input.close();
      input = null;
        //数据有map读取然后在内存计数,最后刷到磁盘中去----有输入计算输出阶段
      output.close(mapperContext);
      output = null;
    } finally {
      closeQuietly(input);
      closeQuietly(output, mapperContext);
    }
}                                 
```

![1566607723663](image/1566607723663.png)

* Java 面向对象,其中要看重对象是怎么来的,`input`,`mapper`和`output`这三个对象是怎么实例化的，特征是什么，他的属性和方法有哪些。。。。。**在框架中context中是不可缺少的，对象继承到context中，总是会有些共用模块贯穿在整个框架业务逻辑线。**其中taskContext传入的参数中job--在Client自己重新实例化一个含有conf配置信息的Job对象。

* <font color="red">客户端</font>向资源层**YARN**提交资源的时候，也会把一些资源上交到HDFS，其中包含一些配置信息的**Job.xml文件**、**wc.jar**包和**Job.split序列化切片List类型**,这些资源放在HDFS后,这时MrAppMaster(负责整个程序的过程调度及状态协调)就会调用一个Container,如果Container里面含有MapTask的话Container是有能力从存储层HDFS中拿到**Job.xml文件**、**wc.jar**包和**Job.split序列化切片**,MapTask可以把Job.xml文件变成Configuration注入到<font color="red">Job对象</font>(和客户端中的Job对象是一个job,含有相同配置文件)中。

* 在并行map类出现的时候,在执行map之前是每个map就发生计算向数据移动，也就是每个map计算程序先移动了split切片对应的那个块的那个节点上[^计算向数据移动]，计算向数据移动后要数据本地化读取这个文件的某个部分也就是某个切片,每个map处理不同的计算[^分治],每个map是一个普通的对象和一个JVM进程,每个map计算一个文件的哪一部门之前的split中就要定义每个map所对应的文件中那个块。
* **Job.split序列化切片**信息包含了哪个文件,其中一个map所对应的分片偏移量offset和这个分片的大小，决定了一个map怎么读取数据。
* 在MapTask类中的split表示从客户端中全局split信息中拿取每个map自己所对应的split数据维度信息,每个map通过拿到的split信息(切片信息)来计算相关数据信息.

![1566641878032](image/1566641878032.png)

![1566641990117](image/1566641990117.png)

* mapper对象中是从taskContext中获取,也是从配置文件获取,当没有在-D后面配置MAP_CLASS_ATTR![1566642057073](image/1566642057073.png)键值对时会指向Mapper.class,也就是在client中人为的往job中设置Mapper对象![1566642210698](image/1566642210698.png),父类引用指向子类。
* 在inputFormat对象和mapper对象实例化原理一样，在-D后面没有配置mapreduce.job.inputformat.class的值时,就指向client中配置`job.setInputFormatClass(oooxx.class);`,TextInputFormat类。
* 每个map归属于要计算这个文件的某个切片,这时切片指的是数据文件的某一部分,定义的是一堆字节大小,真正map计算的是从这堆字节中得到记录,一条记录执行一个map,这时一定会调用format格式化这堆字节为一条条记录,要么用换行符要么用其他规则来split切割。split表示的是这个map要出来这个文件的那一部分，输入格式化表示的是在split格式化一条条记录，转成成的`input`是有能力在这个map的切片中读出一条条记录。

![1566661722333](image/1566661722333.png)

③接下来进入从split和inputformat格式化一条条input记录使用的构造方法**NewTrackingRecordReader**

```java
new NewTrackingRecordReader<INKEY,INVALUE>
        (split, inputFormat, reporter, taskContext);
```

![1566662253916](image/1566662253916.png)

![1566662399690](image/1566662399690.png)

* 父类FileInputFormat在获取切片计算处理的时候,在具体的子类中一定会有一个记录读取器,一个文件有很多种读法,有普通Text文件按照行的,有xml文件按照<></>开闭标签格式来读取的,还有各种基于File文件的格式不一样读取的记录格式也不一样,所以一定是在子类中实现记录读取方式**createRecordReader**。

* **TextInputFormat**文本读取格式的一定是返回行记录读取器**LineRecordReader**

![1566663148180](image/1566663148180.png)

* 在map阶段中input真正核心是行记录读取器.

```java
    return new LineRecordReader(recordDelimiterBytes);
```

input需要初始化:也就是LineRecordReader的初始化

![1566663749269](image/1566663749269.png)

* **LineRecordReader**的**public void initialize(split, mapperContext)**方法数据会在hdfs切割开计算的时候会完整计算出数据(比如一个单词切开后编码两部分,一部门在1分区,这个单词的最后几个字母在2分区开头)

从切片中拿到了未来文件的**起始偏移量**和**结尾偏移量**,start and end 是这个map任务要计算的那个文件的起始和结束位置,以及从这个切片中获取当前的归并文件的路径Path。

在path文件路径中拿到当前文件的获取分布式文件系统的对象，并打开当前文件，open打开后就会得到面向当前文件的输入流,系统会自动跳转到这个文件的开始位置,这时没有块的概念,所以通过open获取的文件输入流fileIn时一定要进行seek操作,并行的map都是从自己的计算切片（偏移量）开始读取数据。

![1566795927134](image/1566795927134.png)

![1566835941342](image/1566835941342.png)

④接下来分析**NewOutputCollector**类的实现的构造方法，**partitioner**类是在这里实例化的。

![NewOutputCollector类的实现的构造方法](image/mapreduce27.png)



###### ReduceTask




#### Yarn资源调度器

​      Yarn是一个资源调度平台，负责为运算程序提供服务器运算资源，相当于一个分布式的操作系统平台，而**MapReduce**等运算程序则相当于运行于操作系统之上的应用程序。JobTracker中的资源管理的某几行代码切割出来成为一个进程使之成为ResourceManager进行作为专门的资源调度器。

​        YARN的基本思想是将资源管理和作业调度/监视的功能分解为单独的守护进程。我们的想法是拥有一个全局ResourceManager（*RM*）和每个应用程序ApplicationMaster（*AM*）。应用程序可以是单个作业，也可以是作业的DAG。

​        ResourceManager和NodeManager构成了数据计算框架。ResourceManager是在系统中的所有应用程序之间仲裁资源的最终权限。NodeManager是每台机器框架代理，负责容器，监视其资源使用情况（CPU，内存，磁盘，网络）**(cpu, memory, disk, network)**并将其报告给ResourceManager / Scheduler。

​        每个应用程序ApplicationMaster实际上是一个特定于框架的库，其任务是协调来自ResourceManager的资源，并与NodeManager一起执行和监视任务。



##### Yarn基本架构

​    YARN主要由ResourceManager、NodeManager、ApplicationMaster和Container等组件构成。

![1565625937521](image/1565625937521.png)

![img](image/clip_image002.png)

##### Yarn工作机制

1）Yarn运行机制

![1565623982260](image/1565623982260.png)

​                                                                            Yarn运行机制

2）工作机制详解

​       （0）Mr程序提交到客户端所在的节点。

​       （1）Yarnrunner向Resourcemanager申请一个Application。

​       （2）rm将该应用程序的资源路径返回给yarnrunner。

​       （3）该程序将运行所需资源提交到HDFS上。

​       （4）程序资源提交完毕后，申请运行mrAppMaster。

​       （5）RM将用户的请求初始化成一个task。

​       （6）其中一个NodeManager领取到task任务。

​       （7）该NodeManager创建容器Container，并产生MRAppmaster。

​       （8）Container从HDFS上拷贝资源到本地。

​       （9）MRAppmaster向RM 申请运行maptask资源。

​       （10）RM将运行maptask任务分配给另外两个NodeManager，另两个NodeManager分别领取任务并创建容器。

​       （11）MR向两个接收到任务的NodeManager发送程序启动脚本，这两个NodeManager分别启动maptask，maptask对数据分区排序。

（12）MrAppMaster等待所有maptask运行完毕后，向RM申请容器，运行reduce task。

​       （13）reduce task向maptask获取相应分区的数据。

​       （14）程序运行完毕后，MR会向RM申请注销自己。



#### 总结

* 在YARN框架中，起监控作用的是Resource Manager，用来监控Node Manager，它们都是节点，也就是进程。

* 在MapReduce框架中，起监控作用的是MRAppMaster，用来监控yarnChild，它们都是动态产生的进程。

------

### Hive

#### **数据仓库**

hive的其中一个特点就是具有**数据仓库**特性:可以放置各种各样类型的数据或者不同数据源的数据。在数据仓库中的数据是不能进行修改的,只能进行数据叠加效果。

存储的元数据是用来方便统一管理文件的元数据



处理元数据,提供了一套SQL

SQL半衰期很长，容易上手

数据仓库---不是数据库,是对业务系统的维护

提供一些SQL方式来对hfds的数据MapReduce操作



文件元数据是namenode，记录的是00000文件的位置信息之类的，数据元数据记录了些字段名之类的

mysql里存的就是hive表的列名,表名之类的元数据.hdfs存的是表里面具体的数据

hive表的元数据存在mysql上
hive表的数据存在hdfs上
文件的元数据存在nn上

##### 建模

![1563757079862](image/1563757079862.png)

![1563757157394](image/1563757157394.png)

#### 数据库

数据库用来接受用户请求操作,并在很短的一个时效内返回用户结果，但是**数据仓库**就不需要，分析数据得到结果就行。



#### OLAP与OLTP

| 数据处理类型 | OLTP                   | OLAP           |
| ------------ | ---------------------- | -------------- |
| 面向对象     | 业务开发人员           | 分析决策人员   |
| 功能实现     | 日常事务处理           | 面向分析决策   |
| 数据模型     | 关系模型               | 多维模型       |
| 数据量       | 几条或几十条记录       | 百万千万条记录 |
| 操作类型     | 查询、插入、更新、删除 | 查询为主       |

------

**OLAP**::jack_o_lantern::建立的时候必须要先建立模型(**雪花模型和星型模型**),是对**数据仓库**方面的控制,对结果关注,需要建立一些模型,**联机分析处理**,通过SQL语句知道数据的结果,而不需要知道实时数据,提供直观易懂的查询结果.最终是要知道结果数据

**OLTP**::japan:**联机事务处理**,事务级别控制.

------



##### OLAP

OLAP有多种实现方法，根据存储数据的方式不同可以分为ROLAP、MOLAP、HOLAP。

**ROLAP：**表示基于关系数据库的OLAP实现（Relational OLAP）。以关系数据库为核心，以关系型结构进行多维数据的表示和存储。ROLAP将多维数据库的多维结构划分为两类表：一类是事实表，用来存储数据和维关键字；另一类是维表，即对每个维至少使用一个表来存放维的层次、成员类别等维的描述信息。维表和事实表通过主关键字和外关键字联系在一起，形成了“星型模式”。对于层次复杂的维，为避免冗余数据占用过大的存储空间，可以使用多个表来描述，这种星型模式的扩展称为“雪花模式”。ROLAP的最大好处是可以实时地从源数据中获得最新数据更新，以保持数据实时性，缺陷在于运算效率比较低，用户等待响应时间比较长。

 

**MOLAP：**表示基于多维数据组织的OLAP实现（Multidimensional OLAP）。以多维数据组织方式为核心，也就是说，MOLAP使用多维数组存储数据。多维数据在存储中将形成“数据立方体（Cube）”的结构，此结构在得到高度优化后，可以最大程度地提高查询性能。随着源数据的更改，MOLAP 存储中的对象必须定期处理以合并这些更改。两次处理之间的时间将构成滞后时间，在此期间，OLAP对象中的数据可能无法与当前源数据相匹配。维护人员可以对 MOLAP 存储中的对象进行不中断的增量更新。MOLAP的优势在于由于经过了数据多维预处理，分析中数据运算效率高，主要的缺陷在于数据更新有一定延滞。

 

**HOLAP：**表示基于混合数据组织的OLAP实现（Hybrid OLAP），用户可以根据自己的业务需求，选择哪些模型采用ROLAP，哪些采用MOLAP。一般来说，会将非常用或需要灵活定义的分析使用ROLAP方式，而常用、常规模型采用MOLAP实现。

 

 





**Cubes：**是数据立方体。何为数据立方体？这主要是和维度的概念一起理解，我们现实是分三维，x,y,z三个坐标决定的空间。而数据库，可能会包含很多维度，只是在我们的认知中无法想像超越三维的事物，这只是个概念。可见，Cube是依赖于维度的。所以在我们建立Cube的时候，需要理解下面的Dimension是什么。

Dimensions：Cube的维度，每个Cube依赖哪些维度来做统计，就需要在这里建。虽然在创建立方的时候会自动帮我们创建维度，但是有时候他创建的维度并不能达到我们的目的。所以，我们先建Dimension，再建Cube。

Mining structures：数据挖掘用的东西，咱这里就不说了，因为我还没用过，只是看了下Webcast的视频，里面介绍了集成了大量的现有挖掘算法，很方便的可以做出相应的分析趋势。 还是看似厉啊。

 

###### OLAP的基本操作

　　我们已经知道OLAP的操作是以查询——也就是数据库的SELECT操作为主，但是查询可以很复杂，比如基于关系数据库的查询可以多表关联，可以使用COUNT、SUM、AVG等聚合函数。OLAP正是基于多维模型定义了一些常见的面向分析的操作类型是这些操作显得更加直观。

![img](image/Better-Reporting-on-Multidimensional-OLAP-Data-Sources.png)

　　OLAP的多维分析操作包括：**钻取（Drill-down）**、**上卷（Roll-up）**、**切片（Slice）**、**切块（Dice）**以及**旋转（Pivot）**，下面还是以上面的数据立方体为例来逐一解释下：

[![OLAP](http://webdataanalysis.net/wp-content/uploads/2010/08/OLAP.png)](http://webdataanalysis.net/wp-content/uploads/2010/08/OLAP.png) 

　　**钻取（Drill-down）**：在维的不同层次间的变化，从上层降到下一层，或者说是将汇总数据拆分到更细节的数据，比如通过对2010年第二季度的总销售数据进行钻取来查看2010年第二季度4、5、6每个月的消费数据，如上图；当然也可以钻取浙江省来查看杭州市、宁波市、温州市……这些城市的销售数据。

　　**上卷（Roll-up）**：钻取的逆操作，即从细粒度数据向高层的聚合，如将江苏省、上海市和浙江省的销售数据进行汇总来查看江浙沪地区的销售数据，如上图。

　　**切片（Slice）**：选择维中特定的值进行分析，比如只选择电子产品的销售数据，或者2010年第二季度的数据。

　　**切块（Dice）**：选择维中特定区间的数据或者某批特定值进行分析，比如选择2010年第一季度到2010年第二季度的销售数据，或者是电子产品和日用品的销售数据。

　　**旋转（Pivot）**：即维的位置的互换，就像是二维表的行列转换，如图中通过旋转实现产品维和地域维的互换。

##### OLTP



#### Hive基本概念

![1563106380005](image/1563106380005.png)



![1563106484390](image/1563106484390.png)

MapReduce要通过解释器,编译器和优化器等转换成MySQL中的数据。

![Hive原理图](image/1563107004293.png "Hive原理图")

![img](https://images0.cnblogs.com/blog/306623/201306/02191643-020a03e8fb3e4223a83e7b4d51ced410.png)





#### Hive搭建步骤

#### Hive DDL数据定义

##### Hive分区

为了检索数据的效率:**分区表**在创建表的时候可以根据某个字段进行分区**partitioned** 

**1.  单分区**

![1563283389415](image/1563283389415.png)

![1563283453063](image/1563283453063.png)

1. **多分区**

![1563283513014](image/1563283513014.png)



插入数据的时候,都要把分区列添加值,是先新建分区目录再创建文件

![1563283601868](image/1563283601868.png)

**3. 动态分区**

![1563284289437](image/1563284289437.png)



![1563284434273](image/1563284434273.png)



1. **修复分区**

![1563284571283](image/1563284571283.png)



![1563284953585](image/1563284953585.png)

![1563284969381](image/1563284969381.png)

分区的粒度是要选择适中,不能大也不能小。

#### Hive DML数据操作

Hive 插入语句中含有Select语句,效率相对于load hdfs数据较慢

insert overwire table psn select ...from...

insert overwire local directory 'root/result' select * from psn;





历史时间拉链表



![1563453491044](image/1563453491044.png)



hdfs dfs -chmod 777 /temp

![1563455967323](image/1563455967323.png)



#### 函数

**开窗函数**

#### Hive分区和分桶

- 分区
- 分桶

![1563715308074](image/1563715308074.png)

laod 

数据抽样:

- LATERAL VIEW

  1). 抽象语法树

  2).查询块

  3).逻辑查询计划

  4).物理查询计划

  5).优化执行

#### 视图

- 和关系型数据库中的**普通视图**一样,<sp**不支持物化视图**,支持迭代视图

#### 索引

![1563885010444](image/1563885010444.png)

seek ,一致移动seek指针,偏移量



4k空间:4k对齐



#### JOIN

`left semi join`:也就是相当于关系型数据库中的IN/exists字段

使用MR如何实现两个文件的join操作:key 是ON条件那个字段



#### 权限

with grant option 某一张表的CRUD

![1563889192403](image/1563889192403.png)



#### 调优

![1564057515789](image/1564057515789.png)



#### 压缩和存储

Hive的压缩和存储也就是Hadoop的压缩和HDFS存储。冷数据压缩省空间。



### HBase

- 可以随机实时读写Big Data，

- 面向列存储数据的数据库(数十亿行X百万列的very large tables),面向列:面向列(族)的存储和权限控制，**列(族)**即<font color='red'>**Columns  Family**</font>独立检索。

  列族是最小控制单元,不能控制列,**列族+列**,位于列族下面的列具有公共的属性，没有独特属性，所以不能单独修改某一列的值。

- MySQL采用B+树数据结构(索引系统,先查询索引然后定位到数据)--在高并发场景下变慢了,MySQL存储数据也是存储到磁盘中的,访问数据的时候要先从磁盘中查找然后缓存到内存中,再返回到客户端。

  - 分库分表：一个表横向切分纵向切分，(在设计表的时候遵循**范式原则**)在访问数据库的数据分散到各个
    - 范式原则
      - <font color="red"  face="楷体">第一范式(1NF)</font>:列式不可分(无重复的列),是**指数据库表的每一列都是不可分割的基本数据项，同一列中不能有多个值，即实体中的某个属性不能有多个值或者不能有重复的属性** - <font color='green'>强调数据表的原子性</font>
      - <font color="red"  face="楷体">第二范式(2NF)</font>:**属性完全依赖于主键**
      - <font color="red"  face="楷体">第三范式(3NF)</font>:**要求一个数据库表中不包含已在其它表中已包含的非主关键字信息**,目标是确保每列都和主键列直接相关,而不是间接相关(另外非主键列必须直接依赖于主键，不能存在传递依赖)。
  - 读写分离

- Hadoop DataBase(HBase),是一个高可用、高性能、面向列、可伸缩、实时读写的分布式数据库

- 利用Hadoop HDFS作为其文本存储系统,利用Hadoop MapReduce来处理HBase中的海量数据,利用Zookeeper作为分布式协同服务(Zookeeper中还有一个树形结构,也可以存储元数据)

- 主要用来存储非结构化和半结构化的松散数据(列存NoSQL数据库):

  - **结构化数据**，是指由二维表结构来逻辑表达和实现的数据，严格地遵循数据格式与长度规范，主要通过**关系型数据库**进行存储和管理。

    也称作行数据，一般特点是：数据以行为单位，一行数据表示一个实体的信息，每一行数据的属性是相同的。

  - **非结构化数据**，是数据结构不规则或不完整，没有预定义的数据模型，不方便用数据库二维逻辑表来表现的数据。包括所有格式的**办公文档、文本、图片、HTML、各类报表、图像和音频/视频信息**等等。

  - **半结构化数据**，是结构化数据的一种形式，虽不符合关系型数据库或其他数据表的形式关联起来的数据模型结构，但包含相关标记，用来分隔语义元素以及对记录和字段进行分层。因此，也被称为自描述的结构。常用的半结构化数据有JSON、XML

  - **数据清洗**是指发现并纠正数据文件中可识别的错误的最后一道程序，包括检查数据一致性，处理无效值和缺失值等。与问卷审核不同，录入后的数据清理一般是由计算机而不是人工完成。

    ![img](image/0d338744ebf81a4c3558041edc2a6059242da6fb.jpg)

    数据清洗原理

    数据清洗(data cleaning)，简单地讲，就是从数据源中清除错误和不一致，即利用有关技术如数理统计、数据挖掘或预定义的清洗规则等，从数据中检测和消除错误数据、不完整数据和重复数据等，从而提高数据的质量。业务知识与清洗规则的制定在相当程度上取决于审计人员的积累与综合判断能力。因此，审计人员应按以下标准评价审计数据的质量。

    （一）准确性：数据值与假定正确的值的一致程度。

    （二）完整性：需要值的属性中无值缺失的程度。

    （三）一致性：数据对一组约束的满足程度。

    （四）惟一性：数据记录（及码值）的惟一性。

    （五）效性：维护的数据足够严格以满足分类准则的接受要求。

#### HBase数据结构(模型)

##### Rowkey

- 决定一行数据
- 按照ASCII字典顺序排序，Hbase在业务查询中查询的是某个范围下的数据。所以把特定的范围下的数据最为Row Key第一个字节。
- Row key只能存储64k的字节数据，实际应用中建议使用10~100个字节。
- 要获取某一列值,必须要获取到其Rowkey值。Rowkey -> 列族 -> 列名 -> 时间戳



###### Rowkey长度设计原则

​        Rowkey是一个二进制，Rowkey的长度被很多开发者建议说设计在10~100个字节，建议是越短越好。

原因有两点：

```text
其一是HBase的持久化文件HFile是按照KeyValue存储的，如果Rowkey过长比如500个字节，1000万列数据光Rowkey就要占用500*1000万=50亿个字节，将近1G数据，这会极大影响HFile的存储效率

其二是MemStore缓存部分数据到内存，如果Rowkey字段过长内存的有效利用率会降低，系统无法缓存更多的数据，这会降低检索效
```

​        需要指出的是不仅Rowkey的长度是越短越好，而且列族名、列名等尽量使用短名字，因为HBase属于列式数据库，这些名字都是会写入到HBase的持久化文件**HFile**中去，过长的Rowkey、列族、列名都会导致整体的存储量成倍增加。



##### Column Family



#### HBase架构

索引放在内存中，默认web端口号2.x版本的端口号是16010，1.x之前端口是60010

布隆过滤器

:!/java

`hbase hfile -p -f file`:查看hbase中文件中数据

![1564490817913](image/1564490817913.png)

![1564479543275](image/1564479543275.png)

##### HLog(WAL log)

​        HLog文件就是一个普通的Hadoop Sequence File，Sequence File 的Key是HLogKey对象，HLogKey中记录了写入数据的归属信息，除了table和region名字外，同时还包括 sequence number和timestamp，timestamp是” 写入时间”，sequence number的起始值为0，或者是最近一次存入文件系统中sequence number。

​      HLog SequeceFile的Value是HBase的KeyValue对象，即对应HFile中的KeyValue。

​      WAL(write ahead log,预习数据日志,相当于MySQL中的二进制日志BinLog),存在内存中: HRegion(表) -> store(列族) -> MeStore -> StoreFIle(Hfile,在不同系统中不同的叫法)

​      



##### Client

- 包含访问HBase的接口并维护cache来加快对HBase的访问

##### Zookeeper

- 保证任何时候，集群中只有一个master
- 存贮所有Region的寻址入口。
- 实时监控Region server的上线和下线信息。并实时通知Master
- 存储HBase的**schema和table**元数据,部分元数据
  - 如果开始的时候Zk里面没有表名的元数据的话会先拿**元数据存储地址**。
  - 表类型，属性，列，字段长度等都会存在HBase中
- 服务注册

##### Master

- 为Region server分配region
- 负责Region server的负载均衡
- 发现失效的Region server并重新分配其上的region
  - 当失效的Region server中的Table 2连接Hdfs的接口也就失效,正常的Region server Table 1就会访问HDFS中Table 2数据
- 管理用户对table的增删改操作

##### RegionServer

- Region server维护region，处理对这些region的IO请求
- Region server负责切分在运行过程中变得过大的region

##### Region

- HBase自动把表水平划分成多个区域(region)，每个region会保存一个表里面某段连续的数据
- 每个表一开始只有一个region，随着数据不断插入表，region不断增大，当增大到一个阀值的时候，region就会等分会两个新的region（裂变）
- 当table中的行不断增多，就会有越来越多的region。这样一张完整的表被保存在多个Regionserver 上。

##### Memstore 与 storefile

- 一个region由多个store组成，一个store对应一个CF（列族）
- memstore 溢写的阈值64k
- store包括位于内存中的memstore和位于磁盘的storefile写操作先写入memstore，当memstore中的数据达到某个阈值，hregionserver会启动flashcache进程写入storefile，每次写入形成单独的一个storefile
- 当storefile文件的数量增长到一定阈值后，系统会进行合并（minor、major compaction），在合并过程中会进行版本合并和删除工作（majar），形成更大的storefile
- 当一个region所有storefile的大小和数量超过一定阈值后，会把当前的region分割为两个，并由hmaster分配到相应的regionserver服务器，实现负载均衡
- 客户端检索数据，先在memstore找，找不到再找storefile



#### HBase-LSM树存储引擎

​      **日志结果树**:内存和磁盘构成的数据结构,先写入小数据到内存中然后写入大的数据到磁盘中。

核心思想是**放弃部分读性能，提高写性能**。

LSM Tree（Log-Structured Merge Tree）日志结构合并树，核心思路就是假设内存足够大，不需要每次有数据更新就必须把数据写入到磁盘中，可以先把最新的数据驻留在磁盘中，等到积累到最后多之后，再使用归并排序的方式将内存内的数据合并追加到磁盘队尾(因为所有待排序的树都是有序的，可以通过合并排序的方式快速合并到一起)。

日志结构的合并树（LSM-tree）是一种基于硬盘的数据结构，与B-tree相比，能显著地减少硬盘磁盘臂的开销，并能在较长的时间提供对文件的高速插入（删除）。然而LSM-tree在某些情况下，特别是在查询需要快速响应时性能不佳。通常LSM-tree适用于索引插入比检索更频繁的应用[系统](https://www.2cto.com/os/)。Bigtable在提供Tablet服务时，使用GFS来存储日志和SSTable，而GFS的设计初衷就是希望通过添加新数据的方式而不是通过重写旧数据的方式来修改文件。而LSM-tree通过滚动合并和多页块的方法推迟和批量进行索引更新，充分利用内存来存储近期或常用数据以降低查找代价，利用硬盘来存储不常用数据以减少存储代价。

磁盘的技术特性：对磁盘来说，能够最大化的发挥磁盘技术特性的使用方式是:一次性的读取或写入固定大小的一块数据，并尽可能的减少随机寻道这个操作的次数。

![这里写图片描述](image/20171227092050247.jpg)

LSM和Btree差异就要在读性能和写性能进行舍和求。在牺牲的同时，寻找其他方案来弥补。

**1.LSM具有批量特性,存储延迟**

当写读比例很大的时候（写比读多），LSM树相比于B树有更好的性能。因为随着insert操作，为了维护B树结构，节点分裂。读磁盘的随机读写概率会变大，性能会逐渐减弱。 多次单页随机写，变成一次多页随机写,复用了磁盘寻道时间，极大提升效率。

**2.B树的写入过程**

对B树的写入过程是一次原位写入的过程，主要分为两个部分，首先是查找到对应的块的位置，然后将新数据写入到刚才查找到的数据块中，然后再查找到块所对应的磁盘物理位置，将数据写入去。当然，在内存比较充足的时候，因为B树的一部分可以被缓存在内存中，所以查找块的过程有一定概率可以在内存内完成，不过为了表述清晰，我们就假定内存很小，只够存一个B树块大小的数据吧。可以看到，在上面的模式中，需要两次随机寻道（一次查找，一次原位写），才能够完成一次数据的写入，代价还是很高的。

**3.LSM树**放弃磁盘读性能来换取写的顺序性，似乎会认为读应该是大部分系统最应该保证的特性，所以用读换写似乎不是个好买卖。但别急，听我分析一下。

a. 内存的速度远超磁盘，1000倍以上。而读取的性能提升，主要还是依靠内存命中率而非磁盘读的次数

b. 写入不占用磁盘的io，读取就能获取更长时间的磁盘io使用权，从而也可以提升读取效率。例如LevelDb的SSTable虽然降低了了读的性能，但如果数据的读取命中率有保障的前提下，因为读取能够获得更多的磁盘io机会，因此读取性能基本没有降低，甚至还会有提升。而写入的性能则会获得较大幅度的提升，基本上是5~10倍左右.

通过以上的分析，应该知道LSM树的由来了，LSM树的设计思想非常朴素：将对数据的修改增量保持在内存中，达到指定的大小限制后将这些修改操作批量写入磁盘，不过读取的时候稍微麻烦，需要合并磁盘中历史数据和内存中最近修改操作，所以写入性能大大提升，读取时可能需要先看是否命中内存，否则需要访问较多的磁盘文件。极端的说，基于LSM树实现的HBase的写性能比MySQL高了一个数量级，读性能低了一个数量级。

LSM树原理把一棵大树拆分成N棵小树，它首先写入内存中，随着小树越来越大，内存中的小树会flush到磁盘中，磁盘中的树定期可以做merge操作，合并成一棵大树，以优化读性能。



![这里写图片描述](image/20171227092050248.png)

以上这些大概就是HBase存储的设计主要思想，这里分别对应说明下：

因为小树先写到内存中，为了防止内存数据丢失，写内存的同时需要暂时持久化到磁盘，对应了HBase的MemStore和HLog

MemStore上的树达到一定大小之后，需要flush到HRegion磁盘中（一般是Hadoop DataNode），这样MemStore就变成了DataNode上的磁盘文件StoreFile，定期HRegionServer对DataNode的数据做merge操作，彻底删除无效空间，多棵小树在这个时机合并成大树，来增强读性能。

关于LSM Tree，对于最简单的二层LSM Tree而言，内存中的数据和磁盘你中的数据merge操作，如下图

![这里写图片描述](image/20171227092051249.png)

lsm tree，理论上，可以是内存中树的一部分和磁盘中第一层树做merge，对于磁盘中的树直接做update操作有可能会破坏物理block的连续性，但是实际应用中，一般lsm有多层，当磁盘中的小树合并成一个大树的时候，可以重新排好顺序，使得block连续，优化读性能。

hbase在实现中，是把整个内存在一定阈值后，flush到disk中，形成一个file，这个file的存储也就是一个小的B+树，因为hbase一般是部署在hdfs上，hdfs不支持对文件的update操作，所以hbase这么整体内存flush，而不是和磁盘中的小树merge update，这个设计也就能讲通了。内存flush到磁盘上的小树，定期也会合并成一个大树。整体上hbase就是用了lsm tree的思路。



#### 合并(Compation)

merge/major



#### HBase读写操作

![img](https:////upload-images.jianshu.io/upload_images/3149801-51c88fb6acf3f21d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/365/format/webp)

二层架构的定位步骤如下：

（1）用户通过查找zk（zookeeper）的/hbase/meta-region-server节点查询哪台RegionServer上有hbase:meta表。

（2）客户端连接含有hbase:meta表的RegionServer。Hbase:meta表存储了所有Region的行健范围信息，通过这个表就可以查询出你要存取的rowkey属于哪个Region的范围里面，以及这个Region又是属于哪个RegionServer。

（3）获取这些信息后，客户端就可以直连其中一台拥有你要存取的rowkey的RegionServer，并直接对其操作。

（4）客户端会把meta信息缓存起来，下次操作就不需要进行以上加载HBase:meta的步骤了。

##### 读流程

##### 写流程



#### HBase搭建

`:! ls /usr/java`

- 同步时间

![1564492470210](image/1564492470210.png)

- 免密



#### [HBase基本概念与基本使用](https://www.cnblogs.com/swordfall/p/8737328.html)



##### 协处理器

* 触发器



* 存储过程









### 项目开发

![1565270372812](image/1565270372812.png)

sqoop---datax

输出格式化类

### Flume

日志收集器:可以收集各种形式的数据

Kafka:数据只对磁盘的数据,重复读写,消息队列,存储引擎

![1565532273214](image/1565532273214.png)

![1565698505329](image/1565698505329.png)



### Sqoop

* 一种HADOOP
* HADOOP----> 关系型数据库 导出; 

![1566480894571](image/1566480894571.png)



### Scala

![1569503767994](大数据/马士兵大数据笔记/Spark/Scala语言学习/image/1569503767994.png)



seq 1 8



#### Spark

##### Spark RDD五大特性

> 1.A list of partitionsRDD
>
> 是一个由多个partition（某个节点里的某一片连续的数据）组成的的list；将数据加载为RDD时，一般会遵循数据的本地性（一般一个hdfs里的block会加载为一个partition）。
>
> 2.A function for computing each split
>
> 一个函数计算每一个分片，RDD的每个partition上面都会有function，也就是函数应用，其作用是实现RDD之间partition的转换。
>
> 3.A list of dependencies on other RDDsRDD
>
> 会记录它的依赖 ，依赖还具体分为宽依赖和窄依赖，但并不是所有的RDD都有依赖。为了容错（重算，cache，checkpoint），也就是说在内存中的RDD操作时出错或丢失会进行重算。
>
> 4.Optionally,a Partitioner for Key-value RDDs  
>
> 可选项，如果RDD里面存的数据是key-value形式，则可以传递一个自定义的Partitioner进行重新分区，例如这里自定义的Partitioner是基于key进行分区，那则会将不同RDD里面的相同key的数据放到同一个partition里面
>
> 5.Optionally, a list of preferred locations to compute each split on
>
> 最优的位置去计算，也就是数据的本地性。

1. spark中的RDD是弹式布式数据集(A Resilient Distributed Dataset)

2. 一个个RDD中含有多个分区数组(A list of partitions SPLITS),每个分区在哪个节点上[**分区列表**]

3. 一个函数可以作用于每个切片,即作用在每个分区每条记录上(A function for computing each split)

4. 一系列依赖关系于多个RDD,是一个窄依赖转换,作用在一个stage主机中。

   ```scala
     /**
       * 每个RDD都有5个特性
       * 1. 分区列表
       * 2. 每个分区都有一个计算函数
       * 3. 依赖于其他RDD的列表
       * 4. 数据类型(Key - Value)的RDD分区器
       * 5. 每个分区都有一个优先位置列表
       *
       * abstract class RDD[T: ClassTag](
       *
       * @transient private var _sc: SparkContext,
       * @transient private var deps: Seq[Dependency[_]]
       *            ) extends Serializable with Logging {
       *
       */
   ```



**1，分区列表( a list of partitions)**

Spark RDD是被分区的，每一个分区都会被一个计算任务(Task)处理，分区数决定了并行计千算的数量，RDD的并行度默认从父RDD传给子RDD。默认情况下，一个HDFS上的数据分片就是一个 partiton，RDD分片数决定了并行计算的力度，可以在创建RDD时指定RDD分片个数，如果不指定分区数量，当RDD从集合创建时，则默认分区数量为该程序所分配到的资源的CPU核数(每个Core可以承载2~4个 partition)，如果是从HDFS文件创建，默认为文件的 Block数。

**2，每一个分区都有一个计算函数( a function for computing each split）**

每个分区都会有计算函数， Spark的RDD的计算函数是以分片为基本单位的，每个RDD都会实现 compute函数，对具体的分片进行计算，RDD中的分片是并行的，所以是分布式并行计算，有一点非常重要，就是由于RDD有前后依赖关系，遇到宽依赖关系，如reduce By Key等这些操作时划分成 Stage， Stage内部的操作都是通过 Pipeline进行的，在具体处理数据时它会通过 Blockmanager来获取相关的数据，因为具体的 split要从外界读数据，也要把具体的计算结果写入外界，所以用了一个管理器，具体的 split都会映射成 BlockManager的Block，而体的splt会被函数处理，函数处理的具体形式是以任务的形式进行的。



**3，依赖于其他RDD的列表( a list of dependencies on other RDDS)**

由于RDD每次转换都会生成新的RDD，所以RDD会形成类似流水线一样的前后依赖关系，当然宽依赖就不类似于流水线了，宽依赖后面的RDD具体的数据分片会依赖前面所有的RDD的所有数据分片，这个时候数据分片就不进行内存中的 Pipeline，一般都是跨机器的，因为有前后的依赖关系，所以当有分区的数据丢失时， Spark会通过依赖关系进行重新计算，从而计算出丢失的数据，而不是对RDD所有的分区进行重新计算。RDD之间的依赖有两种：窄依赖( Narrow Dependency)和宽依赖( Wide Dependency)。RDD是 Spark的核心数据结构，通过RDD的依赖关系形成调度关系。通过对RDD的操作形成整个 Spark程序。

![img](../../../../%E5%AD%A6%E4%B9%A0/a-%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91/%E7%AC%94%E8%AE%B0/Study-Notes/image/5b82e0a406c44ad888cce1123ed92cf3.webp)

RDD有窄依赖和宽依赖两种不同类型的依赖，其中的窄依赖指的是每一个 parent RDD的 Partition最多被 child rdd的一个 Partition所使用，而宽依赖指的是多个 child RDD的Partion会依赖于同一个 parent RDD的 Partition。可以从两个方面来理解RDD之间的依赖关系，方面是RDD的 parent RDD是什么，另一方面是依赖于 parent RDD的哪些 Partion；根据依赖于 parent RDD的哪些 Partion的不同情况， Spark将 Dependency分为宽依赖和窄依赖两种。Spak中的宽依赖指的是生成的RDD的每一个 partition都依赖于父RDD所有的 partiton宽依赖典型的操作有 group By Key， sort By Key等，宽依赖意味着She操作，这是 Spark划分Sae的边界的依据， Spark中的宽依赖支持两种 Shuffle Manager，即 Hash Shuffemanager和 Sortshuffemanager，前者是基于Hash的 Shuffle机制，后者是基于排序的 Shuffle机制。

**4，key- value数据类型的RDD分区器( a Partitioner for key- alue RDDS)、控制分区策略和分区数**

每个key- alue形式的RDD都有 Partitioner属性，它决定了RDD如何分区。当然，Partiton的个数还决定了每个Sage的Task个数。RDD的分片函数可以分区( Partitioner)，可传入相关的参数，如 Hash Partitioner和 Range Partitioner，它本身针对key- value的形式，如果不是key-ale的形式它就不会有具体的 Partitioner， Partitioner本身决定了下一步会产生多少并行的分片，同时它本身也决定了当前并行( Parallelize) Shuffle输出的并行数据，从而使Spak具有能够控制数据在不同结点上分区的特性，用户可以自定义分区策略，如Hash分区等。 spark提供了 partition By运算符，能通过集群对RDD进行数据再分配来创建一个新的RDD。



**5，每个分区都有一个优先位置列表( a list of preferred locations to compute each split on）**

优先位置列表会存储每个 Partition的优先位置，对于一个HDFS文件来说，就是每个Partition块的位置。观察运行 Spark集群的控制台就会发现， Spark在具体计算、具体分片以前，它已经清楚地知道任务发生在哪个结点上，也就是说任务本身是计算层面的、代码层面的，代码发生运算之前它就已经知道它要运算的数据在什么地方，有具体结点的信息。这就符合大数据中数据不动代码动的原则。数据不动代码动的最高境界是数据就在当前结点的内存中。这时候有可能是 Memory级别或 Tachyon级别的， Spark本身在进行任务调度时会尽可能地将任务分配到处理数据的数据块所在的具体位置。据 Spark的RDD。 Scala源代码函数get Parferredlocations可知，每次计算都符合完美的数据本地性。可在RDD类源代码文件中找到4个方法和1个属性，对应上述所阐述的RDD的五大特性，源代码剪辑如下

![img](../../../../%E5%AD%A6%E4%B9%A0/a-%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91/%E7%AC%94%E8%AE%B0/Study-Notes/image/d1d5e08d0da540ca93479de1f639075a.webp)



##### Spark 源码分析

```scala
//当sc.textFile时,依赖其他RDD的关系为空,所以textFile()方法中hadoopFile的HadoopRDD继承的RDD参数中(SparkContext,Nil),其中Nil为@transient private var deps: Seq[Dependency[_]]时deps为空

new SparkContext(conf)
      //minPartitions和文件切片进行比较,取最大的分区数
      .textFile("bigdata-framework/bigdata-spark/data/testdata.txt",6)

//在HadoopRDD中是怎么读取数据和划分分区数的,通过文件格式化类TextInputFormat来进行切片
override def getPartitions: Array[Partition] = {
    val jobConf = getJobConf()
    // add the credentials here as this can be called before SparkContext initialized
    SparkHadoopUtil.get.addCredentials(jobConf)
    //调用FileInputFormat方法中的getSplits方法来获取切片,也就是分区号
    val allInputSplits = getInputFormat(jobConf).getSplits(jobConf, minPartitions)
    val inputSplits = if (ignoreEmptySplits) {
        allInputSplits.filter(_.getLength > 0)
    } else {
        allInputSplits
    }
    val array = new Array[Partition](inputSplits.size)
    for (i <- 0 until inputSplits.size) {
        array(i) = new HadoopPartition(id, i, inputSplits(i))
    }
    array
}

 .flatMap(_.split(" "))

//sc.clean(f)为一个闭包函数,在spark做分布式计算的时候f这个逻辑函数是要分发出去到不同节点上,此方法检查f这个函数是不是可以可序列化出去
  def flatMap[U: ClassTag](f: T => TraversableOnce[U]): RDD[U] = withScope {
      //cleanF代表为f函数
    val cleanF = sc.clean(f)
      // (context, pid, iter) => iter.flatMap(cleanF)匿名函数
    new MapPartitionsRDD[U, T](this, (context, pid, iter) => iter.flatMap(cleanF))
  }

```





#### 闭包

> 一个函数中有个参数为全局变量函数(序列化传递),这个函数就叫闭包函数,当全局变量值改变时,闭包函数也随之改变
>
> 闭包的大致作用就是：函数可以访问函数外面的变量，但是函数内对变量的修改，在函数外是不可见的.
>
>

RDD相关操作都需要传入自定义闭包函数(closure),如果这个函数需要访问外部变量,那么需要遵循一定的规则,否则会抛出运行时异常.闭包函数传入到节点时,需要经过下面的步骤:

* 驱动程序,通过反射,运行时找到闭包访问的所有边浪,并封装成一个对象,然后序列化该对象
* 将序列化后的对象通过网络传输到workder节点
* worker节点反序列化闭包对象
* worker节点执行闭包函数

> 注意:外部变量在闭包内的修改不会反馈到驱动程序

简而言之,就是通过网络传递函数,然后执行.所以,被传递的变量必须可序列化,否则传递失败,本地执行时,仍然会执行上面四步.

广播机制也可以做到这一点,但是频繁的使用广播会使代码不够简洁,而且广播设计的初衷是将较大数据缓存到节点上,避免多次传输,从而提高计算效率,而不是用于进行外部变量访问.



![1576156955695](image/1576156955695.png)

![1576156977808](image/1576156977808.png)

![1576156933297](image/1576156933297.png)



## 底层原理

### 线程，进程，纤程，中断

![1584843879218](image/1584843879218.png)

父进程 回收时， 操作系统检测他的所有子进程，子进程如果没死，挂给init。

![1584845167623](image/1584845167623.png)

![1584846051756](image/1584846051756.png)

![1584846117978](image/1584846117978.png)

![1584846875282](image/1584846875282.png)

![1584847453346](image/1584847453346.png)

![1584848273827](image/1584848273827.png)

### 内存管理

![1584848113173](image/1584848113173.png)

![1585444872389](image/1585444872389.png)

## 公开课

### AI

#### ①内容反垃圾反作弊



### 推荐系统

![1565093532809](image/1565093532809.png)



![1565875190227](image/1565875190227.png)



### HashMap数据结构

求组连续，链表非连续。求组索引块快，链表添加删除快

![1567339052322](image/1567339052322.png)

![1567339060925](image/1567339060925.png)

默认初始化容量 8和加载因子16

![1567340058329](image/1567340058329.png)

![1567341162061](image/1567341162061.png)

![1567341173210](image/1567341173210.png)



### NIO和堆外内存



![1569316389715](image/1569316389715.png)





# 尚硅谷大数据

![1565141288683](image/1565141288683.png)

24_尚硅谷企业级大数据项目之仿今日头条推荐系统

![1567154061540](image/1567154061540.png)

![1567154109833](image/1567154109833.png)



# Linux笔记

## 安装步骤

``boot`` 引导程序区  200M ext4

``swap``  交换区,一般设置为内存的1倍,内存不足的时候放在交换区中

``用户区`` 设置为硬盘剩余空间

```shell
 在命令行输入#vi  /etc/sysconfig/network-scripts/ifcfg-ens33  #编辑配置文件，添加修改或添加以下内容。
BOOTPROTO=static#启用静态IP地址
ONBOOT=yes  #开启自动启用网络连接
IPADDR=192.168.1.73   #设置网关
GATEWAY=192.168.1.1
NETMASK=255.255.255.0
DNS1=114.114.114.114
DNS2=8.8.8.8
```



获取内核源代码:<http://ftp.sjtu.edu.cn/sites/ftp.kernel.org/pub/linux/kernel/>

## 常用命令

### Vim编译器常用命令



**ZZ** --- 在vi编辑器中保存并退出

**shift+o** -----跳到vi文件中最后一行

**小写o** ---- 另起一行并进入INSERT模式

**dd**  --删除当前行

**ndd**  --删除n行数据

**dG**  --删除当前后之后的全部行

**ny**  ---复制当前行下面n行,

**np** --粘贴上面复制到的行

**D** --删除光标所在行后面数据

**``dw``** --删除光标后面的一个单词

``r 要加入的字符串``    ---不是在编辑模式情况下

``nyy p`` 复制当前n行并粘贴到下一行

``:.,$y``复制光标到最后行

``np``粘贴上步骤复制的数据

``:.,$s/#//``在光标所在的行到最后一行``#``替换空

``dw``删除光标所在的单词

``w`` 跳到下一个空格

``shift+zz``退出vi编辑器



#### 命令模式

（1）向右移动一个单词：w

（2）向左移动一个单词：b

（3）向右移动80个字符：80右箭头（数字和方向，可以随意选取）

（4）快速向左向右移动光标：ctrl + 左右箭头

（5）移动光标到行首：0

（6）移动光标到行尾：$

（7）移动光标到文件最后一行：G

（8）移动光标到文件第一行：1G（数字可以随意选取）

（9）复制光标所在行开始的2行：2yy（数字可以随意选取）

（10）将复制的行粘贴到光标所在行的下面：小写p（小写是下面大写则是上面）

（11）删除光标所在行开始的3行：3dd（数字可以随意选取）

（12）删除光标开始到单词结尾：dw

（13）删除光标开始到行首部分：d0

（14）删除光标开始到行尾部分：d$

（15）撤销上一步的操作：u

(16）重复前一步的操作：ctrl+r

(17）重复前一步的操作：ctrl+r

(18）查找root： /root   按n或N向下、向上继续查找（root是文件中的全部单词）

`Tab`:缩进

`dG`:删除当前后面的全部数据到末尾

光标定位到那行输入命令`:.,$-1y`表示复制光标当前行和最后倒数第二行





![1564679526113](image/1564679526113.png)

#### 编辑模式

（1）用鼠标任意的选中某行，就是已经复制完成了。在容易的地方按下滚轮即粘贴（liucx的一种特色）

（2）按ctrl+n可以实现单词补全。（单词三在所在文件的单词。如果不存在则不能补全）

#### 末行模式

（：属于指令的一部分）

（1）存盘指令：w

（2）另存指令：w 文件名

（3）存盘并退出指令：``wq``

（4）退出指令：``q``

（5）强制退出不存盘指令：q!

（6）将光标定位到第3行 指令 :3（数字可以随意选取）

（7）将光标所在行的第一个A字母替换为B字母的指令 :s/A/B

（如果要替换行中的所有的A，则需要加上字母g为：s/A/B/g）

（如果要替换文件中的所有的A，则需要在加上%s为：%s/A/B/g）

（如果要替换文件中指定的行数，则需要变为：2，10s/A/B/g（数字可以随意选取））

（如果要替换文件中指定的行数到最后一行，则需要变为：2，$s/A/B/g（数字可以随意选取））

（8）显示出行号的指令：``set nu``



```
       --------- 按键盘i键-------->输入模式  (按Esc键回到命令模式)   
        |               
  命令模式 
        | 

        -----------输入 ":" ------> 末行模式 (按Esc键回到命令模式)  

```

三种模式的主要功能：

命令模式：复制，粘贴，删除、移动光标、查找

编辑模式：编辑文本

末行模式：存盘、退出、替换



```shell
##不需要设置export LC_ALL="zh_CN.GBK"
##export LANG="zh_CN.GBK"
vi /root/.bash_profile
##在prod和test下加上
##export LC_ALL="zh_CN.GBK"
##export LANG="zh_CN.GBK"
vi /home/prod/.bash_profile
vi /home/test/.bash_profile
```



![img](../../../../%E5%AD%A6%E4%B9%A0/a-%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91/%E7%AC%94%E8%AE%B0/Study-Notes/image/20190614161903972.png)

![img](../../../../%E5%AD%A6%E4%B9%A0/a-%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91/%E7%AC%94%E8%AE%B0/Study-Notes/image/201906141619293.png)

![img](../../../../%E5%AD%A6%E4%B9%A0/a-%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91/%E7%AC%94%E8%AE%B0/Study-Notes/image/20190614161941847.png)

![å¨è¿éæå¥å¾çæè¿°](../../../../%E5%AD%A6%E4%B9%A0/a-%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91/%E7%AC%94%E8%AE%B0/Study-Notes/image/20190614162014213.png)

![å¨è¿éæå¥å¾çæè¿°](../../../../%E5%AD%A6%E4%B9%A0/a-%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91/%E7%AC%94%E8%AE%B0/Study-Notes/image/20190614162030203.png)

![img](../../../../%E5%AD%A6%E4%B9%A0/a-%E9%A1%B9%E7%9B%AE%E5%BC%80%E5%8F%91/%E7%AC%94%E8%AE%B0/Study-Notes/image/20190614162047797.png)

------

### 其他命令

``lsof －i :80`` 查看80端口被什么程序占用

```shell
##关闭80端口并重新启动Nginx
kill －9 lsof -i :80 |grep nginx |grep -v grep|awk '{print $2}'
## 查看openresty服务是否启动
service openresty status

netstat -tulpn

```

`` chkconfig iptables off``:永久性关闭防火墙

``chkconfig iptables on``:永久性开启防火墙

`find . -name '*.class'`:查看当前目录下的class后缀文件

 ```shell
###查看某个文件中包含的字样前后10行,-i表示忽略大小写。
grep -10 -i 'Exception' catalina.2019-08-14.log

###查看某个文件中要找的字符串2018041417434200258001
##grep-A|B n"key"file A：表示在字符串之后 after  context
    #B：表示在字符串之前 before context
    #n：要获取多少行文本 line number
    #key：为要查找的字符串
    #file：文件名
cat catalina.out|grep '2018041417434200258001'
#查看最后一次重启时间命令：
who -b 
#查看历史重启时间命令：
last reboot

###查看一个进程的启动时间和运行时间
ps -A -opid,stime,etime,args
 ```



```shell
mkdir /root/data&rsync -av /etc/passwd /root/data/passwd.txt
rsync -av --rsh="/usr/bin/ssh -l rsyncuser" /etc/passwd /root/data/data/passwd.txt
```



### rsync命令

#### ①本地文件

![blob.png](image/1520515980556457.png)

 **rsync [OPTION] … [user@]host:SRC   DEST    //把远程机器的内容同步到本地机器中**

 **rsync [OPTION] … SRC   [user@]host::DEST**

 **rsync [OPTION] … [user@]host::SRC   DEST**

**[option] :选项         SRC : 源目录、文件      DEST：目标目录、文件**



 -a 包含-rtplgoD这些选项

 -r 同步目录时要加上，类似cp时的-r选项

 -v 同步时显示一些信息（速度，字节等），让我们知道同步的过程

 -l 保留软连接（A->B同步时，把软链接保存到B，但B无软链接的源文件，软链接在B上会            报错，失效。）

 -L 加上该选项后，同步软链接时会把源文件给同步

 -p 保持文件的权限属性

 -o 保持文件的属主

 -g 保持文件的属组

 -D 保持设备文件信息

 -t 保持文件的时间属性

 --delete 删除DEST（目标目录）中SRC（源目录）没有的文件，加这个选项则会同步成一模一样（A有1.txt 2.txt  B有3.txt,同步时加--delete则会把B中的3.txt删除） 

 --exclude 过滤指定文件，如--exclude “logs”会把文件名包含logs的文件或者目录过滤掉，不同步

 -P 显示同步过程，比如速率，比-v更加详细

 -u 加上该选项后，如果DEST中的文件比SRC新，则不同步

 -z 传输时压缩，则可以省时间，节省带宽。

#### ②rsync通过ssh同步

![blob.png](image/1520583597549320.png)

**rsync [选项]  备份文件数据  [user@]ip: 目标地址**





![1566288360240](image/1566288360240.png)

`tcpdump -nn -i eth0 port 80`

`telnet www.baidu.com 80`



### seq命令

**seq命令**用于产生从某个数到另外一个数之间的所有整数。

#### 语法

```shell
seq [选项]... 尾数
seq [选项]... 首数 尾数
seq [选项]... 首数 增量 尾数
```

#### 选项

```
-f, --format=格式        使用printf 样式的浮点格式
-s, --separator=字符串   使用指定字符串分隔数字（默认使用：\n）
-w, --equal-width        在列前添加0 使得宽度相同
```

------

#### 实例

**-f选项：指定格式**

```shell
[root@base ~]#seq -f"%3g" 9 11
9
10
11
```

`%`后面指定数字的位数 默认是`%g`，`%3g`那么数字位数不足部分是空格。

```shell
[root@base ~]#sed -f"%03g" 9 11
[root@base ~]#seq -f"str%03g" 9 11
str009
str010
str011
```

这样的话数字位数不足部分是0，`%`前面制定字符串。

**-w选项：指定输出数字同宽**

```shell
[root@base ~]#seq -w 98 101
098
099
100
101
```

不能和`-f`一起用，输出是同宽的。

**-s选项：指定分隔符（默认是回车）**

```shell
[root@base ~]#seq -s" " -f"str%03g" 9 11
str009 str010 str011
```

要指定`/t`做为分隔符号：

```shell
[root@base ~]#seq -s"`echo -e "/t"`" 9 11
```

指定`\n`作为分隔符号：

```shell
[root@base ~]#seq -s"`echo -e "\n"`" 9 11
19293949596979899910911
```

得到的是个错误结果，不过一般也没有这个必要，它默认的就是回车作为分隔符。

------

**例子：**

```shell
#! /bin/bash
# 打印乘法表
for i in `seq 1 9`
do
    for j in `seq 1 $i`
    do 
        res=`expr $j \* $i`
        echo -e "$j*$i=$res\t\c"
   done 
    echo -e " "
done 
```

 

### nc命令

```shell
#监听本地端口号
nc -l 8080

```



### find命令

```shell
find . -type f -size +800M|xargs ls -lh #列举出当前目录所有大于800M的文件
-type:类型。POSIX支持——b:块设备文档、d:目录、c:字符设备文档、P:管道文档、l:符号链接文档、f:普通文档 
-name:按文件名查找。支持*模糊匹配 
-size:文件大小。+表示大于，-表示小于。支持k,M,G单位。
|xargs:它的作用就是把管道进来的参数切分成多个部分，分别作为新的参数调用后续的命令

find -print0:表示在find的每一个结果之后加一个NULL字符，而不是默认加一个换行符。find的默认在每一个结果后加一个'\n'，所以输出结果是一行一行的。当使用了-print0之后，就变成一行了
xargs -0:表示xargs用NULL来作为分隔符。这样前后搭配就不会出现空格和换行符的错误了。选择NULL做分隔符，是因为一般编程语言把NULL作为字符串结束的标志，所以文件名不可能以NULL结尾，这样确保万无一失。

#find命令通过排序只保留最新的文件目录
find /u01/backup/backup/prod  -name "prod*.gz" | sort -nr | awk '{if (NR>=2){print $1}}' | xargs rm -rf

find ./ -type f -size +800M -print0|xargs -0 du -h --max-depth=2|sort -nr
```



### awk命令

```shell
awk '{if (NR>=2){print $1}}'
$0 代表整个文本行；
$1 代表文本行中的第 1 个数据字段；
$2 代表文本行中的第 2 个数据字段；
$n 代表文本行中的第 n 个数据字段。
```



### tar命令

```shell

```



### 查看端口

1. netstat 是一个命令行工具，可以提供有关网络连接的信息,列出正在侦听的所有 TCP 或 UDP 端口，包括使用端口和套接字状态的服务，请使用以下命令：
   netstat -tunlp

2. ss 是新的 netstat，命令选项大致相同。它缺少一些 netstat 功能，但暴露了更多的 TCP 状态，而且速度稍快。

3. lsof 是一个功能强大的命令行实用程序，它提供有关进程打开的文件的信息。

   在 Linux 中，一切都是文件，可以将套接字视为写入网络的文件。

   要使用 lsof 获取所有侦听 TCP 端口的列表：
   lsof -nP -iTCP -sTCP:LISTEN

   查看正在监听特定端口的进程：sudo lsof -nP -iTCP:3306 -sTCP:LISTEN

使用的选项如下：
-n - 不要将端口号转换为端口名称。
-p - 不要解析主机名，显示数字地址。
-iTCP -sTCP:LISTEN - 仅显示 TCP 协议状态为 LISTEN 的网络文件。

### 其他命令

```shell
#查看端口是否被监听
netstat -tulp

touch file{0..9}.txt
rm -rf file{0..9}
mkdir dir{0..9}

#查找文件并排序
find  dir  -name "*.txt"  | sort
ls  $(find dir -name "*.txt")

#列出带有Server前后30行
grep -30 Server catalina.out 
```

### 启动jar相命令

#### 窗口运行

java -jar DataSync.jar

#### 后台运行

```shell
# 运行java命令时 会出现并保持一个console窗口 程序中的信息可以通过System.out在console内输出
# 而运行javaw 开始时会出现console 当主程序调用之后 console就会消失 javaw大多用来运行GUI程序
# @echo off执行后 后面所有的命令均不显示 包括本条命令
# echo off执行后 后面所有的命令均不显示 但显示本条命令
# start 在新的窗口打开
@echo off
start "data-sync" javaw -jar DataSync.jar
exit # exit退出窗口命令可以省略
```



```shell
# 0 标准输入 一般是键盘
# 1 标准输出 一般是显示屏 是用户终端控制台
# 2 标准错误 错误信息输出
# 将运行的jar 错误日志信息输出到log.file文件中 然后 >&1就是继续输出到标准输出
#前面加的& 是为了让系统识别是标准输出 最后一个& 表示在后台运行
nohup java -jar DataSync.jar > log.file 2 > &1&
# 不指定日志配置可以简写如下 默认输出被重定向到nohup.out文件
nohup java -jar DataSync.jar&
```

## 常用地址

[Linux运维笔记](https://linuxeye.com/)

## ln命令

``ln`` 命令用于创建链接文件，格式为“``ln [选项] 目标``”，其可用的参数以及作用如下：

``-b`` 删除，覆盖以前建立的链接

``-d`` 允许超级用户制作目录的硬链接

``-f`` 强制执行

``-i`` 交互模式，文件存在则提示用户是否覆盖

``-n`` 把符号链接视为一般目录

``-s`` 软链接(符号链接)

``-v`` 显示详细的处理过程

```shell
##向文件写入内容并创建
echo "Welcomne to Linux" > readmes.txt 
##向文件写入内容并创建
echo "Welcomne to Linux" > readme.txt 
##创建软链接,前面是源文件,后面是链文件
ln -s readmes.txt readits.txt
##创建一个硬链接
ln readme.txt readit.txt 
## 当查询生成软链接的源文件信息时,会展现硬盘链接数为1
ls -l readmes.txt
## 当查询生成硬链接的源文件信息时,会展现硬盘链接数为2
ls -l readme.txt
##删除源文件,软文件不会
rm -f readmes.txt
##删除源文件,软文件不会
rm -f readme.txt
## 访问软链文件的时候也将失效,当访问的是硬链文件的时候源文件删掉会还会访问硬链文件中的数据
cat readits.txt
cat: readits.txt: No such file or directory

## 访问硬链文件的时候也将失效,当访问的是硬链文件的时候源文件删掉会还会访问硬链文件中的数据
cat readits.txt
cat: readits.txt: No such file or directory
```

![1563332918755](image/1563332918755.png)

![1563333757009](image/1563333757009.png)

**说明**：**软链接**在删除掉原始文件后，它的链接文件将会失效，无法再访问文件内容，类似于Windows的快捷方式。**硬链接**在删除原始文件后，它的链接文件还可以继续访问，这是因为新建的硬链接不再依赖原始文件的名称等信息，我们可以看到在创建完硬链接后，原始文件的硬盘链接数量增加到了2，如果想要彻底删除，链接数成0才算彻底删除。设置全局

```bash
ln -s /home/node-v4.4.4-linux-x64/bin/node /usr/local/bin/node  
ln -s /home/node-v4.4.4-linux-x64/bin/npm /usr/local/bin/npm  
```



## Linux如何管理目录和文件属性

概述：在Linux文件系统的安全模型中，为系统中的文件（或目录）赋予了两个属性：访问权限和文件所有者，简称为“权限”和“归属”。其中，访问权限包括读取、写入、可执行三种基本类型，归属包括属主（拥有该文件的用户账号）、属组（拥有该文件的组账号）。Linux系统根据文件或目录的访问权限、归属来对用户访问数据的过程进行控制。

### 一、查看目录和文件的属性

使用带“-l”选项的ls命令时，将以长格式显示文件或目录的详细信息，其中包括了该文件的权限和归属等参数。例如，执行以下操作可以列出/etc目录和/etc/passwd文件的详细属性。

![img](image/u=2945884129,1354228025&fm=173&app=49&f=JPEG.jpg)

如“-rw-r--r--.”由四部分组成，各自的含义如下：

第1个字符：表示该文件的类型，可以是d（目录）、b（块设备）、c（字符设备文件）、“-”（普通文件）、字母“l”（链接文件）等。

第2~4个字符：表示该文件的属主用户（user）对该文件的访问权限。

第5~7个字符：表示该文件的属组内各成员用户对该文件的访问权限。

第8~10个字符：表示其他任何用户（Other）对该文件的访问权限。

第11个字符：这里的“.”与SELinux有关，目前不必关注。

“r、w、x”分别表示可读、可写、可执行。若需要去除对应的权限，则使用“-”表示。

![img](image/u=2315803544,881261301&fm=173&app=49&f=JPEG.jpg)

### 二、设置目录和文件的权限

通过chmod命令设置文件或目录的权限，可以采用两种形式的权限表示方法：字符形式和数字形式。r、w、x权限字符可分别表示为八进制数字4、2、1，表示一个权限组合时需要将数字进行累加。

![img](image/u=3090151739,2537553744&fm=173&app=49&f=JPEG.jpg)

如：“rwx”采用累加数字形式可表示为“7”，“r-x”可表示为“5”，而“rwxr-xr-x”由三个权限段组成，因此可以表示成“755”

chmod命令格式：

格式1：

![img](image/u=3593881940,3207782497&fm=173&app=49&f=JPEG.jpg)

格式2：

![img](image/u=1729082947,175257211&fm=173&app=49&f=JPEG.jpg)



常用命令选项：

-R：递归修改指定目录下所有子项的权限

示例：



![img](image/u=236109253,545590266&fm=173&app=49&f=JPEG.jpg)



### 三、设置目录和文件的归属

使用chown命令为文件或目录设置归属

命令格式：

chown 属主 文件或目录

chown :属组 文件或目录

chown 属主:属组 文件或目录

注：同时设置属主、属组时，用户名和组名之间用冒号“：”进行分隔。如果只设置属组时，需使用“：组名”的形式。

常用选项：

-R：递归修改指定目录下所有文件、子目录的归属

示例：

![img](image/u=3296809002,1831454160&fm=173&app=49&f=JPEG.jpg)

## rsync工具介绍

**rsync：数据备份工具（remote sync）。**

**rsync不仅可以远程同步数据(类似scp)，而且可以本地同步数据（类似cp），但是不同于cp或scp的一点是，如果数据存在的话它不会覆盖以前的数据，而是会先判断已存在的数据是否和新的数据有差异，只有数据不同时才会把不同的部分覆盖。**

 **（系统如果没有rsync命令，安装：yum install -y rsync）**

**![blob.png](image/1520515980556457-1566228599652.png)**

**(如：有两台机器A、B，要把A的数据每小时都备份到B下，而且A的文件世事刻刻都在更新，如果我们每小时在备份的时候使用的是** **cp** **操作，则每次都是把B上的文件都覆盖一次，这样我们耗费的时间就很久（如果内容很大）。但是使用rsync则会把A和B之间数据不同的部分进行覆盖，这样耗费的时间就会断，耗费带宽也会小)**



**1.使用rsync 对本地文件进行操作：**

**rsync -av /etc/passwd /tmp/1.txt   （把/etc/passwd 同步到/tmp下，命名为1.txt）**

**![blob.png](image/1520516840408864.png)**



**2.使用rsync远程同步 （进行远程同步必须远程机器和本地机器都得安装有rsync工具）**

**格式：rsync [选项]  备份文件数据  [user@]ip: 目标地址**

**（[user@]可以省略 ，表示拷贝到user这个用户下。“：”后面跟路径）**

**rsync -av /tmp/1.txt root@192.168.136.134:/tmp/2.txt**

**![blob.png](image/1520518042475556.png)**



### 其他选项

 **rsync格式**

 **rsync [OPTION] … SRC   DEST**



 **rsync [OPTION] … SRC   [user@]host:DEST**      把文件同步到远程机器上，[user@]可以省略，如果不加这个选项，则我们在执行这条命令时是什么用户（如在root用户下），则会同步到远程机器ip和执行这条命令时用户（root用户，如果远程机器没有这个目录则会报错）下。两则保持统一。



 **rsync [OPTION] … [user@]host:SRC   DEST    //把远程机器的内容同步到本地机器中**

 **rsync [OPTION] … SRC   [user@]host::DEST**

 **rsync [OPTION] … [user@]host::SRC   DEST**

**[option] :选项         SRC : 源目录、文件      DEST：目标目录、文件**



### rsync常用选项

 -a 包含-rtplgoD这些选项

 -r 同步目录时要加上，类似cp时的-r选项

 -v 同步时显示一些信息（速度，字节等），让我们知道同步的过程

 -l 保留软连接（A->B同步时，把软链接保存到B，但B无软链接的源文件，软链接在B上会            报错，失效。）

 -L 加上该选项后，同步软链接时会把源文件给同步

 -p 保持文件的权限属性

 -o 保持文件的属主

 -g 保持文件的属组

 -D 保持设备文件信息

 -t 保持文件的时间属性

 --delete 删除DEST（目标目录）中SRC（源目录）没有的文件，加这个选项则会同步成一模一样（A有1.txt 2.txt  B有3.txt,同步时加--delete则会把B中的3.txt删除） 

 --exclude 过滤指定文件，如--exclude “logs”会把文件名包含logs的文件或者目录过滤掉，不同步

 -P 显示同步过程，比如速率，比-v更加详细

 -u 加上该选项后，如果DEST中的文件比SRC新，则不同步

 -z 传输时压缩，则可以省时间，节省带宽。



### 常用命令同步方式

#### ①本地连接

**做试验（本地）源目录/root/111/      目标目录：/tmp/**

**1.rsync -av /root/111/ /tmp/111_dest/**

![blob.png](image/1520522080579526.png)

**但是此时的软链接文件是失效的**

**![blob.png](image/1520522179151287.png)**

**加上-L 同步软链接时会把源文件给同步**

**rsync -avL/root/111/ /tmp/111_dest/ (虽然-a中此时有小l,但是L在则会先执行-L功能)**

**![blob.png](image/1520522441811769.png)**



**（因为一开始软链接失效，所以再次操作时，先把B上的软链接指向先做成有效，如下图：）**

**![blob.png](image/1520522558662527.png)**



**2.在/tmp/111_dest/下创建多一个文件new.txt**

 **touch /tmp/111_dest/new.txt**

**使用 --delete  删除DEST（目标目录）中SRC（源目录）没有的文件**

**(删除/tmp/111_dest/new.txt)**

 **![blob.png](image/1520523382122581.png)**



**3.过滤 --exclude（先删除在测试：rm -rf /tmp/111_dest/\*）**

**rsync -avL --exclude "\*.txt" /root/111/ /tmp/111_dest/**

**(同步时过滤所有 .txt文件)**

**![blob.png](image/1520523723603682.png)**

**支持多个 --exclude连写**

**rsync -avL --exclude "\*.txt" --exclude "cansheng*" /root/111/ /tmp/111_dest/**



**4.-P选项**   **显示同步过程，比如速率，比-v更加详细** 

**![blob.png](image/1520523983145210.png)**



**5. -u选项**

**DEST中的文件比SRC新，则不同步**

**如/tmp/111_dest/的文件4913内容更改，新增内容（源/root/111/4913文件下无内容）**

 **rsync -avPu /root/111/ /tmp/111_dest/**

**![blob.png](image/1520524613938002.png)**



#### ②rsync通过ssh同步

**![blob.png](image/1520583597549320-1566228600053.png)**

**（现有A机器：192.168.136.133； B机器：192.168.136.134。并且两台机器能相互通信）**



 **1.A-->B**

**r****sync -av /etc/passwd root@192.168.136.134:/tmp/cansheng.txt**

**![blob.png](image/1520583909670295.png)**

  **B-->A**

**rsync -avP  root@192.168.136.134:/tmp/cansheng.txt  /tmp/123.txt**

**![blob.png](image/1520584284245801.png)**



**2.指定端口： -e "ssh -p 端口号"**

**（-e "ssh -p 22"  指定对方22端口）**

**rsync -avP -e "ssh -p 22" /etc/passwd root@192.168.136.134:/tmp/cansheng.txt**

![blob.png](image/1520584551236879.png)



**ssh -p 端口号+ip （远程连接命令）**

**![blob.png](image/1520584821136033.png)**



#### ③rsync通过服务同步

**通过服务同步：首先要开始一个服务（架构是c/s，客户端和服务端，服务端开启一个rsync服务，并且监听一个端口（默认873，但是可以自定义），客户端就可以通过873端口和服务端进行通信）**

格式：

```shell
rsync -av test1/ 192.168.136133:module/dir/
```

**(A:服务端，B客户端)**

**开启服务前：(对A机器)**

**1.修改配置文件：/etc/rsyncd.conf**

   `rsyncd.conf`样例

  添加以下内容：

```shell
port=873
log file=/var/log/rsync.log
pid file=/var/run/rsyncd.pid
address=192.168.136.133
[test]
path=/tmp/rsync ##(首先这个目录要存在，不存在就创建mkdir /tmp/rsync。修改权限方便实验：chmod 777 /tmp/rsync)
use chroot=false
max connections=4
read only=no
list=true
uid=root
gid=root
auth users=test
secrets file=/etc/rsyncd.passwd ##--》定义密码的 
hosts allow=192.168.136.134 
```

![blob.png](image/1520591466723504.png)

![blob.png](image/1520601012895605.png)

**2.启动服务：rsync --daemon**

**(查看服务启动是否成功 ：ps aux |grep rsync)**

**![blob.png](image/1520588109415909.png)**

**netstat -lntp  查看监听端口**

**![blob.png](image/1520588269516334.png)**



**3.在B机器上同步一个文件到A**

 **rsync -avP /tmp/cansheng.txt 192.168.136.133::test/cansheng-02.txt**

**(::后面的test是在上诉配置文件中/etc/rsyncd.conf定义的模块名![blob.png](image/1520589133804668.png)，这里代表test=/tmp/rsync）**



**出现报错：**

**![blob.png](image/1520589234994663.png)**

**出现这种问题首先查看网路的联通性：ping 192.168.136.133**

**若通，则测试监听端口是否同。命令：telnet ip 端口**

**telnet 192.168.136.133 873  (yum install -y telnet)**

**如果测试端口有问题**

![blob.png](image/1520589542679689.png)

**此时报错：**

**首先判断是否iptables的问题 iptables -nvL** 

**![blob.png](image/1520589851354581.png)(有问题)**

**若是iptables 问题，则把firewalld停掉（A和B机器都停掉）：systemctl stop firewalld**



**此时再次执行：telnet 192.168.136.133 873** 

**（出现图中信息则正确，退出则为：ctrl+u+]  后 qiut）**

**![blob.png](image/1520590017600601.png)**



**再运行：****在B机器上同步一个文件到A**

 **rsync -avP /tmp/cansheng.txt 192.168.136.133::test/cansheng-02.txt**

![blob.png](image/1520590223644190.png)



**（输入密码即可。那么这个输入的密码实在哪里定义呢？答案是：/etc/rsyncd.conf中**



**![blob.png](image/1520590340848072.png)的secrets file定义，如果不想输入密码，则删除或注释掉进行）**

**（为什么视频中auth users也注释掉？）**



**![blob.png](image/1520590623148026.png)**

**（同步成功，A中有同步的文件存在![blob.png](image/1520590687484405.png)）**



**(/etc/rsync/conf 文件修改了要重启，但是重启了端口不会变（netstat -lntp 查看****）**

**但是/etc/rsync/conf 文件修改了use chroot=false这行则不用重启 )**



​      **修改端口：8730 (B:运行命令时要指定端口--port 8730）**

**![blob.png](image/1520597389250418.png)**

**killall rsync** 

**ps aux |grep rsync**

**![blob.png](image/1520597537774369.png)**

**启动服务：rsync --daemon**

**netstat -lntp**

**![blob.png](image/1520597669113753.png)**

**rsync -avP  192.168.136.133::test/  /tmp/test/**

**(因为修改了端口此时运行这条命令会出错)**

**![blob.png](image/1520599306795215.png)**

**修改命令后，端口不在是默认的873。运行命令时要指定端口号 --port 8730**

**rsync -avP --port 8730 192.168.136.133::test/  /tmp/test/**

**![blob.png](image/1520599515555638.png)**



**在配置文件中/etc/rsyncd.conf**

**中添加的内容里**

**![blob.png](image/1520601143209492.png)auth users=test 指定传输时要使用的用户名。**

**(上述实验中我们把auth users=test和secrets file注释了操作的，一下是删掉这两行注释)**

**在同步时使用指定用户和密码：**



**auth users：指定传输时要使用的用户名。**

 **secrets file：指定密码文件，该参数连同上面的参数如果不指定，则不使用密码验证。注意该密码文件的权限一定要是600。格式：用户名:密码**



**密码文件：/etc/rsyncd.passwd**

**vim /etc/rsyncd.passwd**

**![blob.png](image/1520603592697610.png)**

**然后修改文件权限：chmod 600 /etc/rsyncd.passwd**

**B机器上执行：rsync -avP /tmp/test --port=8730 test@192.168.136.133::test/**

**（这是就要设置密码和输入密码了。）**

**![blob.png](image/1520603939428988.png)**



**怎么在同步时不用手动输入密码呢？**

**在客户端也定义一个密码文件：（如：/etc/rsync_pass.txt）**

​    **vi /etc/rsync_pass.txt  在文件中直接写入我们在服务端A：/etc/rsyncd.passwd文件中用户名的密码进行（只写密码）**



**修改文件权限600：chmod 600  /etc/rsync_pass.txt**

**此后在同步时再加上一个选项 --password-file=密码文件路径**

**rsync -avP /tmp/test --port=8730 --password-file=etc/rsync_pass.txt  test@192.168.136.133::test/**

**这时候同步就不需要在客户端B手动输入密码:**

**![blob.png](image/1520604948393142.png)**



**(总结：当我们在这两个选项中设定了用户和密码文件时，如果想在客户端同步且不用手动输入命令**

```shell
auth users=test
secrets file=/etc/rsyncd.passwd
```



**首先编辑服务端密码文件（vi /etc/rsyncd.passwd 添加内容，格式：用户名:密码）**

**接着修改该文件（vi /etc/rsyncd.passwd）权限600，chmod 600 /etc/rsyncd.passwd**

**再在客户端上定义一个密码文件：（如：/etc/rsync_pass.txt）在文件里直接添加刚刚服务端文件定义的密码**

**再修改该文件权限600 ，chmod 600 /etc/rsync_pass.txt**

**最后执行同步命令即可**

**)**



## Linux系统日志

**我们的服务在运行的时候，当出现了问题往往能通过相应的日志文件来检查到出现的错误**

**日志文件记录了系统每日的各种事情（监控系统状态，排查系统故障等），通过日志来检查错误发生的原因，或者受到攻击时攻击者留下的痕迹。**

**![blob.png](image/1520606317713229.png)**



**日志切割配置文件： /etc/logrotate.conf  (**

 参考https://my.oschina.net/u/2000675/blog/908189

**)**

**（系统为了防止日志过于大，可以实现了切割。命令：ls /var/log/messages\*可以查看到切割后的文件**

   **![blob.png](image/1520606628405488.png)**

 **）**

**cat /etc/logrotate.conf**

**![blob.png](image/1520606836664744.png)**



**命令：dmesg (会把系统硬件相关的日志列出来，但是都是保存在内存中)**

**![blob.png](image/1520607334663263.png)**

**dmesg -c 把内存中的日志清空，但是重启又会加载**



**/var/log/dmesg 日志  系统启动的一个日志（与命令dmesg没关联）**

**![blob.png](image/1520607548322015.png)**



**命令 :last     查看正确登录的历史   （命令：last 是调用 /var/log/wtmp（二进制文件））**

**![blob.png](image/1520607644662238.png)**



**命令：lastb  查看 登录失败的用户信息 ，调用/var/log/btmp二进制文件**

![blob.png](image/1520607840395733.png)



**安全日志：/var/log/secure**

**![blob.png](image/1520607905797172.png)**

**当我们的机器受到黑客破解我们的登录密码或者其他操作时这个安全日志就会有记录**



## screen工具

**(使用场景：有一个脚本需要运行几个小时或几天，过程中若断网该怎么解决？**

**为了避免断网造成中断有两种方法：**

**1.任务放到后台执行，加一个日志输出**

 **nohup command（执行命令） &**

**如：nohup /user/local/sbin/xxx.sh &**

**(使用nohup将任务放置后台执行，执行后会生成nohup的一个文件，这文件就是防止进程意外中断，并会把输出信息记录到nohup文件中)**

**nohup不能时刻将输出内容显示在屏幕上**

**2.screen工具（yum install -y screen）**

**命令：screen  直接回车就进入了虚拟终端**

**screen +任务/命令 （此时任务不会中断）**

**![blob.png](image/1520609363503080.png)**

**ctral a组合键再按d退出虚拟终端，但不是结束（把screen放到后台）**

**screen -ls 查看虚拟终端列表**

![blob.png](image/1520609506287239.png)



**把screen再调回来 screen -r id号**

**screen -r 3895**

**( screen -r id 进入指定的终端)**

**终止（杀死）screen进程： exit**

**exit 后screen -ls 则没screen任务了**

**![blob.png](image/1520609826175820.png)**

**screen -ls 查看虚拟终端列表**

**当我们要执行很多个screen时，为了方便的知道到底相应id对应的任务是什么：**

**进入screen时定义相应的名字：**

**screen -S 定义的名字 （screen -S vmstat_test）**

**![blob.png](image/1520610097499701.png)**

**这个时候进入到指定终端screen，就有两种方法：**

**1. screen -r id**

**2. screen -r 定义的名字**



## 文件描述符(FD)和文件

Every program we run on the command line automatically has three data streams connected to it.

- STDIN (0) - Standard input (data fed into the program)
- STDOUT (1) - Standard output (data printed by the program, defaults to the terminal)
- STDERR (2) - Standard error (for error messages, also defaults to the terminal)

![1567527851585](image/1567527851585.png)

Piping and redirection is the means by which we may connect these streams between programs and files to direct data in interesting and useful ways.

We'll demonstrate piping and redirection below with several examples but these mechanisms will work with every program on the command line, not just the ones we have used in the examples.

## MAN

```shell
wget https://src.fedoraproject.org/repo/pkgs/man-pages-zh-CN/manpages-zh-1.5.1.tar.gz/13275fd039de8788b15151c896150bc4/manpages-zh-1.5.1.tar.gz

tar zxf manpages-zh-1.5.1.tar.gz -C /usr/src/

./configure --prefix=/usr/share/zwman --disable-zhtw && make && make install

echo "alias cman='man -M /usr/share/zwman/share/man/zh_CN'" >> ~/.bash_profile
```



## 页缓存

​         为了便于形成页缓存、文件和进程之间关系的清晰思路，文章画出一幅图，如图2所示。

![img](image/201804281624126.png)

​                                                                   页缓存及其相关结构



页面缓存 —— 保存在内存中的页面大小的文件块。为了用图去说明页面缓存，我捏造出一个名为 `render` 的 Linux 程序，它打开了文件 `scene.dat`，并且一次读取 512 字节，并将文件内容存储到一个分配到堆中的块上。第一次读取的过程如下：

![img](image/v2-35ed5c86ea7ba4472af1249e2fa46643_hd.jpg)

​                                                      Reading and the page cache





## Epoll/Select/Poll

### 其他博客地址

<https://www.cnblogs.com/lojunren/p/3856290.html>



**I/O多路复用**:可以监视多个描述符，一旦某个描述符就绪（一般是读就绪或者写就绪），能够通知程序进行相应的读写操作。先构造一张有关描述符的列表（epoll中为队列），然后调用一个函数，直到这些描述符中的一个准备好时才返回，返回时告诉进程哪些I/O就绪。select和epoll这两个机制都是多路I/O机制的解决方案，select为POSIX标准中的，而epoll为Linux所特有的。

**轮询**:用一个进程，但是使用非阻塞的I/O读取数据，当一个I/O不可读的时候立刻返回，检查下一个是否可读，这种形式的循环为轮询（polling）。

　1. select的句柄数目受限，在linux/posix_types.h头文件有这样的声明：#define __FD_SETSIZE 1024 表示select最多同时监听1024个fd。而epoll没有，它的限制是最大的打开文件句柄数目。

　2. epoll的最大好处是不会随着FD的数目增长而降低效率，在selec中采用轮询处理，其中的数据结构类似一个数组的数据结构，而epoll是维护一个队列，直接看队列是不是空就可以了。epoll只会对“活跃”的socket进行操作---这是因为在内核实现中epoll是根据每个fd上面的callback函数实现的。那么，只有“活跃”的socket才会主动的去调用 callback函数（把这个句柄加入队列），其他idle状态句柄则不会，在这点上，epoll实现了一个“伪”AIO。但是如果绝大部分的I/O都是“活跃的”，每个I/O端口使用率很高的话，epoll效率不一定比select高（可能是要维护队列复杂）。

　3. 使用mmap加速内核与用户空间的消息传递。无论是select，poll还是epoll都需要内核把FD消息通知给用户空间，如何避免不必要的内存拷贝就很重要，在这点上，epoll是通过内核于用户空间mmap同一块内存实现的。

　　![epoll和select的区别](image/2755783-1G1101622002Y-1567489684700.png)



**select，poll，epoll都是IO多路复用中的模型。再介绍他们特点时，先来看看多路复用的 模型。**

![这里写图片描述](image/dee7ceb0c21f4668b59c827164feef4f.png)



同其他IO的不同的是,IO多路复用一次可以等多个文件描述符。大大提高了等待数据准备好的时间的效率。为了完成等的效率，系统提供了三个系统调用：select，poll，epoll。



这里不再讲述三者具体实现，只总结三者的优缺点。



### select的缺点

1. **单个进程监控的文件描述符有限，通常为1024*8个文件描述符。**

当然可以改进，由于select采用轮询方式扫描文件描述符。文件描述符数量越多，性能越差。

2. **内核/用户数据拷贝频繁，操作复杂。**

select在调用之前，需要手动在应用程序里将要监控的文件描述符添加到fed_set集合中。然后加载到内核进行监控。用户为了检测时间是否发生，还需要在用户程序手动维护一个数组，存储监控文件描述符。当内核事件发生，在将fed_set集合中没有发生的文件描述符清空，然后拷贝到用户区，和数组中的文件描述符进行比对。再调用selecct也是如此。每次调用，都需要了来回拷贝。

3. **轮回时间效率低**

select返回的是整个数组的句柄。应用程序需要遍历整个数组才知道谁发生了变化。轮询代价大。

4. **select是水平触发**

应用程序如果没有完成对一个已经就绪的文件描述符进行IO操作。那么之后select调用还是会将这些文件描述符返回，通知进程。



### poll特点

1. **poll操作比select稍微简单点。select采用三个位图来表示fd_set，poll使用pollfd的指针**

pollfd结构包含了要监视的event和发生的evevt，不再使用select传值的方法。更方便

2. **select的缺点依然存在**



拿select为例，加入我们的服务器需要支持100万的并发连接。则在FD_SETSIZE为1024的情况下，我们需要开辟100个并发的进程才能实现并发连接。除了进程上下调度的时间消耗外。从内核到用户空间的无脑拷贝，数组轮询等，也是系统难以接受的。因此，基于select实现一个百万级别的并发访问是很难实现的。



### epoll模型

由于epoll和上面的实现机制完全不同，所以上面的问题将在epoll中不存在。



在select/poll中，服务器进程每次调用select都需要把这100万个连接告诉操作系统（从用户态拷贝到内核态）。让操作系统检测这些套接字是否有时间发生。轮询完之后，再将这些句柄数据复制到操作系统中，让服务器进程轮询处理已发生的网络时间。这一过程耗时耗力，



**而epoll通过在linux申请一个建议的文件系统，把select调用分为了三部分。**



1）调用epoll_create建立一个epoll对象，这个对象包含了一个红黑树和一个双向链表。并与底层建立回调机制。



2）调用epoll_ctl向epoll对象中添加这100万个连接的套接字



3）调用epoll_wait收集发生事件的连接。



从上面的调用方式就可以看到epoll比select/poll的优越之处：因为后者每次调用时都要传递你所要监控的所有socket给select/poll系统调用，这意味着需要将用户态的socket列表copy到内核态，如果以万计的句柄会导致每次都要copy几十几百KB的内存到内核态，非常低效。而我们调用epoll_wait时就相当于以往调用select/poll，但是这时却不用传递socket句柄给内核，因为内核已经在epoll_ctl中拿到了要监控的句柄列表。



所以，实际上在你调用epoll_create后，内核就已经在内核态开始准备帮你存储要监控的句柄了，每次调用epoll_ctl只是在往内核的数据结构里塞入新的socket句柄。



在内核里，一切皆文件。所以，epoll向内核注册了一个文件系统，用于存储上述的被监控socket。当你调用epoll_create时，就会在这个虚拟的epoll文件系统里创建一个file结点。当然这个file不是普通文件，它只服务于epoll。



epoll在被内核初始化时（操作系统启动），同时会开辟出epoll自己的内核高速cache区，用于安置每一个我们想监控的socket，这些socket会以红黑树的形式保存在内核cache里，以支持快速的查找、插入、删除。这个内核高速cache区，就是建立连续的物理内存页，然后在之上建立slab层，简单的说，就是物理上分配好你想要的size的内存对象，每次使用时都是使用空闲的已分配好的对象。



#### epoll的高效



epoll的高效就在于，当我们调用epoll_ctl往里塞入百万个句柄时，epoll_wait仍然可以飞快的返回，并有效的将发生事件的句柄给我们用户。这是由于我们在调用epoll_create时，内核除了帮我们在epoll文件系统里建了个file结点，在内核cache里建了个红黑树用于存储以后epoll_ctl传来的socket外，还会再建立一个list链表，用于存储准备就绪的事件，当epoll_wait调用时，仅仅观察这个list链表里有没有数据即可。有数据就返回，没有数据就sleep，等到timeout时间到后即使链表没数据也返回。所以，epoll_wait非常高效。



而且，通常情况下即使我们要监控百万计的句柄，大多一次也只返回很少量的准备就绪句柄而已，所以，epoll_wait仅需要从内核态copy少量的句柄到用户态而已，如何能不高效？！



#### 就绪list链表维护



那么，这个准备就绪list链表是怎么维护的呢？当我们执行epoll_ctl时，除了把socket放到epoll文件系统里file对象对应的红黑树上之外，还会给内核中断处理程序注册一个回调函数，告诉内核，如果这个句柄的中断到了，就把它放到准备就绪list链表里。所以，当一个socket上有数据到了，内核在把网卡上的数据copy到内核中后就来把socket插入到准备就绪链表里了。



如此，一颗红黑树，一张准备就绪句柄链表，少量的内核cache，就帮我们解决了大并发下的socket处理问题。执行epoll_create时，创建了红黑树和就绪链表，执行epoll_ctl时，如果增加socket句柄，则检查在红黑树中是否存在，存在立即返回，不存在则添加到树干上，然后向内核注册回调函数，用于当中断事件来临时向准备就绪链表中插入数据。执行epoll_wait时立刻返回准备就绪链表里的数据即可。

-----

#### 两种模式LT和ET



最后看看epoll独有的两种模式LT和ET。无论是LT和ET模式，都适用于以上所说的流程。区别是，LT模式下，只要一个句柄上的事件一次没有处理完，会在以后调用epoll_wait时次次返回这个句柄，而ET模式仅在第一次返回。



这件事怎么做到的呢？当一个socket句柄上有事件时，内核会把该句柄插入上面所说的准备就绪list链表，这时我们调用epoll_wait，会把准备就绪的socket拷贝到用户态内存，然后清空准备就绪list链表，最后，epoll_wait干了件事，就是检查这些socket，如果不是ET模式（就是LT模式的句柄了），并且这些socket上确实有未处理的事件时，又把该句柄放回到刚刚清空的准备就绪链表了。所以，非ET的句柄，只要它上面还有事件，epoll_wait每次都会返回。而ET模式的句柄，除非有新中断到，即使socket上的事件没有处理完，也是不会次次从epoll_wait返回的。



**其中涉及到的数据结构：**

epoll用kmem_cache_create（slab分配器）分配内存用来存放struct epitem和struct eppoll_entry。



当向系统中添加一个fd时，就创建一个epitem结构体，这是内核管理epoll的基本数据结构：

```c++
struct epitem {
    struct rb_node rbn;          //用于主结构管理的红黑树
    struct list_head rdllink;    //事件就绪队列
    struct epitem *next;         //用于主结构体中的链表
    struct epoll_filefd ffd;     //这个结构体对应的被监听的文件描述符信息
    int nwait;                   //poll操作中事件的个数
    struct list_head pwqlist;    //双向链表，保存着被监视文件的等待队列，功能类似于select/poll中的poll_table
    struct eventpoll *ep;        //该项属于哪个主结构体（多个epitm从属于一个eventpoll）
    struct list_head fllink;     //双向链表，用来链接被监视的文件描述符对应的struct file。因为file里有f_ep_link,用来保存所有监视这个文件的epoll节点
    struct epoll_event event;    //注册的感兴趣的事件,也就是用户空间的epoll_event
}
```



而每个epoll fd（epfd）对应的主要数据结构为：

```c++
struct eventpoll {
    spin_lock_t lock;            //对本数据结构的访问
    struct mutex mtx;            //防止使用时被删除
    wait_queue_head_t wq;        //sys_epoll_wait()使用的等待队列
    wait_queue_head_t poll_wait; //file->poll()使用的等待队列
    struct list_head rdllist;    //事件满足条件的链表 /*双链表中则存放着将要通过epoll_wait返回给用户的满足条件的事件*/
    struct rb_root rbr;          //用于管理所有fd的红黑树（树根）/*红黑树的根节点，这颗树中存储着所有添加到epoll中的需要监控的事件*/
    struct epitem *ovflist;      //将事件到达的fd进行链接起来发送至用户空间
}
```



struct eventpoll在epoll_create时创建。



这样说来，内核中维护了一棵红黑树，大致的结构如下：

![这里写图片描述](image/cbd2fdc0f02f4200a933d5ecb2f3cbef.png)

整体而言：

![这里写图片描述](image/e98038a05d374959bbadd30dd7801733.png)



## 定时任务

![img](image/20180609210648377)

>crontab –e : 修改 crontab 文件. 如果文件不存在会自动创建。 
>crontab –l : 显示 crontab 文件。 
>crontab -r : 删除 crontab 文件。
>crontab -ir : 删除 crontab 文件前提醒用户。
>
>命令必须受权限为可执行脚本,变成绿色的为可执行:chmod +x my.sh



> cron表达式有7个域 依序分别为 秒 分 时 日 月 周 年 年为可选类型 在不设定年分时为每年

cron字符描述
|字符 | 描述|
|----|----|
|*	|匹配所有的值 如 *在分钟的字段域里表示 每分钟|
|?	|只在日期域和星期域中使用 它被用来指定非明确的值|
|-	|指定范围 如 10-12在小时域意味着10点、11点、12点|
|,	|指定多个值 如 MON WED FRI在星期域里表示星期一 星期三 星期五|
|/	|指定增量 如 */1 * * * *每1分钟执行一次|
|L	|表示day-of-month和day-of-week域 但在两个字段中的意思不同 例如day-of-month域中表示一个月的最后一天 如果在day-of-week域表示’7’或者’SAT’ 如果在day-of-week域中前面加上数字 它表示一个月的最后几天 例如’6L’就表示一个月的最后一个星期五|
| W	|只允许日期域出现 这个字符用于指定日期的最近工作日 例如 在日期域中写15W表示 此月15号最近的工作日 所以 如果15号是周六 则任务会在14号触发 如果15好是周日 则任务会在周一也就是16号触发 如果是在日期域填写1W即使1号是周六 那么任务也只会在下周一 也就是3号触发 W字符指定的最近工作日是不能够跨月份的 字符W只能配合一个单独的数值使用 不能够是一个数字段 如 1-15W是错误的|
| LW|L和W可以在日期域中联合使用 LW表示这个月最后一周的工作日|
|#	|只允许在星期域中出现 指定本月的某天 如 6#3表示本月第三周的星期五 6表示星期五 3表示第三周|
|C	|允许在日期域和星期域出现 此表达式值依赖于相关日历计算 无日历关联 则等价于所有包含的日历 如 日期域是5C表示关联日历中第一天 或者这个月开始的第一天的后5天 星期域是1C表示关联日历中第一天 或者星期的第一天的后1天 也就是周日的后一天周一|

cron字符对应意义
|字段	|允许值	|允许的特殊字符|
|----|----|----|
|秒	|0-59|	, - * /|
|分	|0-59|	, - * /|
|小时	|0-23|	, - * /|
|月内日期|	1-31|	, - * ? / L W C|
|月	|1-12 或者 JAN-DEC|	, - * /|
|周内日期|	1-7 或者 SUN-SAT|	, - * ? / L C #|
|年（可选）|	留空 1970-2099|	, - * /|

cron常用写法
|表达式|	作用|
|----|----|
|* * * * *|	每1分钟执行一次|
|*/1 * * * *|	每1分钟执行一次|
|0 0 1 * * ?|	每天1点触发|
|0 10 1 ? * *	|每天早上1点10分触发|
|0 10 1 * * ?	|每天早上1点10分触发|
|0 10 1 * * ? *	|每天早上1点10分触发|
|0 10 1 * * ? 2020|	2020年的每天1点10分触发|
|0 * 2 * * ?|	每天1点到1点59分每分钟一次触发|
|0 0/5 14 * * ?|	每天从下午2点开始到2：55分结束每5分钟一次触发|
|0 0/5 1,3 * * ?|	每天1点至1点55分 6点至6点55分每5分钟一次触发|
|0 5-10 1 * * ?|	每天1点5分至1点10分每分钟一次触发|
|0 10,15 1 ? 3 WED|	三月的每周三的1点10分和1点15分触发|
|0 10 1 ? * MON-FRI|	每周 周一至周五1点10分触发|





## 让进程在后台运行

```shell
[root@base linux]# chmod +x test02.sh 
[root@base linux]# ./test02.sh
#中断脚本test.sh：ctrl+c
#在1的基础上将运行中的test.sh，切换到后台并暂停：ctrl+z
[root@base linux]# jobs
[1]+  Stopped                 ./test02.sh
#bg number让其在后台开始运行,（“number”是使用jobs命令查到的 [ ]中的数字，不是pid）
[root@base linux]# bg 1
[1]+ ./test02.sh &
[root@base linux]# 3
[root@base linux]# jobs
[1]+  Stopped                 ./test02.sh
[root@base linux]# fg %1
./test02.sh
#中断后台运行的test.sh脚本：先fg %number切换到前台，再ctrl+c；或是直接kill %number
[root@base linux]# kill %1
[1]+  Stopped                 ./test02.sh

nohup sh my.sh >my.log 2>&1 &
```



### nohup/setsid/&

#### 场景：

如果只是临时有一个命令需要长时间运行，什么方法能最简便的保证它在后台稳定运行呢？

#### hangup 名称的来由

> 在 Unix 的早期版本中，每个终端都会通过 modem 和系统通讯。当用户 logout 时，modem 就会挂断（hang up）电话。 同理，当 modem 断开连接时，就会给终端发送 hangup 信号来通知其关闭所有子进程。

#### 解决方法：

我们知道，当用户注销（logout）或者网络断开时，终端会收到 HUP（hangup）信号从而关闭其所有子进程。因此，我们的解决办法就有两种途径：要么让进程忽略 HUP 信号，要么让进程运行在新的会话里从而成为不属于此终端的子进程。

**1. nohup**

nohup 无疑是我们首先想到的办法。顾名思义，nohup 的用途就是让提交的命令忽略 hangup 信号。让我们先来看一下 nohup 的帮助信息：

```shell
NOHUP(1)                        User Commands                        NOHUP(1)
 
NAME
       nohup - run a command immune to hangups, with output to a non-tty
 
SYNOPSIS
       nohup COMMAND [ARG]...
       nohup OPTION
 
DESCRIPTION
       Run COMMAND, ignoring hangup signals.
 
       --help display this help and exit
 
       --version
              output version information and exit
```



可见，nohup 的使用是十分方便的，只需在要处理的命令前加上 nohup 即可，标准输出和标准错误缺省会被重定向到 nohup.out 文件中。一般我们可在结尾加上**"&"**来将命令同时放入后台运行，也可用`">*filename* 2>&1"`来更改缺省的重定向文件名。

##### nohup 示例

```shell
[root@pvcent107 ~]# nohup ping www.ibm.com &
[1] 3059
nohup: appending output to `nohup.out'
[root@pvcent107 ~]# ps -ef |grep 3059
root      3059   984  0 21:06 pts/3    00:00:00 ping www.ibm.com
root      3067   984  0 21:06 pts/3    00:00:00 grep 3059
[root@pvcent107 ~]#
```



**2。setsid**

nohup 无疑能通过忽略 HUP 信号来使我们的进程避免中途被中断，但如果我们换个角度思考，如果我们的进程不属于接受 HUP 信号的终端的子进程，那么自然也就不会受到 HUP 信号的影响了。setsid 就能帮助我们做到这一点。让我们先来看一下 setsid 的帮助信息：

```shell
SETSID(8)                 Linux Programmer’s Manual                 SETSID(8)
 
NAME
       setsid - run a program in a new session
 
SYNOPSIS
       setsid program [ arg ... ]
 
DESCRIPTION
       setsid runs a program in a new session.
```



可见 setsid 的使用也是非常方便的，也只需在要处理的命令前加上 setsid 即可。

##### setsid 示例

```shell
[root@pvcent107 ~]# setsid ping www.ibm.com
[root@pvcent107 ~]# ps -ef |grep www.ibm.com
root     31094     1  0 07:28 ?        00:00:00 ping www.ibm.com
root     31102 29217  0 07:29 pts/4    00:00:00 grep www.ibm.com
[root@pvcent107 ~]#
```



值得注意的是，上例中我们的进程 ID(PID)为31094，而它的父 ID（PPID）为1（即为 init 进程 ID），并不是当前终端的进程 ID。请将此例与[nohup 例](https://www.ibm.com/developerworks/cn/linux/l-cn-nohup/index.html#nohup)中的父 ID 做比较。

**3。&**

这里还有一个关于 subshell 的小技巧。我们知道，将一个或多个命名包含在“()”中就能让这些命令在子 shell 中运行中，从而扩展出很多有趣的功能，我们现在要讨论的就是其中之一。

当我们将"&"也放入“()”内之后，我们就会发现所提交的作业并不在作业列表中，也就是说，是无法通过`jobs`来查看的。让我们来看看为什么这样就能躲过 HUP 信号的影响吧。

##### subshell 示例

```shell
[root@pvcent107 ~]# (ping www.ibm.com &)
[root@pvcent107 ~]# ps -ef |grep www.ibm.com
root     16270     1  0 14:13 pts/4    00:00:00 ping www.ibm.com
root     16278 15362  0 14:13 pts/4    00:00:00 grep www.ibm.com
[root@pvcent107 ~]#
```



从上例中可以看出，新提交的进程的父 ID（PPID）为1（init 进程的 PID），并不是当前终端的进程 ID。因此并不属于当前终端的子进程，从而也就不会受到当前终端的 HUP 信号的影响了。

### disown

#### 场景：

我们已经知道，如果事先在命令前加上 nohup 或者 setsid 就可以避免 HUP 信号的影响。但是如果我们未加任何处理就已经提交了命令，该如何补救才能让它避免 HUP 信号的影响呢？

#### 解决方法：

这时想加 nohup 或者 setsid 已经为时已晚，只能通过作业调度和 disown 来解决这个问题了。让我们来看一下 disown 的帮助信息：

```shell
disown [-ar] [-h] [jobspec ...]
    Without options, each jobspec is  removed  from  the  table  of
    active  jobs.   If  the -h option is given, each jobspec is not
    removed from the table, but is marked so  that  SIGHUP  is  not
    sent  to the job if the shell receives a SIGHUP.  If no jobspec
    is present, and neither the -a nor the -r option  is  supplied,
    the  current  job  is  used.  If no jobspec is supplied, the -a
    option means to remove or mark all jobs; the -r option  without
    a  jobspec  argument  restricts operation to running jobs.  The
    return value is 0 unless a jobspec does  not  specify  a  valid
    job.
```



可以看出，我们可以用如下方式来达成我们的目的。

##### 灵活运用 CTRL-z

> 在我们的日常工作中，我们可以用 CTRL-z 来将当前进程挂起到后台暂停运行，执行一些别的操作，然后再用 fg 来将挂起的进程重新放回前台（也可用 bg 来将挂起的进程放在后台）继续运行。这样我们就可以在一个终端内灵活切换运行多个任务，这一点在调试代码时尤为有用。因为将代码编辑器挂起到后台再重新放回时，光标定位仍然停留在上次挂起时的位置，避免了重新定位的麻烦。

- 用`disown -h jobspec`来使**某个作业**忽略HUP信号。
- 用`disown -ah `来使**所有的作业**都忽略HUP信号。
- 用`disown -rh `来使**正在运行的作业**忽略HUP信号。

需要注意的是，当使用过 disown 之后，会将把目标作业从作业列表中移除，我们将不能再使用`jobs`来查看它，但是依然能够用`ps -ef`查找到它。

但是还有一个问题，这种方法的操作对象是作业，如果我们在运行命令时在结尾加了**"&"**来使它成为一个作业并在后台运行，那么就万事大吉了，我们可以通过`jobs`命令来得到所有作业的列表。但是如果并没有把当前命令作为作业来运行，如何才能得到它的作业号呢？答案就是用 CTRL-z（按住Ctrl键的同时按住z键）了！

CTRL-z 的用途就是将当前进程挂起（Suspend），然后我们就可以用`jobs`命令来查询它的作业号，再用`bg *jobspec*来将它放入后台并继续运行。需要注意的是，如果挂起会影响当前进程的运行结果，请慎用此方法。

 

disown 示例1（如果提交命令时已经用“&”将命令放入后台运行，则可以直接使用“disown”）

```shell
[root@pvcent107 build]# cp -r testLargeFile largeFile &
[1] 4825
[root@pvcent107 build]# jobs
[1]+  Running                 cp -i -r testLargeFile largeFile &
[root@pvcent107 build]# disown -h %1
[root@pvcent107 build]# ps -ef |grep largeFile
root      4825   968  1 09:46 pts/4    00:00:00 cp -i -r testLargeFile largeFile
root      4853   968  0 09:46 pts/4    00:00:00 grep largeFile
[root@pvcent107 build]# logout
```



disown 示例2（如果提交命令时未使用“&”将命令放入后台运行，可使用 CTRL-z 和“bg”将其放入后台，再使用“disown”）

```shell
`[root@pvcent107 build]# cp -r testLargeFile largeFile2` `[1]+  Stopped                 cp -i -r testLargeFile largeFile2``[root@pvcent107 build]# bg %1``[1]+ cp -i -r testLargeFile largeFile2 &``[root@pvcent107 build]# jobs``[1]+  Running                 cp -i -r testLargeFile largeFile2 &``[root@pvcent107 build]# disown -h %1``[root@pvcent107 build]# ps -ef |grep largeFile2``root      5790  5577  1 10:04 pts/3    00:00:00 cp -i -r testLargeFile largeFile2``root      5824  5577  0 10:05 pts/3    00:00:00 grep largeFile2``[root@pvcent107 build]#`
```

### screen

#### 场景：

我们已经知道了如何让进程免受 HUP 信号的影响，但是如果有大量这种命令需要在稳定的后台里运行，如何避免对每条命令都做这样的操作呢？

#### 解决方法：

此时最方便的方法就是 screen 了。简单的说，screen 提供了 ANSI/VT100 的终端模拟器，使它能够在一个真实终端下运行多个全屏的伪终端。screen 的参数很多，具有很强大的功能，我们在此仅介绍其常用功能以及简要分析一下为什么使用 screen 能够避免 HUP 信号的影响。我们先看一下 screen 的帮助信息：

```shell
SCREEN(1)                                                           SCREEN(1)
 
NAME
       screen - screen manager with VT100/ANSI terminal emulation
 
SYNOPSIS
       screen [ -options ] [ cmd [ args ] ]
       screen -r [[pid.]tty[.host]]
       screen -r sessionowner/[[pid.]tty[.host]]
 
DESCRIPTION
       Screen  is  a  full-screen  window manager that multiplexes a physical
       terminal between several  processes  (typically  interactive  shells).
       Each  virtual  terminal provides the functions of a DEC VT100 terminal
       and, in addition, several control functions from the  ISO  6429  (ECMA
       48,  ANSI  X3.64)  and ISO 2022 standards (e.g. insert/delete line and
       support for multiple character sets).  There is a  scrollback  history
       buffer  for  each virtual terminal and a copy-and-paste mechanism that
       allows moving text regions between windows.
```



使用 screen 很方便，有以下几个常用选项：

- 用`screen -dmS *session name*`来建立一个处于断开模式下的会话（并指定其会话名）。
- 用`screen -list `来列出所有会话。
- 用`screen -r *session name*`来重新连接指定会话。
- 用快捷键`CTRL-a d `来暂时断开当前会话。

screen 示例

```shell
[root@pvcent107 ~]# screen -dmS Urumchi
[root@pvcent107 ~]# screen -list
There is a screen on:
        12842.Urumchi   (Detached)
1 Socket in /tmp/screens/S-root.
 
[root@pvcent107 ~]# screen -r Urumchi
```



当我们用“-r”连接到 screen 会话后，我们就可以在这个伪终端里面为所欲为，再也不用担心 HUP 信号会对我们的进程造成影响，也不用给每个命令前都加上“nohup”或者“setsid”了。这是为什么呢？让我来看一下下面两个例子吧。

1. 未使用 screen 时新进程的进程树

```shell
[root@pvcent107 ~]# ping www.google.com &
[1] 9499
[root@pvcent107 ~]# pstree -H 9499
init─┬─Xvnc
     ├─acpid
     ├─atd
     ├─2*[sendmail] 
     ├─sshd─┬─sshd───bash───pstree
     │       └─sshd───bash───ping
```



我们可以看出，未使用 screen 时我们所处的 bash 是 sshd 的子进程，当 ssh 断开连接时，HUP 信号自然会影响到它下面的所有子进程（包括我们新建立的 ping 进程）。

2. 使用了 screen 后新进程的进程树

```shell
[root@pvcent107 ~]# screen -r Urumchi
[root@pvcent107 ~]# ping www.ibm.com &
[1] 9488
[root@pvcent107 ~]# pstree -H 9488
init─┬─Xvnc
     ├─acpid
     ├─atd
     ├─screen───bash───ping
     ├─2*[sendmail]
```



而使用了 screen 后就不同了，此时 bash 是 screen 的子进程，而 screen 是 init（PID为1）的子进程。那么当 ssh 断开连接时，HUP 信号自然不会影响到 screen 下面的子进程了。

### 总结

现在几种方法已经介绍完毕，我们可以根据不同的场景来选择不同的方案。nohup/setsid 无疑是临时需要时最方便的方法，disown 能帮助我们来事后补救当前已经在运行了的作业，而 screen 则是在大批量操作时不二的选择了。



## 保留最近五天的文件

1、创建备份文件夹
#cd /bak
#mkdir mysqldata

2、编写运行脚本
#vi /usr/sbin/bakmysql.sh
注：如使用nano编辑此代码需在每行尾添加'&&'或';'连接符，否则生成的文件名末尾字符为乱码

代码：

```shell
#!/bin/bash
Name:bakmysql.sh
This is a ShellScript For Auto DB Backup and Delete old Backup
#
backupdir=/bak/mysqlbak
time=`date +%Y%m%d%H`
mysql_bin_dir/mysqldump -u user -ppassword dataname1 | gzip > $backupdir/name1$time.sql.gz
mysql_bin_dir/mysqldump -u user -ppassword dataname2 | gzip > $backupdir/name2$time.sql.gz
#
find $backupdir -name "name_*.sql.gz" -type f -mtime +5 -exec rm {} \; > /dev/null 2>&1
```

```shell
#!/bin/bash
#保留文件数
ReservedNum=8
#当前脚步所在目录
RootDir=$(cd `dirname $0`; pwd)
#显示文件数， *.*可以改为指定文件类型
FileNum=$(ls -l *.* | grep ^- | wc -l)
while(( $FileNum > $ReservedNum ))
do
    #取最旧的文件，*.*可以改为指定文件类型
    OldFile=$(ls -rt *.* | head -1)
    echo "Delete File:"$RootDir'/'$OldFile
    rm -f $RootDir'/'$OldFile
    let "FileNum--"
done
```



```shell
#接下来，再提供一种组合删除语句
ls -lt | awk '{if(NR>5){print "rm "$9}}' | sh
```





保存退出

说明：

> 代码中time=` date +%Y%m%d%H `也可以写为time="$(date +"%Y%m%d$H")"
> 其中`符号是TAB键上面的符号，不是ENTER左边的'符号，还有date后要有一个空格。
> mysql_bin_dir：mysql的bin路径；
> dataname：数据库名；
> user：数据库用户名；
> password：用户密码；
> name：自定义备份文件前缀标识。
> -type f 表示查找普通类型的文件，f表示普通文件。
> -mtime +5 按照文件的更改时间来查找文件，+5表示文件更改时间距现在5天以前；如果是 -mmin +5 表示文件更改时间距现在5分钟以前。
> -exec rm {} \; 表示执行一段shell命令，exec选项后面跟随着所要执行的命令或脚本，然后是一对儿{ }，一个空格和一个\，最后是一个分号。
> /dev/null 2>&1 把标准出错重定向到标准输出，然后扔到/DEV/NULL下面去。通俗的说，就是把所有标准输出和标准出错都扔到垃圾桶里面；其中的& 表示让该命令在后台执行。

3、为脚本添加执行权限

```shell
chmod +x /usr/sbin/bakmysql.sh
```



4、修改/etc/crontab（在centOS5中测试可行）或  crontab -e





## CentOS6.x 64位安装32位程序

  基础依赖
​    yum install glibc.i686

可能的libstdc++依赖
​    yum install libstdc++.i686

​    若报版本不一致，请依次执行
​        yum install libstdc++
​        yum install libstdc++.i686  



#### j2sdk-1_4_2_19-linux-i586

> [下载地址](https://www.oracle.com/java/technologies/java-archive-javase-v14-downloads.html)

* 如果是j2sdk-1_4_2_19-linux-i586-rpm.bin安装包,chmod 755 j2sdk-1_4_2_19-linux-i586-rpm.bin
* 这需要先执行./j2sdk-1_4_2_19-linux-i586-rpm.bin命令生成rpm
* rpm -i j2sdk-1_4_2_19-linux-i586.rpm
* 如果是j2sdk-1_4_2_19-linux-i586.bin,可直接解压,然后修改权限 chmod -R 766  j2sdk-1_4_2_19-linux-i586



------

# 学习笔记

## 删除没下载完的jar文件信息

当确定不是当前网络问题后，找到maven的本地库路径，及：C:/用户/home名/.m2下。

在此目录下，运行CMD（shift+右键），执行下面命令。

**for /r %i in (*.lastUpdated) do del %i**



## CPU密集型 VS IO密集型

>  也就是计算密集型和IO密集型区别
>
> **计算密集型程序适合C语言多线程，I/O密集型适合脚本语言开发的多线程。**

* **计算密集型任务**的特点是<font color=red>**进行大量的计算，消耗CPU资源**</font>，比如计算圆周率、对视频进行高清解码等等非阻塞任务，完全靠CPU核数来工作，完全让CPU都进行任务合理利用CPU核数，避免过多线程上下文切换，比较理想方案：

  线程数=CPU核数+1

* 涉及网络、磁盘IO、与数据库，与缓存间交互的任务都是**IO密集型任务**，进行IO任务的时候线程处于阻塞状态，这是就需要多设置线程池中线程的数量，达到当某个线程处于阻塞状态时其他线程可以并发处理其他任务，阻塞任务，<font color=red>**反复去读写磁盘文件**</font>，比较理想方案：

  线程数= CPU核心数/(1-阻塞系数)这个阻塞系数一般为0.8~0.9之间，也可以取0.8或者0.9。套用公式，对于双核CPU来说，它比较理想的线程数就是20，当然这都不是绝对的，需要根据实际情况以及实际业务来调整。



# 公钥私钥、签名和证书

Mar 15, 2019

工作需要，研究了一下安全相关理论知识和名词

## 非对称加密中的公钥和私钥

在加解密的过程中，加密密钥和解密密钥不同的加密方式，就是`非对称加密`。例如：

![img](https://i.loli.net/2019/03/15/5c8b3d197c943.png)

在上图中，加密密钥和解密密钥是不同的，并且两个密钥成对出现，替换掉任意一个密钥，这个加解密过程就不成立，这就是一种非对称加密的形式。

在非对称加密过程中，由于密钥是成对的，两个密钥公开其中一个，只要保存好另一个密钥，这个过程仍然是安全的，这个被公开的密钥就被称为`公钥`，自己保留的密钥就是`私钥`。因为非对称加密的这种特性，该加密过程可用于安全通信、文件校验等场景。

需要注意的是，理论上非对称加密中的两个密钥，使用任意一个做公钥都是可以的，但在RSA算法中，私钥和公钥生成的规范不同，二者并不能互换角色。

## 签名

在非对称加密的基础上，考虑如下场景：

现有A和B两个人，A在自己的电脑上生成了一对密钥，并把公钥发给了B

![img](https://i.loli.net/2019/03/15/5c8b3da9d372a.png)

A准备向B发送一个文件，为了确保这个文件在发送过程中不被篡改，并且让B能够确定是A发出的，A采用了这样的方式：将文件先计算哈希和，得到一个文件摘要，然后使用私钥对这个文件摘要进行加密，生成了`数字签名`，然后把这个签名和文件一起发送给B。

![img](https://i.loli.net/2019/03/15/5c8b3de6cda1c.png)

这样B收到文件后，对`数字签名`部分使用公钥进行解密，解密成功说明该文件是由A发出的；再对文件部分计算哈希和，并跟解密之后的摘要进行对比，如果哈希和与摘要相同，说明文件未被篡改过。

## 证书

在上面的场景中，如果出现了一个黑客C，C自己生成了一对密钥，然后在A将公钥发给B的过程中截获了公钥A，并替换成自己的公钥C

![img](https://i.loli.net/2019/03/15/5c8b3e3722d60.png)

但B并不知道此事，B仍然以为自己接收的是公钥A；此时C向B发送一个经过签名的恶意文件，B虽然能够完成对该文件的验证，但是B仍以为该文件是A发出的。

为了解决这种情况，需要一个可信的第三方机构D，并同时引入证书的概念。D生成一对密钥，并把自己的个人信息和公钥打包成一个文件交给B，B相信D，所以把这个文件存了下来，这个文件就是`CA证书`。

A把自己的公钥和个人信息也打包成一个文件，交给D进行认证。D在确认这个文件中的公钥跟信息一致（均属于A）的时候，就使用自己的私钥对这个文件进行签名，这样这个文件就是一个`经过认证的数字证书`。

![img](https://i.loli.net/2019/03/15/5c8b3e7aae5c8.png)

当B需要和A通信时，D会把证书A使用自己的私钥D进行签名，并附带上自己的机构信息，然后将这个文件发送给B。

![img](https://i.loli.net/2019/03/15/5c8b3ea103494.png)

B拿到包含公钥A的证书后，使用CA证书中包含的公钥D进行验证，确认可信后拿到公钥A，然后就可以跟A安全的通信了。

![1563368659057](image/1563368659057.png)

### 个人网站证书

秘钥

```shell
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAzz6LaRx2SrQUPvG1HXrnLwNn3WDz/u5D/AQlPXl6fDKAPLts
SwzLovg9kuhSHcPH4HaTcj2CWhpxLmBMx8ksCkWGExbcs97itF6fWH3eO10wUjcV
ZIVQGTMiASkO/7s1Ifr8zssa0S52zsC1khY5E5CbHdbA5t/LVQrLg9tPnpQ9kcOi
hVgrdB4qdhpO0w+1DK3HUy/VCBwAvlN7h32RaeJc5QsoGVDv3MDK3aN2hRcf32Qb
4np6H5HztClYE6KUsn6c+Ljvm5apHuKL5j84tEhtczVNUXRenM+Tn4nzjEdEHZTX
bPmoRJIC6bTIGHd/8AeKOF8DxmiL3zw2XZ+/iwIDAQABAoIBAQDHquWb9n0NiiP7
ZNpvNasog2p9Qlyx35MGamQKr1BP+kPMv3IdeI11TR/duxDqdmbLHtL9/L7q2pDy
8nrm/S3+E2+SUrN+ZJ4c0xFIq7QBk83rWAC3YS2Dqdz4Kzu1LQOK4orRHaOPp+l1
VvtYbSq+a9LW08H0becz3vum5RP3nfNnTLpHPWH7D5+8m7KBrBwiQBvDRZaX2vig
z60jtnBU3bTw6uKeicrW0GbjLxlQ8SNt1I8IioKbB7KVNMjt0lgLqkLzXlYzklrX
Pi5VNDRn5dzHpZecRazi8+iXuZYT53x26w+aP9xfLe1Sx3VAT6Kw1CgMqiQMQ1yg
HRTDOoSRAoGBAPxeMyT7RSJT17o5DYrLy0IlvAtjcpA06sI87TY/LhWnzVT4KvIp
VkxMmqFHZf/T4/AduoUvrW4fwCLy6zNa1+sG8fN5Huxcy6RzWFUHNLVrJHHIvi2L
UG2yzIqYOc9QKMHeHoXbaPAQwvjx1n1yHJCVamvBc4Wt9sC0+WIssZHTAoGBANI6
GHYH3CiAXMZo/nL5mwUBc3m20WQ3bnbC6utSS06ktS5mMVybU0Aw3ojFIzm4wGFR
XP01voohSqiwgjh7Cacah6DJeNEc3xw6Vh7vvCeZQ0vw+FuOkszla0Wq/TrAR1wO
xUKVDNv3Wy2H3azaUjbDNdIveOAVx3KcUSt7Q1BpAoGAUE/KBuLPxXTZGjI91QW1
0X8gsJ8dPjcY3md1NeY1TD7yYS/4usfc5rsaGmkWVKuhxjAvw2LA1mLUSkrz/ovS
WsEDDnBlHuMJC3SJj8WTSIioOG2h1+yV09MqtJBtFUR1M/zzybVhV8R9x6tujs1Z
uclS7KfLk6cg94KgOlXuzHECgYByoRjravfB4dQ0n9V2reG4RgVILcZZJdyGx1u+
+r1zYV4lsbVisJMhYkRFQXEmrTXBGtNggiimOubxumUXFQe7ZTzlEFZfd6W0R57j
+YaX9Pr78qYJjmE/di0a7NRtb6C5cphe6NT9MBA4cGgQM282yxSSyi3XyihZtyCP
XAPlWQKBgHUuP/CPNKN3SJcVl5LfFM/IGaBHmbJheXUhiIQlQqYOvY54eYD+W5uV
ebSw8YvDSQgSrWdlYxWP1gHCQI+ozpF5Z81b81vOAyYYnXvKwKHZhtIl1oaF4oDc
50WwGAW6LrHUTPUHTQaXSGv3Ur/nyOUY3Q/8/VOYK4c00NqKu1i+
-----END RSA PRIVATE KEY-----

```

证书

```shell
-----BEGIN CERTIFICATE-----
MIIFUzCCBDugAwIBAgISA75Jm9mWm3lSOP+RzbjzoV1zMA0GCSqGSIb3DQEBCwUA
MEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD
ExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xOTA4MjMxMjE2MzJaFw0x
OTExMjExMjE2MzJaMBgxFjAUBgNVBAMTDXpoZW5rc29mdC5jb20wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDPPotpHHZKtBQ+8bUdeucvA2fdYPP+7kP8
BCU9eXp8MoA8u2xLDMui+D2S6FIdw8fgdpNyPYJaGnEuYEzHySwKRYYTFtyz3uK0
Xp9Yfd47XTBSNxVkhVAZMyIBKQ7/uzUh+vzOyxrRLnbOwLWSFjkTkJsd1sDm38tV
CsuD20+elD2Rw6KFWCt0Hip2Gk7TD7UMrcdTL9UIHAC+U3uHfZFp4lzlCygZUO/c
wMrdo3aFFx/fZBvienofkfO0KVgTopSyfpz4uO+blqke4ovmPzi0SG1zNU1RdF6c
z5OfifOMR0QdlNds+ahEkgLptMgYd3/wB4o4XwPGaIvfPDZdn7+LAgMBAAGjggJj
MIICXzAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUF
BwMCMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFPNBvXMOptxYZqHrOwlR8NpfJ/rn
MB8GA1UdIwQYMBaAFKhKamMEfd265tE5t6ZFZe/zqOyhMG8GCCsGAQUFBwEBBGMw
YTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AuaW50LXgzLmxldHNlbmNyeXB0Lm9y
ZzAvBggrBgEFBQcwAoYjaHR0cDovL2NlcnQuaW50LXgzLmxldHNlbmNyeXB0Lm9y
Zy8wGAYDVR0RBBEwD4INemhlbmtzb2Z0LmNvbTBMBgNVHSAERTBDMAgGBmeBDAEC
ATA3BgsrBgEEAYLfEwEBATAoMCYGCCsGAQUFBwIBFhpodHRwOi8vY3BzLmxldHNl
bmNyeXB0Lm9yZzCCAQUGCisGAQQB1nkCBAIEgfYEgfMA8QB2AHR+2oMxrTMQkSGc
ziVPQnDCv/1eQiAIxjc1eeYQe8xWAAABbL6fFXQAAAQDAEcwRQIgY7EbCMDYhQJO
tL7fbU0h6xHmB1YExOv4NNz7SLIZAt4CIQD9D8KP7fwPw33Eb6rBdkUYFMaul+p5
VfbAyXg7wqbXhAB3AGPy283oO8wszwtyhCdXazOkjWF3j711pjixx2hUS9iNAAAB
bL6fF4UAAAQDAEgwRgIhAJPT5JX9vOcEkevWZoAPs8xttGhyu6OIr6mQTFrb9oIl
AiEAwqrUHrP6izzySn1TPynAMbAtCzxLe4UzXG+gbRVbnqIwDQYJKoZIhvcNAQEL
BQADggEBAGSxxbAr8JJDxtlLrpUG1Ru8HeDt68DR1cULsPY7PE+hOgLP4gmJavkT
+lORKZMsW0JDe6cQVvryqb2ampjuzzxX3bngU6g9bXIkM5walQuiSIFnd9zPsskF
PFa052LPENYT8CybAuIH3htmndmAJ6uErPFnvUcuFDR3185wNkWBMDixSwAjryJ5
WBrvp4dLDhwZ7Q+63VE385IbR0vDNfB1bFbF0jBtqs4LGZIv6CPyjTqCwGwMc6Hl
o2jW5TUhIIGvZxdyC2BqpYLyzwbng9EGeHPoMSu5gTxLUpdN7QZXfocnp64XSIUx
t63EF42YcoGYXFDy5fGdydEwfzYalAM=
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIIEkjCCA3qgAwIBAgIQCgFBQgAAAVOFc2oLheynCDANBgkqhkiG9w0BAQsFADA/
MSQwIgYDVQQKExtEaWdpdGFsIFNpZ25hdHVyZSBUcnVzdCBDby4xFzAVBgNVBAMT
DkRTVCBSb290IENBIFgzMB4XDTE2MDMxNzE2NDA0NloXDTIxMDMxNzE2NDA0Nlow
SjELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUxldCdzIEVuY3J5cHQxIzAhBgNVBAMT
GkxldCdzIEVuY3J5cHQgQXV0aG9yaXR5IFgzMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAnNMM8FrlLke3cl03g7NoYzDq1zUmGSXhvb418XCSL7e4S0EF
q6meNQhY7LEqxGiHC6PjdeTm86dicbp5gWAf15Gan/PQeGdxyGkOlZHP/uaZ6WA8
SMx+yk13EiSdRxta67nsHjcAHJyse6cF6s5K671B5TaYucv9bTyWaN8jKkKQDIZ0
Z8h/pZq4UmEUEz9l6YKHy9v6Dlb2honzhT+Xhq+w3Brvaw2VFn3EK6BlspkENnWA
a6xK8xuQSXgvopZPKiAlKQTGdMDQMc2PMTiVFrqoM7hD8bEfwzB/onkxEz0tNvjj
/PIzark5McWvxI0NHWQWM6r6hCm21AvA2H3DkwIDAQABo4IBfTCCAXkwEgYDVR0T
AQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwfwYIKwYBBQUHAQEEczBxMDIG
CCsGAQUFBzABhiZodHRwOi8vaXNyZy50cnVzdGlkLm9jc3AuaWRlbnRydXN0LmNv
bTA7BggrBgEFBQcwAoYvaHR0cDovL2FwcHMuaWRlbnRydXN0LmNvbS9yb290cy9k
c3Ryb290Y2F4My5wN2MwHwYDVR0jBBgwFoAUxKexpHsscfrb4UuQdf/EFWCFiRAw
VAYDVR0gBE0wSzAIBgZngQwBAgEwPwYLKwYBBAGC3xMBAQEwMDAuBggrBgEFBQcC
ARYiaHR0cDovL2Nwcy5yb290LXgxLmxldHNlbmNyeXB0Lm9yZzA8BgNVHR8ENTAz
MDGgL6AthitodHRwOi8vY3JsLmlkZW50cnVzdC5jb20vRFNUUk9PVENBWDNDUkwu
Y3JsMB0GA1UdDgQWBBSoSmpjBH3duubRObemRWXv86jsoTANBgkqhkiG9w0BAQsF
AAOCAQEA3TPXEfNjWDjdGBX7CVW+dla5cEilaUcne8IkCJLxWh9KEik3JHRRHGJo
uM2VcGfl96S8TihRzZvoroed6ti6WqEBmtzw3Wodatg+VyOeph4EYpr/1wXKtx8/
wApIvJSwtmVi4MFU5aMqrSDE6ea73Mj2tcMyo5jMd6jmeWUHK8so/joWUoHOUgwu
X4Po1QYz+3dszkDqMp4fklxBwXRsW10KXzPMTZ+sOPAveyxindmjkW8lGy+QsRlG
PfZ+G6Z6h7mjem0Y+iWlkYcV4PIWL1iwBi8saCbGS5jN2p8M+X+Q7UNKEkROb3N6
KOqkqm57TH2H3eDJAkSnh6/DNFu0Qg==
-----END CERTIFICATE-----
```



## Openssl 生成rsa私钥、公钥和证书

1. SSL
2. OpenSSL



```shell
###JDK自带工具生成秘钥库
keytool -genkey -alias zhenk -keyalg RSA -keystore G:\app\cas\keystory\zhenk

###依据秘钥库导出证书
keytool -export -trustcacerts -alias zhenk -file G:\app\cas\keystory\zhenk.cer -keystore G:\app\cas\keystory\zhenk

####将证书导入到JDK证书库,输入密码是jdk默认密码changeit
keytool -import -trustcacerts -alias zhenk -file G:/app/cas/keystory/zhenk.cer -keystore "G:/Program Files/Java/jdk1.8.0_191/jre/lib/security/cacerts"

keytool -import -trustcacerts -alias itheima -file G:/app/cas/keystory/itheima.cer -keystore "G:/Program Files/Java/jdk1.8.0_91/jre/lib/security/cacerts"
```

### tomcat发布CAS服务端项目

1. 解压一个tomcat，放到D:\workspace\cas\目录下，把刚才我们下载的cas解压打开target目录下有个`cas.war` 拷贝到tomcat的webapps目录并解压，删除war包。

2. 下载的cas解压目录下还有一个文件target\war\work\org.jasig.cas\cas-server-webapp\WEB-INF\cas.properties，把他拷贝到webapps\cas\WEB-INF目录下。

3. 修改spring-configuration\propertyFileConfigurer.xml，把location=“file:/etc/cas/cas.properties”换成刚才cas.properties的绝对路径。

   <util:properties id=“casProperties” location=“file:D:/workspace/cas/apache-tomcat-8.5.16/webapps/cas/WEB-INF/cas.properties” />

修改tomcat的conf/server.xml，加入如下代码

```xml
<Connector port="443" protocol="org.apache.coyote.http11.Http11NioProtocol"
       maxThreads="150" SSLEnabled="true" scheme="https" secure="true"
       clientAuth="false" sslProtocol="TLS"
       keystoreFile="D:\workspace\cas\keystory\itcast" 
       keystorePass="123456" />
```

  

**key 私钥**

```shell
#使用OpenSSL,在OpenSSL的bin目录下,
...OpenSSL-Win64\bin>openssl.exe
OpenSSL>openssl genrsa -des3 -out server.key 1024
###或者直接输入
OpenSSL>genrsa
```



**csr  公钥 = 有key私钥生成**

```shell
###由私钥生成公钥
openssl req -new -key server.key -out server.csr
req -text -in c:/dev/my.csr -noout
```



**crt 证书 = csr公钥+签名**



 openssl 的编译安装

1. 快速安装
2. 产生私钥
3. 产生公钥
4. 生成证书
5. 生成待签名的字符串
6. 



   RSA签名

1. 请求时签名
2. 通知返回时验证签名
3. 更多

### SSL

SSL 是一个缩写，代表的是 Secure Sockets Layer。它是支持在 Internet 上进行安全通信的 标准，并且将数据密码术集成到了协议之中。数据在离开您的计算机之前就已经被加密，然后只有 到达它预定的目标后才被解密。证书和密码学算法支持了这一切的运转，使用 OpenSSL，您将 有机会切身体会它们。
理论上，如果加密的数据在到达目标之前被截取或窃听，那些数据是不可能被破解的。不过， 由于计算机的变化一年比一年快，而且密码翻译方法有了新的发展，因此，SSL 中使用的加密协议 被破解的可能性也在增大。
可以将 SSL 和安全连接用于 Internet 上任何类型的协议，不管是 HTTP、POP3，还是 FTP。还可以用 SSL 来保护 Telnet 会话。虽然可以用 SSL 保护任何连接，但是不必对每一类连接都使用 SSL。 如果连接传输敏感信息，则应使用 SSL。

### OpenSSL

OpenSSL 不仅仅是 SSL。它可以实现消息摘要、文件的加密和解密、数字证书、数字签名 和随机数字。关于 OpenSSL 库的内容非常多，远不是一篇文章可以容纳的。
OpenSSL 不只是 API，它还是一个命令行工具。命令行工具可以完成与 API 同样的工作， 而且更进一步，可以测试 SSL 服务器和客户机。它还让开发人员对 OpenSSL 的能力有一个 认识。要获得关于如何使用 OpenSSL 命令行工具的资料，请参阅 [官方手册](https://www.openssl.org/docs/apps/openssl.html)。

### openssl 的编译安装

下载：<https://www.openssl.org/source/>

安装 OpenSSL, 请确保你已安装以下组件:

- make
- Perl 5
- an ANSI C compiler
- a development environment in form of development libraries and C
  header files
- a supported Unix operating system

#### 快速安装

```shell
$ ./config
$ make
$ make test
$ make install
```

> 更多的安装细节可以参考安装包中的INSTALL文件:<https://github.com/openssl/openssl/blob/master/INSTALL>

#### 产生私钥

```shell
➜  ~  openssl
OpenSSL> genrsa -out rsa_private_key.pem 1024              
Generating RSA private key, 1024 bit long modulus
..........++++++
...++++++
e is 65537 (0x10001)
OpenSSL>
➜  ~  vim rsa_private_key.pem 
----BEGIN RSA PRIVATE KEY-----
MIICXQIBAAKBgQDLAwyua/Mhu4Ik8a2iLst0yWijyyDeHsuTEM9/X/IhAtlxHJ7w
GmO5UmD0rSGv5rGDlu5n/jo8p35WLbOGTocs9RlOV5wS69rxtiO0CHHSdOi+jh1r
+9mDiPmnQQ2sOl6KFsvGwRB3UaCc6LgqDqsg89/f4IkrLLas3nPRa989RQIDAQAB
AoGALjLZde/2+lwzd7jP7LJ9dmxHNc8KAcI8TZFrxu7MqRp+5TDAMp+uxgOrMMMd
gWwcRXfZdSzzj84GABKSYiQIupg7V6rk/XgmIQAiBjWEvyzpwp71IRE9dzhkL5Qc
WF/PymajQ766vI1FhhLdU85Rc0Gly5ZawsfQGDBJ/s6AWMECQQD47D4gPA/Pnzpx
5VnMJpgLLqA7E5oOBiD0EINUZ0iYPMu/EYazUTAcLoRitUQorm16aP7IjaUvymHA
9HfDYsXpAkEA0MimPCuD3Pg8xaaSrqGXSCufOMezIOZcnFYSCIcAy0p0mBoySZON
ypvjB8ojhvCONRhQFJy35OlFuAOsl162/QJBAMNYalzTpbjTBYOycGkU9Ib5/Ua/
WEufJadDejz3nPHT7DUy5Nm+YhoLq1rnU+j1EfdZhHERL8w0b8iEUaRk1FkCQBEG
S4fchIQgOdRkINHcm1lnNTSMFC86mZKl8hJ/77CkAZ3lhPQ68/TxgTHBaeQ2+WGa
+ey0Wspvux+mLQyqzIECQQDEL+4/UFI/wKAsO41k8wibzZ8/Rm3BQTwV0i5tzxHO
9N5jIHkZa5AIVhq2qNBD+ev8gNp9MbipYUhduHrudLdS
-----END RSA PRIVATE KEY-----
```

#### 产生公钥

```shell
OpenSSL> rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem
writing RSA key

➜  ~  vim rsa_public_key.pem 

-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDLAwyua/Mhu4Ik8a2iLst0yWij
yyDeHsuTEM9/X/IhAtlxHJ7wGmO5UmD0rSGv5rGDlu5n/jo8p35WLbOGTocs9RlO
V5wS69rxtiO0CHHSdOi+jh1r+9mDiPmnQQ2sOl6KFsvGwRB3UaCc6LgqDqsg89/f
4IkrLLas3nPRa989RQIDAQAB
-----END PUBLIC KEY-----
```

### 生成证书

```
➜  ~  openssl req -new -key rsa_private_key.pem -out zongbao.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:cn
State or Province Name (full name) [Some-State]:beijing
Locality Name (eg, city) []:bj
Organization Name (eg, company) [Internet Widgits Pty Ltd]:jinritemai
Organizational Unit Name (eg, section) []:jrtm
Common Name (e.g. server FQDN or YOUR name) []:fengzbao
Email Address []:fengzbao@qq.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:1q2w3e4r
An optional company name []:jinritemai
➜  ~

```

### 生成待签名的字符串

**要参与签名的参数**
在请求参数列表中,除去 sign、sign_type 两个参数外,其他需要使用到的参数皆是要签名的参数。(个别接口中参数 sign_type 也需要参与签名。)在通知返回参数列表中,除去 sign、sign_type 两个参数外,凡是通知返回回来的参数皆是要签名的参数

根据支付宝的要求，数组需要完成以下重组：

> 对数组里的每一个值从 a 到 z 的顺序排序,若遇到相同首字母,则看第二个字母,以此类推。排序完成之后,再把所有数组值以“&”字符连接起来,
>
> ```
> public function sign($data)
> {
>  $array = array (
>      'out_trade_no' => '15002420575997',
>      'trade_no' => '2015012041879426',
>      'reason' => '商品质量问题',
>      'trans_fee' => '1000',
>      'payee_account' => 'fengzbao@qq.com',
>      'payee_name' => '冯宗宝',
>  );
> 
>  ksort($array);
>  $message = '';
>  foreach($array as $key=>$value){
>      $message .= $key."=".$value."&";
>  }
> 
>  $message = substr($message, 0, -1);
>  $pric_key_id = openssl_get_privatekey($this->private_key);
> 
>     openssl_sign($this->message, $signgure, $pric_key_id);
>     openssl_free_key($pric_key_id);
>  
> }    
> public function verify($data)
> {
>     $sign = $data['tt_sign'];
>     unset($data['tt_sign']);
>     unset($data['tt_sign_type']);
>     ksort($data);
> 
>     $message = '';
>     foreach ($data as $key => $value) {
>         $message .= $key . '=' . $value . '&';
>     }
>     $message = substr($message, 0, -1);
> 
>     $publicKey = ;
>     $publicKeyId = openssl_pkey_get_public($publicKey);
>     $result = openssl_verify($message, base64_decode($sign), $publicKeyId);
>     openssl_free_key($publicKeyId);
> 
>     return $result;
> }
> 
> ```
>
>
>
> 注意：
>
> - 没有值的参数无需传递,也无需包含到待签名数据中;
> - 根据 HTTP 协议要求,传递参数的值中如果存在特殊字符(如:&、@等),
>   那么该值需要做 URL Encoding,这样请求接收方才能接收到正确的参数值。这
>   种情况下,待签名数据应该是原生值而不是 encoding 之后的值。例如:调用某
>   接口需要对请求参数 email 进行数字签名,那么待签名数据应该是
>   email=test@msn.com,而不是 email=test%40msn.com。

### RSA签名

在 DSA 或 RSA 的签名时,需要私钥和公钥一起参与签名。私钥与公钥皆是客户通过 OPENSSL 来生成得出的。客户把生成出的公钥与支付宝技术人员配置好的支付宝公钥做交换。因此,在签名时,客户要用到的是客户的私钥及支付宝的公钥。

#### 请求时签名

当拿到请求时的待签名字符串后,把待签名字符串与客户的私钥一同放入 DSA 或RSA 的签名函数中进行签名运算,从而得到签名结果字符串。

#### 通知返回时验证签名

当获得到通知返回时的待签名字符串后,把待签名字符串、支付宝提供的公钥、支付宝通知返回参数中的参数 sign 的值三者一同放入 DSA 或 RSA 的签名函数中进行非对称的签名运算,来判断签名是否验证通过。

### 更多

本文只是在做支付过程中的一个指导文件，openssl还可以对文件生成信息摘要等，大家可以参考下面的两篇文章获取更多信息：

- [在Linux环境下使用OpenSSL对消息和文件进行加密](http://www.rising.com.cn/newsletter/news/2013-02-26/13227.html)
- [openssl使用手册](http://blog.chinaunix.net/uid-26729093-id-4090311.html)



# IDEA 快捷键

|快捷键|说明|
|----|----|
|Ctrl+Shift+F8|查看断点|
|alt+F8       |debug时选中查看值|
|Alt+F10      |定位到断点|
| alt+r |执行(run)|
| alt+/ |提示补全 (Class Name Completion)|
| ctrl+alt+/ |提示方法参数类型(Parameter Info)|
| ctrl+shift+y |大写转小写/ 小写转大写(toggle case)|
| ctrl+alt+y |批量修改某个单词|
| ||



# 运维

##  蓝绿部署（Blue/Green Deployment）
>  过去的 10 年里，很多公司都在使用蓝绿部署（发布）来实现热部署，这种部署方式具有安全、可靠的特点。蓝绿部署虽然算不上“ Sliver Bullet”，但确实很实用。
> 蓝绿部署是最常见的一种0 downtime部署的方式，是一种以可预测的方式发布应用的技术，目的是减少发布过程中服务停止的时间。蓝绿部署原理上很简单，就是通过冗余来解决问题。通常生产环境需要两组配置（蓝绿配置），一组是active的生产环境的配置（绿配置），一组是inactive的配置（蓝绿配置）。用户访问的时候，只会让用户访问active的服务器集群。在绿色环境（active）运行当前生产环境中的应用，也就是旧版本应用version1。当你想要升级到version2 ，在蓝色环境（inactive）中进行操作，即部署新版本应用，并进行测试。如果测试没问题，就可以把负载均衡器／反向代理／路由指向蓝色环境了。随后需要监测新版本应用，也就是version2 是否有故障和异常。如果运行良好，就可以删除version1 使用的资源。如果运行出现了问题，可以通过负载均衡器指向快速回滚到绿色环境。

### 蓝绿部署的优点：
> 这种方式的好处在你可以始终很放心的去部署inactive环境，如果出错并不影响生产环境的服务，如果切换后出现问题，也可以在非常短的时间内把再做一次切换，就完成了回滚。而且同时在线的只有一个版本。蓝绿部署无需停机，并且风险较小。

* (1) 部署版本1的应用（一开始的状态），所有外部请求的流量都打到这个版本上。

* (2) 部署版本2的应用，版本2的代码与版本1不同(新功能、Bug修复等)。

* (3) 将流量从版本1切换到版本2。

* (4) 如版本2测试正常，就删除版本1正在使用的资源（例如实例），从此正式用版本2。

  > 从过程不难发现，在部署的过程中，应用始终在线。并且，新版本上线的过程中，并没有修改老版本的任何内容，在部署期间，老版本的状态不受影响。这样风险很小，并且，只要老版本的资源不被删除，理论上，可以在任何时间回滚到老版本。

### 蓝绿部署的弱点：
> 使用蓝绿部署需要注意的一些细节包括：

* 1、当切换到蓝色环境时，需要妥当处理未完成的业务和新的业务。如果数据库后端无法处理，会是一个比较麻烦的问题。
* 2、有可能会出现需要同时处理“微服务架构应用”和“传统架构应用”的情况，如果在蓝绿部署中协调不好这两者，还是有可能导致服务停止；
* 3、需要提前考虑数据库与应用部署同步迁移/回滚的问题。
* 4、蓝绿部署需要有基础设施支持。
* 5、在非隔离基础架构（ VM 、 Docker 等）上执行蓝绿部署，蓝色环境和绿色环境有被摧毁的风险。
* 6、另外，这种方式不好的地方还在于冗余产生的额外维护、配置的成本，以及服务器本身运行的开销。

### 蓝绿部署适用的场景：
1、不停止老版本，额外搞一套新版本，等测试发现新版本OK后，删除老版本。
2、蓝绿发布是一种用于升级与更新的发布策略，部署的最小维度是容器，而发布的最小维度是应用。
3、蓝绿发布对于增量升级有比较好的支持，但是对于涉及数据表结构变更等等不可逆转的升级，并不完全合适用蓝绿发布来实现，需要结合一些业务的逻辑以及数据迁移与回滚的策略才可以完全满足需求。

## A/B 测试（A/B Testing）
> A/B 测试跟蓝绿部署完全是两码事。A/B 测试是用来测试应用功能表现的方法，例如可用性、受欢迎程度、可见性等等。 蓝绿部署的目的是安全稳定地发布新版本应用，并在必要时回滚。
>
> A/B 测试与蓝绿部署的区别在于， A/B 测试目的在于通过科学的实验设计、采样样本代表性、流量分割与小流量测试等方式来获得具有代表性的实验结论，并确信该结论在推广到全部流量可信。
>
> A/B 测试和蓝绿部署可以同时使用。

## 灰度发布／金丝雀发布
>  灰度发布是指在黑与白之间，能够平滑过渡的一种发布方式。灰度发布是增量发布的一种类型，灰度发布是在原有版本可用的情况下，同时部署一个新版本应用作为“金丝雀”（金丝雀对瓦斯极敏感，矿井工人携带金丝雀，以便及时发发现危险），测试新版本的性能和表现，以保障整体系统稳定的情况下，尽早发现、调整问题。

### 灰度发布／金丝雀发布由以下几个步骤组成：
* 1、准备好部署各个阶段的工件，包括：构建工件，测试脚本，配置文件和部署清单文件。

* 2、从负载均衡列表中移除掉“金丝雀”服务器。

* 3、升级“金丝雀”应用（排掉原有流量并进行部署）。

* 4、对应用进行自动化测试。

* 5、将“金丝雀”服务器重新添加到负载均衡列表中（连通性和健康检查）。

* 6、如果“金丝雀”在线使用测试成功，升级剩余的其他服务器。（否则就回滚）

  > 灰度发布可以保证整体系统的稳定，在初始灰度的时候就可以发现、调整问题，以保证其影响度。 

### 灰度发布/金丝雀部署适用的场景：
* 1、不停止老版本，额外搞一套新版本，不同版本应用共存。

* 2、灰度发布中，常常按照用户设置路由权重，例如90%的用户维持使用老版本，10%的用户尝鲜新版本。

* 3、经常与A/B测试一起使用，用于测试选择多种方案。AB test就是一种灰度发布方式，让一部分用户继续用A，一部分用户开始用B，如果用户对B没有什么反对意见，那么逐步扩大范围，把所有用户都迁移到B上面来。

* 趣闻 ：

  > 金丝雀部署（同理还有 金丝雀测试），“金丝雀”的由来：17世纪，英国矿井工人发现，金丝雀对瓦斯这种气体十分敏感。空气中哪怕有极其微量的瓦斯，金丝雀也会停止歌唱；而当瓦斯含量超过一定限度时，虽然鲁钝的人类毫无察觉，金丝雀却早已毒发身亡。当时在采矿设备相对简陋的条件下，工人们每次下井都会带上一只金丝雀作为“瓦斯检测指标”，以便在危险状况下紧急撤离。

## 滚动发布（rolling update）
> 滚动发布，一般是取出一个或者多个服务器停止服务，执行更新，并重新将其投入使用。周而复始，直到集群中所有的实例都更新成新版本。这种部署方式相对于蓝绿部署，更加节约资源——它不需要运行两个集群、两倍的实例数。我们可以部分部署，例如每次只取出集群的20%进行升级。
> 这种方式也有很多缺点，例如：

* (1) 没有一个确定OK的环境。使用蓝绿部署，我们能够清晰地知道老版本是OK的，而使用滚动发布，我们无法确定。

* (2) 修改了现有的环境。

* (3) 如果需要回滚，很困难。举个例子，在某一次发布中，我们需要更新100个实例，每次更新10个实例，每次部署需要5分钟。当滚动发布到第80个实例时，发现了问题，需要回滚。此时，脾气不好的程序猿很可能想掀桌子，因为回滚是一个痛苦，并且漫长的过程。

* (4) 有的时候，我们还可能对系统进行动态伸缩，如果部署期间，系统自动扩容/缩容了，我们还需判断到底哪个节点使用的是哪个代码。尽管有一些自动化的运维工具，但是依然令人心惊胆战。

  > 并不是说滚动发布不好，滚动发布也有它非常合适的场景。

## 红黑部署(Red-Black Deployment)
> 这是Netflix采用的部署手段，Netflix的主要基础设施是在AWS上，所以它利用AWS的特性，在部署新的版本时，通过AutoScaling Group用包含新版本应用的AMI的LaunchConfiguration创建新的服务器。测试不通过，找到问题原因后，直接干掉新生成的服务器以及Autoscaling Group就可以，测试通过，则将ELB指向新的服务器集群，然后销毁掉旧的服务器集群以及AutoScaling Group。
> 红黑部署的好处是服务始终在线，同时采用不可变部署的方式，也不像蓝绿部署一样得保持冗余的服务始终在线。





# 安装Gitbook

## 搭建基本环境

### 安装Git

网上已有很多相关的教程，可参考：[Linux下安装Git](https://link.jianshu.com?t=http://www.cnblogs.com/zhcncn/p/4030078.html)

### 安装Node.js和NPM

相关的包在官网下载速度慢，可在国内的镜像网站下载，如[淘宝NPM镜像](https://link.jianshu.com?t=https://npm.taobao.org/)

```bash
# 下载安装，安装包位置随意
wget https://npm.taobao.org/mirrors/node/v7.2.1/node-v7.2.1-linux-x64.tar.gz
tar zxvf node-v7.2.1-linux-x64.tar.gz
cd node-v7.2.1-linux-x64
# 命令设置全局，因为安装node自带npm，所以不需要安装
sudo ln -s /home/apps/node-v7.2.1-linux-x64/bin/node /usr/local/bin/node
sudo ln -s /home/apps/node-v7.2.1-linux-x64/bin/npm /usr/local/bin/npm
# 查看安装版本
node -v
# 查看npm版本
npm -v
```

除了以上安装方式，还可以使用编译好的安装包或yum安装，不过yum安装的版本比较低，可参考：[Linux下Nodejs安装（完整详细）](https://link.jianshu.com?t=https://my.oschina.net/blogshi/blog/260953)

## 安装Gitbook工具

```bash
# 利用npm安装gitbook
npm install gitbook-cli -g
sudo ln -s /home/apps/node-v7.2.1-linux-x64/bin/gitbook /usr/local/bin/gitbook
# 安装后查看版本
gitbook -V
```

以上的安装方式由于墙的原因，安装非常慢，所以推荐使用国内镜像方式安装，[淘宝NPM镜像][1]

```bash
# 安装淘宝定制的cnpm来替代npm
npm install -g cnpm --registry=https://registry.npm.taobao.org
sudo ln -s /home/apps/node-v7.2.1-linux-x64/bin/cnpm /usr/local/bin/cnpm
# 安装gitbook和以上方式一样，只需把npm修改为cnpm
cnpm install gitbook-cli -g
sudo ln -s /home/apps/node-v7.2.1-linux-x64/bin/gitbook /usr/local/bin/gitbook
# 安装后查看版本，第一次查看时会进行初始化处理，需要等一段时间（挺久点，去干点其他事情吧）
gitbook -V
```

安装完成后，可使用gitbook搭建一个demo-web站点

```bash
cd /home/apps/gitbook
mkdir demo
cd demo
# 初始化之后会看到两个文件，README.md ，SUMMARY.md
gitbook init
# 生成静态站点，当前目录会生成_book目录，即web静态站点
gitbook build ./
# 启动web站点，默认浏览地址：http://localhost:4000
gitbook serve ./

#这个命令在用户退出终端时也会结束。为保持其后台运行须修改为setsid,nohup命令不行
setsid gitbook serve .
```

## 配置Gitbook与Jenkins自动部署

使用Gitbook提供的webhook功能，待文档更新时通知jenkins构建部署

Jenkins搭建与使用，详情可参考：

构建Jenkins-Job后，进入配置页面
 配置Git信息（需安装git插件）

![img](image/1007926-ed7811c7b6e6eb54.png)

Paste_Image.png

设置触发构建http地址信息

![img](image/1007926-7f334e977183e50a.png)

Paste_Image.png

按以上说明操作， 可添加验证令牌防止误访问，然后再拼接http地址，如：
 [http://localhost:12000/jenkins/job/interfaceDoc/buildWithParameters?token=xxxxxx](https://link.jianshu.com?t=http://localhost:12000/jenkins/job/interfaceDoc/buildWithParameters?token=xxxxxx)

然后把以上http地址填到Gitbook服务即可

![img](image/1007926-6c76e275dbff93e0.png)