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

## Nginx TLS

TLS에 대한 설명은 [링크](/protocol/SSL-TLS.md) 참조

```
server {
    listen       443 ssl http2;
    server_name  ${DOMAIN_NAME};

    access_log  /var/log/nginx/${DOMAIN_NAME}.access.log  main;

    location / {
        root   /var/www/html/wordpress;
        index  index.php index.html index.htm;
    }

    ssl_certificate           ${DOMAIN_NAME}.crt;
    ssl_certificate_key       ${DOMAIN_NAME}.key;
    ssl_session_timeout       5m;
    ssl_protocols             TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

	...
}

```

위와 같은 방식으로 nginx에 TLS 설정을 할 수 있음.

`ssl_certificate` : 인증서 파일의 위치
`ssl_certificate_key` : 인증서 파일의 키 파일의 위치
`ssl_session_timeout` : TLS 세션 유효시간
`ssl_protocols` : 사용할 프로토콜
`ssl_ciphers` : 사용할 암호화 방식 기본값은 `HIGH:!aNULL:!MD5` 이며 `openssl ciphers -v "HIGH:!aNULL:!MD5"` 명령어에 대응되는 암호화 방식이 모두 포함됨. [openssl 참고](/openssl/openssl.md), 
`ssl_prefer_server_ciphers` : TLS 암호화 방식 협상 과정에서 서버측 암호화 방식 우선. 

[nginx ssl config](http://nginx.org/en/docs/http/ngx_http_ssl_module.html)
[openssl ciphers](https://www.openssl.org/docs/manmaster/man1/openssl-ciphers.html)


## Nginx fastCGI

### php-fpm

php-fpm은 php를 fcgi모드로 동작하게 해주며, 다양한 최적화가 되어있음

[상세정보](https://opentutorials.org/module/384/4332)

### nginx fcgi

nginx에는 fcgi을 위한 다양한 config 옵션을 지원함

```
location ~ \.php$ {
   fastcgi_pass   wordpress:9000;
   fastcgi_index  index.php;
   fastcgi_param  SCRIPT_FILENAME  /var/www/html/wordpress$fastcgi_script_name;
   include        fastcgi_params;
}
```

`fastcgi_pass` : 해당 url로 들어온 요청에 대하여 php-fpm과 nginx을 연결하기 위한 인터페이스를 지정. 
`fastcgi_index` : 요청된 URL이 / 로 끝날때 자동으로 덧붙임
`fastcgi_param` : 요청이 fastCGI로 전달되도록 구성하는 지시어.

![nginx fcgi](/image/fcgi-with-nginx.jpeg)

## Nginx proxy

Nginx를 reverse proxy로 활용하기 위한 설정이며 특정 url의 포트로 보낼 뿐만 아니라 http 버젼, 헤더, 버퍼 등을 설정할 수 있음.

```
location /backend {
		proxy_pass http://backend:3000;
		proxy_http_version 1.1;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-Host $host;
		proxy_set_header X-Forwarded-Port $server_port;
}
```

`proxy_pass` : 요청이 들어오면 어떤 url로 전달되는지 지정
`proxy_http_version` : http 버전 지정
`proxy_set_header` : 요청에 대한 헤더 설정