#!/bin/env bash

# etcd 集群启动脚本

DIR=$(cd "$(dirname "$0")"; pwd)


if [ ! -f "$1" ]; then
    echo "配置文件错误"
fi


CONFIG_FILE=$1
PROTOCAL="http"
G_TOEKN="col-token"
G_STATE="new"

CLUSTERS=""
# 定义节点数组
declare -A NODE_NAMES
# 定义节点数据服务地址数组
declare -A NODE_NAME_CLIENTS
# 定义节点同步地址数组
declare -A NODE_NAME_CLUSTERS


function parseConfigFile()
{
    while read LINE
    do
        NODE_CONFIG=$(echo $LINE | grep -v "^#" )
        if [ "$?" != "0" -o  "$NODE_CONFIG" == "" ]; then
            continue
        fi
        node=$(echo $NODE_CONFIG | cut -d " " -f 1)
        client=$(echo $NODE_CONFIG | cut -d " " -f 2)
        cluster=$(echo $NODE_CONFIG | cut -d " " -f 3)
        NODE_NAMES["$node"]="$node"
        NODE_NAME_CLIENTS["$node"]="$client"
        NODE_NAME_CLUSTERS["$node"]="$cluster"
    done < $CONFIG_FILE 

    echo "读取到 ${#NODE_NAMES[*]} 个节点"

}

# nodeName cluster-token cluster-state client_url peer_url cluster_url
function startEtcd()
{
    node_name="$1"
    token="$2"
    state="$3"
    client_url="${PROTOCAL}://$4"
    peer_url="${PROTOCAL}://$5"
    cluster_url="$6"

    echo "启动节点 ${node_name} ... "
    nodes_dir="${DIR}/nodes/"
    nodes_log="${nodes_dir}/${node_name}.log"
    [ ! -d "${nodes_dir}" ] && mkdir -p ${nodes_dir}
    [ ! -f "${nodes_log}" ] && touch ${nodes_log}

    nohup etcd --name ${node_name} --initial-advertise-peer-urls ${peer_url} \
    --listen-peer-urls ${peer_url} \
    --listen-client-urls ${client_url} \
    --advertise-client-urls ${client_url} \
    --initial-cluster-token ${token} \
    --initial-cluster ${cluster_url} \
    --initial-cluster-state ${state} & >${nodes_log} 2>&1

    if [ "$?" == "0" ]; then
        echo "节点 ${node_name} 启动成功"
    else
        echo "节点 ${node_name} 启动失败"
        exit 1
    fi
}

function tryStartNode()
{
    initial_cluster=""
    for node in ${NODE_NAMES[*]}; do
        initial_cluster="${initial_cluster},$node=${PROTOCAL}://${NODE_NAME_CLUSTERS[${node}]}"
    done
    initial_cluster=$(echo $initial_cluster | sed "s/^\,//" )
    

    for node in ${NODE_NAMES[*]}; do
        startEtcd $node $G_TOEKN $G_STATE ${NODE_NAME_CLIENTS[${node}]} ${NODE_NAME_CLUSTERS[${node}]} ${initial_cluster}
    done

}


# 格式化配置文件
parseConfigFile
# 尝试启动节点
tryStartNode
