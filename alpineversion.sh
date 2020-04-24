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
<h1>like, whatever.</h1>
EOF

cat > Dockerfile <<'EOF'
FROM alpine:latest
RUN mkdir -p /run/nginx/
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./index.html /nginx/html/index.html
RUN apk update
RUN apk add nginx 
ENTRYPOINT ["nginx", "-g", "daemon off;"]
EXPOSE 80

EOF

docker image build -t nginxpractice:v1 .
rm nginx.conf
rm Dockerfile
rm index.html
docker run -d -p 8080:80 nginxpractice:v1
