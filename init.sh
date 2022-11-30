#!/bin/sh

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

status_log() {
	echo
	echo "${RED} [log] ${NC} ${YELLOW}$@${NC}"
}

# check 339 line in nginx.c - for multi-process

status_log "** mkdir /Users/$USER/goinfre/$USER/nginx/[log|conf] + touch .log, .conf"
mkdir -p /Users/$USER/goinfre/$USER/nginx/logs
mkdir -p /Users/$USER/goinfre/$USER/nginx/conf
mkdir -p /Users/$USER/goinfre/$USER/nginx/www
touch /Users/$USER/goinfre/$USER/nginx/logs/error.log
touch /Users/$USER/goinfre/$USER/nginx/conf/nginx.conf


status_log "** insert config"
cat << EOF > /Users/$USER/goinfre/$USER/nginx/conf/nginx.conf
#user       www www;  ## Default: nobody
worker_processes  5;  ## Default: 1
error_log  /usr/local/nginx/logs/error.log;
pid        /usr/local/nginx/logs/error.pid;
worker_rlimit_nofile 8192;

events {
  worker_connections  4096;  ## Default: 1024
}

http {
  #include    conf/mime.types;
  #include    /etc/nginx/proxy.conf;
  #include    /etc/nginx/fastcgi.conf;
  index    index.html index.htm index.php;

  default_type application/octet-stream;
  log_format   main '$remote_addr - $remote_user [$time_local]  $status '
    '"$request" $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log   logs/access.log  main;
  sendfile     on;
  tcp_nopush   on;
  server_names_hash_bucket_size 128; # this seems to be required for some vhosts

  server { # php/fastcgi
    listen       80;
    server_name  domain1.com www.domain1.com;
    access_log   /usr/local/nginx/logs/error.log main;
    root		/www;

    #location ~ \.php$ {
    #  fastcgi_pass   127.0.0.1:1025;
    #}
  }
}
EOF




status_log "** mv configure in root"
cd auto && cp configure ../ && cd ..



status_log "** configure... "
./configure --without-http_rewrite_module



status_log "** make... "
make -j 8


status_log "** excutable nginx mv in root"
cp ./objs/nginx .
