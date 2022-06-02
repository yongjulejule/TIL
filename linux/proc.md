# proc

리눅스의 `/proc` 디렉토리에 관하여

`/proc` 디렉토리는 `proc` 파일시스템이 마운트된 디렉토리임. 보통 시스템에 의해 자동으로 마운트되며 수동으로 하려면 `mount -t proc proc /proc` 와 같은 방식으로 마운트 할 수 있음.

`proc` 파일시스템은 커널 data structure에 대한 인터페이스를 제공함. 커널에 대한 방대한 정보를 파일별로 저장할 수 있으며 `/proc/<pid>` 디렉토리에 각 프로세스에 대한 정보가 담겨있음.

![proc directory](/image/proc-dir.png)

프로세스별로 메모리 정보, 시스템콜, 네트워크 정보, 유저, 환경변수, 네임스페이스 등 많은 정보가 있으며 이를 이용하여 시스템의 상태를 추적할 수 있음.

![proc pid directory](/image/proc-pid-dir.png)

네트워크, 메모리, 마운트, 그룹, 해당 프로세스를 실행한 커멘드 등등이 있음.

각 세부 내용은 `man 5 proc` 참조.

[한국어로 정리된 블로그](http://egloos.zum.com/powerenter/v/10949008)

[cat /proc/<pid>/status 예시](/linux/proc-status.md)