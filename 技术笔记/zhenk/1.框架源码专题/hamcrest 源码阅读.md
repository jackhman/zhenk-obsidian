## 前言
hamcrest ，一个被多个测试框架依赖的包。听说 hamcrest 的源码质量很高，特此来学习一下。建议fork原仓库，拉到本地看代码。

[hamcrest github 仓库](https://github.com/hamcrest/JavaHamcrest)

![[image-20231216160334605.png]]


## 1.类图概览
看个大概的类图。很经典的接口、抽象类、子类实现
![[image-20231215180416076.png]]
## 2.源码阅读
将源码逐一拆解，提取有借鉴意义的编码方式。

### 2.1.抽象类 BaseMatcher
基类提供了基础方法。
![[image-20231215180433155.png]]
* 一个很有趣的方法名
在接口层面告诉使用者不要直接实现 Matcher 接口，而是继承 BaseMatcher
```java
@Deprecated
void _dont_implement_Matcher___instead_extend_BaseMatcher_();
```
### 2.2.接口 Description
BaseMatcher 中的方法依赖 Description 接口。
```java
@Override
    public void describeMismatch(Object item, Description description) {}

    @Override
    public String toString() {
        return StringDescription.toString(this);
    }
```
看看这个接口有什么特殊的地方。

#### 提炼模式：空对象模式
* Description 接口使用静态内部类包装一个 “空对象”，表达 “什么也不做”
```java
public interface Description {

  /**
   * A description that consumes input but does nothing.
   */
  static final Description NONE = new NullDescription();
}
```
![[image-20231215180641596.png]]

* BaseMatcher 主要使用的 StringDescription
![[image-20231215180949421.png]]

> 可以用idea的查找依赖功能，能看到 “空实现” 使用的地方

![[image-20231215180956540.png]]
### 2.3.接口 Description 与 SelfDescribing 配合使用
* 一个有意思的写法
```java
 	@Override
    public String toString() {
        return StringDescription.toString(this);
    }
```

* 发现 Matcher 父接口 SelfDescribing 的使用痕迹，用于表达 Matcher 自身的信息 (由开发者决定)
```java
public interface Matcher<T> extends SelfDescribing {}
```

* 接口定义
```java
public interface SelfDescribing {
    void describeTo(Description description);
}
```

#### 提炼模式：模板方法模式
* 声明一个自己的matcher 方法调用链如下 (省掉了与该模式无关的方法和类)
![[image-20231215180838784.png]]

* BaseMatcher 中的模板方法就是 toString()
```java
    @Override
    public String toString() {
        return StringDescription.toString(this);
    }
```

* 子类需要自定义describe逻辑 (模板方法toString会回调这个方法 )
```java
	@Override
    public void describeTo(Description description) {
    	// EG: BigDecimalCloseTo 的声明
         description.appendText("a numeric value within ")
              .appendValue(delta)
              .appendText(" of ")
              .appendValue(value);
    }
```
### 2.4.抽象类 BaseDescription
#### 提炼模式：迭代器模式
1. 泛型参数和自定义迭代器
hamcrest 作为一个`matcher`库，把某个matcher的职责打印出来，可以方便开发者进行调试。
##### 2.4.1.使用场景
![[image-20231215181848644.png]]

* 这里表示实例化一个 IsIn 的 Matcher，规则是需要满足在 a, b, c 中任意的一个值。
* 打印逻辑就在`StringDescription.toString()`中
* 使用jdk的迭代器可以保证打印方法的复用性，下文就读读框架中的实现。

##### 2.4.2.实现
关注到这个泛型参数`? extends SelfDescribing`表示必须是来自于 SelfDescribing 子类的迭代器。
![[image-20231215181923394.png]]
###### 2.4.2.1.自定义迭代器
![[image-20231215181929891.png]]

声明该参数的作用：appendDescription方法只接收 SelfDescribing，而appendList方法需要对存储 SelfDescribing 的容器进行遍历，所以需要约束容器内的成员类型
![[image-20231215185315198.png]]

**“跳过第一个元素” 的一种写法**
```java

private Description appendList(String start, String separator, String end, Iterator<? extends SelfDescribing> i) {  
    boolean separate = false;  
    append(start);  
    while (i.hasNext()) {
         // “跳过第一个元素” 的一种写法
        // 第一个字符前不拼接连接符, 其他都拼接
        if (separate) {
	        append(separator);  
	    }
	    // 打印字符
        appendDescriptionOf(i.next());  
        separate = true;  
    }  
    append(end);  
        return this;  
}  
  
/**  
 * Append the String <var>str</var> to the description.    
 * The default implementation passes every character to {@link #append(char)}.    
 * Override in subclasses to provide an efficient implementation.  
 */protected void append(String str) {  
    for (int i = 0; i < str.length(); i++) {  
        append(str.charAt(i));  
    }  
}
```
## 3.后记
* 笔者认为，如果存在大量的抽象类实现类，hamcrest 空对象模式可以借鉴一下。
* hamcrest 的 toString 模板方法把 describe 逻辑很好的解耦到子类了，下次遇到需要追加上下文的实现可以参考这个模式（如上文的BigDecimalCloseTo ）。