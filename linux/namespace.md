# namespace

mam 7 namespaces

>네임스페이스는 global system resource를 추상화하여 네임스페이스 내의 프로세스에 고유한 global resource 인스턴스가 있는 것처럼 보이게 함. global resource 에 대한 변경 사항은 해당 네임스페이스의 구성원인 다른 프로세스에는 표시되지만 다른 프로세스에는 표시되지 않음. 네임스페이스를 활용하는 대표적인 예는 컨테이너가 있음

리눅스는 다음과 같은 네임스페이스들을 제공함

```
Namespace   Constant          Isolates
 Cgroup      CLONE_NEWCGROUP   Cgroup root directory
 IPC         CLONE_NEWIPC      System V IPC, POSIX message queues
 Network     CLONE_NEWNET      Network devices, stacks, ports, etc.
 Mount       CLONE_NEWNS       Mount points
 PID         CLONE_NEWPID      Process IDs
 User        CLONE_NEWUSER     User and group IDs
 UTS         CLONE_NEWUTS      Hostname and NIS domain name
```

그리고 프로세스 별 네임스페이스는 `ls -l /proc/<pid>/ns` 로 확인할 수 있음.

![linux namespace](/image/linux-namespace-example.png)

일반적인 프로세스는 `init process (pid 1)`과 네임스페이스를 공유함.

![linux namespace compare 1](/image/linux-namespace-comp1.png)

docker로 컨테이너를 생성하여 비교해보면 서로 다름!

![linux namespace compare 2](/image/linux-namespace-comp2.png)

(pid 8839 : docker로 구동한 컨테이너의 pid 1에 해당하는 프로세스)

## Cgroup Namespace

### Cgroup

man 7 cgroups

>cgroups(control cgroups)는 리눅스 커널 기능으로 프로세스를 계층적 그룹으로 구성하여 다양한 유형의 리소스 사용을 제한하고 모니터링할 수 있음. 커널의 cgroup 인터페이스는 cgroupfs라는 pseudo-filesystem을 통해 제공됨. grouping은 코어 cgroup 커널 코드에서 구현되는 반면 리소스 추적과 제한은 리소스 유형별 sub-systems(메모리, CPU 등)에서 구현됨.

요약하면, 프로세스들의 리소스 사용량을 제한, 모니터링, 격리할 수 있는 linux kernel 기능임.

![linux cgroup fs](/image/linux-cgroup-fs.png)

이와 같이 어떻게 구성되어 있는지 확인할 수 있음!

결국 namespace는 무엇을 볼 수 있는지를 정해주고 cgroup는 무엇을 사용할 수 있는지 정해줌!

[cgroup 한글 블로그](https://sonseungha.tistory.com/535)

[redhat cgroup 문서](https://access.redhat.com/documentation/ko-kr/red_hat_enterprise_linux/6/html/resource_management_guide/ch01)

[nginx cgroup & namespace 문서](https://www.nginxplus.co.kr/doc/guide/what-are-namespaces-cgroups-how-do-they-work/)

### Cgroup namespace

Cgroup 자체로 격리가 가능하지만, process의 cgroup 뷰를 가상화한게 cgroup namespace임. 각 cgroup namespace는 cgroup root directory를 가지게 되며 이 root directory는 `/proc/<pid>/cgroup` 파일에 표시되는 상대 경로의 기준점이 됨... 잘 모르겠다

아마 여기에 해당하는 cgroup에 영향을 미치는듯

![proc cgroup](/image/linux-proc-cgroup.png)

man 7 cgroup_namespaces 참조

## IPC Namespace

IPC Namespace는 특정 IPC 자원(system V의 IPC object나 POSIX의 Message Queue)을 격리한다. 각 IPC Namespace는 자기만의 IPC object를 갖고 있고, 이 object는 동일한 namespace에 있으면 볼 수 있으며 다른 namespace에선 볼 수 없음.

POSIX Message Queue의 경우 `/proc/sys/fs/mqueue`에서 확인할 수 있음.

IPC namespace가 사라질때, (이 네임스페이스의 마지막 프로세스가 종료되었을때) 해당 IPC object는 자동으로 제거됨.

## network namespace

network namespace는 네트워킹에 관련된 시스템 자원을 격리하여 제공함. network device, ip protocol stack, IP routing table, 방화벽, /proc/net 디렉토리, 포트넘버 등등이 이런 자원에 해당함.

물리적인(physical) 네트워크 장치는 정확히 하나의 네임스페이스에서만 존재할 수 있고, 만약 물리적 네트워크 장치를 사용하는 network interface가 사라지면, initial network namespace로 돌아감.

물리적 네트워크가 없는 network namespace는 가상 네트워크에 물리적 네트워크로 bridge를 걸어서 사용할 수 있음.

## mount namespace

mount namespace는 각 네임스페이스의 프로세스가 볼 수 있는 독립된 마운팅 포인트의 리스트를 제공함. 따라서 네임스페이스의 프로세스는 또렷한 하나의 디렉토리 계층을 볼 수 있게됨.

자세한 내용은 man 7 mount_namespaces 참조

## pid namespace

PID namespace는 pid 숫자의 space를 격리시키며, 따라서 서로 다른 네임스페이스에 있다면 pid가 중복될 수 있음. 새로운 pid namespace의 pid는 1부터 시작하고, 독립된 시스템으로 작동하며 `fork`, `vfork`, `clone`을 통해 프로세스를 생성하여 네임스페이스 내에서 중복되지 않는 pid를 생성할 수 있음.

이렇게 만들어진 새로운 네임스페이스는 디폴트 네임스페이스에 동시에 속하게 되어, 디폴트 네임스페이스에서는 두개의 pid를 가진 샘이 됨.(default의 pid, new namespace의 pid)

간단한 예시)

`unshare --fork --pid --mount-proc bash` 커맨드로 pid 네임스페이스를 만들자.

![create pid namespace](/image/linux-pid-namespace-create.png)

새로운 pid namespace에서 pid 1번은 디폴트 네임스페이스에서 pid 4702번이 할당됨. (이미지의 NSpid 참조)

![new pid process status](/image/linux-pid-namespace-status.png)

`readlink /proc/<pid>/ns/pid` 커맨드로 pid 네임스페이스의 링크를 조회해보자.

![pid namespace compare](/image/linux-pid-namespace-compare.png)

이렇게 간단히 분리된 Pid 네임스페이스를 만들 수 있음.

nsenter(namespace enter) 커멘드를 통해 네임스페이스에 들어갈 수 있으며 이는 `docker exec`과 유사함

![pid namespace enter](/image/linux-pid-namespace-nsenter.png)
> host에서 pstree로 컨테이너 프로세스의 process tree를 확인하고, nsenter를 통하여 네임스페이스 안에서 pstree를 확인해보면 다른것을 확인해 볼 수 있음.

## User namespace

User namespace는 보안에 관련된 identifier와 attribute를 격리시킴. 특히 user id, group id, root directory, keys (man 7 keyrings), capabilities (man 7 capabilities)가 해당됨. 프로세스의 uid와 gid는 네임스페이스 내부와 외부에서 다를 수 있음. 특히 user namespace 내부에서 모든 권한을 갖는 프로세스여도 외부에선 그렇지 않음.

## UTS namespace

UTS namespace는 hostname과 [NIS](/linux/namespace.md#nis-network-information-service) domain name을 격리시킴. 

### NIS (Network Information Service)

네트워크 상의 컴퓨터 간에 유저 및 호스트 이름 같은 시스템 구성 데이터를 배포하기 위한 프로토콜. 중요한 시스템 데이터 파일을 네트워크를 통하여 공유하여 관리자와 사용자들에게 일관성 있는 환경을 제공함.

[NIS 사용 예시](http://www.linuxlab.co.kr/docs/98-03-4.htm)


# References

[linux namespace의 모든것 (영문)](https://windsock.io/using-linux-namespaces-to-isolate-processes/)

[linux namespace 블로그](https://www.44bits.io/ko/keyword/linux-namespace)

[linux namespace wikipedia](https://en.wikipedia.org/wiki/Linux_namespaces)