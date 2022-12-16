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

rm ./test_write
mkdir -p data/{logs,conf,www}
# mkdir -p data/www/upload/cgi-bin
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

cat << EOF > ./data/www/upload/index.html
<html>
<body>
   <form enctype = "multipart/form-data"
                     action = "./cgi-bin/save_file.py" method = "post">
   <p>File: <input type = "file" name = "filename" /></p>
   <p><input type = "submit" value = "Upload" /></p>
   </form>
</body>
</html>
EOF

# cat << EOF > ./data/www/upload/cgi-bin/save_file.py
# #!/usr/bin/python

# import cgi, os
# import cgitb; cgitb.enable()

# form = cgi.FieldStorage()

# # Get filename here.
# fileitem = form['filename']

# # Test if the file was uploaded
# if fileitem.filename:
#    # strip leading path from file name to avoid
#    # directory traversal attacks
#    fn = os.path.basename(fileitem.filename)
#    open('/tmp/' + fn, 'wb').write(fileitem.file.read())

#    message = 'The file "' + fn + '" was uploaded successfully'

# else:
#    message = 'No file was uploaded'

# print ("""\
# Content-Type: text/html\r\n\r\n<html>
# <body>
#    <p>%s</p>
# <a href='/'>Go Back to Root</a>
# </body>
# </html>
# """ % (message,))
# EOF

status_log "** insert config"
sh ./config.sh





status_log "** mv configure in root"
cp ./auto/configure .



status_log "** configure... "
./configure --without-http_rewrite_module
rm configure



status_log "** make... "
make -j 8


status_log "** excutable nginx mv in root"
cp ./objs/nginx .
