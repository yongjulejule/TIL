# docker-dockerfile

Dockerfile은 파일에 쓰여진 instruction에 따라 자동으로 이미지를 빌드해주며, docker image 커멘드들에 해당하는 모든 instruction을 줄 수 있음. `docker build` 커멘드를 이용하여 이미지를 빌드하며 `docker build [options] PATH|URL|-` 형태로 사용함. 이때 PATH는 Dockerfile을 실행할 경로가 되며 URL은 깃허브의 Dockerfile을 사용함. 이때 PATH의 subdirectory, 그리고 URL의 submodule까지 recursive하게 탐색하기 때문에, `.dockerignore`으로 잘 관리해주는게 좋음! 또한, 빈 디렉토리에서 Dockerfile을 작성하기 시작하는게 좋으며 해당 디렉토리엔 Dockerfile에 필요한 파일만 넣어두는게 좋음.

관례상 Dockerfile은 앱의 루트디렉토리에 넣는것이 좋으며, 필요하다면 `docker build -f PATH/TO/Dockerfile .`로 경로를 지정할 순 있음.
또한, `docker build -t NAME .`로 이미지의 태그를 지정해서 사용할 수 있음.

## Dockerfile 로드 과정

1. `docker daemon`으로 넘기기 전, syntax validation 
2. Dockerfile의 instruction을 하나씩 실행하는데, 이때 가능하다면 각 instruction의 결과를 새로운 이미지로 커밋하면서 진행.
3. 끝까지 진행되었으면, 최종적인 이미지와 id를 부여함
4. `docker daemon`이 필요 없는 내용들을 정리.

- 모든 instruction들은 독립적으로 실행되기 때문에, `RUN cd /blah/blah` 같은건 아무런 효과가 없음.
- 가능하다면 docker는 build-cache를 사용하기 때문에, 주의할 필요가 있음
- 생성한 이미지는 `docker scan [이미지 이름]` 을 통하여 취약점을 분석할 수 있음.
- `DOCKER_BUILDKIT=1`을 줘서 도커의 최신기술 백엔드인 Buildkit을 활용하여 빌드 가능 ㅎㅎ


## Dockerfile Environment replacement

- `ENV` instruction을 통하여 환경변수를 설정할 수 있고, 해당 Dockerfile내에서 사용할 수 있음 (shell script 같은 느낌)
- `${variable}`, `${variable:-word}`, `${variable:+word}` 의 옵션 지원
- `ADD, COPY, ENV, EXPOSE, FROM, LABEL, STOPSIGNAL, USER, VOLUME, WORKDIR, ONBUILD` instruction에서 작동함.


## FROM instruction

Dockerfile은 반드시 FROM instruction이 필요하며 이후 instruction에 대하여 base image를 지정해줌.

```DOCKERFILE
FROM [--platform=<platform>] <image> [AS <name>]
FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]
FROM [--platform=<platform>] <image>[@<digest>] [AS <name>]
```

예시:

```DOCKERFILE
ARG TAG=latest
FROM --platform=linux/arm64 nginx:${TAG} AS base
```

보통 `FROM [이미지:태그]`태그의 옵션을 사용하지만 몇몇 옵션이 더있음.

- `ARG` instruction은 유일하게 `FROM` 앞에 올 수 있는 instruction이며 이를 사용하여 환경변수를 설정할 수 있음.
- `FROM`은 Dockerfile에서 여러번 나올 수 있는데 이는 이미지를 여러개 빌드하는 경우이거나, 의존성이 있는 경우이며 각 `FROM` instruction은 이전 instruction들을 clear 하고 실행됨.
- `AS`로 주는 이미지의 이름은 이후 `FROM`이나 `COPY --from=<name>`에서 사용할 수 있음
- `platform`은 멀티플렛폼 이미지에서 사용하며 `linux/arm64`, `linux/amd64`, `window/amd64` 등을 줄 수 있음

## RUN instruction

`RUN`은 두가지 형태가 있음

```DOCKERFILE
RUN <command> # shell form. /bin/sh -c 로 실행됨
RUN ["executable", "arg1", "arg2", ...] # exec form exec 로 실행됨
```

현재 이미지의 top layer에서 명령어를 실행하고, 그 결과를 commit함. 이렇게 commit된 이미지는 Dockerfile의 다음 instruction을 위해 사용됨.
이런식으로 `RUN` instruction을 layering 하고 commit을 생성하는것은 도커의 핵심 컨셉과 일치함. (커밋의 비용이 적다는것, 이미지 히스토리의 어느 시점에서든 컨테이너를 생성할수 있다는 것 - source control이랑도 유사함!)

### shell form vs exec form

**shell form**:

- /bin/sh로 실행하기 때문에, 다른 쉘로 실행하려면 /bin/bash -c "command" 와 같이 사용해야 함.

**exec form**:

- `RUN ["/bin/bash", "-c", "echo hello"]` 형태로 사용하여 syntax가 좀 더 깔끔함.
- argument가 JSON array로 넘어가기 때문에, double-quote를 사용해야함.
- shell로 실행되지 않을 수 있기 때문에, shell 프로세싱이 일어나지 않음. (환경변수같은거 사용에 주의!)
- `backslash`를 escape 해줘야 함

### 주의

`RUN`의 cache는 다음 build에서 자동으로 invalidate되지 않음...! 따라서 주의가 필요하며 상황에 맞게 `docker build --no-cache`를 사용해야함. `ADD`나 `COPY` instruction에 의해 `RUN` cache는 invalidate됨

## ARG instruction



## CMD instruction

> [signal-and-docker 문서와 함께 보기](/docker/signal-and-docker.md)

`CMD`는 세가지 형태가 있음

```DOCKERFILE
CMD ["executable","param1","param2"] # exec form, this is the preferred form
CMD ["param1","param2"] # as default parameters to ENTRYPOINT
CMD command param1 param2 # shell form
```

`CMD`는 Dockerfile에서 한번만 사용되며, 만약 여러개 있으면 가장 마지막에 나온 게 적용됨.

- `ENTRYPOINT`와 같이 사용된다면, `ENTRYPOINT`, `CMD` 모두 JSON array 포멧으로 넘어감 
- exec form이나 shell form을 사용한다면, 이미지로부터 컨테이너가 실행될때 커멘드를 세팅해줌.
- `docker run`에서 커멘드를 주면, `Dockerfile`에서 세팅된 `CMD`는 무시됨

## ENTRYPOINT instruction

> [signal-and-docker 문서와 함께 보기](/docker/signal-and-docker.md)

`ENTRYPOINT`는 두가지 형태가 있음

```DOCKERFILE
ENTRYPOINT ["executable","param1","param2"] # exec form, this is the preferred form
ENTRYPOINT command param1 param2 # shell form
```

`ENTRYPOINT`는 컨테이너가 `executable`로 실행되도록 설정을 해주고 `CMD` instruction은 덮어씀. `docker run <image> -d` 같은 형태로 `ENTRYPOINT`에 인자를 넘길 수 있으며 `docker run --entrypoint`로 `ENTRYPOINT` instruction을 덮어쓸 수 있음.

`ENTRYPOINT`가 여러개 있으면 가장 마지막에 있는 것이 적용됨.

[docker docs 에 다양한 예시가 있음](https://docs.docker.com/engine/reference/builder/#entrypoint)

### CMD와 ENTRYPOINT의 상호작용

`CMD`와 `ENTRYPOINT`의 작용에 대한 몇가지 룰이 있음.

1. `Dockerfile`은 적어도 하나의 `ENTRYPOINT`나 `CMD`를 가지고 있어야 함.
2. `ENTRYPOINT`는 사용하는 컨테이너가 `executable`일때 정의해줘야함.
3. `CMD`는 `ENTRYPOINT`의 default arguments를 정의하는 용도로 사용하거나 컨테이너의 커맨드를 실행하는 용도로 사용해아함.
4. `CMD`는 컨테이너를 `run`할때 주는 인자에 의해 덮어씌워짐.

> 만약 `CMD`가 base image에서 정의되어 있고, `ENTRYPOINT`를 설정한다면 `CMD`는 reset되기 때문에 현재 이미지에 대하여 다시 정의해줘야함.

![docker-entrypoint-and-cmd](/image/docker-entrypoint-and-cmd.png)

## LABEL instruction

```DOCKERFILE
LABEL key=value # key=value 형태로 사용
```

key=value 형태로 이미지에 라벨을 줄 수 있으며, `docker image inspect`를 통하여 확인할 수 있음

## EXPOSE instruction

```DOCKERFILE
EXPOSE <port> [<port>/<protocol>...] # port를 expose함
```

`EXPOSE` instruction은 컨테이너가 런타임에서 특정 포트를 listen하도록 **정보를 제공**하며, `TCP`/`UDP`를 선택할 수 있음. (기본값은 `TCP`)
실제로 port를 publish하는것은 아니며 컨테이너를 실행하는 유저에게 정보를 제공하는 역할을 함. 컨테이너에서 publish를 하려면 `run`시 `-P`옵션을 통하여 publish 해야함.

`EXPOSE 8080:80/tcp`와 같이 호스트의 포트는 여기서 줄 수 없고, 컨테이너가 실행될때 커멘드로 설정해줘야 함... 당연함.

## ENV instruction

```DOCKERFILE
ENV <key>=<value> ... # 한번에 여러개 설정 가능
```

`<key>=<value>`형태로 환경변수를 설정함. 이는 Dockerfile 내부에서도 쓰이고, 컨테이너에도 적용됨. 만약 Dockerfile 내부에서만 쓰고싶은 변수를 설정하고 싶다면 `ARG`를 사용하거나, 한 instruction에서만 사용하려면 `RUN TMP=VALUE apt-get update && ...`형태로 사용함.	

## ADD instruction

`ADD`는 두가지 형태가 있음

```DOCKERFILE
ADD [--chown=<user>:<group>] <src>... <dest>
ADD [--chown=<user>:<group>] ["<src>", ... "<dest>"] # path에 whitespace가 있으면 이 방식을 사용해야함
```

> Note
> --chown은 linux 환경에서만 작동함!

`ADD`는 `src`의 새로운 파일이나, 디렉토리 혹은 file URL을 복사해서 이미지의 `dest` path에 추가함.

파일이나 디렉토리를 추가하는 경우, build context의 상대경로로 적용되며 각 `src`는 wildcard를 사용할 수 있고 [Go의 filepath.Match](https://pkg.go.dev/path/filepath#Match) 룰을 따름

```DOCKERFILE
ADD hom* /mydir/ # hom 으로 시작하는 파일들
ADD hom?.txt /mydir/ # ? = any single character
ADD test.txt relative/path # 상대경로 지정
ADD test.txt /absolute/path/ # 절대경로 지정
```

`--chown` 플레그가 없으면 UID와 GID는 0(root)로 설정됨. `--chown` 플레그를 준다면 리눅스의 `chown` 커멘드와 동일한 방식으로 설정하면 됨.
만약 `/etc/passwd`나 `/etc/group`에 존재하지 않는 user name이나 group name을 준다면, 해당 `ADD` instruction은 실패함! 하지만 UID나 GID를 숫자로 준다면 해당 id를 생성해서 만들어줌. 따라서 id로 주는것 추천

`URL`로 `ADD`를 할 때, authentication이 필요하다면 `RUN wget`나 `RUN curl`같은 다른 툴을 사용해야함.

`ADD`에 적용되는 다양한 rule은 [Dockerfile reference](https://docs.docker.com/engine/reference/builder/#add) 참조.

## COPY instruction

```DOCKERFILE
COPY [--chown=<user>:<group>] <src>... <dest>
COPY [--chown=<user>:<group>] ["<src>",... "<dest>"]
```

`COPY`는 `RUN`과 유사하지만, URL을 사용할 수 없으며 로컬 tar 파일을 자동으로 압축해제해주지 않음.

`COPY`가 더 직관적이기 때문에, 꼭 필요하지 않으면 `COPY`를 사용하는게 좋음 ([COPY vs ADD](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#add-or-copy))

## VOLUME instruction

```DOCKERFILE
VOLUME ["/data"]
```

> [docker-mount](/docker/docker-mount.md)에서 `volume-mount` 방식임.

`VOLUME` instruction은 해당 이름으로 `mount point`를 생성하고 호스트나 다른 컨테이너와 별개의 volume을 holding한다고 mark함. 값들은 `VOLUME ["/var/log/"]`와 같이 JSON array 형식으로 나타낼 수 있고, `VOLUME /var/log /var/db` 같이 plain string 형태로 여러개를 지정할 수도 있음.

`docker run` 커맨드로 base image의 특정 위치에 존재하는 어떤 데이터로도 새로 생성된 volume를 초기화할 수 있음.

```DOCKERFILE
FROM alpine:3.13
RUN mkdir /myvol
RUN echo "hello volume!" > /myvol/hihi
VOLUME /myvol
```

![docker-volume-example](/image/docker-volume-example.png)

해당 `Dockerfile`로 만들어진 이미지로 `run`을 하면 `/myvol`에 새로운 마운트 포인트를 만들고, `hihi` 파일을 생성된 볼륨에 저장함. 

### VOLUME instruction을 사용할때 주의할점

- Volumes on Windows-based containers: 윈도우 기반의 컨테이너를 사용할때, volume의 위치는 다음 중 하나와 같음
  - 존재하지 않거나 빈 디렉토리
  - `c:`드라이브가 아닌 다른 드라이브에 저장됨
- Changing the volume from within the Dockerfile: volume이 선언된 이후 데이터를 변경하는 step가 있으면, discard됨.
- JSON formatting: 선언된 리스트는 JSON array 형식이라서, `"`을 사용해야함
- The host directory is declared at container run-time: 호스트 디렉토리는 호스트에 의존함. 이는 이미지의 호환성을 위한거임. 따라서 `Dockerfile`내부에서 호스트 디렉토리를 마운트 할 수 없음. 

# USER instruction

```DOCKERFILE
USER <user>[:<group>]
USER <UID>[:<GID>]
```

`USER` instruction은 이미지를 실행할때, 그리고 `Dockerfile`의 `RUN`, `CMD` and `ENTRYPOINT` instruction을 실행할때 `user name`과 `group name`(optional)을 지정할 수 있음.

> user에게 그룹을 지정할때는, 선언된 그룹에만 속하게 되고 다른 그룹은 무시됨

> user에게 `primary group`가 없으면 root 로 지정됨. 

# WORKDIR instruction

```DOCKERFILE	
WORKDIR /path/to/workdir
```

`WORKDIR` instruction은 `Dockerfile` 의 `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, `ADD` instruction을 실행할때 working directory를 지정함. 만약 `WORKDIR`이 존재하지 않으면 디렉토리를 생성함.

`WORKDIR`은 `Dockerfile`에서 여러번 사용될 수 있고, 상대경로로도 지정할 수 있음.

예시:

```DOCKERFILE
WORKDIR /a
WORKDIR b 
WORKDIR c
RUN pwd
```

이 Dockerfile을 실행하면 pwd는 /a/b/c에 있음.

`WORKDIR`에서 환경변수를 사용하면, 이는 `Dockerfile`의 `ENV`에 설정된 환경변수만 사용할 수 있음.

만약 `WORKDIR`이 지정되지 않으면 기본값으로 `/`가 되며, 의도치 않은 디렉토리에서 작업하는것을 방지하기 위해 `WORKDIR`을 명시적으로 작성하는게 좋음.

# ONBUILD

```DOCKERFILE
ONBUILD <INSTRUCTION>
```

`ONBUILD` instruction은 이미지가 또다른 build의 base로 쓰일 때 실행할 _trigger_ instruction을 지정해줌. 이 trigger는 


# Reference

[Docker 공식 document - dockerfile](https://docs.docker.com/engine/reference/builder/)