# docker-cp

컨테이너간 파일 관리를 `docker cp` 커멘드로 할 수 있음.

쉘의 cp 커멘드와 유사하게, `docker cp [option] [컨테이너 이름]:[컨테이너의 파일] 경로` 와 같은 방식으로 사용 가능함.

## nginx index 페이지 변경 예시

1. `docker run --rm -itd -p 8080:80 --name nginx1 nginx` 로 nginx 컨테이너 실행
2. `docker cp /home/yongjule/index.html nginx1:/usr/share/nginx/html/index.html` 커멘드로 컨테이너에 index.html 파일을 전송
3. [호스트ip]:8080으로 접속하면 내가 만든 index.html 페이지가 뜸!