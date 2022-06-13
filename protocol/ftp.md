# FTP (File Transport Protocol)

FTP는 파일 전송 프로토콜으로, 서버와 클라이언트 사이에 파일을 전송하기 위해 나온 것임. 1971년에 나왔으며 연결하기 위해선 로그인을 해야함(서버가 허용한 경우 익명 사용자 가능).하지만 이런 정보가 plaintext 형태로 넘어가기 때문에 보안상 상당히 취약하며, 2021년에 대부분 브라우저에서 지원을 중단하고 SFTP(ssh + FTP) 나 FTPS(FTP + TLS)를 사용함.

이 FTP는  파일 전송을 위해 두개의 포트를 사용하며 한 포트는 연결을 위해 사용하고(command port)  다른 포트는 데이터 전송을 위해 사용하며(data port) 여기서 passive mode와 active mode로 나뉨.

command port를 위해선 통상적으로 21번 포트를 사용하지만 data port는 passive mode와 active mode에서 서로 다름.

## active mode

active mode에서는 다음과 같이 진행됨

1. 클라이언트에서 임의의 포트(N > 1023)를 FTP 서버의 21번 포트에 연결함. (command port)
2. 클라이언트는 N+1번 포트를 listen하기 시작하고 FTP 명령 port N+1을 FTP 서버로 보냄.
3. 서버는 20번 포트(데이터 포트)에서 클라이언트의 N+1 포트로 연결함. (data port)

이때 client측에서 문제가 발생함. client는 서버와 data port로 실제로 연결된게 아니며 단순히 서버에게 data port를 위하여 어떤 포트를 Listening 할건지 알려주는 거임. 서버측에서 data port로 연결하려고 하면 클라이언트측 방화벽에선 그저 외부 시스템에서 연결을 하려는 것으로 보이기 때문에 방화벽에 막힘.

## passive mode




- file을 위해 특별한 프로토콜이 왜 필요했을까?
- 어느 이점이 있을까?
- FTP + SSL/TLS 는 없나?

## ftp-server for linux

vsftpd, pro-ftp, pure-ftp...

[vsftpd config](https://2factor.tistory.com/96)