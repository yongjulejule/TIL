# node debugging

# 디버깅
- `node --inspect` 옵션으로 서버를 실행하거나, 프로세스에 `USR1`  시그널을 날려서 디버깅 모드를 실행한다.
- 디버깅 모드로 진입 시 노드는 디버깅 클라이언트를 위하여  `ws://127.0.0.1:9229/{uuid}` 로 listen 을 시작한다.
- 디버깅 클라이언트로는 chrome devtool 이나 IDE 를 사용할 수 있으며, chrome 의 경우 chrome://inspect 에 접속하여 inspect 를 시작할 수 있다.

# 메모리

## 힙 프로파일러

## 힙 스냅샷

## GC 

# Reference

https://nodejs.org/en/docs/guides/debugging-getting-started
https://nodejs.org/en/docs/guides/diagnostics
https://nodejs.org/en/docs/guides/diagnostics/memory
