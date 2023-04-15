# mariadb-for-container

mariadb config 파일과 docker container로 운용하기 위한 설정

- `skip-network` : skip-network가 설정되어 있으면 소켓으로만 통신하고, 꺼져있으면 ip를 이용해서 통신함
- `bind-address` : 통신을 허용할 ip를 지정해줌. (유저 권한이랑 별개임!)
- `port` : 포트를 지정해줌 (기본값:3306)
- `datadir` : DB의 루트 디렉토리
- `basedir` : DB가 설치되는 디렉토리. 모든 디렉토리는 이 디렉토리 기준의 상대경로로 정해짐
- `default-time-zone` : 타임존 설정
- `user` : 디폴트 유저 설정
- `log-error` : 에러 로그 디렉토리 설정
- `log-warnings` : 에러 로그 레벨 설정 (클수록 높으며 0~11까지 있고, 기본값:2)

`/usr/bin/mysqld_safe` : mariadb daemon을 시작하는 명령어. Debian이나 RPM같이 systemd를 지원하는 리눅스에서는 설치되지 않음. (mariadb 공식 문서 추천)

## MariaDB를 위한 도커 이미지

`MariaDB`를 로컬에서 직접 설정하려면 `config` 작성, `DB init`, `systemctl` 같은 도구들을 활용하여 하나하나 설정하면 되지만, 도커 이미지를 만들어서 컨테이너로 사용하려면 이 모든 작업이 자동으로 이루어져 유저가 바로 사용할 수 있어야 하고, 최대한 경량화 하는게 좋음.

`Alpine Linux`를 사용하기 때문에 `systemctl`같은 `Mariadb Daemon`을 다루는 도구가 없고, `alpine`에서 `openRC`라는 패키지가 `systemctl`을 대체하는데 도커 `base` 이미지로 받아오는 `alpine linux` 이미지에는 이 패키지도 안깔려있음. 따라서 직접 `mysqld(mariadbd)`를 이용하여 서버를 열어야 함! 

`Dockerfile instruction` 을 이용하여 필요한 `MariaDB` 패키지를 다운받고, 쉘 스크립트에서 초기 DB install을 진행함. 이때 컨테이너 특성상 원격으로 DB에 접근하게 될텐데, root 유저로 원격에서 접근하는 것은 보안상 문제가 있으므로 이 단계에서 유저와 DB를 만들고 적절한 권한을 줘아함.

### mysqld_safe의 함정

`Mariadb` 공식 문서에서 `Mariadb daemon`을 가동시키는 방법으로 `mysqld_safe(mariadbd_safe)`을 사용하길 추천하는데, `mysqld_safe`는 자식 프로세스로 `mariadbd`를 실행하고, 해당 프로세스를 관리해주는 역할을 함. 이때 `SIGTERM`이나 `SIGQUIT`같은 시그널을 받으면 자식인 `mariadbd`에 넘겨서 잘 종료되게 한 뒤 재시작을 시켜버림. 

`Docker`로 `MariaDB container`를 관리하는 입장에서는, 서비스를 종료하고 싶을때 `signal`을 보내도 계속 살아나니 결국 `SIGKILL`으로 `MariaDB container` 를 강제종료 시켜서 이는 예상치 못한 문제를 낳을 수 있음! 따라서 `mariadbd`로 실행을 해야함.