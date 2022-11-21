# Reentrant vs Thread-Safety

> 정의하는 곳마다 내용이 살짝 달라지기도 하고, reentrant 는 과거에 자주 쓰이던 개념...임

함수는 reentrant 할 수도 있고, thread-safe 할 수 있으며, 둘 다 일 수 있고, 둘 다 아닐 수도 있다.

## Reentrant code

여러개의 thread가 코드를 동시에 수행할 수 있고, 의도한대로 작동하는 코드.

이를 위해선 공유하는 자원을 사용하면 안되며, 내부에서도 reentrant 한 함수만 call 해야 한다. (static, global 사용 불가)

또한, OS 에 의하여 자기 자신의 코드가 변경되면 안된다. [self-modifying code 참조](https://en.wikipedia.org/wiki/Self-modifying_code)

sharable code 라고도 불림.

Interrupt latency refers to the period of time from the arrival of an interrupt at the CPU to the start of the routine that services the interrupt. When an interrupt occurs, the operating system must first complete the instruction it is executing and determine the type of interrupt that occurred. It must then save the state of the current process before servicing the interrupt using the specific interrupt service routine (ISR).

## Thread-Safe code

여러개의 thread 에 의해 코드가 실행 되더라도 의도한대로 작동하는 코드.

이는 공유 자원을 사용할때 적절히 lock 를 거는 방식으로 구현된다.

구현하는 방법으로는

1. 공유 자원을 피하는 방법 - reentrant, thread-local, immutable object 를 사용
2. 공유 자원을 동기화 하는 방법 - Mutex, Atomic 가 있음

[libc 라이브러리 함수들의 thread-safety](https://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html#tag_15_09_01)

# Reference

[reentrant wikipedia](<https://en.wikipedia.org/wiki/Reentrancy_(computing)>)

[reentrant function stackoverflow 답변](https://stackoverflow.com/questions/2799023/what-exactly-is-a-reentrant-function)

[thread-safe vs reentrant](https://stackoverflow.com/questions/856823/threadsafe-vs-re-entrant)

[qt 라는 회사의 문서 threads-reentrancy ](https://doc.qt.io/qt-6/threads-reentrancy.html)

[thread-safe vs reentrant 한국 블로그](https://yesarang.tistory.com/214)
