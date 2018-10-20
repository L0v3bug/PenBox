# PenBox

PenBox is a docker container, designed to help you to realize penetration testing.

# Summary

1. [Dependencies](#dependencies)
1. [Commands](#commands)
1. [Available tools](#available-tools)
1. [How to ?](#how-to)
1. [Licence](#licence)

# Dependencies

- [Docker](https://www.docker.com/)
- Makefile

# Commands

- `attach` Get the CLI of PenBox
- `help`   Display commands
- `launch` Build and create your PenBox container from scratch
- `remove` Remove the PenBox container and his image
- `reset`  Reset your PenBox container

# Available tools

- searchsploit
- sqlmap
- wpscan
- gobuster
- hydra
- john the ripper
- owasp zap
- metaspoit
- dnsenum
- the harvester
- tmux
- sudo
- sshfs
- vim
- openssh-client
- openssh-server
- curl
- nslookup
- dig
- nmap
- git
- netcat
- whois
- build-essential
- pip
- wget
- firefox
- xterm
- java-jre

# How to

## How PenBox work ?

PenBox is a simple Debian image on docker, with a server X redirection on a socket-unix. Actually it is only working on Linux.

## How to install and create your first PenBox container ?

For install and create a PenBox you should have `docker` and `make` install in your machine, your OS must be a Linux. You just must clone the git repository, and then type `make launch`, followed by `make attach`.

## How to create multiple containers ?

You cannot run multiple containers with the same name. So if you want for a reason used multiple PenBox container you must copy the repository on different sub directories and modify the `Makefile` by modifying the variables:
- CONTAINER_DB: the container name
- IMAGE_DB: the image name
- HOSTNAME: the hostname

## You need features which are not provide by PenBox ?

You want some features which are not provide straightly by PenBox, you can modify the Dockerfile and add them.

## How to add dictionaries in the PenBox image

If you need to add some useful files like dictionaries for fuzzing or brute force you can add in the docker file `ADD opt/* /opt/.` and create a repository `opt` and put every file you need.

# Licence

BSD Licence