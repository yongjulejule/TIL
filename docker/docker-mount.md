# docker-mount

저장소를 분할해서 컨테이너에 마운트 하는것. 컨테이너는 생성과 삭제가 빈번하기 때문에 매번 데이터를 옮기기 힘드니 마운트해서 사용함.

마운트 방식은 [볼륨 마운트](https://docs.docker.com/storage/volumes/)/[바인드 마인트](https://docs.docker.com/storage/bind-mounts/)가 있음 ([tmpfs mount](https://docs.docker.com/storage/tmpfs/), named pipes 방식도 존재하지만 패스...)

공식문서 : [docker-storage](https://docs.docker.com/storage/)

![docker-mount](/image/docker-type-of-mount.png)

## volume-mount

도커 엔진이 관리하는 영역 내에 만들어진 볼륨을 컨테이너에 디스크 형태로 마운트 하는것. 도커가 생성 및 관리를 하며 `docker volume create` 명령어로 생성.

>*주의!*
>
>*맥같은 경우 docker desktop을 사용하는데, vm으로 실행되기 때문에 volume mount시 /var/lib/docker/<volume-name> 디렉토리가 없음! 컨테이너를 생성하여 -v로 마운트하여 사용해야함...*

### 컨테이너에 마운트

`docker run ... -v [볼륨명]:[컨테이너 마운트 path]`

### 장점:

- 도커 엔진에 의해서 관리되므로 사용자가 파일 위치를 신경 쓸 필요가 없음
- host machine과 독립된 상태임.
- os마다 커맨드가 달라지는 등 의존성 문제가 없음
- 도커 제작사에서 추천함. (익숙해지면 편해서)

### 단점:

- 직접 조작하기 어려우며 항상 컨테이너를 경유해서 볼륨에 접근해야함.
- 백업 절차가 복잡함.

### 예시

1. `docker volume create [볼륨 이름]` 으로 저장소 생성
2. `docker run ... -v [볼륨 이름]:[컨테이너 마운트 path]` 으로 컨테이너에 마운트

- 마운트된 볼륨의 위치는 `docker volume inspect [볼륨 이름]` 명령어로 확인할 수 있음. (`/var/lib/docker/volumes/볼륨 이름/`)
- `docker container inspect [컨테이너 이름]`으로 컨테이너 정보를 볼 수 있는데, 이때 마운트 정보도 확인 가능.
- `docker volume ls`로 생성한 볼륨 리스트 확인 가능
- `docker volume prune`로 사용하지 않는 볼륨 정리 가능

## bind-mount

host-machine 디렉토리, 즉 도커 엔진에서 관리하지 않는 기존 디렉토리를 컨테이너에 마운트 하는것.

### 컨테이너에 마운트

`docker run ... -v [host machine의 디렉토리 path]:[컨테이너 마운트 path]` 

### 장점:

- 기존과 동일한 방식으로 파일을 사용할 수 있어 손쉽게 편집 가능
- 자주 편집이 일어나는 경우 사용하기 편함
- 백업 역시 편함

### 단점:

- host machine의 파일시스템에 의존함
- bind-mount를 관리하는 docker cli command가 없음
- host filesystem에 직접적으로 접근하고, 수정하기 때문에 몹시 주의해야함.

### 예시:

`docker run --rm -it -v /home/yongjule/cpp-module:/cpp-module --name=ccc gcc`

gcc로 컨테이너 생성 및 cpp-module 프로젝트 폴더 마운트

![docker-bind-mount](/image/docker-bind-mount-example.png)

![docker-bind-mount-file-cp](/image/docker-bind-mount-file-cp.png)

생성한 파일이 host machine에도 멀쩡하게 존재함


# volume in docker-compose

```yaml
.
.
.
    volumes:
      - mariadb-volume:/var/lib/mysql
.
.
.

volumes:
  mariadb-volume:
    name: mariadb-volume
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/yongjule/data
```

위와 같이 volume에 다양한 옵션을 줄 수 있음. 호스트 머신의 디렉토리를 docker volume에 마운트 하고, 컨테이너에선 docker volume를 사용하는 구조가 됨!

`driver`는 마운트를 위한 외부 라이브러리를 사용할 수 있으며 `local`을 사용하면 호스트의 파일시스템을 따라가며 default가 local임.(리눅스, 맥만 지원... 윈도우는 안된다고 함)
`driver_opts`는 linux의 `mount(8)`을 따르며 보통 위와 같이 사용한다고 함... 