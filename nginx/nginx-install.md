# nginx-install

`nginx`는 패키지 매니저를 이용하여 다운로드 할 수 있지만, 리눅스 배포판마다 패키지가 있을수도 있고 구버전일 수 있기 때문에, 또 컴파일 플래그를 활용하여 config를 해야하기 때문에 소스코드를 기반으로 직접 컴파일 하는걸 권장함. (nginx 공식 docker image도 Dockerfile에서 직접 컴파일함!)

nginx를 컴파일 하기 위해선 gcc(컴파일러), PCRE(Perl Compatible Regular Expression), zlib(압축 모듈), OpenSSL(SSL 인증모듈)을 설치해야함.

