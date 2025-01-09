# EvilProxy
Pentesting squid proxy

Personal project that consists of installing a squid proxy with security flaws to use it as a pentesting tool.


# Docker manual run
Create
docker build -t squid-ssl .

Abrir consola
docker run -it --name squid-container squid-ssl /bin/bash

Verificar
docker ps -a
docker logs squid-container

# Docker manual reinstall

docker stop squid-container
docker rm squid-container
docker rmi squid-ssl

docker build -t squid-ssl .
docker run -it --name squid-container squid-ssl /bin/bash