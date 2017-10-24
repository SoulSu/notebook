#!/bin/env bash

# etcd 集群启动脚本

DIR=$(cd "$(dirname "$0")"; pwd)

RUN_DIR=$DIR/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p $RUN_DIR
fi

ACTION_START="--start"
ACTION_STOP="--stop"
ACTION_START_ALL="startall"
ACTION_STOP_ALL="stopall"

# 默认执行
ACTION=${ACTION_START_ALL}
ACTION_NODE=""

# 控制程序启动关闭
if [ ! -f "$1" ]; then
    echo "配置文件错误"
fi
# config --start node1
# config --stop node1
# config --stop all
if [ "$2" == "${ACTION_START}" -o "$2" == "${ACTION_STOP}" ]; then
    ACTION=$2
    ACTION_NODE=$3
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

NODES_DIR="${RUN_DIR}/logs"
[ ! -d "${NODES_DIR}" ] && mkdir -p ${NODES_DIR}

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
    nodes_log="${NODES_DIR}/${node_name}.log"
    nodes_pid="${NODES_DIR}/${node_name}.pid"
    
    [ ! -f "${nodes_log}" ] && touch ${nodes_log}

    cd ${RUN_DIR}
    nohup etcd --name ${node_name} --initial-advertise-peer-urls ${peer_url} \
    --listen-peer-urls ${peer_url} \
    --listen-client-urls ${client_url} \
    --advertise-client-urls ${client_url} \
    --initial-cluster-token ${token} \
    --initial-cluster ${cluster_url} \
    --initial-cluster-state ${state} > ${nodes_log} 2>&1 &
    last_pid=$!
    
    if [ "$?" == "0" ]; then
        echo "节点 ${node_name} 启动成功"
        echo ${last_pid} > $nodes_pid 
    else
        echo "节点 ${node_name} 启动失败"
        exit 1
    fi
    cd -
}

# nodeName
function stopEtcd()
{
    node_name="$1"

    echo "停止节点 ${node_name} ... "
    if [ ! -f ${NODES_DIR}/${node_name}.pid ]; then
        echo "停止节点 ${node_name} 失败， 没有找到pid文件: ${NODES_DIR}/${node_name}.pid"
        exit 2
    fi
    node_pid=$(cat "${NODES_DIR}/${node_name}.pid" )

    kill -9 ${node_pid}
    if [ "$?" == "0" ]; then
        echo "节点 ${node_name} 停止成功"
        rm -rf ${NODES_DIR}/${node_name}.pid
    else
        echo "节点 ${node_name} 停止失败"
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
        if [ ${ACTION} == ${ACTION_START_ALL} -o ${ACTION} == ${ACTION_START} ]; then
            if [ "${ACTION_NODE}" == "" -o "${ACTION_NODE}" == "${node}" ]; then
                startEtcd $node $G_TOEKN $G_STATE ${NODE_NAME_CLIENTS[${node}]} ${NODE_NAME_CLUSTERS[${node}]} ${initial_cluster}
            fi
        fi
        if [ ${ACTION} == ${ACTION_STOP_ALL} -o ${ACTION} == ${ACTION_STOP} ]; then
            if [ "${ACTION_NODE}" == "" -o "${ACTION_NODE}" == "all" -o "${ACTION_NODE}" == "${node}" ]; then
                stopEtcd $node
            fi
        fi
    done

}


# 格式化配置文件
parseConfigFile
# 尝试启动节点
tryStartNode
