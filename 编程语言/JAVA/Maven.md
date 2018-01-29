


#### Maven 常用命令



> Maven 项目目录结构

```
├── pom.xml
├── src
│   └── main
│       ├── java
│       │   └── com
│       │       └── self
│       │           └── MavenMain.java
│       └── test
└── target
```

可以使用　`mvn archetype:generate` 来生成一个项目 


> 生命周期

```
`clean` -> `compile` -> `test` -> `package` -> `install`
    |
pre-clean
```

>　插件使用
```
<build>
    <plugins>
        <plugin> <!-- 注册的插件 -->
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-source-plugin</artifactId>
            <version>2.4</version>
            <executions>
                <execution>
                    <!-- 指定声明周期的阶段　打包的时候执行　-->
                    <phase>package</phase>
                    <goals>
                        <goal>jar-no-fork</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

> 文件描述

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>

	<groupId></groupId>
    <!-- 项目标识　项目名+模块名-->
	<artifactId>soul-study</artifactId>
    <!--　项目版本号 -->
	<version>0.0.1-SNAPSHOT</version>
    <!--　打包文件　-->
	<packaging>jar</packaging>
    <!-- 项目URL -->
    <url>hha</url>
	<!--　项目license -->
    <licenses><license>MIT</license></licenses>

	<name>soul-study</name>
	<description>Demo project for Spring Boot</description>

    <!--　父模块　-->
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>1.5.9.RELEASE</version>
		<relativePath/> <!-- lookup parent from repository -->
	</parent>

	<properties>
		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		<project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
		<java.version>1.8</java.version>
	</properties>

	<dependencies>
		<dependency>
            <!--　坐标　-->
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-aop</artifactId>
            <type></type>
            <!--依赖范围-->
            <scope></scope>
            <!--　依赖设置是否可选　-->
            <optional></optional>
            <!--　排除依赖　-->
            <exclusions>
                <exclusion>
                    <artifactId></artifactId>
                    <groupId></groupId>
                </exclusion>
            </exclusions>

		</dependency>
	</dependencies>
    <!--依赖管理-->
    <dependencyManagement>
        <dependencies>
            <dependency>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <!--注册编译时候需要做的事情-->
	<build>
        <!-- 插件列表 -->
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
            <plugin> <!-- 注册的插件 -->
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-source-plugin</artifactId>
                <version>2.4</version>
                <executions>
                    <execution>
                        <!-- 指定阶段　打包的时候执行　-->
                        <phase>package</phase>
                        <goals>
                            <goal>jar-no-fork</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
		</plugins>
	</build>
    <!--多个模块一起编译-->
    <modules>
        <module>
        </module>
    </modules>


</project>

```

> 项目如何讲依赖的包也打包导出

参考 `http://blog.csdn.net/xiao__gui/article/details/47341385`

打包文件并可以直接运行

```
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <version>2.6</version>
    <configuration>
        <archive>
            <manifest>
                <addClasspath>true</addClasspath>
                <classpathPrefix>lib/</classpathPrefix>
                <mainClass>com.self.study.mybatis.selfmybatis.Test1</mainClass>
            </manifest>
        </archive>
    </configuration>
</plugin>
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-dependency-plugin</artifactId>
    <version>2.10</version>
    <executions>
        <execution>
            <id>copy-dependencies</id>
            <phase>package</phase>
            <goals>
                <goal>copy-dependencies</goal>
            </goals>
            <configuration>
                <outputDirectory>${project.build.directory}/lib</outputDirectory>
            </configuration>
        </execution>
    </executions>
</plugin>
```

---


- `mvn compile` 编译程序 编译后的目标在 `target` 目录中
- `mvn install` 将jar包部署到本地 Maven 仓库中
- `mvn clean` 清楚 `target`　生成的数据
