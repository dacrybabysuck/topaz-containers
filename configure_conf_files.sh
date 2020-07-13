#!/bin/bash
source .env

pushd topaz/conf/default

echo ${MYSQL_USER}

sed -i s/\{MYSQL_USERNAME\}/${MYSQL_USER}/g map.conf
sed -i s/\{MYSQL_PASSWORD\}/${MYSQL_PASSWORD}/g map.conf
sed -i s/\{MYSQL_DB_NAME\}/${MYSQL_DATABASE}/g map.conf

sed -i s/\{MYSQL_USERNAME\}/${MYSQL_USER}/g login.conf
sed -i s/\{MYSQL_PASSWORD\}/${MYSQL_PASSWORD}/g login.conf
sed -i s/\{MYSQL_DB_NAME\}/${MYSQL_DATABASE}/g login.conf

sed -i s/\{MYSQL_USERNAME\}/${MYSQL_USER}/g search_server.conf
sed -i s/\{MYSQL_PASSWORD\}/${MYSQL_PASSWORD}/g search_server.conf
sed -i s/\{MYSQL_DB_NAME\}/${MYSQL_DATABASE}/g search_server.conf
