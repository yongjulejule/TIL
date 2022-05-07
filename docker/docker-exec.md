# docker-exec

`docker exec [컨테이너] [명령어]` 를 통하여 특정 컨테이너에서 명령어를 실행할 수 있음.

만약 mariadb 컨테이너를 생성해서 db에 접속하고 싶다면 `docker exec  --it [mariadb container name] bash` 와 같이 입력하면, mariadb 컨테이너에서 bash가 실행되어 interactive하게 사용할수 있음.