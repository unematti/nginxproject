#!/bin/bash

cat > nginx.conf <<'EOF'
worker_processes  2;
user              root;

events {
    use           epoll;
    worker_connections  128;
}

error_log         off;

http {
       server {
        server_name   localhost;
        listen        0.0.0.0:80;

        location      / {
            root      /nginx/html;
            index     index.html;
        }
    }
}
EOF

cat > index.html <<'EOF'
<h1>arch version.</h1>
EOF

cat > Dockerfile <<'EOF'
FROM archlinux:latest
RUN mkdir -p /run/nginx/
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./index.html /nginx/html/index.html
RUN pacman -Syy --noconfirm nginx 
ENTRYPOINT ["nginx", "-g", "daemon off;"]
EXPOSE 80

EOF

docker swarm init
docker image build -t nginxpractise:v1 .
rm nginx.conf
rm Dockerfile
rm index.html
#docker run -d -p 8080:80 archnginx:v1
docker stack deploy web -c docker-compose.yml
