# Usar imagen base Debian Bullseye
FROM debian:bullseye

# Configurar entorno no interactivo
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar repositorios e instalar dependencias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    squid-openssl ssl-cert openssl && \
    rm -rf /var/lib/apt/lists/*

# Configurar zona horaria
RUN ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Crear certificados SSL
RUN mkdir -p /usr/local/squid3/etc/ && \
    openssl genrsa -out /usr/local/squid3/etc/site_priv+pub.key 4096 && \
    openssl req -new -x509 -days 365 -key /usr/local/squid3/etc/site_priv+pub.key -out /usr/local/squid3/etc/site_priv+pub.pem -subj "/C=ES/ST=Province/L=City/O=Organization/OU=Department/CN=squid-proxy" && \
    chown proxy:proxy /usr/local/squid3/etc/site_priv+pub.* && \
    chmod 600 /usr/local/squid3/etc/site_priv+pub.*

# Crear carpeta para certificados dinámicos
RUN rm -rf /var/spool/squid_ssldb && \
    mkdir -p /var/spool/squid_ssldb && \
    chmod -R 700 /var/spool/squid_ssldb && \
    chown -R proxy:proxy /var/spool/squid_ssldb

# Copiar configuración personalizada
COPY squid.conf /etc/squid/squid.conf

# Exponer el puerto 3128
EXPOSE 3128

# Comando para iniciar Squid y generar SSL DB en tiempo de ejecución
RUN /usr/lib/squid/security_file_certgen -c -s /var/spool/squid_ssldb -M 4MB