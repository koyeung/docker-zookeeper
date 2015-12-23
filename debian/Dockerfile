# [Apache ZooKeeper](https://zookeeper.apache.org/)

FROM debian:latest

MAINTAINER King-On Yeung <koyeung@gmail.com>

ENV TARGET_VERSION 3.5.1-alpha
ENV INSTALLDIR /opt/zookeeper
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/jre

RUN apt-get update && \
    apt-get install -y apt-utils openjdk-7-jre-headless wget

RUN wget -q -O - http://apache.communilink.net/zookeeper/zookeeper-${TARGET_VERSION}/zookeeper-${TARGET_VERSION}.tar.gz \
  | tar -C /opt -xz
RUN ln -s /opt/zookeeper-${TARGET_VERSION} ${INSTALLDIR}

# for troubleshooting
RUN apt-get install -y net-tools telnet less

WORKDIR ${INSTALLDIR}

# preinst
RUN getent group hadoop 2>/dev/null >/dev/null || /usr/sbin/groupadd -r hadoop && \
    /usr/sbin/useradd --comment "ZooKeeper" --shell /bin/bash -M -r --groups hadoop --home ${INSTALLDIR}/share/zookeeper zookeeper

# inst
RUN mkdir -p share/zookeeper /tmp/zookeeper && \
    cp -r src/packages/templates share/zookeeper && \
    cp -f conf/zoo_sample.cfg share/zookeeper/templates/conf/zoo.cfg && \
    ./src/packages/update-zookeeper-env.sh \
      --prefix=${INSTALLDIR} \
      --conf-dir=${INSTALLDIR}/conf \
      --log-dir=/var/log/zookeeper \
      --pid-dir=/var/run/zookeeper \
      --var-dir=/var/lib/zookeeper && \
    chown -R zookeeper:hadoop . /tmp/zookeeper

EXPOSE 2181 2888 3888 8080
VOLUME ["${INSTALLDIR}/conf", /tmp/zookeeper]

COPY ["setup.sh", "bin"]
RUN chown zookeeper:hadoop bin/setup.sh

USER zookeeper
