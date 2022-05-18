# connect-host-to-db-container

mariaDB를 컨테이너로 올리고 로컬에서 컨테이너의 db에 연결하는 방법을 알아보자.

`docker-compose`나 `docker run`에서 지정한 `<host port>:<container port>` 부분에서, localhost의 <host port>가 <container ip>:<container port>로 연결되는 구조이기 때문에, `mariadb -u<username> -p<password> -h<localhost ip> -P<host port>`로 연결할 수 있다. 

물론, 이때 컨테이너의 db에서 `bind-address`를 잘 설정해줘야 하고, 해당 유저에게 접근 권한을 주어야함.
