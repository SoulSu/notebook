---
title: [Nginx] 负载均衡实践
tags: nginx
notebook: Linux
---

### HTTP 负载均衡

需求

> 你需要将请求分配到两台或者更多的 HTTP 服务器

解决方法


> 在 HTTP 模块中使用 `Nginx` 的 `upstram` 语法来实现 HTTP 的服务负载均衡

```
upstream backend_name {
    server  127.0.0.1:7881 weight=1;
    server  127.0.0.1:7880 weight=2;
}
server {
    location / {
        proxy_pass http://backend_name;
    }
}
```

1. 默认请求下 `weight` 值都为 *1* 
2. 当一台后端服务器不能提供服务时候，该次请求还是能切到能提供服务的服务器上面；但是在error.log 中可以看到一条错误信息 `[error] 11618#0: *199 connect() failed (111: Connection refused) while connecting to upstream, client: 127.0.0.1, server: localhost, request: "GET / HTTP/1.1", upstream: "http://127.0.0.1:7880/", host: "127.0.0.1"`
3. 以上配置需要放到 `http` 节点中才能生效

这就是一个非常简单的负载均衡配置，是不是so easy 啊～


### TCP 负载均衡

需求

> 你需要将请求分配到两台或者更多的 TCP 服务器

解决方法

> 在 stream 模块中使用 `Nginx` 的 `upstram` 语法来实现 TCP 的服务负载均衡

```
stream {
        upstream mysql_read{
                server 127.0.0.1:3306;
                server 127.0.0.1:3307;
        }
        server {
                listen 3305;
                proxy_pass mysql_read;
        }
}
```

1. `stream` 模块类似于 `http` 模块， 允许你设置 `upstream` 连接池
2. `upstream` 可以定义为 [Unix socket](https://zh.wikipedia.org/wiki/Unix%E5%9F%9F%E5%A5%97%E6%8E%A5%E5%AD%97),`IP`,[FQDN](https://zh.wikipedia.org/wiki/%E5%AE%8C%E6%95%B4%E7%B6%B2%E5%9F%9F%E5%90%8D%E7%A8%B1)




### 负载均衡策略


需求

> 使用负载均衡不单单是轮询请求，可以使用特定的策略来分配到不同的代理服务器上面

#### `Round robin` 轮询

轮询是默认的负载均衡策略，在使用轮询负载策略的时候，可以添加 `weight` 权重，权重值越大，分配的请求量就越多。

```
upstream backend {
    server  127.0.0.1:7881 weight=1;
    server  127.0.0.1:7880 weight=2;
    server  127.0.0.1:7882;
}
```
  

#### `Least connections` 连接最少 

最少连接是按照当前 Nginx 服务器对应的代理请求数量决定的，新请求会代理到连接最少的服务器上面；该策略还是可以配置 `weight` 权重。

```
upstream backend {
    least_conn;
    server backend.example.com weight=3;
    server backend1.example.com;
}
```

#### `Least time` *Nginx Plus* 平均最少请求时间

该功能只有 `Nginx Plus` 才支持；新的请求会代理到平均响应时间最少的服务器上面。

```
upstream backend {
    least_time;
    server backend.example.com;
    server backend1.example.com;
}
```


#### `Generic hash`



通过配置来将请求hash到后端代理服务器上面；`hash` 后面必须添加参数， 可以是变量，也可以是变量和`consistent` 的组合。


```
upstream backend {
    #hash consistent;
    #hash "test";
    hash $request_uri consistent;
    server backend.example.com;
    server backend1.example.com;
}
```



#### `IP hash` 

只支持 **HTTP** 负载均衡，通过请求客户端的 IP 地址 前 3字节（IPv4），或者全部（IPv6） 的地址获取 hash 值；如果你要使用一般的会话一致性保证，这是一个不错的选择；该策略还是可以配置 `weight` 权重。


```
upstream backend {
    ip_hash;
    server backend.example.com weight=8;
    server backend1.example.com weight=2;
}
```


### 连接数量限制


该功能只有 `Nginx Plus` 中使用

使用 `max_conns` 参数来限制 `upstream servers` 的请求数量;使用 `queue` 指令来设置同时在队列中的请求数量，参赛 `timeout` 参数限制队列中请求的超时时间；`zone` 指令用来设置 每个工作线程共享的信息，多少个在队列中的连接数量～


```
upstream backend {
    zone backends 64k;
    queue 750 timeout=30s;
    server webserver1.example.com max_conns=25;
    server webserver2.example.com max_conns=15;
}
```
