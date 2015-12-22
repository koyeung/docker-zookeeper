# docker-zookeeper
Run [ZooKeeper](https://zookeeper.apache.org) 3.5.x in Distributed mode


## Usage

### Run "cluster" with single server initially
``` bash
docker run -d -t --name zk1 zookeeper
docker exec zk1 bin/setup.sh --myid=1
docker exec zk1 bin/zkServer.sh start
```

### Run cluster of 3 servers
``` bash
SERVERS=3

# Start containers
for i in $(seq $SERVERS); do
    docker run -d -t --name zk${i} zookeeper
    docker exec zk${i} bin/setup.sh --myid=${i}
done

# Consolidate server list
echo -n "" > /tmp/zoo.cfg.dynamic
for i in $(seq $SERVERS); do
    docker exec zk${i} cat /opt/zookeeper/conf/zoo.cfg.dynamic >> /tmp/zoo.cfg.dynamic
done

# Transfer full server list to containers
for i in $(seq $SERVERS); do
    docker cp /tmp/zoo.cfg.dynamic zk${i}:/tmp/zoo.cfg.dynamic
    docker exec zk${i} cp /tmp/zoo.cfg.dynamic /opt/zookeeper/conf/zoo.cfg.dynamic
done

# Start the server processes
for i in $(seq $SERVERS); do
   docker exec zk${i} bin/zkServer.sh start
done
```
