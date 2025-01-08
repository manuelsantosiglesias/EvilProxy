# EvilProxy
Pentesting squid proxy

Personal project that consists of installing a squid proxy with security flaws to use it as a pentesting tool.


# Docker manual run
Create
docker build -t squid-ssl .

Run modo iterativo -it
docker run --name squid-container -d squid-ssl

Verificar
docker ps -a
docker logs squid-container

Comprobar proxy
docker exec -it squid-container squid -v
