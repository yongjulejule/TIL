# docker-compose

`Dockerfile`처럼 호스트 머신의 스크립트를 이용하여 run이나 volume, network등을 설정할 수 있게 해줌. `docker-compose.yml` 파일을 사용하며 한 디렉토리당 하나만 존재할 수 있음.

- 예시

```yaml
version: "3"

services:
  wordpress-db:
    image: mariadb:latest
    network:
      - wordpress-network
    volumes:
      - wordpress-db-volume:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
  wordpress:
    depends-on:
      - wordpress-db
    image: wordpress:latest
    network:
      - wordpress-network
    volumes:
      - wordpress-volume:/var/www/html
    ports:
      - "8042:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: wordpress-db
      WORDPRESS_DB_NAME: ${MYSQL_DATABASE}
      WORDPRESS_DB_USER: ${WORDPRESS_DB_USER}
      WORDPRESS_DB_PASSWORD: ${WORDPRESS_DB_PASSWORD}
networks:
  wordpress-network:
volumes:
  wordpress-volume:
  wordpress-db-volume:
```

입력 후 `docker-compose up -d`를 실행하면 각 컨테이너와 네트워크, 볼륨이 생성됨. (-d = detached)

`docker-compose`는 자동으로 현재 디렉토리의 `.env`를 사용해주므로 환경변수를 안전하게 관리 가능.
알아서 `network`나 `volume`를 먼저 만들어주고, `depends-on`옵션이 의존성 있는 컨테이너의 순서를 보장해줌
`Makefile`처럼 내용이 바뀌면 바뀐 사항에 대해서만 재구성함

`docker-compose down`을 하면 알아서 컨테이너들을 종료시키고 삭제해주며 네트워크 역시 삭제해줌! (볼륨은 남아있음. -v옵션을 주면 삭제함)