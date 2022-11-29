# virtual memory

virtual memory 는 프로세스의 전체가 메모리에 올라오지 않아도, 실행할 수 있게 해주는 기술이다. physical memory 보다 더 큰 프로세스를 실행할 수 있게 해주며, main memory 를 아주 큰 일련의 배열로 추상화 하여 프로그래머가 메모리 부족에 대한 걱정을 하지 않게 해준다. 또한 shared memory 를 통하여 프로세스간에 파일이나 라이브러리를 공유하게 만들어주고 효율적으로 프로세스 생성도 가능하게 해준다.

프로세스의 virtual address space 는 메모리에 프로세스가 어떻게 저장되어 있는지에 대한 논리적인 view 를 나타낸다. 보통, 프로세스의 logical address 는 0부터 시작하며 연속적으로 메모리가 존재한다. physical memory 상에선 page frames 구조로 되어 있고 연속적이지 않지만, 이를 매칭시켜 주는 작업은 MMU 가 해준다.

## Demand paging

Demand paging 은 프로세스의 실행중, 필요한 page 만 load 하는 방식이다. 프로세스 전체를 load 하지 않아도 돼서 메모리를 효율적으로 사용할 수 있다.

이를 구현하기 위해선, 어느 페이지가 메모리에 있고, 어느 페이지가 백업 저장소에 있는지에 대한 정보를 하드웨어가 지원해야 한다. 페이지 테이블의 valid-invalid 비트로 구현할 수 있으며 valid 면 페이지가 메모리에 있으며, 프로세스의 logical address space 에 존재한다(legal 하다). invalid 면 페이지가 현재 메모리에 없거나, illegal 하다는 뜻이다. 다음과 같은 과정을 통해 demand paging 이 진행된다.

1. 메모리에 대한 참조가 valid 인지 invalid 인지 판단하기 위하여 프로세스의 내부 테이블을 체크한다. (주로 PCB 에 저장되어 있다.)
2. 만약 invalid 라면, 프로세스를 종료시킨다. valid 지만 아직 메모리에 load 되지 않았다면(page fault), page 를 가져온다. (interrupt 발생)
3. free frame 을 찾는다.
4. 이 프레임을 통하여 원하는 페이지를 읽을 수 있도록 백업 저장소의 작업을 스케쥴링 한다.
5. 4번 작업이 완료되면, 프로세스의 내부 테이블을 업데이트 한다.
6. interrupt 된 instruction 부터 다시 실행한다.

Demand paging 은 page fault 후 어떤 instruction 도 재실행 할 수 있어야 한다. interrupted process 의 상태를 저장하기 때문에, 손쉽게 재실행이 가능하다.

## 요약

- virtual memory 는 physical memory 를 아주 큰 저장소의 배열로 추상화 한다.
- virtual memory 의 이점은 (1) 프로그램이 physical memory 보다 커질 수 있으며, (2) 프로그램이 메모리 전체를 필요로 하지 않고 (3) 프로세스들이 메모리를 공유할 수 있으며 (4) 프로세스들이 더 효율적으로 생성된다는 것이다.
- Demand paging(요구 페이징)은 프로그램 실행중 필요할 때만 page 가 load 되는 방식이다.
- page fault 는 메모리에 접근했는데, 페이지가 현재 메모리에 없을 때 발생한다. 이 페이지는 백업 저장소에서 메모리의 가용한 페이지 프레임에 가져와야 한다.
- Copy-on-write 는 자식 프로세스가 부모와 같은 address space 를 공유하게 해준다.
- 가용한 메모리가 적으면, page-replacement 알고리즘을 이용하여 메모리의 페이지와 새로은 페이지를 교체한다. 이때 page-replacement 알고리즘에는 FIFO, optimal, LRU 등이 있으며 Pure LRU 알고리즘은 구현이 불가능하기 때문에 LRU approximation (clock algorithm) 을 사용한다.
- Global page-replacement algorithm 은 페이지 교체를 위하여 어떤 프로세스의 페이지든 선택하는 반면 local page-replacement algorithm 은 실패한(faulting) 프로세스의 페이지만 선택한다.
- 시스템이 실행보다 페이징에 더 많은 시간을 소모할 때, Thrashing 이 발생한다.
- locality 는 함께 사용되는 페이지의 set 를 나타낸다. 프로세스가 실행됨에 따라, 이는 locality 에서 locality 로 이동한다. working set 은 locality 에 기반하며, 현재 한 프로세스에서 사용하는 페이지의 set 이다.
- 커널 메모리는 user-mode 프로세스들과 다르게 할당된다. 다양한 크기의 연속된 청크로 할당되는데, 여기서 두가지 공통된 테크닉은 (1) buddy system (2) slab allocator 이다.
- TLB reach 는 TLB 에서 접근할 수 있는 메모리의 양을 뜻하며 TLB entries 수에 page size 를 곱한것과 같다.

# reference

> _Abraham Silberschatz , Greg Gagne & Peter B. Galvin (2018). Operating System Concepts (10th ed.) U.S. : willy_
