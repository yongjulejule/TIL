
# Nginx

Nginx는 가장 인기있는 웹 서버 프로그램이며 웹서버로 시작했지만 리버스 프록시, 로드밸런스를 위해서도 사용됨. 개발 당시 가장 유명했던 아파치 웹서버가 한번에 10만개 이상 연결을 할 수 없다는 한계때문에 만들어졌음. 아파치는 연결 1개당 프로세스 하나를 할당하여 연결을 처리하는 반면 Nginx는 이벤트 중심의 비동기 아키텍쳐로 연결을 처리함. 따라서 적은 메모리 사용량으로 많은 커넥션을 핸들링 할 수 있게됨!

비동기 I/O이기 때문에 큐에 I/O작업이 많이 쌓이는 경우 apache가 더 낫고, 이럴때는 Nginx를 리버스 프록시 서버로 사용할 수 있음.

Nginx는 마스터 프로세스가 있어서 config를 읽고 검증한 후 그에 맞게 적용하고, 워커 프로세스를 생성 및 관리함.
워커 프로세스의 수는 cpu의 코어수, 디스크 수를 고려하여 만들어지며 기본값으로 최대 core 수 만큼 만들어지기 때문에 컨텍스트 스위칭의 비용이 적음. 

또한 Nginx는 웹서버의 역할 뿐만 아니라, 리버스 프록시 서버의 역할도 할 수 있기 때문에 로드밸런싱과 보안상의 이점을 가져올 수 있음.

- 프록시
    
    ![cgi.006.jpeg](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/1b29d170-189e-4e63-baff-5c1dca73ba3f/cgi.006.jpeg)
    
    - 프록시는 서버와 클라이언트 사이에서 중계역할을 함. 요청을 받으면 프록시 서버를 거쳐 다음 목적지로 가는것. 이는 보안상의 이유로 사용할 수 있고 프록시 서버에서 캐싱을 통해 빠르게 요청에 응답할 수 있다는 장점도 있음.
    - Forward Proxy (proxy)
        - Forward Proxy는 대상에 접근하기 전에 proxy를 거쳐서 접근하는 거임. 만약 보안상 위험이 있거나 악의적인 접근이 있다면 여기서 접근을 제한할 수 있음. 방화벽같은 경우 서버에 접근을 한 뒤 막아주지만 프록시는 문제가 있다면 프록시 서버에서 더이상 진행되지 않기 때문에 이점이 있음.
        - proxy와 vpn(virtual private network)이 비교되는데, proxy는 application level에서 ip만 암호화가 되는 것이고, vpn은 OS level에서 암호화 되기 때문에 ip 뿐만 아니라 모든 데이터가 암호화됨.
        - 
    - Reverse Proxy
        - Reverse Proxy는 클라이언트 입장에서 그냥 서버로 요청을 보내는 것 처럼 보임. 하지만 서버 측에 리버스 프록시가 있어서, 서버로 오는 모든 요청은 리버스 프록시를 거침. 이는 다양한 장점을 가져옴.
            - 정적 컨텐츠를 캐싱하여 요청에 빠르게 응답할 수 있음
            - SSL 암호화 같은 작업을 할 수 있어 웹서버의 부하를 줄임
            - 내부 서버의 정보를 숨길 수 있어서 보안상 좋음
- Load balancing
    - Load balancing(부하 분산)은 요청이 너무 많아 여러대의 서버가 필요할때 사용함. 클라이언트의 요청을 가용한 적절한 서버에 보내서 처리함. 만약 서버 하나가 다운되어도 다른 서버에 요청을 전달하면 되니 안정성이 높아지고, 설정이 간단해서 확장성도 좋음. Nginx에선 어떤 방식으로 분산시킬지 정할 수 있음.
    - application level (HTTP level)의 로드벨런싱은 리버스 프록시와 비슷하지만, 리버스 프록시는 HTTP 요청에 국한되는 반면 로드밸런싱은 다른 계층에 대하여도 조절할 수 있음. Nginx에서 제공하는 Load balancing은 HTTP 한정임.
    
    
- Nginx with SSL
    - Nginx를 리버스 프록시 서버를 사용하여 모든 요청에 대해 https 연결을 요구할 수 있음.
    - 각 앱마다 SSL을 적용하는건 몹시 힘듦!
    - 하지만 Nginx에서 SSL을 적용하고 리버스 프록시로 활용하여 내부 다른 서버와 소통하면 간단하게 해결됨.

# Reference

[https://ssdragon.tistory.com/60](https://ssdragon.tistory.com/60)

[https://medium.com/@su_bak/nginx-nginx란-cf6cf8c33245](https://medium.com/@su_bak/nginx-nginx%EB%9E%80-cf6cf8c33245)

[https://oxylabs.io/blog/reverse-proxy-vs-forward-proxy](https://oxylabs.io/blog/reverse-proxy-vs-forward-proxy)

[https://dzone.com/articles/nginx-reverse-proxy-and-load-balancing](https://dzone.com/articles/nginx-reverse-proxy-and-load-balancing)

[https://www.upguard.com/blog/reverse-proxy-vs-load-balancer](https://www.upguard.com/blog/reverse-proxy-vs-load-balancer)

[https://www.digitalocean.com/community/tutorials/understanding-nginx-http-proxying-load-balancing-buffering-and-caching](https://www.digitalocean.com/community/tutorials/understanding-nginx-http-proxying-load-balancing-buffering-and-caching)