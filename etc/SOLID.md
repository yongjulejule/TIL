# SOLID 

함수와 데이터 구조를 클래스로 배치하는 방법, 그리고 이들 클래스를 서로 결합하는 방법을 설명해줌
'클래스' 라는 단어를 사용했다고 해서, 이 원칙들이 객체지향 프로그래밍에만 적용되는 것은 아님
'클래스'는 단순히 함수와 데이터를 결합한 집합을 뜻함

**목적**

중간 수준의 소프트웨어가 다음과 같도록 만드는 데 있음

- 변경에 유연하다.
- 이해하기 쉽다.
- 많은 소프트웨어 시스템에 사용될 수 있는 컴포넌트의 기반이 된다

> 중간 수준?
>
> 프로그래머가 이 원칙을 모듈 수준에서 작업할 때 적용할 수 있다는 뜻으로, 코드 수준보다 조금 상위에서 적용되며 모듈과 컴포넌트 내부에서 사용되는 소프트웨어 구조를 정의하는데 도움을 줌

## SRP(Single Responsibility Principle, 단일 책임 원칙)

> A module should be responsible to one, and only one, actor. (Robert C. Martin)
>
> 하나의 모듈은 하나의, 오직 하나의 액터에 대해서만 책임져야 한다.

여기서 액터란, 해당 변경을 요청하는 한 명 이상의 사람들(사용자 또는 이해관계자)을 뜻함.

이 원칙은 메서드와 클래스 수준의 원칙이지만, 컴포넌트 수준에선 공통 폐쇄 원칙(Common Closure Principle) 이 되고, 아키텍쳐 수준에선 아키텍쳐 경계의 생성을 책임지는 변경의 축이 됨

## OCP(Open-Closed Principle, 개방-폐쇄 원칙)

> software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification (Bertrand Meyer, 1988)
>
> 소프트웨어 개체는 확장에는 열려 있어야 하고, 변경에는 닫혀 있어야 한다.

즉, 소프트웨어 개체의 행위는 확장할 수 있어야 하지만, 이때 개체를 변경해서는 안 된다 (Robert C. Martin)
이는 아키텍쳐 컴포넌트 수준에서 OCP 를 고려할 때 훨씬 중요한 의미를 가짐

> Clean Architecture 73p 에 자세한 예시가 있음

OCP 의 목표는 시스템을 쉽게 확장하는 동시에 시스템이 많은 영향을 받지 않게 하는 것.
이를 위해선 시스템을 컴포넌트 단위로 분리하여, 저수준 컴포넌트에서 발생한 변경으로 부터 고수준 컴포넌트를 보호할 수 있는 형태의 의존성 계층 구조가 만들어져야 함

## LSP(Liskov Substitution Principle, 리스코프 치환 원칙)

LSP 는 strong behavioral subtyping 이라는 subtyping 의 특정한 정의임

> Subtype Requirement: Let q(x) be a property provable about objects x of type T. Then q(y) should be true for objects y of type S where S is a subtype of T.

이렇게 초기에 LSP 는 subtyping 에 대한 정의였지만 시간이 지나며 소프트웨어 설계 원칙으로 바뀜

> 상호 대체 가능한 구성요소를 이용해 소프트웨어 시스템을 만들 수 있으려면, 이들 구성요소는 반드시 서로 치환 가능해야 한다는 계약을 반드시 지켜야 한다. (Robert C. Martin)

쉽게 말하면, 자식 클래스는 부모 클래스가 들어갈 자리에 대체될 수 있어야 한다는 것 (하위 타입에 전혀 의존하지 않음)

if-else 와 같은 분기로 subtype 을 구분해야 한다면, OCP 를 위반하게 됨. 이는 LSP 를 위반하는 것과 같음
아래 링크에서 LSP 위반의 예시를 볼 수 있음

- https://medium.com/hackernoon/liskov-substitution-principle-a982551d584a
- https://stackify.com/solid-design-liskov-substitution-principle/
- https://www.tomdalling.com/blog/software-design/solid-class-design-the-liskov-substitution-principle/

## ISP(Interface Segregation Principle, 인터페이스 분리 원칙)

> the interface segregation principle (ISP) states that no code should be forced to depend on methods it does not use. (Robert C. Martin)
>
> 어떤 코드도 사용하지 않는 메서드에 의존해서는 안 된다.

인터페이스 분리를 통해 사용하지 않는 메서드에 의존하지 않도록 해야 함.

이를 지키지 않을 경우 언어별 특성에 따라 불필요한 재컴파일 및 재배포가 발생할 수 있지만, ISP 를 언어와 관련된 문제라고 결론지을 수는 없음.

불필요한 것에 의존하면 예상치 못한 문제에 빠질 수 있다는게 핵심임.

## Dependency Inversion Principle

>The principle states:
>
>A. High-level modules should not import anything from low-level modules. Both should depend on abstractions (e.g., interfaces).
>
>B. Abstractions should not depend on details. Details (concrete implementations) should depend on abstractions.
>
>A. 고수준 모듈은 저수준 모듈에 의존해서는 안된다. 둘 다 추상화에 의존해야 한다.
>
>B. 추상화는 세부사항에 의존해서는 안된다. 세부사항은 추상화에 의존해야 한다.
>
> (Robert C. Martin)

자바의 String 클래스와 같이 구체적인 것에 의존해야 하는 상황이 있지만, 이는 예외적인 상황이라고 볼 수 있음. 운영체제나 플랫폼 같이 안정성이 보장된 환경에 대해서는 DIP 가 무시됨.

의존하지 않도록 피하고자 하는 것은 변동성이 큰 구체적인 요소(개발중이라서 자주 변경되는 것들)임. 

DIP 에서 전달하려는 내용을 다음과 같이 구체적인 코딩 실천법으로 요약할 수 있음 (Robert C. Martin)

- 변동성이 큰 구체(concretion) 클래스를 참조하지 말라. (일반적으로 [추상 팩토리](https://refactoring.guru/ko/design-patterns/abstract-factory)를 사용하도록 강제함)
- 변동성이 큰 구체 클래스로부터 파생하지 말라.
- 구체 함수를 오버라이드 하지 말라. (의존성을 상속하는 꼴이 되어버림. 차라리 추상 함수로 선언 후 각 용도에 맞게 구현)
- 구체적이며 변동성이 크다면 절대로 그 이름을 언급하지 말라.

## References

[wikipedia SOLID](https://en.wikipedia.org/wiki/SOLID)

[wikipedia SRP](https://en.wikipedia.org/wiki/Single-responsibility_principle)

[wikipedia OCP](https://en.wikipedia.org/wiki/Open%E2%80%93closed_principle)

[wikipedia LSP](https://en.wikipedia.org/wiki/Liskov_substitution_principle)

[wikipedia ISP](https://en.wikipedia.org/wiki/Interface_segregation_principle)

[wikipedia DIP](https://en.wikipedia.org/wiki/Dependency_inversion_principle)

[SRP Robert C. Martin 의 블로그](https://blog.cleancoder.com/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html)

[OCP Robert C. Martin 의 블로그](https://blog.cleancoder.com/uncle-bob/2014/05/12/TheOpenClosedPrinciple.html)

*Clean Architecture by Robert C. Martin*
