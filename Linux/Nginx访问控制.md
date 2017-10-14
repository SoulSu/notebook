---
title: [Nginx] 访问控制
tags: nginx
notebook: Linux
---


### 限制 IP 访问

需求

> 有一个后台，只允许由公司内部发送访问，不支持其他地方访问，这个时候就需要使用IP 地址进行访问控制啦～

```
location /admin/ {
    deny 10.0.0.1;
    allow 10.0.0.0/20;
    allow 2001:0db8::/32;
    deny all;
}
```

如上所示， `deny` 指令限制不能访问的IP， `allow` 指令允许能够访问的IP，从上到下执行匹配，直到最后一个配置为止。


### 配置跨域访问

[CORS 跨域说明](http://www.ruanyifeng.com/blog/2016/04/cors.html)，资源跨域共享的方法很多，这里就说说如何使用 Nginx 来配置资源支持跨域访问。

配置方法：

```
map $request_method $cors_method {
    OPTIONS 11;
    GET 1;
    POST 1;
    default 0;
}
server {
    location / {
        if ($cors_method ~ '1') {
            add_header 'Access-Control-Allow-Methods' 'GET,POST,OPTIONS';
            add_header 'Access-Control-Allow-Origin' '*.example.com';
            add_header 'Access-Control-Allow-Headers' 'DNT,
            Keep-Alive, User-Agent, X-Requested-With, If-Modified-Since, Cache-Control, Content-Type';
        }
        if ($cors_method = '11') {
            add_header 'Access-Control-Max-Age' 1728000;
            add_header 'Content-Type' 'text/plain; charset=UTF-8';
            add_header 'Content-Length' 0;
            return 204;
        }
    }
}
```


当浏览器发现请求是一个跨域请求时，会先发送一个 **OPTIONS** HTTP 方法，用来检测服务端是否支持跨域。如果支持，就会发送正常的 HTTP 请求方法。