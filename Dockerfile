FROM centos:centos7

# SETUP ROOT PASSWORD
RUN echo 'root:password' | chpasswd

# install SSHD
RUN yum install -y java-1.8.0-openjdk.x86_64 wget && yum clean all
ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk
ENV JRE_HOME /usr/lib/jvm/jre
RUN echo "export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk" >> /etc/profile
RUN echo "export JRE_HOME=/usr/lib/jvm/jre" >> /etc/profile
RUN wget http://www-us.apache.org/dist/kafka/0.9.0.1/kafka_2.11-0.9.0.1.tgz
RUN tar -xvf kafka_2.11-0.9.0.1.tgz && mv kafka_2.11-0.9.0.1 /opt
RUN sed -i 's/Xmx1G/Xmx256M/g' /opt/kafka_2.11-0.9.0.1/bin/kafka-server-start.sh
RUN sed -i 's/Xms1G/Xms128M/g' /opt/kafka_2.11-0.9.0.1/bin/kafka-server-start.sh

EXPOSE 2181 9092

CMD /opt/kafka_2.11-0.9.0.1/bin/zookeeper-server-start.sh -daemon /opt/kafka_2.11-0.9.0.1/config/zookeeper.properties && \
/opt/kafka_2.11-0.9.0.1/bin/kafka-server-start.sh /opt/kafka_2.11-0.9.0.1/config/server.properties
