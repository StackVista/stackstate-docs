---
title: Configuring a reverse proxy
kind: Documentation
---

StackState makes heavy use of Websockets, so when setting up a reverse proxy to make StackState available on, for example,
port 80 or 443 (with TLS) you will also need to proxy Websocket requests. An example setup for Nginx for this looks like this
(proxying port 80 to StackState running on localhost port 7070):

```
http {
    server {
        listen 80;
        server_name _;
        server_tokens off;

        location /health {
            return 200;
        }

        if ($http_x_forwarded_proto != "https") {
            return 301 https://$host$request_uri;
        }

        location / {
            proxy_pass http://localhost:7070;
            proxy_set_header Host                    $host;
            proxy_set_header X-Real-IP               $remote_addr;
            proxy_set_header X-Scheme                $scheme;
            proxy_set_header X-Forwarded-Proto       https;
            proxy_set_header X-Content-Type-Options  nosniff;
            proxy_set_header X-Frame-Options         SAMEORIGIN;
            proxy_set_header X-XSS-Protection        "1; mode=block";
        }

        location /api/stream {
            proxy_pass http://localhost:7070/api/stream;
            proxy_set_header Host                    $host;
            proxy_set_header X-Real-IP               $remote_addr;
            proxy_set_header X-Scheme                $scheme;
            proxy_set_header X-Forwarded-Proto       https;
            proxy_http_version                       1.1;
            proxy_set_header Upgrade                 $http_upgrade;
            proxy_set_header Connection              "Upgrade";
            proxy_set_header X-Content-Type-Options  nosniff;
            proxy_set_header X-Frame-Options         SAMEORIGIN;
            proxy_set_header X-XSS-Protection        "1; mode=block";
        }

        location /api/telemetry {
            proxy_pass http://localhost:7070/api/telemetry;
            proxy_set_header Host                    $host;
            proxy_set_header X-Real-IP               $remote_addr;
            proxy_set_header X-Scheme                $scheme;
            proxy_set_header X-Forwarded-Proto       https;
            proxy_http_version                       1.1;
            proxy_set_header Upgrade                 $http_upgrade;
            proxy_set_header Connection              "Upgrade";
            proxy_set_header X-Content-Type-Options  nosniff;
            proxy_set_header X-Frame-Options         SAMEORIGIN;
            proxy_set_header X-XSS-Protection        "1; mode=block";
        }
    }
}
```
