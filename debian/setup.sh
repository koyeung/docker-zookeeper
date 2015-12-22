#!/bin/bash

usage() {
    printf "usage: $0 <parameters>
  parameters:
    -h Display this message
    --help Display this message
    --myid=# Set the myid to be used, if any (1-255)
"
    exit 1
}

OPTS=$(getopt \
           -n $0 \
           -o 'h' \
           -l 'help' \
           -l 'myid:' \
           -- "$@")

if [ $? != 0 ] ; then
    usage
    exit 1
fi

setup() {

    if [ $MYID ]; then
        ./bin/zkServer-initialize.sh --myid=${MYID}

        CONFDIR=/opt/zookeeper/conf
        
        echo "server.${MYID}=$(hostname --ip-address):2888:3888" > ${CONFDIR}/zoo.cfg.dynamic
        echo "standaloneEnabled=false" >> ${CONFDIR}/zoo.cfg
        echo "dynamicConfigFile=${CONFDIR}/zoo.cfg.dynamic" >> ${CONFDIR}/zoo.cfg
    else
        echo "No myid provided; no setup is done"
    fi

}

eval set -- "${OPTS}"
while true; do
    case "$1" in
        --myid)
            MYID=$2; shift 2
            ;;
        -h)
            usage
            ;;
        --help)
            usage
            ;;
        --)
            setup
            break
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done
