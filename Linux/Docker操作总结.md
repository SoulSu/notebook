---
title: [Docker] 操作终结
tags: Docker
notebook: Linux
---




### 常用命令

- `docker images` 查看所有镜像
- `docker cp [file] [container:path]` 拷贝文件到一个容器中
- `docker ps` 查看运行中的容器
    - `docker ps -a` 查看所有的容器包括没有运行的
- `docker rm [container]` 删除一个没有运行的容器
    - `docker rm [container] -f` 强制删除一个容器
- `docker rmi [imageid]` 删除一个镜像
- `docker commit -m [msg] [container] [repository:tag]` 将一个容器提交到镜像中，之前对该容器的修改会一直保存
- `docker info` 查看docker的一些信息
- `docker stop|start [container]` 启动或者停止容器
- `docker search` 从远端仓库查找docker镜像
- `docker pull` 获取image
- `docker build` 通过Dockerfile 文件创建镜像
- `docker run` 运行镜像
    - `docker run -d --name [name] -v [挂载]`
- `docker inspect [container]` 查看容器的配置信息

### Dockerfile 语法

- `FROM` 基础镜像
- `RUN` 执行命令
- `ADD` 添加文件
- `COPY` 拷贝文件
- `CMD` 执行命令
- `EXPOSE` 暴露端口
- `ENV` 设定环境变量
- `WORKDIR` 指定路径
- `MAINTAINER` 维护者 作者
- `ENTRYPOINT` 容器入口
- `USER` 指定用户
- `VOLUME` 挂载




### 常见问题


