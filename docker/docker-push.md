# docker-push

생성한 이미지를 docker-hub에 github처럼 push할 수 있다.

1. `docker login` 커멘드로 docker-hub 계정 로그인
2. `docker tag [이미지 이름] [계졍/레포]` 커멘드로 특정 이미지에 태그를 달아줌
3. `docker push [태그]` 로 푸쉬!