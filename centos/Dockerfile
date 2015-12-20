# [Apache ZooKeeper](https://zookeeper.apache.org/)

FROM centos:latest

MAINTAINER King-On Yeung <koyeung@gmail.com>

ENV TARGET_VERSION 3.5.1-alpha
ENV INSTALLDIR /opt/zookeeper
ENV JAVA_HOME /usr/lib/jvm/jre

RUN yum install -y deltarpm yum-utils && \
    yum update -y && \
    yum install -y java-1.8.0-openjdk-headless wget && \
    yum clean all

RUN wget -q -O - http://apache.communilink.net/zookeeper/zookeeper-${TARGET_VERSION}/zookeeper-${TARGET_VERSION}.tar.gz \
  | tar -C /opt -xz
RUN ln -s /opt/zookeeper-${TARGET_VERSION} ${INSTALLDIR}

# for troubleshooting
RUN yum install -y net-tools telnet less

WORKDIR ${INSTALLDIR}

# preinst
RUN getent group hadoop 2>/dev/null >/dev/null || /usr/sbin/groupadd -r hadoop && \
    /usr/sbin/useradd --comment "ZooKeeper" --shell /bin/bash -M -r --groups hadoop --home ${INSTALLDIR}/share/zookeeper zookeeper

# inst
RUN mkdir -p share/zookeeper /tmp/zookeeper && \
    chown -R zookeeper:hadoop . /tmp/zookeeper && \
    cp -r src/packages/templates share/zookeeper && \
    cp -f conf/zoo_sample.cfg share/zookeeper/templates/conf/zoo.cfg && \
    ./src/packages/update-zookeeper-env.sh \
      --prefix=${INSTALLDIR} \
      --conf-dir=${INSTALLDIR}/conf \
      --log-dir=/var/log/zookeeper \
      --pid-dir=/var/run/zookeeper \
      --var-dir=/var/lib/zookeeper && \
    echo "standaloneEnabled=false" >> conf/zoo.cfg && \
    echo "dynamicConfigFile=/opt/zookeeper/conf/zoo.cfg.dynamic" >> conf/zoo.cfg && \
    touch conf/zoo.cfg.dynamic && \
    chown -R zookeeper:hadoop conf/zoo.cfg conf/zoo.cfg.dynamic

EXPOSE 2181 2888 3888 8080

VOLUME ["${INSTALLDIR}/conf"]

USER zookeeper