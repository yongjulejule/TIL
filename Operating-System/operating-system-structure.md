# operating-system-structure

![os-structure](/image/os-structure.png)

os마다 차이가 있지만 보통 위와 비슷한 구조임.

- service 부분은 유저에게 도움이 되는 기능들을 제공함
- system call 부분은 시스템 자체의 운영을 효율적으로 할 수 있게 해줌
	- 일반적으로 c나 c++ 함수로 제공되며, 몇몇 기능은 asm으로 사용해야함(직접적으로 하드웨어에 접근할시)
- user interface는 유저를 위한 인터페이스

## Reference
> _Abraham Silberschatz , Greg Gagne & Peter B. Galvin (2018). Operating System Concepts (10th ed.) U.S. : willy_


