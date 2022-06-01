# nginx-fcgi

## CGI 

[한글 설명](https://server-talk.tistory.com/308) [rfc cgi 문서](https://datatracker.ietf.org/doc/html/rfc3875)

Common Gateway Interface의 약자로 과거 서버가 html의 정적 페이지만 서비스하다 한계를 느껴서 나오게 된 규약. 어떤 언어로든 작성될 수 있으며 서버에서 요청이 오면 앱이 필요한 데이터를 처리하여 응답으로 보내줌.

그냥 웹 서버와 외부 앱을 연결해주는 표준화된 방식임.

하지만 CGI는 한 요청당 하나의 프로세스를 생성하여 요청을 처리하기 때문에 퍼포먼스에 상당한 손해가 있었고, 이를 보안하기 위해 나온게 fcgi(fast cgi)임.

## FCGI

fcgi는 cgi가 연결마다 프로세스를 생성 / 삭제하는 문제를 개선하여 프로세스를 생성해두고 계속 사용하는 방식으로 작동하고, 이때 연결을 위해 socket나 FTP를 사용함. cgi에 비해 훨신 빠른 속도를 자랑함.

[fcgi란?](https://grip.news/archives/1287)

## php-fpm

php-fpm은 php를 fcgi모드로 동작하게 해주며, 다양한 최적화가 되어있음

[상세정보](https://opentutorials.org/module/384/4332)

## nginx fcgi

nginx에는 php-fpm을 위한 다양한 config 옵션을 지원함

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
