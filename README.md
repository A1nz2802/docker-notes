# Table of Contents
- [Getting Started](#getting-started)
- [Understanding the state of docker](#understanding-the-state-of-docker)
- [Interactive mode](#interactive-mode)
- [Lifecycle of docker container](#lifecycle-of-docker-container)
- [Expose containers](#expose-containers)
- [Bind mounts](#bind-mounts)
- [Volumes](#volumes)
- [Insert and extract files from a container](#insert-and-extract-files-from-a-container)
- [Docker Images](#docker-images)
  - [Build an own image](#build-an-own-image)
- [Docker for development](#docker-for-development)
- [Docker Networking](#docker-networking)
- [Docker Compose](#docker-compose)
  - [Subcommands](#subcommands)
  - [Docker Compose in Development](#compose-development)
  - [Compose Override](#compose-override)
- [Clen my Docker environment](#clean-my-docker-environment)

## Getting Started
```bash
# Start and enable docker service
systemctl start docker.service
# List containers
docker ps
# Download images
docker pull <image>:<version>
# Run commands in the container
docker run <image> ls -l
```

## Understanding the state of docker
```bash
# List all containers
docker ps -a
# Inspect docker container
docker inspect <NAME>
# Change default name container
docker run --name <NEW_NAME> <IMAGE>
# Rename docker container
docker rename <OLD_NAME> <NEW_NAME>
# Remove specific container with name
docker rm <NAME>
# Remove all containers
docker container prune
```
![1](https://static.platzi.com/media/user_upload/3-1a4b2bfc-71e0-4b3e-88bb-a46ad64cce93.jpg)

## Interactive mode
```bash
# Download newer image for ubuntu latest
docker run ubuntu
# Run a container interactively, you can access a command prompt inside the running container.
docker run -it ubuntu
# Check ubuntu version
cat /etc/lsb-release
# execute this on another terminal
docker ps 
```
## Lifecycle of docker container
```bash
docker run --name alwaysup -d ubuntu tail -f /dev/null
# Run a command in a running container
docker exec -it alwaysup bash
# In the container, try this
ps
ps -aux
exit
docker ps
# Obtain the main process id
docker inspect --format '{{.State.Pid}}' alwaysup
# kill main process
sudo kill -9 <PROCESS_ID>
docker ps
```
## Expose containers
```bash
# You can see nginx logs but bash is blocked
docker run --name proxy -p 8080:80 nginx
or
# Run container in background (with -d or --detach)
docker run --name proxy -d -p 8080:80 nginx
# See logs in detach mode
docker logs proxy
# See logs in real time
docker logs -f proxy
docker logs --tail 10 -f proxy
```
## Bind mounts
```bash
mkdir mongodata
docker run -d --name db -v ~/hacking/Docker/docker-test/mongodata:/data/db mongo
docker ps
docker exec -it db bash
mongo --version
mongo
use test-db
db.users.insert({"nombre":"brawer"})
db.users.find()
exit
docker rm -f db
ll mondota/
# try again
docker run -d --name db -v ~/hacking/Docker/docker-test/mongodata:/data/db mongo
docker exec -it db bash
use test-db
db.users.find()
exit exit
```
## Volumes
```bash
docker volume ls
docker volume create dbdata
docker run -d --name db --mount src=dbdata,dst=/data/db mongo
docker inspect db
docker exec -it db bash
mongo
use db-test
db.users.insert({"nombre":"Brawer"})
db.users.find()
exit exit

```
```bash
docker ps
docker rm -f db
docker run -d --name db --mount src=dbdata,dst=/data/db mongo
docker exec -it db bash
mongo
use db-test
db.users.find()
exit exit
```
## Insert and extract files from a container
```bash
# Copy a file from the local file system to a container
touch test.txt
docker run -d --name copytest ubuntu tail -f /dev/null
docker exec -it copytest bash
mkdir testing
exit
```
```bash
docker cp
docker cp test.txt copytest:/testing/test.txt
docker exec -it copytest bash
ls /testing
exit
```
```bash
# Copy a file from container to the local file system
docker cp copytest:/testing localtesting
cd /localtesting
ls
# is not required run a container in the background to use docker cp
```
![2](https://i1.wp.com/cdn-images-1.medium.com/max/800/1*bo6IOrBjaHbtkPgTKT08NA.png?w=1170&ssl=1)
## Docker images
```bash
docker image ls
docker pull ubuntu:20.04
docker image ls
```
![3](https://static.packt-cdn.com/products/9781788992329/graphics/0ee3d4cf-2133-4143-a7c4-690274483841.png)
### Build an own image
```bash
mkdir images
cd /images
touch Dockerfile
```
add this in your Dockerfile
```Dockerfile
FROM ubuntu:latest

RUN touch /usr/src/hello.txt
```
```bash
# Build an image ubuntu:version-t using the current directory as the build context
docker build -t ubuntu:version-test .
docker image ls
```
![4](https://static.platzi.com/media/user_upload/Screenshot%20from%202020-11-06%2019-53-30-a305c998-0991-44ad-9319-80cacb1a4bc7.jpg)
```bash
docker run -it ubuntu:version-test
ll /usr/src
exit
```
```bash
# Share your images to the Docker hub
docker login
docker image ls
docker tag ubuntu:version-test a1nz2802/ubuntu:version-test
docker image ls
docker push a1nz2802/ubuntu:version-test
```
![5](https://i.ibb.co/JBL946b/Screenshot-at-Feb-05-15-26-18.png)

```bash
docker history ubuntu:version-test
# https://github.com/wagoodman/dive
dive ubuntu:version-test
```
add this line in your Dockerfile
```Dockerfile
RUN rm /usr/src/hello.txt
```
```bash
docker build -t ubuntu:version-test .
dive ubuntu:version-test
```
## Docker for development
```bash
# Build image
docker build -t testapp .
# List images
docker image ls
# Run image and link port 3000 in the current file system to port 3000 of container
docker run --rm -p 3000:3000 testapp

docker run --rm -p 3000:3000 -v $(pwd)/index.js:/usr/src/index.js testapp
```

## Docker Networking
```bash
# List all networks
docker network ls
# Create a new network
docker network create --attachable testnetwork
# Inspect network
docker network inspect testnetwork
# Run container and rename mongo image to db
docker run -d --name db mongo
# Connect db container to testnetwork
docker network connect testnetwork db
# Check the connection
docker network inspect testnetwork
# Run container, rename container to app, linked current file system port to port container and set up enviroment variables
docker run -d --name app -p 3000:3000 --env MONGO_URL=mongodb://db:27017/test testapp
docker ps
# Connect app container to testnetwork
docker network connect testnetwork app
# Verify that both containers (app and db) are connected to the same network (testnetwork)
docker network inspect testnetwork 
```
## Docker Compose
```bash
# Download docker-compose in ArchLinux
sudo pacman -S docker-compose

# Remove app and db containers
docker ps -a
docker rm -f app
docker rm -f db

# Up services with logs
docker-compose up

# Up services in detach mode
docker-compose up -d
```
### Subcommands
Need a services names, in this case is app and db
```bash
# See logs app
docker-compose logs app
# logs in real time
docker-compose logs -f app
docker-compose logs -f app db
# Execute bash in the container 
docker-compose exec app bash
ls
exit
docker-compose ps
# Stop and remove containers, and remove network
docker-compose down
```
![6](https://i.imgur.com/TaizyYP.png)

### Docker Compose in Development
docker-compose.yml
```yml
version: "3.8"

services:
  app:
    # image: testapp
    build: .
    environment:
      MONGO_URL: "mongodb://db:27017/test"
    depends_on:
      - db
    ports:
      - "3000:3000"
    volumes:
      - .:/usr/src
      - /usr/src/node_modules
    command: npx nodemon index.js

  db:
    image: mongo
```
```bash
docker-compose build
docker-compose up -d
```
make changes in index.js
```bash
docker-compose build app
docker-compose up -d
```
### Compose Override
docker-compose.override.yml
```yml
version: "3.8"

services:
  app:
    build: .
    environment:
      VARIABLE: "Hello Override!"
```
```bash
docker-compose up -d 
docker-compose exec app bash
env
exit
docker-compose ps
```
## Clean my Docker environment
```bash
# Remove all stopped containers
docker container prune
docker ps

# Show id container
docker ps -q
docker rm -f $(docker ps -aq)
# in fish shell
docker rm -f (docker ps -aq)

docker network ls
docker network prune

docker volume ls
docker network prune

# Remove all containers, networks, images, etc
docker system prune -a

# Remove all volumes
docker volume rm -f (docker volume ls -q)

# Remove all images
docker image rm -f (docker image ls -q)

docker run -d --name <new_name> --memory 1g <image>

docker stats
```