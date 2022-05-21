# mariadb-config-for-container

mariadb config 파일과 docker container로 운용하기 위한 설정

- `skip-network` : skip-network가 설정되어 있으면 소켓으로만 통신하고, 꺼져있으면 ip를 이용해서 통신함
- `bind-address` : 통신을 허용할 ip를 지정해줌. (유저 권한이랑 별개임!)

`/usr/bin/mysqld_safe` : mariadb daemon을 시작하는 명령어. Debian이나 RPM같이 systemd를 지원하는 리눅스에서는 설치되지 않음. (mariadb 공식 문서 추천)

`docker run` 과 `docker-compose`로 실행했을때 다른 이유 찾아보기