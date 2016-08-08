FROM ubuntu:14.04
MAINTAINER Prakash N D <nprakash@anutanetworks.com>

# Set locales
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8

# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common

# Install JDK 7
RUN \
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
add-apt-repository -y ppa:webupd8team/java && \
apt-get update && \
apt-get install -y oracle-java7-installer wget unzip tar && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/cache/oracle-jdk7-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle 
ENV JAVA_OPTS -XX:MaxPermSize=512m -Xms2048m -Xmx4096m



#Installing pyang from python

RUN     apt-get update && \
        apt-get install -y python-pip && \
        pip install pyang && \
        rm -rf /var/lib/apt/lists/* && \
        echo "Pyang version is" pyag -version

ENV PATH=$PATH:/usr/local/bin/pyang


#Installing maven

ENV MAVEN_VERSION 3.0.5

RUN apt-get update && apt-get install -y curl && apt-get clean

RUN mkdir -p /usr/share/maven \
  && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven 
ENV MAVEN_OPTS -XX:MaxPermSize=512m -Xms2048m -Xmx4096m

VOLUME /root/.m2

RUN mkdir -p /usr/src/app 
WORKDIR /usr/src/app

ADD . /usr/src/app
CMD ["mvn clean install"]

# Get Tomcat

ENV TOMCAT_VERSION 7.0.70

RUN wget --quiet --no-cookies http://apache.rediris.es/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz && \
tar xzvf /tmp/tomcat.tgz -C /opt && \
mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
rm /tmp/tomcat.tgz && \
rm -rf /opt/tomcat/webapps/examples && \
rm -rf /opt/tomcat/webapps/docs && \
rm -rf /opt/tomcat/webapps/ROOT

# Add admin/admin user
COPY tomcat-users.xml /opt/tomcat/conf/
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 8009
VOLUME "/opt/tomcat/webapps"
#WORKDIR /opt/tomcat

#COPY web-1.0-SNAPSHOT.war /opt/tomcat/webapps
# Launch Tomcat
RUN java -version
RUN pyang -version
CMD ["/opt/tomcat/bin/catalina.sh", "run"]


