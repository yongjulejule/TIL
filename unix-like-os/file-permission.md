# file-permission

unix-like 시스템에서 대부분의 파일은 read, write, execute 권한으로 나뉘어져 있고 소유자 / 그룹 / other에 대한 권한이 부여됨.

read, write, execute은 각각 4, 2, 1의 숫자로 표현되며 763권한이면 `rwxrw--wx`의 형태로 표현됨.

![general-file-permission](/image/general-file-permission.png)

특수한 권한(SUID, SGID, sticky bit)이 설정되는 경우가 있음. (일부 시스템에서 passwd나 /tmp 디렉토리)

## SUID

SUID의 S는 set라는 의미를 가지며, 해당 파일을 실행할 때 파일의 소유주 권한이 설정되어서 실행됨.

예를들어, `passwd`란 파일의 소유주가 root이고, `rwsr-xr-x`의 권한이 설정되어 있으면, root가 아닌 유저가 이 파일을 실행할때 `root`로 실행하게 되는거임. 이때, 파일의 소유자에게도 execute 권한이 없으면 `rwSr-x-r-x`와 같이 대문자 S로 표현이 되며 실행이 불가능함.

SUID에 해당하는 권한은 `4000`이라서, `rwsr-x-r-x`같은 경우 `4766`으로 표현하고, `chmod 4766 filename`로 권한을 적용시킬 수 있음. SUID 권한만 주고 싶다면 `chmod u+s filename` 커맨드를 사용하면 됨.

**일반 유저가 root로 파일을 실행할 수 있기 때문에 보안 문제를 잘 고려해서 설정해야함!**

## SGID

SGID의 S 역시 set이라는 의미이며, 해당 파일을 실행할 때 파일 소유주의 그룹 권한이 설정되어서 실행됨.

사용방법 역시 SUID와 동일하며 SGID에 해당하는 권한은 `2000`임. `chmod 2000 filename` 이나 `chmod g+s filename` 커맨드로 권한 적용 가능.

**일반 유저가 root로 파일을 실행할 수 있기 때문에 보안 문제를 잘 고려해서 설정해야함!**

## sticky bit

`sticky bit`는 주로 디렉토리에 사용되며 (리눅스에서 파일에 적용하면 무시된다고 함) 소유자나 슈퍼유저만 파일들을 수정 / 이름변경 / 삭제 할 수 있음. 주로 `777` 권한 + `sticky bit`가 적용되기 때문에 다른 사용자들은 읽기, 쓰기, 실행만 가능. `/tmp` 디렉토리가 `sticky bit`를 사용하는 대표적인 예시임.

`sticky bit`에 해당하는 권한은 `1000`이며 `chmod 1777 filename` 커맨드로 권한 적용 가능.

## 예시

![special-file-permission](/image/special-file-permission.png)