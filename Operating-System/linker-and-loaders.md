# Linkers and Loaders

일반적으로, 프로그램은 disk에 binary executable file 으로 존재한다. CPU에서 실행하기 위해선, 프로그램이 메모리에 올라와야 하고 프로세스의 context에 배치되어야 한다. 

1. source 파일은 physical memory에 load 되도록 설계된 object file으로 컴파일 되며, "relocatable object file" 으로 알려진 형식이다. 
2. `linker` 는 "relocatable object file" 을 하나의 "executable file" 로 변환한다. 여기서 다른 object file이나 library file가 포함될 수 있다.
3. `loader` 는 "executable file" 을 메모리에 load 한다. 

linking 과 loading 에 관련된 활동은 프로그램 부분에 최종 주소를 할당하고 예를 들어 코드가 실행될 때 라이브러리 함수를 호출하고 해당 변수에 액세스할 수 있도록 프로그램의 코드 및 데이터의 주소를 조정하는 "relocation" 이다.

이러한 과정을 거친 뒤, 쉘에서 `./a.out` 을 실행하면, 쉘에 `fork()` 를 호출하여 프로세스를 생성하고, `exec()` 를 호출하여 `loader` 가 프로그램을 메모리에 load 하게 한다.

## Reference

> _Abraham Silberschatz , Greg Gagne & Peter B. Galvin (2018). Operating System Concepts (10th ed.) U.S. : willy_
