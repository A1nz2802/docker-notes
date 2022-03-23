# Table of Contents
- [Getting Started](#getting-started)
- [Understanding the state of docker](#understanding-docker)
- [Interactive mode](#interactive-mode)
- [Lifecycle of docker container](#lifecycle-docker)
- [Expose containers](#expose-containers)
- [Bind mounts](#bind-mounts)
- [Volumes](#volumes)
- [Insert and extract files from a container](#insert-extract)
- [Docker for development](#docker-development)
- [Docker Networking](#docker-networking)
- [Practices](#practices)
  - [Practice 01](#practice-01)
  - [Practice 02](#practice-02)
  - [Practice 03](#practice-03)

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
### Volumes
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
docker network ls
docker network create --attachable testnetwork
docker network inspect testnetwork

docker run -d --name db mongo
docker network connect testnetwork db
docker network inspect testnetwork

docker run -d --name app -p 3000:3000 --env MONGO_URL=mongodb://db:27017/test testapp
docker ps

docker network connect testnetwork app
docker network inspect testnetwork 
```






## Practices

### Practice 01
```sh
docker run -d nginx:1.21.6
docker ps
docker exec -it <CONTAINER_ID> bash
apt-get update
apt-get install procps
ps fax
apt-get install curl
curl localhost
exit
docker stop <CONTAINER_ID>
```

mount file into docker container
```sh
docker run -v <~/Path/to/a/urFile>:</Path/into/docker>:ro -d nginx:1.21.6
docker ps
docker exec -it <CONTAINER_ID> bash
```
expose docker port
```sh
docker run -v <~/Path/to/a/urFile>:</Path/into/docker>:ro -p 8080:80 -d nginx:1.21.6
curl localhost:8080
```
modify your file and try this
```sh
curl localhost:8080
```

### Practice 02
```sh
docker run -it <image> /bin/bash
apt-get update
apt-get install figlet
figlet "Hello Docker"
exit
```
```sh
docker ps -a | head
docker commit <CONTAINER_ID>
docker image ls | head
docker image tag <IMAGE_ID> <NAME_TAG>:<VERSION_TAG>
docker image ls | head
docker run <NAME_TAG> figlet hello
```

### Practice 03

```sh
nvim Dockerfile
cd /path/to/a/Dockerfile
docker build -t mydocker:1.1 .
docker image ls | head
docker run mydocker:1.1 figlet hello
docker image history <IMAGE_ID>
```

add this line in your Dockerfile
```sh
RUN touch /tmp/hello
```
build docker image from previous image
```sh
docker build -t mydocker:1.2 .
docker run mydocker:1.2 ls /tmp/
```