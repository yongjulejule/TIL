# SSL/TLS

SSL은 Secure Socket Layer의 약자로 흔히 HTTPS에 사용된다고 알려져 있지만, SSL은 1996년에 v3.0을 마지막으로 더이상 업데이트 되고 있지 않고, TLS로 바뀌어서 업데이트 중이며 SSL 3.0은 2015년에 추방되었다. 즉 현재 SSL이라고 부르는 것은 관례적으로 남아있을 뿐 TLS임.

## About TLS

TLS는 Transport Layer Security의 약자로 컴퓨터 네트워크 상에서 사용되는 암호화 프로토콜임. OSL 7 layer model, TCP/IP model 중 단일 계층에 속한다고 하긴 어려우며 TCP가 있는 Transport layer와 Application layer 사이라고 생각해야함. 주로 HTTPS를 위해 사용되지만 voice over IP, 파일 전송(FTPS) 등을 위해서도 사용됨.

TLS 프로토콜은 두개 이상의 컴퓨터 통신 어플리케이션 간에 인증서를 사용하여 개인정보와 데이터 무결성, 사이트의 신뢰성을 포함하는 암호화를 제공하는 것을 목표로 함. application layer(TCP/IP model 기준)에서 실행되며 TLS v1.3 기준 TLS record, TLS handshake 그리고 TLS Alert 세가지 프로토콜로 구성됨.

## TLS가 해주는것

- 프라이버시를 제공하기 위해서 SSL은 웹에 전송되는 데이터를 암호화함. 만약 이 데이터를 누군가가 인터셉트 한다면, 복호화가 거의 불가능한 의미없는 문자열만 볼 수 있는 상태임.
- Handshake라고 불리는 인증 과정을 거치는데, 이때 연결하고자 하는 두 기기가 진짜로 요청을 원하는 기기인지 확인함.
- 데이터 무결성는 위하여 데이터이 디지털로 sign을 함. 데이터가 의도한 곳으로 도달하기 전에 변조되어있는지 확인 가능.

## TLS의 암호화 기법

TLS는 성능상의 이유로 두가지 암호화 기법을 사용함. 이를 이해하기 위해선 암호화 기법들에 대한 이해가 선행되어야 함.

### 키

암호화를 할 때 사용하는 일종의 비밀번호를 키 라고 함. 이 키에 따라서 암호화된 결과가 달라지기 때문에, 키를 모르면 복호화가 불가능함. 대칭키는 동일한 키로 암호화와 복호화를 하는것임. 이러한 키는 문자열 형태이며 현대의 암호화 키는 매우 복잡한 문자 및 숫자로 이루어짐.

### symmetric-key cryptography (symmetric cryptography)

대칭키 암호화 방식은 동일한 키로 암호화와 복호화가 가능한것임. 같은 키가 사용되는 만큼 보안에 취약하며 대칭 키를 전달하다가 intercept 당하면 문제가 심각해짐. 이런 문제를 해결하기 위해 나온게 공개키 방식임.

### public-key cryptography (asymmetric cryptography)

공개키 암호화 방식은 두개의 키를 갖게 되며 A, B란 키가 있다고 가정하면, A 키로 암호화된 데이터는 B 키로 복호화할 수 있고 B 키로 암호화된 데이터는 A 키로 복호화할 수 있음. 이 방식에서 착안하여 두 키중 하나를 `private key`, 하나를 `public key`로 지정한 뒤 `private key`는 자신만이 갖고 있고 `public key`는 타인에게 공개함. `public key`를 받은 타인은 `public key`를 이용하여 데이터를 암호화하고 이 데이터를 `private key`를 가진 사람에게 보내면, 복호화할 수 있음. 이 과정에서 `public key`가 유출되더라도 데이터를 복호화 할 수 없음.

이러한 방식을 응용하여 전자 서명을 할 수 있음. `private key`를 이용하여 데이터와 `public key`를 함께 암호화해서 전송하고, 이를 받은 사람은 `public key`를 이용하여 데이터를 복호화 함. 이때 복호화가 가능하다면 그에 맞는 `private key`를 이용하여 암호화가 되었다는 뜻이기 때문에 데이터를 전송한 사람의 신원을 보장할 수 있음.

## SSL(TLS) 인증서란?

TLS는 TLS 인증서가 있는 웹사이트에서만 작동함. 인증서는 요청한 사람이 그곳에 있는지(someone is who they say they are.) 증명해주는 ID card 같은거임. TLS인증서는 웹사이트나 어플리케이션의 서버에 의해 저장되고 표시되며 웹에서 볼 수 있음.

TLS 인증서에서 가장 중요한 정보는 웹사이트의 `public key`임. 이 `public key`가 암호화를 해줌. 유저의 기기는 `public key`를 볼 수 있고 웹서버와 안전한 암호화 키를 만들기 위해 사용됨. 웹서버 또한 `private key`를 갖고 있으며 이 `private key`는 유출되면 안됨. 이 `private key`가 `public key`로 암호화된 데이터를 복호화 함.

CA(Certificate Authorities)는 TLS 인증서를 발행하기 위해 필수임. 엄격하게 공인된 기업들만이 CA가 될 수 있으며 TLS 통신을 제공하려는 서비스는 CA를 통하여 인증서를 구매해야함.

TLS 인증서에는 서버측의 `public key`와 인증서를 발급한 CA, 서비스의 도메인 등의 정보가 포함되며 공개키 방식으로 CA에 의해서 암호화 되며 `private key`는 CA가 갖고 있음.

이 CA들의 리스트와 해당 CA의 `public key`는 브라우저 내부에 저장되어 있으며 이렇게 브라우저가 미리 파악하고 있어야 공인된 CA가 될 수 있음.

## SSL(TLS) 인증서가 서비스를 보증하는 방법

- 웹 브라우저가 서버에 접속할때 서버에서 인증서를 제공함
- 브라우저는 이 인증서를 발급한 CA가 내장된 CA 리스트에 있는지 확인
- 리스트에 있으면 해당 CA의 `public key`를 이용하여 인증서를 복호화함. 이때 복호화가 가능하다면 CA에서 발급된 셈이므로 접속한 사이트가 CA에 의해서 검토되었다는 뜻이 됨.
- 따라서 서비스는 신뢰할 수 있는 서비스임.

## SSL(TLS) 의 동작 방법

TLS는 암호화된 데이터를 전송하기 위해서 `symmetric key`와 `asymmetric key` 방식을 모두 사용함.

처음 연결을 수립할때 하는 Handshake 과정에서는 `asymmetric key`방식을 이용하고 연결된 뒤 데이터를 주고 받을때는 `session key`값을 이용하여 `symmetric key`방식으로 데이터를 암호화하고 복호화함. 데이터 전송이 끝나면 TLS 통신이 끝났음을 서로에게 알려주고, `session key`를 폐기함. 이런 방식은 `asymmetric key` 방식이 자원을 많이 사용하기 때문에 도입되게 됨.

### Handshake 과정 (TLS v1.2)

기본적으로 TLS는 TCL 프로토콜 위에서 작동하기 때문에 TCP Handshake 과정 이후 TLS Handshake 과정이 시작됨.

![TLS v1.2](/image/TLSv1.2.png)
> daum.net 에서 TLS v1.2 을 사용하여 연결하는 과정 wireshark 패킷 캡쳐

![TLS v1.2 Full](/image/TLSv1.2-FULL-wiki.svg.jpg)
> TLS v1.2 handshake 과정. 출처: https://en.wikipedia.org/wiki/Transport_Layer_Security#SSL_1.0,_2.0,_and_3.0

1. client hello: 클라이언트가 서버에 접속. 이 과정에서 클라이언트 측에서 다음과 같은 정보를 전송함.
   1. 랜덤 데이터
   2. 클라이언트가 지원하는 암호화 방식들(어떤 암호화 방식을 사용할지에 대한 협상을 하기 위함)
   3. 세션 아이디 (이미 TLS Handshaking을 했으면 시간과 비용을 절약하기 위해 기존 세션을 사용하는데 이때 사용할 연결에 대한 식별자를 서버로 전송)
	![client hello packet](/image/TLSv1.2-client-hello.png)
2. server hello: 서버에서 hello client에 대한 응답으로 보내주며 서버 측에선 다음과 같은 정보를 제공함
   1. 랜덤 데이터
   2. 서버가 선택한 클라이언트의 암호화 방식. (서버와 클라이언트 모두가 사용할 수 있는 암호화 방식을 선택)
	 ![server hello packet](/image/TLSv1.2-server-hello.png)
   3. 인증서
	 ![server certificate](/image/TLSv1.2-server-certificate.png)
3. 클라이언트는 서버의 인증서가 CA에서 발급된 것인지 확인하기 위해 CA리스트를 확인함. 만약 없다면 사용자에게 경고 메시지를 보냄. 리스트에 있다면 클라이언트에 내장된 CA의 `public key`를 활용하여 인증서를 복호화함. 복호화에 성공했다면 CA의 개인키로 암호화 되었다는 것이므로 서버를 신뢰할 수 있음. 그리고 서버에서 받은 랜덤 데이터와 클라이언트에서 생성했던 랜덤 데이터를 조합해여 `pre master secret`를 생성함. 이 키는 세션단게에서 데이터를 주고 받을때 암호화 하기 위해 사용됨! 또한 을션에선 대칭키 방식으로 작동하기 때문에 절대 유출되면 안됨. 이 `pre master secret`을 인증서 안에 들어있는 서버의 `public key`로 암호화하여 서버로 전송함. 
![client key exchange packet](/image/TLSv1.2-client-key-exchange.png)
4. 서버는 클라이언트가 전송한 `pre master secret` 값을 자신의 `private key`로 복호화함. 복호화에 성공하면 신뢰할 수 있다는게 되며 서버와 클라이언트 모두 `pre master secret`을 공유함. 양 측에서 `pre master secret`을 일련의 과정을 거쳐 `master secret`으로 만들고, 이를 기반으로 `session key`를 생성함. 
![server key exchange](/image/TLSv1.2-server-key-exchange.png)
![server handshake message](/image/TLSv1.2-server-handshake-msg.png)
5. Handshake 과정이 끝나며 종료되었음을 서로에게 알림.

+) 첨부한 wireshark 패킷 캡쳐 이미지와 내용이 다소 차이 있지만 흐름은 같으며 차이는 대략적으로 다음과 같음.
- Encrypted Handshake Message가 오고 가면서 Handshake 과정이 끝남을 알리는것임.
- Server Hello 과정과 Certificate 전송 과정이 별개임
- `pre master secret`를 언급했는데, 이는 Server|client key exchange 과정에서 EC Diffie-Hellman server|client params ([ECDH란?](https://en.wikipedia.org/wiki/Elliptic-curve_Diffie%E2%80%93Hellman))이 전달되는 과정에서 x축들이 `pre master secret`가 됨. [링크 참고](https://crypto.stackexchange.com/questions/43290/how-is-pre-master-secret-encrypted-when-ecc-is-used)

### TLSv1.3의 Handshake

TLSv1.3에서는 TLSv1.2에서 두번 왕복해야 했던 것을 한번으로 압축함. 

- client hello에서 연결에 사용될 cipher를 추측하고 그에 대한 키를 공유함.
- server hello에서는 공유된 키가 있으므로 cipher suite만 선택하면 키를 생성할 준비가 완료 되므로 server hello, key share, 암호화된 인증서, finish 메시지를 보냄.
- 클라이언트는 이 정보들을 받아서 공유된 키로 키를 생성하고, 인증서를 확인한뒤 finish가 됨. 바로 HTTP 요청을 보낼 수 있어짐!

![TLSv1.3 wireshark](/image/TLSv1.3-wireshark-flow.png)
>wireshark로 naver.com에 접속할 때 TLSv1.3 flow

![TLSv1.2 cloudflare](/image/cloudflare-TLS1.2.png)
>cloudflare TLSv1.2 flow

![TLSv1.3 cloudflare](/image/cloudflare-TLS1.3.png)
>cloudflare TLSv1.3 flow

# Reference

[TLS v1.3 RFC Document](https://datatracker.ietf.org/doc/html/rfc8446)

[TLS v1.2 RFC Document](https://datatracker.ietf.org/doc/html/rfc5246)

[A detailed look at RFC 8446(TLS 1.3) cloudflare 블로그](https://blog.cloudflare.com/rfc-8446-aka-tls-1-3/)

[TLS 1.3 overview cloudflare 블로그](https://blog.cloudflare.com/tls-1-3-overview-and-q-and-a/)

[TLS wikipedia](https://en.wikipedia.org/wiki/Transport_Layer_Security)

[TLS 영문 블로그](https://hpbn.co/transport-layer-security-tls/)

[생활코딩 SSL/TLS](https://opentutorials.org/course/228/4894)

[TLS 상세설명 영문 블로그](https://hpbn.co/transport-layer-security-tls/)
