# docker-run-command

커맨드를 새로운 컨테이너에서 실행

`docker run [options] IMAGE [COMMAND] [ARG...]`

`docker run --rm centos cat /etc/os-release`

centos:latest 환경에서 /etc/os-release 파일을 읽어온 뒤 이미지를 삭제

`docker run --rm -it ubuntu`

ubuntu:latest 환경에 tty를 할당하고 (-t 옵션), interactive 모드로 (-i 옵션) 실행

`--rm` 옵션을 주면 종료시 컨테이너를 삭제함. 옵션을 주지 않으면 `docker ps -a` 로 프로세스를 체크했을때, 종료된 채로 이미지가 남아있음. 남아있는 이미지들은 `docker rm $(docker ps -a | awk '{print $1}') ` 의 명령어로 제거 가능

## Mariadb 컨테이너 실행

`docker run --rm -dit --name [컨테이너 이름] --net=[사용할 네트워크] -e MYSQL_ROOT_PASSWORD=[루트 비번] -e MYSQL_DATABASE=[Mariadb 속에 만들 db 이름] -e MYSQL_USER=[mariadb 유저 이름] -e MYSQL_PASSWORD=[유저 비밀번호] mariadb --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --default-authentication-plugin=mysql_native_password`

`-d` 옵션은 daemon으로 실행, `--net`은 컨테이너 내부에서 사용할 네트워크, `-e` 옵션은 환경변수 설정으로 mariadb에 필요한 환경변수를 설정해줌.
`--character-set-server=utf8mb4` `--collation-server=utf8mb4_unicode_ci` `--default-authentication-plugin=mysql_native_password` 옵션은 mariadb에 필요한 옵션을 설정해줌. (텍스트 인코딩 및 로그인 정책)

## Wordpress 컨테이너 실행

`docker run --rm -dit --name [컨테이너 이름] --net=[사용할 네트워크] -p 8085:80 -e WORDPRESS_DB_HOST=[db 컨테이너 이름] -e WORDPRESS_DB_NAME=[db 컨테이너의 db이름] -e WORDPRESS_DB_USER=[db 유저 이름] -e WORDPRESS_DB_PASSWORD=[db 유저 비밀번호] wordpress`

`--net`옵션은 mariadb에서 준 network와 동일해야 하며 해당 네트워크로 연결됨. -p는 포트번호를 지정해줌. 그 뒤 환경변수는 mariadb에서 사용하던 아이들을 환경변수로 줘야함.

---

이 외에도 특정 디렉토리 마운트, 환경변수 설정 등 많은 옵션을 줄 수 있는데 [공식문서](https://docs.docker.com/engine/reference/commandline/run/)에 자세히 나와있음