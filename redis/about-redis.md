# about-redis

in-memory database. RAM에 저장되며 일정 주기로 디스크에 백업하는 형태(`/path/to/backup/dump.rdb`). 따라서 성능이 훨씬 더 좋음.
종료시 `dump.rdb`파일에 저장되어 종료되어도 데이터 유지 가능.

dump.rdb라는 파일을 기반으로 데이터를 유지하는데, 이는 conf에서 디렉토리 설정가능