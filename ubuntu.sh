#!/bin/bash
arg_checker() {
    for o in $OPTIONS; do
        case $o in
            help)
                help
                ;;
            install)
                install_docker
                ;;
            remove)
                remove_docker
                ;;
        esac
    done
}

#install docker
install_docker(){
    require_root
    apt-get update
    echo "removing old version of docker"
    apt-get remove docker docker-engine docker.io containerd runc

    apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

    echo "install docker gpg key, fingerprint should be 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    apt-key fingerprint 0EBFCD88

    #add docker repo
    ARCHITECTURE=$(dpkg --print-architecture)
    echo "system architecture is ${ARCHITECTURE}"
    add-apt-repository "deb [arch=${ARCHITECTURE}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update

    #install docker
    apt-get install docker-ce docker-ce-cli containerd.io


    #install docker compose
    curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    #install ug4 docker image
        
    #install jupiter docker image

    # echo "do you wish to run docker as non-root user (affects your systems security)? (y/n)"
    # read nonroot
    # if [ "${nonroot}" = "y" ]; then
    #     groupadd docker
    #     usermod -aG docker $USER
    #     newgrp docker
    # else
    #     echo "non-root usage disabled."
    # fi
}

#remove docker
remove_docker(){
    require_root
    #remove docker
    apt-get purge docker-ce
    #remove all images, containers, etc.
    rm -rf /var/lib/docker
}

#help
help() {
    printf "Usage: ./script option\n"
    printf "Options:\n"
    printf "\r help: display this help page\n"
    printf "\r install: install docker\n"
    printf "\r remove: Remove docker and all of its components\n"
}

require_root(){
    if [ $EUID -ne 0 ]; then
        printf "you need root permissions to perform the desired operation.\nhave you tried using sudo or su?\n"
        exit 1
    fi
}

OPTIONS=($*)
arg_checker