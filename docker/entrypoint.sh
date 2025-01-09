#!/bin/bash
# encoding: utf-8

C_ICAP_USER=c-icap
C_ICAP_DIR=/usr/local/c-icap

mkdir -p $C_ICAP_DIR/share/c_icap/templates
mkdir -p $C_ICAP_DIR/var/log
mkdir -p $C_ICAP_DIR/var/run/c-icap
useradd $C_ICAP_USER -U -b $C_ICAP_DIR
chown -R ${C_ICAP_USER}:${C_ICAP_USER} $C_ICAP_DIR
echo "#===added config===" >> $C_ICAP_DIR/etc/c-icap.conf
echo "User $C_ICAP_USER" >> $C_ICAP_DIR/etc/c-icap.conf
echo "Group $C_ICAP_USER" >> $C_ICAP_DIR/etc/c-icap.conf
echo "PidFile $C_ICAP_DIR/var/run/c-icap/c-icap.pid" >> $C_ICAP_DIR/etc/c-icap.conf
echo "CommandsSocket $C_ICAP_DIR/var/run/c-icap/c-icap.ctl" >> $C_ICAP_DIR/etc/c-icap.conf
#echo "Service xss srv_xss.so" >> $C_ICAP_DIR/etc/c-icap.conf
cat $C_ICAP_DIR/etc/c-icap.conf | grep added\ config -A1000 #fflush()
echo "#===added config==="
$C_ICAP_DIR/bin/c-icap -D -d 10 -f $C_ICAP_DIR/etc/c-icap.conf


SQUID_USER=squid
SQUID_DIR=/usr/local/squid
VAR_LOG=/var/log

openssl req -new -newkey rsa:2048 -nodes -days 3650 -x509 -keyout $SQUID_DIR/myCA.pem -out $SQUID_DIR/myCA.crt \
 -subj "/C=JP/ST=Ikebukuro/L=Tokyo/O=Dollers/OU=Dollers Co.,Ltd./CN=squid.local"
openssl x509 -in $SQUID_DIR/myCA.crt -outform DER -out $SQUID_DIR/myCA.der
mkdir -p $SQUID_DIR/var/lib
$SQUID_DIR/libexec/security_file_certgen -c -s $SQUID_DIR/var/lib/ssl_db -M 4MB
mkdir -p $SQUID_DIR/var/cache
useradd $SQUID_USER -U -b $SQUID_DIR
mkdir -p $SQUID_DIR/var/logs
touch $SQUID_DIR/var/logs/cache.log
chown -R squid:squid $SQUID_DIR/var/logs
chmod -R 700 $SQUID_DIR/var/logs
chown 700 $SQUID_DIR/myCA.pem
chown -R ${SQUID_USER}:${SQUID_USER} $SQUID_DIR

mkdir -p $VAR_LOG/squid
touch $VAR_LOG/squid/access.log
chown -R squid:squid $VAR_LOG/squid
chmod -R 700 $VAR_LOG/squid

$SQUID_DIR/sbin/squid -N -d 10 -f /etc/squid.conf

bash