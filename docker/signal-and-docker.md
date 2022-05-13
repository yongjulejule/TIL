# signal-and-docker

`docker stop`은 시그널을 보내서 컨테이너를 종료시키며, 이때 `SIGTERM`을 보내고, 만약 10초간 컨테이너가 종료되지 않으면 `SIGKILL`을 보낸다.

> - SIGTERM: 소프트웨어를 polite하게 종료하는... 시그널. ignore이나 block, handling가 가능하고, child process는 kill하지 않음.
> - SIGKILL: hard하게 종료하는 시그널. ignore와 block, handling가 불가능하며 child process 또한 kill함.

## Signal in Docker

`docker run <image> <executable>`의 컨테이너를 실행할때 사용하는 `<executable>`는 해당 컨테이너에서 PID 1로 작동함. 

- 도커의 instruction에는 보통 `exec form`과 `shell form`이 있음. `exec form`은 JSON array형태로 직접 실행되며, `shell form`은 `/bin/sh -c` 형태로 실행됨.
- `shell form`은 기본적으로 내부에서 `fork`를 하기 때문에 `subprocess`로 명령어가 작동함. 따라서 `shell form`에선 `/bin/sh`가 PID 1이 되고, `<executable>` 은 PID 2 이후의 것을 받음.
- `exec form`에선 `<executable>`이 PID 1이 됨.
- PID 1은 Linux에서 특별한 의미를 지님. `init` process라고 알려져 있으며 고아나 좀비 프로세스를 적절히 핸들링 해줄 필요가 있음. 또한 PID 1에 시그널 핸들러가 없으면 `SIGTERM`은 아무것도 하지 않음.
- 일반적으론 환경에선 PID 1에 적절한 `init` 프로세스가 할당되지만, 도커에선 `<executable>`이 바로 PID 1로 실행됨.
- `docker`가 `SIGTERM`을 받으면, 컨테이너에 시그널을 전달하고, 바로 종료시키며 컨테이너가 종료될때까지 기다리지 않음.
- `shell`은 시그널을 큐에 넣어서 현재 진행중인 자식 프로세스가 종료될때까지 기다림.
- `shell form`은 따라서 `SIGTERM` 시그널을 받아도 자식 프로세스들이 종료되길 기다림. 만약 `shell form`으로 실행한 `<executable>`이 오랜 시간동안 실행되는 프로그램 이라면, 시그널은 무시될 것임.
- `exec form`에서는 PID 1로 `<executable>`이 실행되기 때문에, `SIGTERM`을 제외한 다른 `Trappable signal`은 정상적으로 작동하지만 `SIGTERM`은 시그널 핸들러가 없다면 PID 1이기 때문에 무시됨.

- Docker stop
- `docker run`이 `SIGTERM`을 받으면, 컨테이너에 시그널을 전달하고, 컨테이너 자체가 (TODO: never die?) never die여도 종료 시킴.
- `docker stop`이 실행되면, `SIGTERM`을 보내고, 10초간 기다린뒤 종료되지 않으면 `SIGKILL`을 보내서 종료시킴.

해결방안...?

- shell form을 쓰지 마라. (docker docs도 exec form을 추천함)
- 

[Best practices for propagating signals on Docker](https://www.kaggle.com/code/residentmario/best-practices-for-propagating-signals-on-docker/notebook)

[Why Your Dockerized Application Isn’t Receiving Signals](https://hynek.me/articles/docker-signals/)

