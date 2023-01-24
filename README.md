## Bases de Docker

Hola mundo en Docker
```bash
$ docker pull hello-world
```

Correr contenedor
```bash
$ docker run hello-world
```

Remover contenedor por id
```bash
$ docker container rm <container_id>
```

Remover cotenedor
```bash
$ docker container rm <container_id>
# Si el contenedor está corriendo, puedes usar la bandera -f para forzar la eliminación
$ docker container rm -r <container_id>
```

Remover todos los contenedores detenidos
```bash
$ docker container prune
```

Remover todas las imagenes sin usar
```bash
$ docker image prune
```

Detached mode
```bash
$ docker container run -d docker/getting-started
# Luego detenemos el contenedor
$ docker container stop <container_id>
```

Detached mode y publish mode (publicar un puerto)
```bash
$ docker container run -dp 80:80 docker/getting-started
```

Correr un contenedor de postgres
  - nombre del contenedor: some-postgres
  - detached y publish mode: 5432:5432
  - variables de entorno: POSTGRES_PASSWORD=mysecretpassword
  - imagen: postgres
```bash
$ docker run --name some-postgres -dp 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```

Correr múltiples contenedores de postgres
```bash
# contenedor 1
$ docker container run \
         --name postgres-alpha \
         -e POSTGRES_PASSWORD=secret \
         -dp 5432:5432 \
         postgres
```

```bash
# contenedor 2
$ docker container run \
         --name postgres-beta \
         -e POSTGRES_PASSWORD=secret \
         -dp 5433:5432 \
         postgres
```

```bash
# contenedor 3
$ docker container run \
         --name postgres-gamma \
         -e POSTGRES_PASSWORD=secret \
         -dp 5434:5432 \
         postgres
```

## Volumes y Redes
Crear volumen
```bash
$ docker volume create world-volume
```

Inspeccionar volumen
```bash
$ docker volume inspect world-volume
```

Correr contenedor de mariadb usando un volumen
```bash
$ docker container run \
        --name world-db \
        -dp 3306:3306 \
        -e MARIADB_USER=example-user \
        -e MARIADB_PASSWORD=user-password \
        -e MARIADB_ROOT_PASSWORD=root-secret-password \
        -e MARIADB_DATABASE=world-db \
        --volume world-volume:/var/lib/mysql \
        mariadb:jammy
```

Correr contenedor phpmyadmin
```bash
$ docker run --name phpmyadmin \
            -e PMA_ARBITRARY=1 \
            -dp 8080:80 \
            phpmyadmin:5.2.0-apache
```

Listar redes
```bash
$ docker network ls
```

Crear red
```bash
$ docker network create world-app
```

Conectar contenedor de mariadb/phpmyadmin con la nueva red
```bash
$ docker network connect world-app world-db
$ docker network connect world-app phpmyadmin
```

Inspeccionar red
```bash
$ docker network inspect world-app
```

<a href="https://imgur.com/3ejz6v2"><img src="https://i.imgur.com/3ejz6v2.png" title="source: imgur.com" /></a>

Asigar la red desde la inicialización de los contenedores
```bash
$ docker container run \
        --name world-db \
        -dp 3306:3306 \
        -e MARIADB_USER=example-user \
        -e MARIADB_PASSWORD=user-password \
        -e MARIADB_ROOT_PASSWORD=root-secret-password \
        -e MARIADB_DATABASE=world-db \
        --volume world-volume:/var/lib/mysql \
        --network world-app \
        mariadb:jammy
```

```bash
$ docker run --name phpmyadmin \
            -e PMA_ARBITRARY=1 \
            -dp 8080:80 \
            --network world-app \
            phpmyadmin:5.2.0-apache
```

Bind volumes
```bash
# Desde la ruta de la app
$ docker run --name nest-app \
           -w /app \
           -p 80:3000 \
           -v "$(pwd)":/app \
           node:18.13.0-alpine3.17 \
           sh -c "yarn install && yarn start:dev"
```

Terminal interactiva
```bash
$ docker exec -it nest-app /bin/sh
```

```bash
# Montar un contenedor postgreSQL y pgadmin4
# Crear un volumen para la base de datos y crear una red
# Agregar ambos contenedores a la red
# Conectarse a la base de datos mediante pgadmin4

$ docker volume create postgres-db

$ docker run -d \
           --name postgres-db \
           -e POSTGRES_PASSWORD=123456 \
           -v postgres-db:/var/lib/postgresql/data \
           postgres:alpine3.17

$ docker run --name pgadmin \
           -e PGADMIN_DEFAULT_PASSWORD=123456 \
           -e PGADMIN_DEFAULT_EMAIL=superman@google.com \
           -dp 8080:80 \
           dpage/pgadmin4:6.19

$ docker network create postgres-net

$ docker network connect postgres-net postgres-db
$ docker network connect postgres-net pgadmin
```

## Buildx
```bash
$ docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t <username>/<image>:latest --push .
```