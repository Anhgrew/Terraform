#!/bin/bash -x


# Sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
    sleep 1
done

# Install nginx
apt-get update
apt-get -y install nginx

# Make sure nginx is started
systemctl start nginx

systemctl enable nginx

# Remove old template
rm -rf /home/ubuntu/data/template/

# Download free css template
wget https://www.free-css.com/assets/files/free-css-templates/download/page280/petology.zip -O /home/ubuntu/data/template.zip

# Install unzip command
apt install unzip -y 

# Unzip web application
unzip -d /home/ubuntu/data/ /home/ubuntu/data/template.zip && rm /home/ubuntu/data/template.zip && mv /home/ubuntu/data/* /home/ubuntu/data/template

# Update root path
# sed -i s+/usr/share/nginx/html+/home/ubuntu/data/template+g /etc/nginx/nginx.conf

cat /dev/null > /etc/nginx/nginx.conf

rm /etc/nginx/sites-enabled/default

cat <<EOF>> /etc/nginx/nginx.conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
        worker_connections 768;
        # multi_accept on;
}

http {

        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # SSL Settings
        ##

        # ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
        # ssl_prefer_server_ciphers on;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        ##
        # Gzip Settings
        ##

        gzip on;

        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
        server {

            listen 80 default_server;

            server_name anhgrewxyz.xyz;

            root /home/ubuntu/data/template;

            index index.html;

        }
}


#mail {
#       # See sample authentication script at:
#       # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#       # auth_http localhost/auth.php;
#       # pop3_capabilities "TOP" "USER";
#       # imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#       server {
#               listen     localhost:110;
#               protocol   pop3;
#               proxy      on;
#       }
#
#       server {
#               listen     localhost:143;
#               protocol   imap;
#               proxy      on;
#       }
#}



EOF


# User privilege provided
chmod o+x /home/ubuntu

# Restart nginx
systemctl restart nginx