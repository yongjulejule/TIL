# FTP (File Transport Protocol)

FTP는 파일 전송 프로토콜으로, 서버와 클라이언트 사이에 파일을 전송하기 위해 나온 것임. 1971년에 나왔으며 연결하기 위해선 로그인을 해야함(서버가 허용한 경우 익명 사용자 가능).하지만 이런 정보가 plaintext 형태로 넘어가기 때문에 보안상 상당히 취약하며, 2021년에 대부분 브라우저에서 지원을 중단하고 SFTP(ssh + FTP) 나 FTPS(FTP + TLS)를 사용함.

이 FTP는  파일 전송을 위해 두개의 포트를 사용하며 한 포트는 연결을 위해 사용하고(command port)  다른 포트는 데이터 전송을 위해 사용하며(data port) 여기서 passive mode와 active mode로 나뉨.

command port를 위해선 통상적으로 21번 포트를 사용하지만 data port는 passive mode와 active mode에서 서로 다름.

## active mode

active mode에서는 다음과 같이 진행됨

1. 클라이언트에서 임의의 포트(N > 1023)를 FTP 서버의 21번 포트에 연결함. (command port)
2. 클라이언트에서 data port로 쓸 N+1번 포트의 정보를 서버에게 넘겨줌.
3. 서버는 20번 포트(데이터 포트)에서 클라이언트의 N+1 포트로 연결함. (data port)

![ftp active mode](/image/ftp-active.jpeg)

이때 client측에서 문제가 발생함. client는 서버와 data port로 실제로 연결된게 아니며 단순히 서버에게 data port를 위하여 어떤 포트를 Listening 할건지 알려주는 거임. 서버측에서 data port로 연결하려고 하면 클라이언트측 방화벽에선 그저 외부 시스템에서 연결을 하려는 것으로 보이기 때문에 방화벽에 막힘.

## passive mode

active mode의 문제를 해결하기 위해 등장한 방법이 passive mode이며 PASV라고도 불림.

passive mode FTP에서 클라이언트는 두 연결을 모두 시작하여 방화벽 문제를 해결함.

1. FTP연결을 열 때 클라이언트는 두개의 랜덤 포트를 로컬에서 열음.(N>1023, N+1)
2. 첫번째 포트는 서버의 21번 포트에 연결됨.(command port)
3. 클라이언트가 psav 명령을 보내서 서버에서 랜덤 포트 P (p > 1023)을 열고 클라이언트에게 P를 알려줌.
4. 클라이언트는 N+1에서 P로 연결함. (data port)

![ftp passive mode](/image/ftp-passive.jpeg)

여기서 서버가 특정 포트들을(data port) 열어둬야 한다는 문제가 발생함. 하지만 서버측에서 특정 포트 범위를 data port로 쓰도록 설정하여 문제를 해결할 수 있음.

또한 passive mode를 지원하지 않는 클라이언트가 있을 수 있으나 요즘엔 그런거 없음.
 
[active FTP vs passive FTP](http://slacksite.com/other/ftp.html)


## FTP의 장단점

### 장점

- 여러 파일과 폴더를 전송 가능.
- 연결이 끊어지면 전송 재개 가능.
- 전송할 파일의 크기 제한이 없음.
- HTTP보다 빠른 데이터 전송.
- 많은 FTP client가 파일 전송 예약을 지원함.

### 단점

- 내용이 그대로 가서 보안상 매우 좋지 않음.(전송되는 데이터 뿐만 아니라 로그인할때 사용하는 id, password까지 텍스트 그대로 전송됨)
- 적은 용량의 파일을 여러 클라이언트에 연결해야 하는 경우 비효율적임. (이를 위해 HTTP가 나옴)

## FTP vs HTTP

| FTP | HTTP |
| ---- | ---- |
| 인증이 필요함 | 인증이 필요하지 않음 |
| 대용량 파일 전송에 효율적 | 작은 파일을 전송할 때 효율적 |
| 파일이 메모리에 저장됨 | 메모리에 저장되지 않음 |
| 클라이언트와 서버간에 파일을 다운로드하고 업로드 할때 사용 | 웹페이지 전송에 사용 |
| 상태(state)를 저장하는 프로토콜 | 상태를 저장하지 않는(stateless) 프로토콜 |
| 양방향 통신 시스템 지원 | 단방향 통신 시스템 |
| data connection, command connection으로 나뉨 | data connection만 있음 |


[how ftp works?](https://afteracademy.com/blog/what-is-ftp-and-how-does-an-ftp-work)