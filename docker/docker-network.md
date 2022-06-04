# docker-network

도커 네트워크는 컨테이너와 컨테이너 사이의 네트워크를 구축하는 기능임.

예를 들면, wordpress는 mariadb같은 관계형 데이터 베이스를 기반으로 작동하기 때문에 wordpress를 사용하기 위해선 wordpress 컨테이너와 mariadb 컨테이너가 필요하며 이 두 컨테이너의 네트워크는 연결되어 있어야 한다.

`docker network create [네트워크 이름]` 같은 형태로 네트워크를 만들어 주고, mariadb와 wordpress 컨테이너를 run 할때 --net=[네트워크 이름] 과 같은 형태로 주면 된다.

`docker network inspect [도커 프로세스 id]`로 해당 컨테이너가 사용하는 네트워크 정보를 가져올 수 있음.

[docker-run-command.md](/docker/docker-run-command.md)의 내용에 따라 `mariadb`와 `wordpress`의 컨테이너를 생성하고, 해당 컨테이너가 사용하는 네트워크를 inspect 해보면 다음과 같음

```bash
.
.
.
"IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
.
.
.
"Containers": {
  "550a8ca10522981a1c1a137ab51a72341b3b49c9e03355c132d5ba247f319023": {
      "Name": "wordpress",
      "EndpointID": "6fd0af955b35f38b8f5f2ef1ec92dcfc6cce648e3bc960066d8339521e5729d8",
      "MacAddress": "02:42:ac:12:00:03",
      "IPv4Address": "172.18.0.3/16",
      "IPv6Address": ""
  },
  "5f4ab743aee21b6fcaa2d164c0a694e0dd93d80d9e9f3221579be61903e180c6": {
      "Name": "maria",
      "EndpointID": "1c80606f9bac9a538975ccc580c16e8768ee191a57495e4c36220d44490adf41",
      "MacAddress": "02:42:ac:12:00:02",
      "IPv4Address": "172.18.0.2/16",
      "IPv6Address": ""
  }
},
.
.
.
```

적당한 ip가 컨테이너들에 할당된 모습을 확인할 수 있음.