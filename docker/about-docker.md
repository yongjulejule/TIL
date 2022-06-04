# about-docker

도커는 OS-level 가상화를 통해 컨테이너를 쉽게 다루게 해주는 플랫폼임. 이미지 기반으로 컨테이너를 손쉽게 생성한다는 점으로, 어플리케이션마다 필요한 환경을 구축, 테스트, 배포하기 좋음!

컨테이너 기술은 그 전부터 존재했으며 도커는 이를 정말 잘 활용할 수 있도록 만들어졌을 뿐임.

![docker architecture](/image/docker-architecture.jpeg)
> 출처 : docker 공식문서

이와 같이 다양한 기능을 제공하는데, client(shell or docker desktop app)에서 명령을 하면 Docker daemon이 이미지와 컨테이너를 관리하고, 필요하면 Registry(주로 Docker hub)에서 이미지를 가져오기도 함.


## Docker vs Virtual Machine

도커와 가상머신은 독립된 환경을 제공한다는 점에서 유사하고, 직접 컨테이너를 사용하면 vm과 큰 차이가 없어 보이지만 컨테이너가 가상머신보다 성능이 훨씬 좋다는 이점이 있음.

이런 차이는 환경을 구축하는 방식에서 비롯되는데, VM의 경우는 호스트 머신 위에 가상화나 반-가상화를 통하여 새로운 os를 구축하고, 그 위에서 작동하는 방식이지만 도커 컨테이너의 경우는 호스트 머신 위에서 리눅스 커널의 namespace, cgroup 기능을 통해 작동하기 때문에 훨씬 가볍고 성능이 좋음. [docker container](/docker/docker-container.md) 참고

또한 도커 컨테이너를 생성하기 위해 만드는 이미지 파일도 layer로 분할되어 생성되기 때문에 변경점이 있다면 그 레이어만 업데이트하고, 나머지는 캐시되어 있는 데이터를 활용할 수 있기 때문에 이미지 생성 시간이 단축됨. [docker image](/docker/docker-image.md) 참고

![docker vs vm](/image/Docker-containerized-and-vm-transparent-bg.jpg)

하지만 단점도 존재하는데, process-level의 격리이기 때문에, 상대적으로 보안이 좋지 않음.

## hello-world

![docker hello world](/image/docker-hello-world.png)

# Reference

[도커란? docker 홈페이지 docs](https://docs.docker.com/get-started/overview/)

[도커란? aws 문서](https://aws.amazon.com/docker/)

[도커 vs vm](https://hoon93.tistory.com/41?category=1105706)

[도커 개념 정리](https://cultivo-hy.github.io/docker/image/usage/2019/03/14/Docker%EC%A0%95%EB%A6%AC/#%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88-%EB%AA%85%EB%A0%B9%EC%96%B4-%EC%8B%A4%ED%96%89%ED%95%98%EA%B8%B0-exec)

[도커 입문 - 추천!](https://www.44bits.io/ko/post/easy-deploy-with-docker)

[컨테이너의 내부 작동 방식 - 추천!](https://www.44bits.io/ko/post/easy-deploy-with-docker)

[도커 입문 2](https://code-masterjung.tistory.com/130)

[docker internals](http://docker-saigon.github.io/post/Docker-Internals/)