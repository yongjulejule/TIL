# main memory

CPU scheduling 을 통하여 여러개의 프로세스를 CPU가 효율적으로 관리하고 유저에게 빠른 응답을 제공할 수 있게 만들더라도, 프로그램들을 메모리에 올리지 못하면 좋은 성능을 기대하기 힘들다. 따라서 메모리 상에 수많은 프로그램들을 올려 놓을 수 있어야 하며, 이때 어떻게 메모리를 관리 (manage memory) 할 것인지 알아보자.

## 메모리의 주소

메모리는 커다란 바이트들의 배열로 이루어져 있으며, 각 바이트는 메모리 주소를 가지고 있다. 메모리 주소는 0부터 시작하여 1씩 증가한다. 메모리 주소는 32비트 또는 64비트로 표현되며, 32비트의 경우 4GB(2^32 - 1)의 메모리를 표현할 수 있고, 64비트의 경우 16EB(2^64 - 1)의 메모리를 표현할 수 있다.

## CPU와 메모리의 작동 방식

CPU는 program counter의 값에 따라 메모리로부터 instruction을 가져와 실행하고, instruction은 추가적으로 특정 memory address에 값을 저장하거나, 로딩할 수 있다.

예를 들어, 전형적인 instruction-execution cycle은 다음과 같다.

1. memory로 부터 instruction을 가져온다(fetch).
2. instruction은 디코딩되고 메모리에서 피연산자(operands)를 가져올 수 있다.
3. instruction이 피연산자(operands)에서 실행이 된 후, 결과가 메모리에 저장된다.

메모리 유닛은 메모리 주소의 stream만 볼 뿐, 어떻게 생성되었는지 혹은 무엇을 위한 것인지 알 수 없다.

메모리 관리에 대한 몇가지 내용을 다뤄보자.

### Basic Hardware

Main memory와 각 processing core에 탑재된 registers는 CPU가 직접 접근 할수 있는 유일한 저장장치이다. 메모리 주소를 인자로 받는 instruction이 존재하지만, disk의 주소를 받는 instruction은 존재하지 않는다. 따라서, CPU가 disk에 접근하기 위해서는 disk의 내용을 memory에 올려놓아야 한다.

각 CPU core에 내장된 register는 일반적으로 CPU clock 의 한 cycle 내에서 접근 할 수 있다. 일부 CPU core는 clock tick당 하나 이상의 작업 속도로 명령어를 decoding 하고 register 내용에 대한 간단한 작업을 수행할 수 있다. 메모리 버스의 트랜잭션을 통해 액세스되는 main memory에 대해서도 마찬가지이다. 메모리 액세스를 완료하는 데 CPU clock의 많은 cycle이 소요 될 수 있다. 이러한 경우 프로세서는 실행 중인 명령을 완료하는 데 필요한 데이터가 없기 때문에 일반적으로 정지(stall)해야 한다. 이 상황은 빈번한 메모리 액세스 때문에 좋지 않다. 해결책은 빠른 액세스를 위해 일반적으로 CPU 칩에 있는 CPU와 주 메모리 사이에 빠른 메모리(Cache)를 추가하는 것이다. CPU에 내장된 캐시를 관리하기 위해 하드웨어는 운영체제의 제어 없이 자동으로 메모리 액세스 속도를 향상시킨다.

physical memory에 접근하는 상대적인 속도만 고려할 것이 아니라, 정확한 operation을 보장하여야 한다. OS에 user process가 접근하는 것을 막아야 하며, 다른 user process에 접근하는 것도 막아야 한다. OS는 일반적으로 CPU와 메모리 엑세스 사이에 개입하지 않기 때문에(성능상의 이유), 이는 하드웨어에 의하여 보장되어야 한다. 한 가지 방법을 살펴보자.

![main-memory-basic-hardware](../image/main-memory-basic-hardware.jpg)

위 그림과 같이, 프로세스 메모리 영역의 범위를 결정 할 수 있어야 한다. base register와 limit register 라는 두 개의 registers를 이용하여 이를 관리한다. base register는 프로세스 내부에서 유효한 physical memory address의 가장 작은 주소이며 limit register 에는 프로세스가 사용하는 메모리의 범위가 저장된다. user process 가 생성될 때 registers를 같이 생성하고, 만약 프로세스가 메모리 영역을 침범하였을때, fatal error를 발생시킨다.

### Address Binding

일반적으로 프로그램은 disk에서 binary executable file 으로 저장되어 있고, 실행하기 위해선 프로세스라는 컨텍스트로 메모리에 올라와야 한다.

[linker and loader](./linker-and-loaders.md)

프로세스가 실행되면, 메모리의 instruction과 data에 접근할 수 있게 되며, 프로세스가 종료됐을땐 다른 프로세스가 사용할 수 있도록 메모리가 반환된다.

대부분의 시스템에선 user process가 physical memory의 어디든 존재할 수 있다. 따라서 컴퓨터의 address space가 00000에서 시작하더라도, 프로세스의 시작 주소는 00000이 아닐 수 있다.

소스 프로그램의 주소는 일반적으로 symbolic address 이며, 컴파일러는 symbolic address를 relocatable address로 `bind` 한다( 예를 들면, 현재 모듈에서 14바이트 떨어진 곳). linker나 loader는 relocatable address를 absolute address로 변환한다(74000 + 14).

`binding` 이 어떤 방식으로 이루어 질 수 있는지 알아보자.

### Logical vs Physical Address space

CPU에 의하여 만들어진 address는 주로 logical address를 나타내는 반면 memory unit이 보는 address, 즉 메모리의 memory-address register에 load 되는 address는 physical address를 나타낸다.

![MMU](/image/main-memory-memory-management-unit.jpeg)

compile 이나 load 과정에서 logical address와 physical address 는 같지만, execution-time의 address-binding scheme 의 결과에 따라 달라질 수 있다. 이 상황에서 logical address를 보통 virtual address라 부르지만, 혼용해서 쓰기도 한다. 한 프로그램에 의하여 생성된 logical addresses의 집합을 logical address space라 부르며 이 logical addresses 에 대응하는 physical addresses의 집합을 physical address space라 부른다. 따라서, execution-time address-binding scheme에서, logical address space와 physical address space는 서로 다를 수 있다.

실행중 virtual addresses에서 physical addresses로의 매핑은 MMU(memory-management unit)이라는 하드웨어 장치에 의해 일어난다. 다양한 방식으로 매핑을 할 수 있으며, [위에서 살펴본](#basic-hardware) base-register를 사용하는 방식이 간단히 MMU scheme 을 일반화한 것이다. 이제 base-register는 "relocation register" 라고 하자. 만일 relocation register의 값이 14000이고, user-process에서 address 346에 접근하려고 한다면, MMU는 346 + 14000 = 14346으로 변환하는 방식이다.

user program은 절대 실제 physical address에 직접 접근하지 않는다. user program은 logical address만 사용하며, MMU가 logical address를 physical address로 변환한다.

### Dynamic Loading

과거엔 프로세스를 실행하기 위해 프로그램 전체와 모든 데이터를 physical memory에 올려야 해서, 프로그램의 크기에 제한이 있었다. 메모리를 더 잘 활용하기 위해 "dynamic loading"을 사용하게 되었다. 이 방식은 하나의 루틴이 호출되기 전까지 메모리에 올라오지 않는다. 모든 루틴은 relocatable load format으로 disk에 저장되어 있으며, 메인 프로그램이 메모리에 load 되고 실행된다. 한 루틴이 다른 루틴을 호출하면, 호출한 루틴은 메모리에 원하는 루틴이 존재하는지 확인하고, 존재하지 않으면 메모리에 load 하고 프로그램의 address table을 업데이트 하기 위해 relocatable linking loader 가 호출된다.

"dynamic loading" 덕분에 특정 루틴이 필요 할 때만 load 되며 특히 규모가 큰 프로그램에서 에러 상황 처럼 자주 발생하지 않는 케이스를 다룰 때 유용하다. 이 방식에서 이점을 얻기 위해선 프로그램을 만드는 유저에게 책임이 있고, OS는 "dynamic loading" 을 구현한 라이브러리 루틴을 제공하여 프로그래머를 도와준다.

### Dynamic Linking and Shared Libraries

DLLs(Dynamically linked libraries) 는 프로그램이 실행될 때 linking되는 시스템 라이브러리다. 이 방식은 dynamic loading과 유사하지만, loading 과정이 아니라 linking 과정을 실행 때까지 미루는 것이다. 이 방식은 프로그램의 크기를 줄일 수 있으며 main memory를 더 효율적으로 사용할 수 있다. DLLs 는 라이브러리가 여러 프로세스에서 사용되는 경우 main memory에 한 번만 load 되기 때문이다. 이런 이유에서 DLLs 는 shared libraries 라고도 불린다.

프로그램이 dynamic library에 있는 루틴을 참조할 때, loader는 DLL을 찾아 필요하다면 메모리에 loading 한다. 그리고 dynamic library의 함수 주소를 DLL이 저장된 메모리상의 주소로 맞춘다.

Dynamic loading 과 다르게, dynamic linking과 shared library은 OS의 도움을 필요로 한다. 만일 프로세스의 메모리가 다른 프로세스로부터 protected인 상태일때, OS만이 다른 프로세스의 메모리 영역에 있는 루틴인지 체크할 수 있고, 또 같은 메모리 주소에 접근 할 수 있는지 허가할 수 있기 때문이다.

## Contiguous Memory Allocation

main memory는 os와 user processes 모두를 위해 사용되기 때문에, 메모리를 가능한 효율적으로 할당해야 한다. 주로 OS 를 메모리의 높은 주소에 할당한다. 유저 프로세스의 경우, 일반적으로 여러개의 프로세스가 동시에 메모리에서 사용되기 원한다. "contiguous memory allocation" 에선, 각 프로세스는 메모리의 한 섹션에 포함되고, 이 섹션들은 연속적으로 (contiguous) 배치된다.

### Memory Protection

다른 프로세스가 한 프로세스의 영역을 침범하면 안되는데, 이를 memory protection이라 한다. 한 가지 단순한 방법은 위에서 논의한 relocation register 와 limit register를 이용하여 MMU가 Logical address를 Physical address로 겹치지 않게 변환하면 된다.

### Memory Allocation

프로세스에 메모리를 할당하는 방식을 단순하게 생각해보면, 프로세스의 크기에 딱 맞게 메모리를 할당하는 것이다. 이 "variable-partition" scheme에선, OS가 메모리의 어느 부분에 어떤 프로세스가 있다는 Table을 갖고 있어야 한다. 처음엔 프로세스가 없어서 메모리에 하나의 큰 "hole" 가 있고, 프로세스가 hole을 채우면서 메모리를 할당한다. 그리고 프로세스가 생성되고 종료됨에 따라 수많은 size의 hole들이 생기게 된다. 이 과정이 반복되면, dynamic storage-allocation problem 이라는 문제가 발생하는데, 이는 메모리의 hole 에 프로세스를 어떻게 배정할지에 대한 문제이다.

- first-fit : 사이즈가 충분한 첫 번째 hole 에 배정 -> search가 빠름
- best-fit : 사이즈가 맞는 것 중 가장 작은 hole 에 배정 -> 메모리를 가장 효율적으로 사용
- worst-fit : 사이즈가 가장 큰 hole 에 배정 -> 너무 작은 hole 이 생기는 것을 방지해줌

메모리 사용성과 속도 면에서 worst-fit이 최악이고, first-fit 과 best-fit 은 큰 차이가 없지만 일반적으로 first-fit이 더 빠르다.

### Fragmentation(단편화)

메모리 할당과 해제가 반복되면서, 메모리 공간이 수많은 빈 조각(hole)으로 나뉘게 된다. 이때 남은 공간이 충분한데도 불구하고 빈 공간이 연속적이지 않아 프로세스를 할당할 수 없는 경우를 external fragmentation 이라고 한다. "first-fit" 이나 "best-fit" 방식을 사용하면 external fragmentation이 많이 발생하는 문제가 발생한다.

internal fragmentation 도 존재한다. 이는 프로세스의 크기가 hole의 크기보다 미세하게 작아서, 메모리에 load 후 너무 적은 공간이 남는 경우이다. hole 이 너무 작아서 프로세스를 할당 할 수 없고, 이 hole을 추적하는 오버헤드가 오히려 커지는 문제가 생긴다.

external fragmentation 의 한가지 해결 방법은 "compaction" 이다. 빈 메모리들을 하나의 커다란 블록으로 만드는 방식이나, relocation이 동적으로 이루어지는 경우에만 가능하고, 비용이 많이 든다. 또 다른 해결 방법은 프로세스의 logical address space가 연속적이지 않아도 되도록 하는 방법이다. physical memory에 가용한 공간이 있으면 어디에나 메모리를 할당할 수 있어지며, 주로 paging 에서 사용되는 기법이다.

## Paging

[paging 문서](paging.md)

## Structure of Page Table

### Hierarchical Paging

현대의 컴퓨터 시스템은 2^32 ~ 2^64 크기의 logical address space 를 가지고 있다. 32 bit 시스템을 예로 들면, 각 page 의 사이즈가 4KB 일때 각 프로세스 마다 page table은 백만개가 넘는 (2^32 / 2^12) entry를 가지게 된다. 각 entry가 4 byte 라면, page table 의 크기가 4MB를 차지하게 되어 매우 큰 메모리를 차지하게 된다. 이를 해결하기 위해 page table 을 계층적(hierarchical) 으로 구성하는 방법이 있다. two-level paging 은 page table을 다시 paging 하고, 4byte 의 각 entry의 10 bit 는 첫 번째 page number (outer page number), 다음 10 bit 는 두 번째 page number (inner page number), 마지막 12 bit 는 offset 으로 사용한다.

하지만 64 bit 에서는 이 방법으로도 해결할 수 없다. 64 bit 에선, outer page 에 42 bits 를 사용하고, inner page 에 10 bits, offset 에 12 bits 를 사용한다면, outer page table 의 크기는 2^44 가 된다. page 를 더 쪼개서, 3개로 분할해도 outer page table 은 2^34 bytes 라는 어마어마한 크기가 된다.

### Hashed Page Tables

32 bits 보다 큰 address space 를 다루기 위한 다른 방법은 hash value 를 virtual page number 로 사용하는 hashed page table 을 이용하는 것이다. 각 hash table 의 entry 는 연결리스트로 관리되며, 각 element 는 virtual page number, 매핑된 page frame, next element 의 pointer 로 이루어져 있고 다음과 같은 방식으로 진행된다.

1. virtual address 에 있는 virtual page number 가 hash 되어서 hash table 에 들어간다.
2. virtual page number 와 각 hash table entry 의 첫 번째 element 의 virtual page number 를 비교한다.
3. 매칭되면, 해당 entry 의 page frame 을 찾아서 physical address 를 계산하고, 그렇지 않으면 다음 element 로 이동한다.

이 방법의 variation 으로 "clustered page table" 이 있다. 이 방법은 각 entry 에 하나의 페이지가 아닌 여러개의 page 를 나타내도록 한다.

### Inverted Page Tables

An inverted page table has one entry for each real page (or frame) of memory. Each entry consists of the virtual address of the page stored in that real memory location, with information about the process that owns the page. Thus, only one page table is in the system, and it has only one entry for each page of physical memory.

inverted page table 에는 메모리의 각 실제 page(또는 frame)에 대해 하나의 entry가 있다. 각 entry 는 실제 메모리 위치에 저장된 page의 virtual address 와 page 를 소유한 프로세스에 대한 정보로 구성된다. 따라서 시스템에는 하나의 page table 만 있고 physical memory 의 각 page 에 대해 하나의 entry만 있다.

하나의 간단한 예시를 들어보면, 각 entry 가 `<pid, page-number, offset>` 으로 구성되어서, 메모리를 참조하면 virtual address 의 부분에서 pid, page-number 를 찾고, `<i, offset>` 을 생성하여 physical memory 에 접근한다.

만약 shared memory에 대한 접근이 필요하다면, 다른 방법에선 프로세스마다 page table 이 있어서 같은 physical memory 를 가리키는 page 가 있을 수 있었지면, 여기선 사용할 수 없고, 만약 같은 메모리에 접근한다면 page fault 가 발생한다.

## Swapping

프로세스의 instruction 와 data 는 실행되기 위하여 메모리에 있어야 하지만, 어떤 프로세스나, 그 일부는 메모리에서 백업 저장소 (backing store) 에 임시적으로 "swap" 될 수 있으며, 실행을 위해 다시 메모리로 올라올 수 있다. 이런 "swapping" 은 physical memory 보다 더 큰 address space 를 다루기 위해 필요하다.

### Standard Swapping

standard swapping 은 프로세스 전체를 백업 저장소에 옮기는 것이다. 백업 저장소는 주로 빠른 secondary storage 가 되며 프로세스를 항상 담을 수 있을만큼 커야하고, 이 메모리 이미지에 직접 접근할 수 있어야 한다. 또한, 백업 저장소에 스왑이 되면, 프로세스에 관련된 데이터들이 같이 저장 되어야 한다. 운영 체제 또한 프로세스의 스왑 여부에 대한 메타데이터를 유지해야 한다.

유휴 상태(idle) 인 프로세스들이 swapping 에 대한 좋은 대상이며 메모리에 할당된 유휴 상태의 프로세스가 차지하던 공간은 다른 프로세스에게 할당될 수 있다.

하지만 이 방식은 과거 유닉스 시스템에서 사용하던 방식이며, 프로세스 전체를 swapping 하는 비용이 비싸기 때문에, 현재는 거의 사용되지 않는다.

## Swapping with paging

리눅스나 윈도우를 포함한 대부분의 시스템은 프로세스의 page 를 swap 하는 방식을 사용한다. 이 전략은 여전히 physical memory 이상의 메모리를 사용할 수 있으며, page 몇 개만 swap 할 수 있다.
메모리에서 백업 저장소로 옮기는걸 "page out" 이라고 하고, 그 반대롤 "page in" 이라고 한다.
또한 이는 가상메모리와도 연관이 있다.

![swapping with page](swapping-with-page.png)

## 요약

- 메모리는 현대의 컴퓨터 체계 운영의 핵심이며 커다란 바이트들의 배열로 이루어져 있고, 각 바이트는 메모리 주소를 가지고 있다.
- 각 프로세스에 address space를 할당하는 한 방법은 base 와 limit registers를 사용하는 것이다. base register는 프로세스의 시작 주소를 가리키고, limit register는 프로세스의 크기를 가리킨다.
- symbolic address 와 실제 physical address를 매핑은 (1) compile, (2) load, (3) execution time에 이루어진다.
- CPU에 의해 생성된 주소는 logical address라고 알려져 있으며, 이는 MMU(memory management unit)에 의해 physical address로 변환된다.
- 메모리 할당을 하는 한가지 접근 방식은 다양한 크기의 연속 메모리 파티션을 할당하는 방식이다. 이 파티션들은 (1) first-fit, (2) best-fit, (3) worst-fit 라는 세가지 전략으로 할당 될 수 있다.
- 현대 운영체제는 메모리 관리를 위하여 페이징(paging)을 사용한다. 페이징은 physical memory를 frame 라고 하는 고정된 크기의 블록으로 나누고, virtual memory를 page 라고 하는 고정된 크기의 블록으로 나눈다.
- 페이징이 적용될 때, logical address는 page number와 page offset라는 두가지 부분으로 나뉘어진다. page number 는 page 를 보유한 physical memory 의 frame 을 포함하는 프로세스별 페이지 테이블에 대한 인덱스 역할을 한다. page offset은 frame이 참조되는 구체적인 위치를 가리킨다.
- TLB(translation look-aside buffer) 는 페이지 테이블에 대한 하드웨어의 cache 이다. 각 TLB의 entry는 page number와 그에 대응하는 frame number를 가지고 있다.
- 페이징 시스템을 위한 address translation에서 TLB를 사용하는 것은 logical address에서 페이지 넘버를 얻기 위함도 있고, 페이지를 위한 frame가 TLB에 있는지 체크하기 위한 목적도 있다. TLB에 frame이 있다면, 여기서 frame이 얻어지고, 그렇지 않으면 page table에서 다시 찾아야 한다.
- Hierarchical paging은 logical address를 여러개로 분할하고, 각각은 다른 level의 page table을 나타낸다. address가 32bits 넘게 확장될 수 있기 때문에, hierarchial level 은 커질 수 있다. 이 문제를 해결하기 위한 두가지 전략은 (1) hashed page tables, (2) inverted page tables 이다.
- Swapping 은 시스템이 pages를 프로세스에서 disk로 옮길 수 있게 해준다.

# reference

> _Abraham Silberschatz , Greg Gagne & Peter B. Galvin (2018). Operating System Concepts (10th ed.) U.S. : willy_
