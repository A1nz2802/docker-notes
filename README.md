### Getting Started
Start and enable docker service
```sh
systemctl start docker.service
```
List containers
```sh
docker ps
```
Download images
```sh
docker pull <image>:<version>
```
Run docker image with specific version
```sh
docker run <image>:<version>
```
Run commands in the container
```sh
docker run <image> ls -l
```

### First Practice
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

### Create a Dockerfile

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



