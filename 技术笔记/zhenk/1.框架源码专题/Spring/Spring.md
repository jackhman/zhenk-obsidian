## 事务失效场景
在Spring框架中，事务管理是通过使用`@Transactional`注解或编程式事务管理来实现的。虽然Spring框架提供了强大的事务支持，但在某些情景下，可能会出现事务失效的情况。以下是一些可能导致Spring事务失效的场景：

1. **未捕获的异常**：如果在事务内发生未被捕获的异常，并且没有通过`rollbackFor`属性指定进行回滚的异常类型，事务可能会失效。默认情况下，Spring只对`RuntimeException`及其子类进行回滚，对于受检异常，需要通过`rollbackFor`属性指定。
```java
@Transactional(rollbackFor = CustomException.class) 
public void myMethod() {     
// ... 
}
```   
2. **事务传播行为设置不当**：Spring事务管理中有事务传播行为的概念，例如`Propagation.REQUIRES_NEW`、`Propagation.NESTED`等。如果嵌套事务或新事务的传播行为设置不当，可能导致事务失效。
```java
@Transactional(propagation = Propagation.REQUIRES_NEW) 
public void myMethod() {     
// ... 
}
```
3. **非公开方法内部调用**：如果在同一个类的非公开方法内部调用带有`@Transactional`注解的方法，事务可能不会生效，因为Spring使用基于代理的AOP来实现事务，而在同一个类内部的自调用是不会被代理拦截的。
```java
@Transactional 
public class MyService {     
	public void publicMethod() {         
		// 事务会生效         
		internalMethod();     
	}      
	@Transactional     
	public void internalMethod() {
		// 事务可能失效         
		// ...     
	} 
}
```
4. **Runtime异常的处理**：如果在事务方法内抛出的异常被捕获并没有继续抛出，事务可能不会回滚。Spring默认只对未捕获的异常进行回滚，如果异常被捕获并处理，事务可能不会失效。
```java
@Transactional 
public void myMethod() {     
	try {         
	// ...     
	} catch (Exception e) {         
	// 异常被捕获，事务可能失效     
	} 
}
```
5. **数据库引擎不支持事务**：如果使用的数据库引擎不支持事务，例如MyISAM引擎，那么`@Transactional`注解也无法生效。确保使用支持事务的数据库引擎，例如InnoDB
7. **在非公共方法上使用@Transactional注解**：`@Transactional`注解通常应该用于公共方法上，如果在非公共方法上使用，可能会导致事务失效。
```java
@Transactional
private void myPrivateMethod() {
    // 事务可能失效
}
```

8. **自调用问题**：Spring的事务是通过AOP实现的，因此在同一个类的内部调用带有`@Transactional`注解的方法时，事务可能失效。这是因为Spring的AOP代理是基于动态代理或CGLIB的，对于自调用的情况可能无法拦截。
```java
@Service
public class MyService {
   @Autowired
   private MyService self;

   @Transactional
   public void outerMethod() {
   // 事务可能失效
   self.innerMethod();
   }

   @Transactional
   public void innerMethod() {
   // ...
   }
}

```
在这个例子中，`outerMethod`调用了`innerMethod`，因为它是在同一个类内被调用的，AOP代理可能无法拦截，从而导致事务失效。
9. **数据库连接的释放**：在某些情况下，如果数据库连接没有正确释放，可能会导致事务失效。确保使用`@Transactional`注解时Spring能够正确地管理数据库连接的获取和释放。
要避免这些问题，确保在Spring应用程序中正确配置事务，了解`@Transactional`注解的使用和相关的事务管理概念。通过仔细设计事务边界、异常处理和传播行为，可以最大程度地减少事务失效的可能性。