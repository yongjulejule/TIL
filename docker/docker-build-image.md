# docker-build-image

컨테이너를 이용하여 도커 이미지 만들기

`commit` 커맨드를 활용하여 기존 컨테이너를 이미지로 변환할 수 있고, `Dockerfile` 스크립트를 활용하여 이미지를 만들 수도 있음.

## commit 커맨드

`docker commit [컨테이너 이름] [새로운 이미지 이름]`

![docker commit](/image/docker-image-commit.png)
![docker commit ls](/image/docker-image-commit-list.png)

만든 이미지는 `push`하여 `docker-hub`에서 관리할 수 있고, `docker run`을 통하여 컨테이너로 실행할 수 있음.

## Dockerfile 스크립트

`Dockerfile` 스크립트는 이미지를 만들기 위한 스크립트로, 이미지나 실행할 명령어 등을 정의해놓은 파일이며 `commit`와 다르게 컨테이너를 만들 필요 없음.

간단한 script

```DOCKERFILE
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
```

`docker build -t [이미지 이름] [실행할 디렉토리(host machine)]` 커멘드로 Dockerfile 스크립트를 실행하면 이미지가 생성됨.
`docker build -f /path/to/Dockerfile .`로 `Dockerfile`의 경로를 줄 수 있음.

- `FROM` : 기반이 되는 이미지 지정
- `COPY` : 이미지에 파일이나 디렉토리 추가
- `RUN` : 이미지를 빌드할때 실행할 명령어 추가
- `CMD` : 컨테이너를 실행할때 실행할 명령어 지정
- `ENV` : 환경변수 정의

[Dockerfile instructions](https://docs.docker.com/engine/reference/builder/)

[Dockerfile best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)

[Dockerfile에서 자주 쓰이는 명령어 (한글 블로그)](https://www.daleseo.com/dockerfile/)

### Dockerfile vs docker-compose

`Dockerfile`은 이미지를 만드는거고 `docker-compose`는 컨테이너와 주변 환경(볼륨이나 네트워크)을 만드는거임. 