# docker-run-command

커맨드를 새로운 컨테이너에서 실행

`docker run [options] IMAGE [COMMAND] [ARG...]`

`docker run --rm centos cat /etc/os-release`

centos:latest 환경에서 /etc/os-release 파일을 읽어온 뒤 이미지를 삭제

`docker run --rm -it ubuntu`

ubuntu:latest 환경에 tty를 할당하고 (-t 옵션), interactive 모드로 (-i 옵션) 실행

`--rm` 옵션을 주면 종료시 컨테이너를 삭제함. 옵션을 주지 않으면 `docker ps -a` 로 프로세스를 체크했을때, 종료된 채로 이미지가 남아있음. 남아있는 이미지들은 `docker rm $(docker ps -a | awk '{print $1}') ` 의 명령어로 제거 가능

이 외에도 특정 디렉토리 마운트, 환경변수 설정 등 많은 옵션을 줄 수 있는데 [공식문서](https://docs.docker.com/engine/reference/commandline/run/)에 자세히 나와있음