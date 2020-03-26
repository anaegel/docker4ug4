# Getting Started with Docker and UG4
Docker is a tool to containerize applications. This means that applications run in a docker container live in their own subsystem (container) and have no impact on your host os (Windows e.g.). This allows you to experiment within your docker container as you wish without ever having to fear to break your computer. 

### Install Docker on Ubuntu
run `$ sudo ./ubuntu.sh install`

### Install Docker on Mac
[Download](https://hub.docker.com/editions/community/docker-ce-desktop-mac) the newest Version of Docker Hub and follow the install instructions given there.

### Install Docker on Windows Home
Get the [boot2docker image](https://github.com/boot2docker/boot2docker/releases) as well as VMWare or VirtualBox. Create a new Wirtual Machine and boot from the boot2docker image.

### Install Docker on Windows Pro / Enterprise
[Download](https://hub.docker.com/editions/community/docker-ce-desktop-windows) the newest Version of Docker Hub and follow the install instructions given there.

## Docker basics
docker provides a cli with a lot of functionality but if you only want to run ug4, you just need the following two
+ `$ docker pull <image>` downloads the given image from [Docker Hub](https://hub.docker.com/search)
+ `$ docker run <image>` starts a container from the given image, usefull options:
    + `--rm` deletes the container once you stop it
    + `-it` starts an interactive shell within the container and enters it
    + `--cpus` runs the container on a given amount of cpus
    + `-d` detaches the container
    + `-m` set a memory limit for the container
    + `-v` mount a volume to the container
    + `-w` set the workspace for the container   

## Run ug4 in Docker
Start Docker on your machine, build the Dockerfile with e.g. `$ docker build -t ugshell` and run the image with e.g. `$ docker run --rm -it --cpu 2 -w $HOME/ug_scripts ugshell`. You then can access the ugshell as normal.
