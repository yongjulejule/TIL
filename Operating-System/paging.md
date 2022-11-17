# Paging

Paging은 프로세스의 physical address space 가 연속적이지 않은 것을 허용해주는 메모리 관리 방법이다. 수많은 장점이 있기 때문에, 다양한 방식으로 현대의 운영체제에서 사용되고 있으며 하드웨어와 운영체제의 협력으로 구현된다.

## Basic Method

Paging을 구현하는 기본적인 방식은 physical memory를 "frames" 이라는 고정된 크기의 블록으로 쪼개고, logical memory를 "pages" 라는 같은 크기의 블록으로 나누는 것이다. 프로세스가 실행되면, pages 는 소유한 자원 중가용한 memory frames 에 로드된다(file system 이나 백업 저장소). 백업 저장소는 memory frames 나 여러 frames의 cluster 와 같은 고정된 크기의 블록으로 나눈다. 이러한 단순한 방식으로 큰 효과가 생긴다. 예를 들면, logical address space와 physical address space가 완전히 분리되어, 프로세스는 시스템이 2^64 바이트 이하의 physical memory를 가지고 있는데도 불구하고 logical 64-bit address space를 가질 수 있다.

![paging hardware](../image/paging-hardware.png)

CPU에 의해 생성된 모든 address는 "page number(p)" 와 "page offset(d)" 라는 두 가지 부분으로 나뉜다. 

page number 는 각 프로세스 page table 의 인덱스로 사용되고, page table 에는 각 frame 에서 physical address의 base 가 저장되어 있다. page offset 은 각 page 의 시작 주소로부터의 offset 이다. 이 두 가지 부분을 합치면, physical address 가 된다.

MMU 가 logical address 에서 physical address로 변환하는 과정은 다음과 같다.

1. page number p 를 추출하고 page table 의 p 번째 entry 에 접근한다.
2. page table 로부터 frame number f 를 얻는다.
3. logical address 의 page number p 를 frame number f 로 변환한다.

페이지의 크기는 하드웨어에 의해 정의되며, 2^n으로 정의되는데 아키텍쳐에 따라 4KB ~ 1GB 까지 변화한다. 2^n 이기 때문에 logical address 에서 page number 와 page offset 으로 변환이 쉽게 가능하다. 만약 logical address space 의 크기가 2^m 이고, page size 가 2^n 이라면, page number 는 m-n bits 로 표현되고, page offset 은 n bits 로 표현된다.

모든 logical address 는 paging hardware 에 의하여 physical address의 어딘가로 바인딩 되기 때문에, dynamic relocation 이라고 볼 수도 있으며 base(or relocation) register 의 테이블을 사용하는 방식과도 유사하다.

paging 방법을 사용하기 때문에 external fragmentation 은 발생하지 않지만 internal fragmentation 은 여전히 발생할 수 있다(page size 가 4096 이고, 프로세스의 크기가 4097 인 경우). page 사이즈를 줄이면 이 문제가 어느정도 해결되지만, page 의 크기가 클수록 성능이 좋아지는 이점도 있기에 보통 4KB ~ 8KB 의 크기를 사용하며, 운영체제에 따라 여러 page 사이즈를 지원하기도 한다.

프로세스가 실행될 때, 프로세스 사이즈는 pages 로 표현되며, 각 page 는 한 frame 을 필요로 한다. 프로세스가 n pages 를 필요로 하면, 적어도 n frames 가 가용해야 한다. 첫 page가 할당된 frame 에 로드될 때, frame 번호가 이 프로세스를 위한 page table 에 저장되고, 다음 page 가 frame에 로드될 때, page table 에 이 정보가 추가되는 방식으로 작동한다. 

프로그래머가 보는 메모리와 실제 physical memory 는 상당히 달라지는데, 이는 주소 변환 하드웨어 (address-translation hardware) 에 의해 이루어진다. logical addresses 에서 physical addresses 의 매핑은 프로그래머에게 숨겨져 있으며 운영체제에 의해 통제된다. 따라서 프로세스는 자신의 주소 영역 밖으로 나갈 수 없게 된다.

운영체제는 physical memory 에 대하여, 어느 프레임이 할당되었고 가용한지, 얼마나 많은 frames 가 존재하는지 등 많은 정보를 갖고 있어야 한다. 이는 "frame table" 이라는 하나의 시스템 자료구조에 저장되고 유지된다. frame table 에는 각 physical page frame 과 frame 이 할당된 상태인지 아닌지, 할당 되었다면 어느 프로세스에 할당 되었는지에 대한 정보가 들어있다. 게다가 운영체제는 user space 에서 운영되는 user processes 를 인지하고 모든 logical addresses 가 physical address 로 변환될 수 있도록 매핑되어야 한다. 만약 유저가 시스템 콜과 그 인자로 주소를 주면, 적절한 physical address 로 갈 수 있어야 한다. 운영체제는 각 프로세스의 page table의 복사본을 유지하는데, logical address 를 physical address 로 수동으로 매핑해야 할 때 이 복사본이 사용된다. 또한, 프로세스가 CPU 에 할당될 때 CPU dispatcher 가 hardware page table 을 정의하기 위해 사용한다. 따라서 paging 은 context-switch time 을 증가시킨다.

## Hardware Support



