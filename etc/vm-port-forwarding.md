# vm-port-forwarding

호스트 머신에서 이미 사용중인 포트를 VirtualBox에서 포워딩하면 어떻게 될까? 란 의문을 해결하기 위한 과정을 기록.

> 맥의 아이피: `10.12.8.8`

1. VirtualBox에서 `0.0.0.0:42424->0.0.0.0:443`으로 포트포워딩 설정
2.  `net-server HTTP port 42424 host localhost` 커맨드로 임시 서버를 실행
3. `localhost:42424`로 접속하면 임시 서버에 연결되고, `10.12.8.8:42424`로 접속하면 VirtualBox에 접속됨.
   - `ip monitor all`이란 명령어로 머신 내 네트워크에 접속하는 정보를 확인할 수 있음.(macOS에는 존재하지 않는 커맨드)

---

1. `net-server HTTP port 42424 host 10.12.8.8` 커맨드로 임시 서버를 실행
2. VirtualBox에서 `10.12.8.8:42424->0.0.0.0:443`으로 포트포워딩 설정
3. `lsof -i tcp -n` 커맨드로 확인해보면 VirtualBox의 해당 포트포워딩이 무시된것 확인 가능
4. 임시 서버를 닫아도, VirtualBox에 포트 포워딩이 작동하지 않음
5. VirtualBox을 재부팅 해야 포트포워딩이 다시 작동함...!

---

1. VirtualBox에서 `10.12.8.8:42424->0.0.0.0:443`으로 포트포워딩 설정
2. `net-server HTTP port 42424 host 10.12.8.8` 커맨드로 임시 서버를 실행
3.  이미 VirtualBox가 해당 port를 listen하는 상태이므로 임시 서버 실행에 실패함.

## 결론

포트는 먼저 실행된 프로세스가 가져감. 하지만 VirtualBox에선 포트포워딩에 문제가 있어도 정상적으로 실행됨...! 호스트 머신에서 `lsof -i tcp -n | grep Virtual` 같은 방식으로 포트 상태를 체크할 수 있음.