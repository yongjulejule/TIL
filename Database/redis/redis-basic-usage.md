# redis-basic-usage

`EXISTS name`

- name이 존재하는지 확인. boolean 값으로 나옴

`KEYS *` 

- 이렇게 패턴으로 입력하면 매칭되는 값들이 모두 나옴

`FLUSHALL`

- 싹다 삭제

`TTL name`

- key=name의 time to live.
- -1이면 영영 안사라진다는 뜻
- -2면 이미 만료되었다는 뜻
- 모든 key값에 대하여 적용할 수 있음

`EXPIRE name 10`

- key=name의 만료 시간을 10초 뒤로 줌.
- `TTL name` 을 하면 남은 시간이 초로 뜸

`GET name` 

- name이라는 키값에 해당하는 값을 받아옴

`DEL name` 

- name를 지움

## Redis의 자료구조

### String

`SET [key] [value]`

- key - value값 설정. expire는 defalut로 -1

`SETEX [key] [seconds] [value]`

- seconds 뒤에 만료되는 key값 설정

### List

`LPUSH friends ghan jiskim sehhong` (`RPUSH`는 오른쪽에 넣음)

- 리스트로 friends라는 키에 값들을 넣음

`LRANGE friends 0 1` 

- 리스트를 0번째부터 1번째까지 불러옴. 뒤에 숫자가 -1이면 전체

`LPOP friends` (`RPOP` 는 오른쪽)

- friends의 가장 왼쪽에 있는 아이를 삭제

가장 최근 메시지 5개 이런거 보여줄때 긴편함

### SET

javascript의 set과 같음 (unique array)

`SADD hobbies 'weight lifting'`  

- hobbies set에 ‘weight lifting’을 추가

`SMEMBERS hobbies` 

- ‘weight lifting’을 가져옴

`SREM hobbies 'weight lifting'` (rem = remove)

- hobbies의 weight lifting을 지움

### HASH

Hash 안에 Hash를 담을 순 없음

`HSET person name jule`

`HGET person name`

- person이라는 hash의 key=name, value=jule로 저장
- person이라는 hash의 key=name에 해당하는 value 출력

`HGETALL person` 

- person이라는 hash의 모든 key, value를 가져옴

`HEXISTS person name` 

- person이라는 hash에 key=name이 존재하는지 확인 (boolean)

[[Redis] Hashes 명령어 설명 및 예제](https://realmojo.tistory.com/172)

hash 자세한 설명
