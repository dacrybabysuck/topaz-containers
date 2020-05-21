# topaz-containers

## Initial Setup

create a .env file to define some passwords and paths

```properties
MYSQL_PASSWORD=password
MYSQL_ROOT_PASSWORD=password
MYSQL_DATABASE=tpzdb
MYSQL_USER=topaz
SERVERNAME=topaz

#local filesystem persistence
TOPAZ_DB=/opt/container_data/topaz/db
TOPAZ_CONF=/opt/container_data/topaz/conf
TOPAZ_LOG=/opt/container_data/topaz/log
TOPAZ_SCRIPTS=/opt/container_data/topaz/scripts
SQL_BACKUP=/opt/conatiner_data/topaz/sql_backup

#repo and branch can override the these defaults
GIT_REPO=https://github.com/project-topaz/topaz.git
GIT_BRANCH=release
```

### Initial Deployment
if this is an initial deployment, remove the following from `docker-compose.override.yml`

```dockerfile
  dbupdate:
    entrypoint: ["echo", "service dbupdate is disabled"]
``` 

### Configuring the conf files

The compose file has 4 running containers: `game`, `connect`, `search` and `db`.  The most important thing to configure is inside of each conf file to change the default databse server from 127.0.0.1 to reference the container name of `db`. Here are some things to look out for:

#### map.conf, login.conf, search_server.conf
```conf
#--------------------------------
#SQL parameters
#--------------------------------

mysql_host:      db
mysql_port:      3306
mysql_login:     topaz
mysql_password:  password
mysql_database:  tpzdb
```

#### map.conf, login.conf
```
#Central message server settings (ensure these are the same on both all map servers and the central (lobby) server
msg_server_port: 54003
msg_server_ip: connect
```
