# MariaDB

`MariaDB`는 `RDBMS`(관계형 데이터베이스)로 `MySQL`에서 떨어져 나온 거임. `MySQL`이 `Oracle`에 인수되면서 상업적 이용을 위해선 비용을 지불해야 했고, 이를 맘에 안들게 여긴 `MySQL`의 핵심 창업자 Monty씨가 나와 동료들과 `MySQL`의 코드 베이스를 이용하여 만든게 `MariaDB`(5.5버전 기준으로 포크해서 만들음). `MariaDB`는 현재도 오픈소스로 유지되고 있음. [디비 랭킹 사이트](https://db-engines.com/en/ranking)

`MySQL`과 완벽한 호환성을 위하여 `MySQL` 관련 바이너리를 실행해도 `MariaDB`가 돌아가게 할 수 있음.

분리된 시점이 어느정도 지난 만큼 내부 구조나 성능에 차이가 있긴 함! ([MariaDB vs mysql](https://www.guru99.com/mariadb-vs-mysql.html#:~:text=MariaDB%20has%2012%20new%20storage,in%20MySQL%2C%20replication%20is%20slower.))

## MariaDB를 위한 도커 이미지

`MariaDB`를 로컬에서 직접 설정하려면 `config` 작성, `DB init`, `systemctl` 같은 도구들을 활용하여 하나하나 설정하면 되지만, 도커 이미지를 만들어서 컨테이너로 사용하려면 이 모든 작업이 자동으로 이루어져 유저가 바로 사용할 수 있어야 하고, 최대한 경량화 하는게 좋음.

`Alpine Linux`를 사용하기 때문에 `systemctl`같은 `Mariadb Daemon`을 다루는 도구가 없고, `alpine`에서 `openRC`라는 패키지가 `systemctl`을 대체하는데 도커 `base` 이미지로 받아오는 `alpine linux` 이미지에는 이 패키지도 안깔려있음. 따라서 직접 `mysqld(mariadbd)`를 이용하여 서버를 열어야 함! 

`Dockerfile instruction` 을 이용하여 필요한 `MariaDB` 패키지를 다운받고, 쉘 스크립트에서 초기 DB install을 진행함. 이때 컨테이너 특성상 원격으로 DB에 접근하게 될텐데, root 유저로 원격에서 접근하는 것은 보안상 문제가 있으므로 이 단계에서 유저와 DB를 만들고 적절한 권한을 줘아함.

### mysqld_safe의 함정

`Mariadb` 공식 문서에서 `Mariadb daemon`을 가동시키는 방법으로 `mysqld_safe(mariadbd_safe)`을 사용하길 추천하는데, `mysqld_safe`는 자식 프로세스로 `mariadbd`를 실행하고, 해당 프로세스를 관리해주는 역할을 함. 이때 `SIGTERM`이나 `SIGQUIT`같은 시그널을 받으면 자식인 `mariadbd`에 넘겨서 잘 종료되게 한 뒤 재시작을 시켜버림. 

`Docker`로 `MariaDB container`를 관리하는 입장에서는, 서비스를 종료하고 싶을때 `signal`을 보내도 계속 살아나니 결국 `SIGKILL`으로 `MariaDB container` 를 강제종료 시켜서 이는 예상치 못한 문제를 낳을 수 있음! 따라서 `mariadbd`로 실행을 해야함.