FROM centos:latest

ENV SPARK_VERSION=2.4.0
ENV HADOOP_VERSION=2.7

RUN yum update -y && \
  yum install -y openssh-clients openssh-server java-1.8.0-openjdk && yum clean all && \
  curl -o /tmp/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
  tar xzf /tmp/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
  rm /tmp/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
  mv /spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /spark && \
  echo "Installed spark: spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" >> /installed_spark_version.txt && \
  ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
  ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
  ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N '' && \
  echo -e "UserKnownHostsFile /dev/null\nStrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

COPY entrypoint.sh /
COPY daemonize /usr/local/sbin
RUN chmod a+x /entrypoint.sh && chmod a+x /usr/local/sbin/daemonize

WORKDIR /spark
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "daemonize" ]