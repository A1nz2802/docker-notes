# Construir la imagen con el tag tigre
docker build \
-t a1nz28/cron-ticker:tigre . 

# Correr un contenedor usando la imagen
docker run -d a1nz28/cron-ticker:tigre

docker exec -it <container_id/name> /bin/sh

# Asignar la imagen latest
docker build \
-t a1nz28/cron-ticker . 

# o también
docker build \
-t a1nz28/cron-ticker:latest . 

# construir para diferentes arquitecturas con buildx
# https://docs.docker.com/build/building/multi-platform/#getting-started
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t <username>/<image>:latest --push .