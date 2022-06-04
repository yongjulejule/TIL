# docker image

도커 이미지는 `Dockerfile`의 instruction들을 기반으로 만들어지며 컨테이너를 생성하기 위한 snapshot 역할을 함.

이때 각 instruction에 따라 layer된 이미지를 생성하는데, 그 구조는 아래와 같음.

![docker image layer](/image/docker-container-layers.jpg)
> 출처 : docker 공식문서 https://docs.docker.com/storage/storagedriver/

각 layer는 READ-ONLY이며 union file system를 통하여 최상위 layer에서 일관성 있는 파일 구조를 확인할 수 있게 됨.

이렇게 layer화된 구조를 가져서, 특정 instruction이 변경되면 모든 이미지를 다시 빌드하는게 아니라, 변경점이 있는 layer부터 빌드할 수 있고, 이전 layer는 cache를 이용하여 빠르게 빌드할 수 있음

*첫 빌드*
![image layer 1](/image/docker-image-build-1.png)

*같은 이미지를 다시 빌드했을 때*
![image layer 2](/image/docker-image-build-2.png)

*layer 2를 변경했을 때*
![image layer 3](/image/docker-image-build-3.png)

`time` 명령어를 이용하면 확연한 시간 차이를 볼 수 있음.

이렇게 READ-ONLY로 만들어진 이미지 위에 R/W인 Container layer를 올리고, 이 layer에서 작업하기 때문에 컨테이너에서 파일을 생성하거나 삭제해도 image layer에는 영향이 없음.

이러한 특징 때문에 이미지는 불변성을 지니고 빠른 빌드타임을 가질 수 있으며 원격 저장소에서 이미지를 pull 받을때 역시 이렇게 중복된 layer를 제외하고 받기 때문에 빠른 속도를 보임.

만약, 컨테이너의 작업 사항을 이미지로 저장하고 싶다면 `docker commit` 명령어를 통해 컨테이너 layer를 이미지로 통합할 수 있음.