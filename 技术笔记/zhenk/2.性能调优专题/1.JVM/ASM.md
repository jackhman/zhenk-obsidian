## 一、ASM基础知识
ASM 可以直接产生二进制 class 文件，也可以在类被加载入 Java 虚拟机之前动态改变类行为。ASM主要被用于动态生成类和增强既有类的功能，实现更改类的继承关系，更改类的访问修饰符，增加、删减或修改字段和方法等需求。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/fe86270328e11a66f38f775fd7d3b4df.jpeg)

ASM核心类主要有三个：ClassReader、ClassVisitor和ClassWriter。ClassReader用于解析字节码文件；ClassVisitor用于寻找对应的结构，通过ClassVisitor可以实现方法的修改而不用关心结构关系；ClassWriter用于生成修改之后的字节码文件。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/ad128a4ac2648341e525ee22c6e98c96.jpeg)

### 动态修改方法案例

首先是针对方法调用的修改，比如我们在产品发布时有将原生log日志替换成Xlog日志方法的需求，此时就可以通过ASM完成方法调用的修改。其次是方法实现的修改，比如我们可以在OkHttpClientBuilder的构造⽅法⾥加入代码逻辑，实现自己的业务实现。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/7a8179d957cdf8f21671d1fc6642aeed.jpeg)

#### （1）方法调用修改

以下方网络请求为例，当它执行时，只要碰到Httpclient对象，都可以将它对应的方法替换成另一个方法，并且原来的参数还可以作为新方法的参数传入。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/7d898896b225b54dfe80a83b8ea60ceb.jpeg)

ASM实现方法调用的替换，会先后对方法的对象、名称和签名进行验证，确认一致后执行相应的替换。替换过程很简单，只是访问INVOKESTATIC这个指令。

#### （2）方法实现修改

大多是网络请求用的都是用的OkHttp方法，下方案例中，我们通过一行代码实现添加了网络拦截器。此时也要对相应的方法进行判断，图中的方法是在最后一行加入的，所以先判断一下当前的操作码是不是即将要返回，以及我当前所操作的对象，是不是HttpclientBuilder的类，如果是的话就会采用ASM相应的API做一些处理。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/3b90fcdf95979bb61d08f7f2a61ca730.jpeg)

## 二、ASM的底层原理

ASM的底层原理主要是分为字节码、虚拟机栈和指令三部分，对这三部分的理解可以帮助大家更好理解ASM功能的实现。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/cb7e0a172a6277f4dd4ba26c21084925.jpeg)

### 1、Java字节码文件及结构

下图左侧为字节码文件，通过010Editor工具打开，以16进制形式严格按照字节码文件的结构进行展开。第一个字段代表模数，后面分别是Version、常量、常量值、访问标志、类的方法、属性等。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/9c09cb4eff043a9c27eac03847089362.jpeg)

通过javap命令对某一个class文件做了输出，输出之后可以看到HomeActivity方法的描述图以及访问的标识。Code的属性存储了很多特别有用的信息，值得重点关注：Stack代表操作栈中最大的深度；locals代表方法内最多有多少个局部变量；args_size代表参数的个数。图中的1代表着默认参数。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/6d8cadb6286235adb20ca862a9f05910.jpeg)

### 2、虚拟机栈

Java运行时数据区分为两部分：一个是线程共享数据区，比如方法区和堆；还有一部分是线程隔离数据区，它属于某一个线程独有的，比如虚拟机栈、本地方法栈和程序计数器。当虚拟机引擎去执行命令时，它就会对这些虚拟机栈和方法栈等进行相应的操作。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/7c41c6bef27230a52df06eed4f14d61d.jpeg)

### 3、指令

指令本身由操作码和操作数组成，指令的类型很多，例如加载和存储、运算、操作数栈管理和方法调用与返回等。还有一些常用的指令，如：同步指令、异常处理指令和控制转移的指令等。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/7e8ad2cc2129728e75ad8ab1e1c8090f.jpeg)

### 4、虚拟机栈与字节码的关系

下图左边是字节码文件，字节码文件里面它会对应很多的方法，每一个方法都归对应一个栈帧，这包括局部变量表、操作栈、动态链接和访问地址，每一个操作栈里面的大小。Code属性中的Stack代表每个操作栈栈帧的大小，locals代表局部变量表的大小，其中字节码指令也在Code属性中。虚拟机执行引擎执行方法的时候字节码指令会逐步执行，然后对局部变量做一些赋值取值的操作。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/aca03577c123efbaaa58ada942bc2823.jpeg)

以int a=2+21赋值运算为例，在操作栈中起初只有30、19、8三个数值，当执行“int a=2+21；”这行代码时，首先会将2和21进行一个入栈的操作，当虚拟机执行引擎去执行iadd命令时，它首先会将21和2这两个值弹出，然后进行iadd加法的操作，得到23之后编码结果入栈。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/447f0473a5deefa5dccaf5aaf41ff882.jpeg)

过程源码如下图所示。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/5705f5adc964f92d193e787e15073be2.jpeg)

### 5、两种方式解析XML
1. **DOM**：基于事件触发的core API，不需要解析完整的文档，而是采用的是流式、单向的解析符合特定的事件则回调一些函数来处理事件，解析过的内容无法在不重新开始的情况下再次读取。
2. **SAX**：基于对象的Tree API，将整个 XML 作为类似树结构的方式读入内存中以便操作及解析

## 三、ASM与Aspectj的性能对比

从360手机卫士的8.1.0版本上的测试数据为例工具，之前使用的就为Aspectj，如果继续使用Aspectj，新增的方法数约为16000个，而使用ASM基本不会增加方法数，而且可以在方法内部进行处理，根据需求增加代码。Aspectj它本身是有自己的一套规则，如果想对某个方法做一些切面或者切点切入，它会根据自己的规则会生成一系列的辅助类，而辅助类里又有很多方法，当我们的切入点特别多的时候就会导致整个Apk方法数剧增。

![](https://ask.qcloudimg.com/http-save/yehe-1515841/e255aa2a2ef5e255b99766e78bd41cf2.jpeg)

手机卫士在16M大小的范围内就会增加1600个方法。从Apk包体积对比，采用ASM版本比Aspectj版本减少400KB大小。从编译器代码织入速度看，ASM只需3秒即可完成，而Aspectj则需要30秒左右。

基于以上考虑，360安全卫士最终选择使用ASM替换Aspectj。当然Aspectj没有被完全淘汰，因为Aspectj的规则相对简单，可以借助Aspectj快速实现一些代码的切入。


## 四、ASM官网
• http://asm.ow2.io
• the ASM name does not mean anything: it is just a reference to the `__asm__` keyword in C,which allows some functions to be implemented in AsSeMbly language.

## 五、有关设计模式
iterator + vistor + chainofresposibility
### 动态代理
#### ClassTransformerTest
```java
package com.mashibing.dp.ASM;  
  
import org.objectweb.asm.*;  
  
import java.io.File;  
import java.io.FileOutputStream;  
import java.io.OutputStream;  
  
import static org.objectweb.asm.Opcodes.*;  
  
public class ClassTransformerTest {  
    public static void main(String[] args) throws Exception {  
        ClassReader cr = new ClassReader(  
                ClassPrinter.class.getClassLoader().getResourceAsStream("com/mashibing/dp/ASM/Tank.class"));  
  
        ClassWriter cw = new ClassWriter(0);  
        ClassVisitor cv = new ClassVisitor(ASM4, cw) {  
            @Override  
            public MethodVisitor visitMethod(int access, String name, String descriptor, String signature, String[] exceptions) {  
                MethodVisitor mv = super.visitMethod(access, name, descriptor, signature, exceptions);  
                //return mv;  
                return new MethodVisitor(ASM4, mv) {  
                    @Override  
                    public void visitCode() {  
                        visitMethodInsn(INVOKESTATIC, "com/mashibing/dp/ASM/TimeProxy","before", "()V", false);  
                        super.visitCode();  
                    }  
                };  
            }  
        };  
  
        cr.accept(cv, 0);  
        byte[] b2 = cw.toByteArray();  
  
        MyClassLoader cl = new MyClassLoader();  
        //Class c = cl.loadClass("com.mashibing.dp.ASM.Tank");  
        cl.loadClass("com.mashibing.dp.ASM.TimeProxy");  
        Class c2 = cl.defineClass("com.mashibing.dp.ASM.Tank", b2);  
        c2.getConstructor().newInstance();  
  
  
        String path = (String)System.getProperties().get("user.dir");  
        File f = new File(path + "/com/mashibing/dp/ASM/");  
        f.mkdirs();  
  
        FileOutputStream fos = new FileOutputStream(new File(path + "/com/mashibing/dp/ASM/Tank_0.class"));  
        fos.write(b2);  
        fos.flush();  
        fos.close();  
  
    }  
}
```

#### Tank.java
```java
package com.mashibing.dp.ASM;  
  
public class Tank {  
    public void move(){  
        System.out.println("Tank Moving ClaClaCla ...");  
    }  
}
```

#### TimeProxy.java
```java
package com.mashibing.dp.ASM;  
  
public class TimeProxy {  
  
    public static void before() {  
        System.out.println("before ...");  
    }  
}
```
#### 代理逻辑
![[涉及到CoR设计模式.png]]

#### 生成新的Class文件
```java
//  
// Source code recreated from a .class file by IntelliJ IDEA  
// (powered by FernFlower decompiler)  
//  
  
package com.mashibing.dp.ASM;  
  
public class Tank {  
    public Tank() {  
        TimeProxy.before();  
        super();  
    }  
  
    public void move() {  
        TimeProxy.before();  
        System.out.println("Tank Moving ClaClaCla ...");  
    }  
}
```