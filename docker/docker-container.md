# docker container

컨테이너는 이미지를 통해 생성되는 instance로, 독립된 환경을 제공해주는 프로세스임. [docker image](/docker/docker-image.md)에서 기술한 것 처럼, 이미지 위에 R/W layer를 올린 형태이며, 컨테이너가 삭제되면 작업 내역도 모두 사라짐.

하나의 빈 레이어만 생성하면 되기 때문에 매우 빠르게 생성할 수 있음!
![docker container layer](/image/docker-container-layer.jpg)
> 출처 : docker 공식문서

각 컨테이너는 완전히 새로운 환경을 생성한 것 처럼 작동하며 root 디렉토리, pid, 네트워크, 메모리, cpu등을 새롭게 구성할 수 있음.

이는 리눅스 커널의 [namespace와 cgroup](/linux/namespace.md)라는 기능으로 구현됨!

결국, vm과 다르게 컨테이너는 Host os에서 native로 작동하기 때문에 훨씬 가볍고 빠름.(리눅스가 아닌 환경에서는 docker app이 리눅스 환경으로 가상화를 하여 작동함.)

![linux namespace compare with docker process](/image/linux-namespace-comp2.png)
> 컨테이너 프로세스와 init 프로세스의 namespace 비교

## pid 1

컨테이너는 독립된 pid namespace에서 실행되기 때문에 내부에서 pid 1을 갖게 되는데, 리눅스의 pid 1은 특별한 작동을 하기 때문에 이를 고려해야함. [docker and signal](/docker/signal-and-docker.md) 참고

