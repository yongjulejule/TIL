# Transaction Isolation

Isolation Level 은 SQL-transaction 이 concurrent 하게 실행될 때 발생할 수 있는 현상(phenomena)의 종류에 따라 정의한 것임.

다음과 같은 현상이 가능함.

1. Dirty Read: 트렌잭션 T1 과 T2 가 있을 때, T1 이 데이터를 변경하고 아직 커밋하지 않았는데 T2 가 변경된 데이터를 읽는 것. T1 이 만약 롤백된다면, T2 가 읽은 데이터는 더 이상 유효하지 않음.
2. Non-Repeatable Read: 트랜잭션 T1 이 데이터를 읽고 있을 때, T2 가 데이터를 변경하고 커밋하는 것. T1 이 같은 데이터를 다시 읽었을 때, 데이터가 변경되어 있음.
3. Phantom: 트랜잭션 T1 이 데이터를 읽고 있을 때, T2 가 데이터를 삽입하고 커밋하는 것. T1 이 같은 데이터를 다시 읽었을 때, 데이터가 추가되어 있음.

ANSI/ISO standard SQL 92 에선 다음과 같은 4가지의 트랜잭션 격리 수준을 정의하고 있다. 

- READ UNCOMMITTED
- READ COMMITTED
- REPEATABLE READ
- SERIALIZABLE

이러한 격리 수준은 concurrent 한 SQL transaction 의 SQL 데이터 또는 스키마에 대한 작업이 다른 transaction 에 의해 어떻게 영향을 주고 받는지를 정의한다.

| Isolation Level | Dirty Read | Non-Repeatable Read | Phantom Read |
| --- | --- | --- | --- |
| READ UNCOMMITTED | O | O | O |
| READ COMMITTED | X | O | O |
| REPEATABLE READ | X | X | O |
| SERIALIZABLE | X | X | X |

## references

- [sql 1992 문서](https://www.contrib.andrew.cmu.edu/~shadow/sql/sql1992.txt)
- [sql isolation wikipedia](https://en.wikipedia.org/wiki/Isolation_(database_systems))
- [postgreSQL transaction isolation](https://dev.mysql.com/doc/refman/8.0/en/innodb-transaction-isolation-levels.html)
- [MySQL transaction isolation](https://www.postgresql.org/docs/current/transaction-iso.html)
