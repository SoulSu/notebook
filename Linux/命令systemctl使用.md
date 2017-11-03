---
title: 命令 [systemctl] 使用
tags: cmd
notebook: Linux
---


### 什么是　`systemd`

`systemd`　是新一代的系统初始化服务，[wiki讲解](https://zh.wikipedia.org/wiki/Systemd) ;她类似于老的　`init`　，但是加入并行启动和依赖相关，以守护进程的形式运行～


### `systemctl`　又是干什么的？

`systemctl` 是 Systemd 的主命令，用于管理系统。

#### `systemctl` 常见用法

> systemctl 管理下的开机启动程序默认读取目录 `/etc/systemd/system/` 该目录下的　service　一般都是符号链接自 `/usr/lib/systemd/system/`



##### 列出正在运行的 Unit
`systemctl list-units`

##### 列出所有Unit，包括没有找到配置文件的或者启动失败的
`systemctl list-units --all`

##### 列出所有没有运行的 Unit
`systemctl list-units --all --state=inactive`

##### 列出所有加载失败的 Unit
`systemctl list-units --failed`

##### 列出所有正在运行的、类型为 service 的 Unit
`systemctl list-units --type=service`


##### 设置开机启动
`systemctl enable service`


##### 禁止开机启动
`systemctl disable service`

