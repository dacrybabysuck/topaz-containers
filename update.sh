#!/bin/bash

echo "Snagging public ip"
ipadd=$(wget checkip.dyndns.org -O - | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
echo "Current public ip address: ${ipadd}"
echo "update zone_settings SET zoneip = '${ipadd}';" > update_zone_settings.sql

echo -n "Updating zone_ip in the database..."
mysql -hdb "${MYSQL_DATABASE}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" < update_zone_settings.sql
