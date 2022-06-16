# proc-status

`cat /proc/pid/status` 파일은 다음과 같이 출력됨 (uid=1000, gid=1000으로 실행한 bash 프로세스임)

```bash
Name:   bash # 실행된 프로세스의 이름
Umask:  0022 # 실행된 프로세스의 실행 권한
State:  S (sleeping) # 프로세스의 상태
Tgid:   4083 # 쓰레드의 그룹 id이며, 이는 pid와 같음! (main thread로 프로세스가 실행되며 main thread에서 생성된 thread는 같은 그룹 id를 지님)
Ngid:   0 # numa group id (man 7 numa)
Pid:    4083 # 프로세스 id
PPid:   1975 # 부모 프로세스 id
TracerPid:      0 # 이 프로세스를 추적하는 프로세스 id. 없으면 0
Uid:    1000    1000    1000    1000 
Gid:    1000    1000    1000    1000
FDSize: 256
Groups: 27 33 123 1000 
# NS는 namespace를 의미함. 가장 왼쪽의 값은 reading processd의 id가 되고, 따라오는 값들은 successively nested inner namespace의 값들이 됨.
# 예를들어, docker로 실행한 컨테이너 내부의 프로세스는 다른 네임스페이스를 갖고 있기 때문에, "NStgid: 8755    7" 와 같이 출력됨. (현재 프로세스에선 8755, 컨테이너 내부에선 7)
NStgid: 4083 # Namespace의 thread group id
NSpid:  4083 # Namespace의 process id
NSpgid: 4083 # Namespace의 process group id
NSsid:  4083 # Namespace의 session id
# Vm은 virtual memory를 뜻함
VmPeak:    11344 kB 
VmSize:    11312 kB
VmLck:         0 kB
VmPin:         0 kB
# resident set size는 실제로 RAM에 올라와있는 메모리. (나머지는 filesystem이나 swap에 있음)
VmHWM:      8360 kB # Peak resident set size
VmRSS:      8360 kB # Resident set size. (밑 Rss*의 합으로 계산됨)
RssAnon:            4436 kB # anon: anonymous memory
RssFile:            3924 kB
RssShmem:              0 kB
VmData:     4460 kB
VmStk:       132 kB # stack segment
VmExe:       876 kB # text segment
VmLib:      1600 kB # shared library code size
VmPTE:        56 kB # page table entry size
VmSwap:        0 kB
HugetlbPages:          0 kB # HUGE Translation Lookaside Buffer 
CoreDumping:    0
Threads:        1
SigQ:   0/70621 # signal Q
# 아래 값들은 16진수로 표현되는데, 비트마스킹이기 때문에 2진수로 변환하여 값을 읽을 수 있음.
# SigIgn: 0000000000380004 는 해당 숫자를 2진수로 변환하면 11 1000 0000 0000 0000 0100가 되는데, 3번, 20번, 21번, 22번 시그널이 ignore 된거임
SigPnd: 0000000000000000 # pended signal
ShdPnd: 0000000000000000 # shared pended signal
SigBlk: 0000000000010000 # blocked signal
SigIgn: 0000000000380004 # ignored signal
SigCgt: 00000001cb817efb
# capabilities에 대한 설정. 권한을 세분화하여 일부 권한을 넘겨줄 수 있는것.
# 자세한 내용은 밑의 링크 및 man 7 capabilities 참고
CapInh: 0000000000000000
CapPrm: 0000000000000000
CapEff: 0000000000000000
CapBnd: 0000003fffffffff
CapAmb: 0000000000000000
# prctl의 no_new_privs 비트 설정
# man 2 prctl 참조
NoNewPrivs:     0
# seccomp 의 비트 설정
# man 2 seccomp 참조
Seccomp:        0
Speculation_Store_Bypass:       vulnerable # ??
# cpu / memory 설정. 프로세스에 cpu와 memory를 특정 node의 subset만큼 한정하는것
# mem 7 cpuset 참조
Cpus_allowed:   f
Cpus_allowed_list:      0-3
Mems_allowed:   00000000,00000001
Mems_allowed_list:      0
# context switching 횟수
voluntary_ctxt_switches:        8525
nonvoluntary_ctxt_switches:     5542
```

TODO: Docker container process의 status 추가하기

[session id 정리](https://mug896.github.io/bash-shell/session_and_process-group.html)
[resident set size](https://en.wikipedia.org/wiki/Resident_set_size#:~:text=In%20computing%2C%20resident%20set%20size,the%20executable%20were%20never%20loaded.)
[Huge tlb](https://access.redhat.com/documentation/ko-kr/red_hat_enterprise_linux/6/html/performance_tuning_guide/main-memory)
[capabilities](http://egloos.zum.com/studyfoss/v/5338802)
[자발적 / 비자발적 컨텍스트 스위칭](https://jeongchul.tistory.com/94)