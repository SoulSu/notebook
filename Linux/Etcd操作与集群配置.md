




### Etcd 参数说明


- `--name` 方便理解的节点名称，默认为 default，在集群中应该保持唯一，可以使用 hostname
- `--data-dir` 服务运行数据保存的路径，默认为 ${name}.etcd
- `--snapshot-count` 指定有多少事务（transaction）被提交时，触发截取快照保存到磁盘
- `--heartbeat-interval` leader 多久发送一次心跳到 followers。默认值是 100ms
- `--eletion-timeout` 重新投票的超时时间，如果 follow 在该时间间隔没有收到心跳包，会触发重新投票，默认为 1000 ms
- `--listen-peer-urls` 和同伴通信的地址，比如 http://ip:2380，如果有多个，使用逗号分隔。需要所有节点都能够访问，所以不要使用 localhost！
- `--listen-client-urls` 对外提供服务的地址：比如 http://ip:2379,http://127.0.0.1:2379，客户端会连接到这里和 etcd 交互
- `--advertise-client-urls` 对外公告的该节点客户端监听地址，这个值会告诉集群中其他节点
- `--initial-advertise-peer-urls` 该节点同伴监听地址，这个值会告诉集群中其他节点
- `--initial-cluster` 集群中所有节点的信息，格式为 node1=http://ip1:2380,node2=http://ip2:2380,…。注意：这里的 node1 是节点的 --name 指定的名字；后面的 ip1:2380 是 --initial-advertise-peer-urls 指定的值
- `--initial-cluster-state` 新建集群的时候，这个值为 new；假如已经存在的集群，这个值为 existing
- `--initial-cluster-token` 创建集群的 token，这个值每个集群保持唯一。这样的话，如果你要重新创建集群，即使配置和之前一样，也会再次生成新的集群和节点 uuid；否则会导致多个集群之间的冲突，造成未知的错误


### 集群配置

#### 单机配置

- 服务一
    - 数据提供地址 `127.0.0.1:2379`
    - 集群同伴请求地址 `127.0.0.1:2380`
- 服务二
    - 数据提供地址 `127.0.0.1:2389`
    - 集群同伴请求地址 `127.0.0.1:2390`
- 服务三
    - 数据提供地址 `127.0.0.1:2399`
    - 集群同伴请求地址 `127.0.0.1:2400`
    
服务一配置信息
```
etcd --name infra0 --initial-advertise-peer-urls http://127.0.0.1:2380 \
  --listen-peer-urls http://127.0.0.1:2380 \
  --listen-client-urls http://127.0.0.1:2379 \
  --advertise-client-urls http://127.0.0.1:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=http://127.0.0.1:2380,infra1=http://127.0.0.1:2390,infra2=http://127.0.0.1:2400 \
  --initial-cluster-state new
```

服务二配置信息
```
etcd --name infra1 --initial-advertise-peer-urls http://127.0.0.1:2390 \
  --listen-peer-urls http://127.0.0.1:2390 \
  --listen-client-urls http://127.0.0.1:2389 \
  --advertise-client-urls http://127.0.0.1:2389 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=http://127.0.0.1:2380,infra1=http://127.0.0.1:2390,infra2=http://127.0.0.1:2400 \
  --initial-cluster-state new
```

服务三配置信息
```
etcd --name infra2 --initial-advertise-peer-urls http://127.0.0.1:2400 \
  --listen-peer-urls http://127.0.0.1:2400 \
  --listen-client-urls http://127.0.0.1:2399 \
  --advertise-client-urls http://127.0.0.1:2399 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster infra0=http://127.0.0.1:2380,infra1=http://127.0.0.1:2390,infra2=http://127.0.0.1:2400 \
  --initial-cluster-state new
```

