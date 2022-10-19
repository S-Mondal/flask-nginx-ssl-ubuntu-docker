upstream site {
    server 127.0.0.1:5000;
}
server
{
listen 80;
server_name www.example@it.com example@it.com;
return  302 https://$server_name$request_uri;
}

server {
        listen 443 ssl default_server;
	add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload";
        server_name www.example@it.com example@it.com;
        client_max_body_size 10M;

location /{
proxy_set_header   Host                 $host;
proxy_set_header   X-Real-IP            $remote_addr;
proxy_set_header   X-Forwarded-For      $proxy_add_x_forwarded_for;
proxy_set_header   X-Forwarded-Proto    $scheme;
proxy_pass http://127.0.0.1:5000;
proxy_connect_timeout   300;
proxy_send_timeout      300;
proxy_read_timeout      300;
        if ($http_origin ~* (https?://[^/]*\.domain\.com(:[0-9]+)?)$) {
            set $cors "true";
        }
    if ($cors = 'true') {
    add_header X-Cache $upstream_cache_status;
    add_header Referrer-Policy "strict-origin";
    add_header Content-Security-Policy "default-src 'self'; font-src *;img-src * data:; script-src *; style-src *";
    add_header Expect-CT 'max-age=60, report-uri="https://rekyc.jmfonline.in"';
    }
}
ssl on;
ssl_certificate /ssl/server.crt;
ssl_certificate_key /ssl/server.key;
ssl_protocols TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM';

    location /socket.io {
        include proxy_params;
        proxy_http_version 1.1;
        proxy_buffering off;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_pass http://site/socket.io;
    }
}

