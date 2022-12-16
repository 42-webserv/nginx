#!/bin/sh

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

status_log() {
	echo
	echo "${RED} [log] ${NC} ${YELLOW}$@${NC}"
}


status_log "*config.sh called"

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
	#include    /etc/nginx/proxy.conf;
	include    $PWD/conf/mime.types;
	include    $PWD/conf/fastcgi.conf;
	#   root      $PWD/data/www;
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
		root      $PWD/data/www;

		location /upload {
			# root		$PWD/data/www/upload;
			index                 	errors.html;
			# index                 	index.html index.htm index.php;
		error_page 404 /error.html;
			client_body_temp_path		$PWD/data/www/upload;
			client_body_in_file_only  	on;
			client_body_buffer_size		128k;
			client_max_body_size		100M;
		# dav_methods  PUT;
		}

    location / {
		index  index.html index.htm index.php;
		# autoindex on;
    }

    #location ~ \.php$ {
    #  fastcgi_pass   127.0.0.1:1025;
    #}

	}
}
EOF
