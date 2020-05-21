# topaz-containers

## Initial Setup

create a .env file to define some passwords and paths

```
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
if this is an initial deployment.  Either remove the following from `docker-compose.override.yml`

```dockerfile
  dbupdate:
    entrypoint: ["echo", "service dbupdate is disabled"]
``` 