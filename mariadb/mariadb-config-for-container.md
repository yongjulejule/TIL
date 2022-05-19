# mariadb-config-for-container

mariadb config 파일과 docker container로 운용하기 위한 설정

- `skip-network` : skip-network가 설정되어 있으면 소켓으로만 통신하고, 꺼져있으면 ip를 이용해서 통신함
- `bind-address` : 통신을 허용할 ip를 지정해줌. (유저 권한이랑 별개임!)