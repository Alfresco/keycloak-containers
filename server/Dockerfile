FROM quay.io/alfresco/alfresco-base-java:11.0.7-openjdk-centos-7-9448dd21de19

ARG KEYCLOAK_VERSION=11.0.0-alfresco-001

ENV JDBC_POSTGRES_VERSION 42.2.5
ENV JDBC_MYSQL_VERSION 8.0.19
ENV JDBC_MARIADB_VERSION 2.5.4
ENV JDBC_MSSQL_VERSION 7.4.1.jre11

ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING true
ENV JBOSS_HOME /opt/jboss/keycloak
ENV LANG en_US.UTF-8

USER root

RUN yum update -y && yum install -y openssl which && yum clean all

COPY temp/keycloak /opt/jboss/keycloak
ADD tools /opt/jboss/tools
RUN /opt/jboss/tools/build-keycloak.sh

USER 1000

EXPOSE 8080
EXPOSE 8443

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]

CMD ["-b", "0.0.0.0"]
