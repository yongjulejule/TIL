# nginx-fcgi

## php-fpm

php-fpm은 php를 fcgi모드로 동작하게 해주며, 다양한 최적화가 되어있음

[상세정보](https://opentutorials.org/module/384/4332)

## nginx fcgi

nginx에는 fcgi을 위한 다양한 config 옵션을 지원함

```
    location ~ \.php$ {
       fastcgi_pass   wordpress:9000;
       fastcgi_index  index.php;
       fastcgi_param  SCRIPT_FILENAME  /var/www/html/wordpress$fastcgi_script_name;
       include        fastcgi_params;
    }
```

- `fastcgi_pass` : 해당 url로 들어온 요청에 대하여 php-fpm과 nginx을 연결하기 위한 인터페이스를 지정. 
- `fastcgi_index` : 요청된 URL이 / 로 끝날때 자동으로 덧붙임
- `fastcgi_param` : 요청이 fastCGI로 전달되도록 구성하는 지시어.

![nginx fcgi](/image/fcgi-with-nginx.jpeg)