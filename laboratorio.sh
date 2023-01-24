# Nest app
docker run --name nest-app \
           -w /app \
           -p 80:3000 \
           -v "$(pwd)":/app \
           node:18.13.0-alpine3.17 \
           sh -c "yarn install && yarn start:dev"

docker volume create postgres-db

docker run -d \
           --name postgres-db \
           -e POSTGRES_PASSWORD=123456 \
           -v postgres-db:/var/lib/postgresql/data \
           postgres:alpine3.17

docker run --name pgadmin \
           -e PGADMIN_DEFAULT_PASSWORD=123456 \
           -e PGADMIN_DEFAULT_EMAIL=superman@google.com \
           -dp 8080:80 \
           dpage/pgadmin4:6.19

docker network create postgres-net

docker network connect postgres-net postgres-db
docker network connect postgres-net pgadmin

