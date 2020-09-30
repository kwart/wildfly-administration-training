#!/bin/bash

# Manually: setup newer Maven version into /opt/maven

git clone --depth 1 -b wildfly-training https://github.com/kwart/quickstart.git wildfly-quickstarts
pushd wildfly-quickstarts
mvn clean install
popd

mkdir wildfly-labs-resources
pushd wildfly-labs-resources
wget https://download.jboss.org/wildfly/20.0.1.Final/wildfly-20.0.1.Final.zip
wget https://jdbc.postgresql.org/download/postgresql-42.1.4.jar
wget https://github.com/kwart/ldap-server/releases/download/2017-09-04/ldap-server.jar
popd

docker pull postgres:10.1-alpine
docker pull kwart/wildfly
docker pull letsencrypt/pebble
docker pull letsencrypt/pebble-challtestsrv
