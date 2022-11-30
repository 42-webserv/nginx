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
mkdir -p data/{logs,conf,www}
touch data/logs/error.log
touch data/conf/nginx.conf
touch data/www/index.html

status_log "** add default page"
cat << EOF > ./data/www/index.html
<!doctype html>
<html>
  <head>
    <title>Hello nginx</title>
    <meta charset="utf-8" />
  </head>
  <body>
    <h1>
      Hello World!
    </h1>
  </body>
</html>
EOF


status_log "** insert config"
cat << EOF > ./data/conf/nginx.conf
#user       www www;  ## Default: nobody
worker_processes  5;  ## Default: 1
error_log  $PWD/data/logs/error.log;
pid        $PWD/data/logs/error.pid;
worker_rlimit_nofile 8192;

events {
  worker_connections  4096;  ## Default: 1024
}

http {
  #include    conf/mime.types;
  #include    /etc/nginx/proxy.conf;
  #include    /etc/nginx/fastcgi.conf;
  root      $PWD/data/www;
  index    index.html index.htm index.php;

  default_type application/octet-stream;
  log_format   main '\$remote_addr - \$remote_user [\$time_local]  \$status '
    '"\$request" \$body_bytes_sent "\$http_referer" '
    '"\$http_user_agent" "\$http_x_forwarded_for"';
  access_log   $PWD/data/logs/access.log  main;
  sendfile     on;
  tcp_nopush   on;
  server_names_hash_bucket_size 128; # this seems to be required for some vhosts

  server {
    listen       80;
    server_name  domain1.com www.domain1.com;
    # access_log   $PWD/data/logs/access.log main;
    # root		/www;

    location / {
      index  index.html index.htm index.php;
    }

    #location ~ \.php$ {
    #  fastcgi_pass   127.0.0.1:1025;
    #}
  }
}
EOF




status_log "** mv configure in root"
cp ./auto/configure .



status_log "** configure... "
./configure --without-http_rewrite_module
rm configure



status_log "** make... "
make -j 8


status_log "** excutable nginx mv in root"
cp ./objs/nginx .
