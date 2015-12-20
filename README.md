# docker-zookeeper
Run [ZooKeeper](https://zookeeper.apache.org) 3.5.x in Distributed mode


## Usage

1. Start containers
   ``` bash
   SERVERS=3
   for i in $(seq $SERVERS); do
       docker run -d -t --name zk${i} zookeeper
       docker exec zk${i} bin/setup.sh --myid=${i}
   done
   ```

1. Consolidate server list
   ``` bash
   SERVER=3
   echo -n "" > /tmp/zoo.cfg.dynamic
   for i in $(seq $SERVERS); do
       docker exec zk${i} cat /opt/zookeeper/conf/zoo.cfg.dynamic >> /tmp/zoo.cfg.dynamic
   done
   ```

1. Transfer full server list to containers
   ``` bash
   SERVER=3
   for i in $(seq $SERVERS); do
       docker cp /tmp/zoo.cfg.dynamic zk${i}:/opt/zookeeper/conf/zoo.cfg.input.dynamic
       docker exec zk${i} cp /opt/zookeeper/conf/zoo.cfg.input.dynamic /opt/zookeeper/conf/zoo.cfg.dynamic
   done
   ```

1. Start the server processes
   ``` bash
   SERVER=3
   for i in $(seq $SERVERS); do
       docker exec zk${i} bin/zkServer.sh start
   done
   ```
