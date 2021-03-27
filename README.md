# postgres

set enviroment variable
```
export POSTGRES_HOME=/srv/postgres
```
and add previous line to .bashrc file

# start docker
```
docker run --name postgres --restart=always -e POSTGRES_PASSWORD=1 --detach -p 5432:5432 --volume $POSTGRES_HOME/data:/var/lib/postgresql/data --volume $POSTGRES_HOME/backup:/backup ledangtuanbk/postgres:9.6
```

# Create database 
```
CREATE DATABASE "DB_NAME" WITH OWNER "postgres" ENCODING 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8' TEMPLATE template0;
docker exec -it postgres  createdb -T template0 -E UNICODE -O postgres -U postgres test
```

# Backup database
```
docker exec -t $CONTAINER_NAME pg_dump -U postgres --no-owner -Fc $DB_NAME -f /backup/${DB_NAME}_dump_$(date +%Y%m%d"_"%H%M%S).dmp
```

# restore database
```
docker exec -t $CONTAINER_NAME pg_restore --if-exists  --clean -U postgres -d $DB_NAME -1 /backup/backup_file.dmp
```

# create extentions 
```
create extension unaccent;
```

# Create textsearch api
```
create or replace function textsearch(x text) returns text as
  $$
      begin
        return lower(unaccent(x));
      end;
  $$ language plpgsql;
```
# create textsearchlike
```
create function textsearchlike(x text) returns text
    language plpgsql
as
$$
begin return textsearch(concat('%',x,'%')); end;
$$;

alter function textsearchlike(text) owner to postgres;
```
# Docker compose docker-compose.yml
```
version: '3.3'
services:
    postgres:
        container_name: postgres
        restart: always
        environment:
            - POSTGRES_PASSWORD=1
        ports:
            - '5432:5432'
        volumes:
            - '$POSTGRES_HOME/data:/var/lib/postgresql/data'
            - '$POSTGRES_HOME/backup:/backup'
        image: 'ledangtuanbk/postgres:9.6'
```        
