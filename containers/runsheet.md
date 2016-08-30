# Docker basics
Start your first container  
```
docker run busybox echo Welcome to SoftwareCircus
```  
That's it, thanks for your attention. Please consult Container Solutions for more informations or insert another coin!

We used a small and simple image `busybox` and ran a single process `echo`

More useful container:  
```bash
docker run -it ubuntu /bin/bash
```
Install something inside the container e.g.: `apt-get update && apt-get install -y figlet`

Run:
```
figlet hello
```

Exit this container and execute again:

```bash
docker run -it ubuntu /bin/bash
figlet hello
```
Figlet is missing

Make that change persistent:
```bash
docker run -it ubuntu /bin/bash
apt-get update && apt-get install -y figlet
```
If you have started an interactive container (with option `-it`), you can detach from it.

The "detach" sequence is `^P^Q`.
Or you can detach by killing the Docker client.
Don’t hit `^C`, as this would deliver SIGINT to the container

```bash
docker commit <yourContainerId> <newImageId>
```
Find out your container ID with `docker ps`

Test it `docker run -ti figlet` and then execute `figlet hello`

List running containers
```bash
docker ps
```

To see only the last container that was started
```bash
docker ps -l
```

To see only the ID of containers
```bash
docker ps -q
```

This also works in combination
```bash
docker ps -ql
```

# Dockerfile overview
A Dockerfile is a build recipe for a Docker image.
* It contains a series of instructions telling Docker how an image is constructed.
* The docker build command builds an image from a Dockerfile.

## Writing a Dockerfile
1. Create a directory to hold our Dockerfile.  
`mkdir myimage`
2. Create a Dockerfile inside this directory.  
`cd myimage`  
`vim Dockerfile`

Copy this into your editor of choice:
```
FROM ubuntu
RUN apt-get update
RUN apt-get install -y figlet
```
Build the image
```bash
docker build -t figlet .
```
`-t` indicates that a tag will be applied and `.` is the default location to store the image

Test it `docker run -ti figlet` and then execute `figlet hello`