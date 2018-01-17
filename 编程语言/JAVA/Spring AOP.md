


#### Spring AOP　编程


- 添加依赖

```
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```

- 为需要标明成切面的类添加　`@Aspect` 注解


- `@Pointcut` 注解添加到方法中，声明需要匹配运用该切面的规则
    - 注解匹配
        - `@annotation(MyAnnotation)` *MyAnnotation* 为自定义注解，有使用该注解的**方法**会用到本切面方法
        - `@within()` **类**级别的注解匹配
        - `@args()`　**方法**参数匹配 
        - `@target()` **类**
        - `excution(arg1 arg2 arg3)` arg1:访问限定符,arg2:方法返回值,arg3:包路径 (public * com.a.b) **该匹配可以代替所有的执行点 如下**

- `@Before` 前置通知
- `@After()` 执行之后
- `@AfterThrowing()` 方法抛出异常才会执行　
- `@AfterReturing()` 有方法返回值执行 
- `@Around()`　比较强大的注解，可以模拟上面的几种切入点






#### 实现原理

##### 织入的时机

1. 编译器(AspectJ)
2. 类加载时(AspectJ 5+)
3. 运行时(Spring AOP)


- 运行时织入如何实现

1. 代理模式
2. JDK　代理实现
    - 类: java.lang.reflect.Proxy
    - 接口: InvocationHandler
    - 只能基于接口进行动态代理
3. CgLib 代理实现

