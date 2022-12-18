# PostgreSQL 원격 접속 환경 구축

postgreSQL server 에 원격 접속을 하기 위해선 다음과 같은 과정이 필요하다.

1. `postgresql.conf` 에서 listen_address 설정
2. `pg_hba.conf` 에서 접속을 허용할 User, Database 및 Address 설정 (hba : host based authenticate)
3. 원격 접속시 사용할 Role(User) 및 Database 생성

---

# postgresql.conf 설정

- listen_address (string)
    - 원격 접속을 허용하기 위해선 서버가 listen 할 IP 를 명시해줘야 한다. 이는 postgresql.conf 파일의 `listen_address` directive 에서 설정할 수 있으며, 기본값은 `localhost` 이다. `*` 로 설정하게 되면 모든 IP 를 듣게 되며, `0.0.0.0` 으로 설정하면 모든 IPv4, `::` 는 모든 IPv6 에서 듣게 된다.
    - 만약 이 부분을 비워둔다면, IP 를 아무것도 듣지 않아서 `Unix-domain socket` 을 이용하여 접속해야 한다.
- port (integer)
    - 원격 접속시 사용할 포트를 명시해주며, 기본값은 `5432` 이다.
- password_encryption (enum)
    - 원격 접속시 사용하는 Role(유저) 패스워드의 암호화 방식을 나타낸다. 암호화에 대한 자세한 내용은 [링크](#password-authentication)에 나와있다.
- 이 외에도 [이곳](https://www.postgresql.org/docs/15/runtime-config-connection.html)에 다양한 설정들이 있다.

# pg_hba.conf 설정

postgreSQL 에서 Client Authentication 은 `pg_hba.conf` 파일에 따라 결정된다. (HBA 는 Host-Based Authentication 을 뜻한다.) default `pg_hba.conf` 파일은 `initdb` 로 생성되는 data 디렉토리에 생성되며, `hba_file` parameter 를 설정하여 다른 경로에 있는 `pg_hba.conf` 파일을 사용할 수 있다. 

일반적으로 `pg_hba.conf` 파일은 records 로 구성되며 각 record 는 connection type, client IP address range, database name, user name, authentication method 로 구성된다.

Record 는 다음과 같은 format 을 가진다

```
local  database  user  auth-method
host   database  user  address      auth-method
```

- `local`  은 Unix-domain socket 을 이용한 connection 을 뜻한다.
- `host` 는 TCP/IP 를 사용한 connection 이며 SSL 여부는 상관없다.
- `database` 는 사용할 데이터베이스 의 이름이다.
    - `all` 은 모든 데이터베이스를 뜻한다.
    - `sameuser` 는 요청한 user 의 이름과 같은 이름의 데이터베이스를 뜻한다.
    - `samerole` 은 요청한 user 가 요청한 데이터베이스와 동일한 이름을 가진 role 의 구성원이어야 한다.
    - `replication` 은 미러링을 통하여 다중화 할 때 사용한다고 하는데, 설명은 [링크](https://rastalion.me/postgresql-replication%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%9C-%EB%8B%A4%EC%A4%91%ED%99%94-%EA%B5%AC%EC%84%B1/) 참조, 설정 방법은 [링크](https://www.postgresql.org/docs/15/auth-pg-hba-conf.html)를 참조 해주시기 바랍니다…
- `user` 는 postgreSQL 의 role name 이다.
    - `all` 은 모든 유저를 뜻한다.
    - `all` 이 아니면, 특정 user(role) 를 기입해야 하며 `+` 가 선행되면 “이 role 의 직접, 간접적인 멤버인 아무 role” 이라는 뜻이 된다. `,` 를 이용하여 여러명의 유저를 기입할 수 있다.
- `address` 는 client 의 주소이며 값으로 host name, IP address range, 혹은 다음과 같은 special key words 가 올 수 있다.
    - `all` 은 모든 IP address 를 뜻한다.
    - `samehost` 는 서버가 가진 모든 IP address 와 매칭된다.
    - `samenet` 은 서버와 직접적으로 연결된 모든 subnet 과 매칭된다.
- `auth-method` 는 사용할 인증 방법을 뜻한다. 자세한 설명은 [이곳](https://www.postgresql.org/docs/15/auth-methods.html)에 나와있으며, 보안 상`scram-sha-256`  을 사용하였다.

이 외에도 [링크](https://www.postgresql.org/docs/15/auth-pg-hba-conf.html)를 참조하여 다양한 설정을 할 수 있다.

## Password Authentication

Password-based Authentication 방식에는 `scram-sha-256, md5, password` 가 있으며 server 에 password 가 저장되는 방식, client 가 connection 을 통하여 password 를 전송하는 방식에 영향을 미친다.

`scram-sha-256 > md5 > password` 순으로 보안이 강력하다. 더 자세한 내용은 [공식문서](https://www.postgresql.org/docs/15/auth-password.html), [RFC](https://www.rfc-editor.org/rfc/rfc7677), [wikipedia](https://en.wikipedia.org/wiki/Challenge%E2%80%93response_authentication) 에 설명되어 있다.

PostgreSQL 데이터베이스의 비밀번호는 OS 의 유저 패스워드와 분리되며 각 password 는 `pg_authid` system catalog 에 저장된다.

```sql
dev=\# SHOW password_encryption;
 password_encryption 
---------------------
 scram-sha-256
(1 row)
dev=\# CREATE ROLE sha WITH LOGIN PASSWORD 'abc';
CREATE ROLE
dev=\# SET password_encryption='md5';
SET
dev=\# SHOW password_encryption;
 password_encryption 
---------------------
 md5
(1 row)
dev=\# CREATE ROLE mdfive WITH LOGIN PASSWORD 'abc';
CREATE ROLE
dev=\# SELECT rolname, rolpassword  FROM pg_authid WHERE rolname='sha' OR  rolname='mdfive';
 rolname |                                                              rolpassword                                                              
---------+---------------------------------------------------------------------------------------------------------------------------------------
 sha     | SCRAM-SHA-256$4096:HuVfcOi6gS3qSgPWYpN6rw==$s92Dl0LIbaluL1qhdat7zsiGMbk9vAc1o6c3wjySMbc=:mABZFmlbs4FJM9cQLfc3gYWURmKj///Kmmf5PbvH/Yk=
 mdfive  | md52f9f868b4f4f040ae489d127376805f5
(2 rows)
```

암호화 방식을 변경해가며 유저를 생성하고 패스워드를 설정하면, 다른 방식으로 저장되는 것을 확인할 수 있다.

# postgreSQL Role 설정

PostgreSQL 은 데이터베이스의 접근 권한을 `role` 이라는 컨셉으로 관리한다. `role` 어떻게 설정 하는지에 따라 데이터베이스의 유저처럼 될 수 있고, 유저들이 모인 그룹이 될 수도 있다. `role` 은 데이터베이스 object 를 소유하면서 다른 `role` 에게 privilege 를 할당할 수 있는 등 다양한 작업을 할 수 있다.

postgreSQL 8.1 이전에는 users 와 groups 가 명백히 구분되었지만, 이제는 role 밖에 없으며 role 이 user 나 group 의 역할을 할 수 있다.

이 외에도 방대한 설정이 [postgresql Role 설정](#postgresql-role-설정) 에 나와있다.

# Docker 에서 자동화

Docker 를 이용하여 별도의 DB 컨테이너를 띄우고, 다른 컨테이너에서 원격 접속이 되어야 해서, 위에서 설명한 원격 접속 환경을 스크립트를 이용하여 구축해야 한다. 

커넥션 할때 사용하는 host, role, database, password 등의 정보는 PostgreSQL 에 예약된 환경변수를 이용하면 간편하게 구축할 수 있다.

예를 들면, `psql --host=dev_host --port=5432 --username=dev_user --dbname=dev_db -W <type password in prompt>` 라는 명령어는 `PGHOST=dev_host; PGPORT=5432; PGUSER=dev_user; PGDATABASE=dev_db PGPASSWORD=<password>` 와 같이 환경변수가 설정되어 있다면 `psql` 하나로 끝낼 수 있다. 이 외에 다른 환경변수들은 [링크](https://www.postgresql.org/docs/current/libpq-envars.html)에 더 나와있다.

`psql -c` 옵션을 사용하면, 쉘에서 쿼리를 postgreSQL 에 실행이 가능해져서, `psql -U postgres postgres -c "CREATE ROLE ${PGUSER} NOSUPERUSER NOCREATEROLE LOGIN CREATEDB PASSWORD '${PGPASSWORD}'"` 와 같은 커멘드를 스크립트에 넣어서 컨테이너 실행 시 원격 접속을 위한 유저가 생성되게 할 수 있다.

# Reference

## postgresql.conf 설정

[20.3. Connections and Authentication](https://www.postgresql.org/docs/15/runtime-config-connection.html)

## pg_hba.conf 설정

[21.1. The pg_hba.conf File](https://www.postgresql.org/docs/15/auth-pg-hba-conf.html)

[21.3. Authentication Methods](https://www.postgresql.org/docs/15/auth-methods.html)

### Password Authentication

[21.5. Password Authentication](https://www.postgresql.org/docs/15/auth-password.html)

[postgresql 암호 인증 방식 md5을 scram-sha-256으로 바꿔 봅시다.](https://codingdog.tistory.com/entry/postgresql-%EC%95%94%ED%98%B8-%EC%9D%B8%EC%A6%9D-%EB%B0%A9%EC%8B%9D-md5%EC%9D%84-scram-sha-256%EC%9C%BC%EB%A1%9C-%EB%B0%94%EA%BF%94-%EB%B4%85%EC%8B%9C%EB%8B%A4)

## postgresql Role 설정

[Chapter 22. Database Roles](https://www.postgresql.org/docs/15/user-manag.html)

Role 에 대한 설명

[22.2. Role Attributes](https://www.postgresql.org/docs/15/role-attributes.html)

Role 이 가질 수 있는 Attribute

[22.3. Role Membership](https://www.postgresql.org/docs/15/role-membership.html)

Role 에 Membership 을 설정하는 방법

[CREATE ROLE](https://www.postgresql.org/docs/current/sql-createrole.html)

Role 을 생성하는 방법

[5.7. Privileges](https://www.postgresql.org/docs/current/ddl-priv.html)

권한 설정 문서

## docker 에서 자동화

[34.15. Environment Variables](https://www.postgresql.org/docs/current/libpq-envars.html)

[20.2. File Locations](https://www.postgresql.org/docs/15/runtime-config-file-locations.html)

custom conf 설정 하는 방식
