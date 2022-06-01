# nginx-config

nginx config 파일은 여러 모듈들 단위로 작성됨. `/etc/nginx/nginx.conf`에 base module이 정의되어 있고 `/etc/nginx/conf.d/`추가적인 모듈들을 정의함.

user, worker_process, error_log, pid 등 다양한 설정을 할 수 있으며 아래와 같이 블록 단위로 설정함.

자세한 내용은 [링크](https://server-talk.tistory.com/303) 참고

```
user  www-data;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}

# /etc/nginx/conf.d/default.conf

	server {
			...
			location / {
					...
					proxy_pass http://backend:3000;
			}
	}
```
