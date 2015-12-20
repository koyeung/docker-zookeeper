# docker-zookeeper
Run [ZooKeeper](https://zookeeper.apache.org) 3.5.x in Distributed mode


## Usage
1. Start containers
   ``` bash
   docker run -d -t --name zk1 zookeeper
   docker run -d -t --name zk2 --volumes-from zk1 zookeeper
   docker run -d -t --name zk3 --volumes-from zk1 zookeeper

   docker exec zk1 bin/zkServer-initialize.sh --myid=1
   docker exec zk2 bin/zkServer-initialize.sh --myid=2
   docker exec zk3 bin/zkServer-initialize.sh --myid=3
   ```

1. Create initial dynamic configuration

   ``` bash
   containers="zk1 zk2 zk3"
   ports=2888:3888
   i=1
   for h in $containers; do
     ip=$( docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${h} )
     echo "server.${i}=${ip}:${ports}"
     i=$(( i+1 ))
   done > zoo.cfg.dynamic
   ```

1. Transfer dynamic configuration to container:
   ``` bash
   docker cp zoo.cfg.dynamic zk1:/opt/zookeeper/conf/zoo.cfg.input.dynamic
   docker exec zk1 cp /opt/zookeeper/conf/zoo.cfg.input.dynamic /opt/zookeeper/conf/zoo.cfg.dynamic
   ```

1. Start the servers
   ``` bash
   docker exec zk1 bin/zkServer.sh start
   docker exec zk2 bin/zkServer.sh start
   docker exec zk3 bin/zkServer.sh start
   ```
