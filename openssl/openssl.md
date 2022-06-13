# openssl

openssl은 TLS 네트워크 프로토콜을 위한 암호화 도구로 암호화 기능이 구현되어 있으며 다양한 유틸리티 기능을 제공함. Nginx의 ssl 모듈도 이 openssl을 사용함!

## openssl req

`openssl req -new` 새로운 인증 요청서 생성. 입력하면 필요한 정보에 대한 프롬프트가 나옴.

`openssl req -newkey [argument]` 새로운 인증 요청서 발급 및 새로운 private key 생성. 이때 생성하는 private key는 `[argument]`에 따른 암호화 방식으로 생성됨.

`openssl req -newkey [argument] -nodes -keyout {filename.key} -out  {filename.csr} -subj "/C=KR/ST=Seoul/L=gae-po/O=SecureSignKR/OU=42-Seoul/CN=${DOMAIN_NAME}"`

`-nodes` : private key자체에 암호 설정을 하지 않음.
`-keyout {filename.key}` : 생성된 private key를 저장할 파일
`-out {filename}` : 출력값을 filename에 저장
`-subj {info}` : 인증서의 입력해야 하는 값을 프롬프트가 아닌 커맨드에서 받음.

## openssl x509

x509는 공개 키 인증서 형식을 정의하는 ITU(International Telecommunication Union)표준으로, 이 표준에 맞는 인증서를 생성하기 위해 사용하는 커맨드

`openssl x509 -req -days 365 -in {filename.csr} -signkey {filename.key} -out {filename.crt}`

`-req` : 인증서 요청 (csr) 파일을 인증서로 변환
`-in {filename}` : input을 받을 파일
`-signkey {key file}` : private key를 제공
`-out {crt file}` : output을 저장할 파일(인증서)


## openssl ciphers

openssl에서 지원하는 cipher 정보

`openssl ciphers` 커멘드로 모든 cipher 리스트를 볼 수 있음

`openssl ciphers -v 'HIGH:!aNULL'` 커맨드로 지정한 cipher 리스트를 볼 수 있음. 이는 `nginx`에서 `ssl_ciphers`에서 사용하는 구문과 동일함.

## openssl s_client

`openssl s_client -connect [도메인]:443 -tls1_3`

특정 프로토콜로 연결하기 위해 사용하는 명령어