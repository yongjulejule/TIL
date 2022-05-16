# rfc 2119 : keywords for use in RFCs to Indicate Requirement levels

>[RFC 2119 link](https://datatracker.ietf.org/doc/html/rfc2119)

명세서의 요구 사항을 나타내는 여러 단어가 있는데, 이들은 종종 대문자로 쓰며, 이 문서에서 각 단어를 어떻게 해석해야 할지 정의함. 이 가이드라인을 준수하는 저자는 상단에 다음과 같은 문단을 추가해야 함.

>  The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

실제로 이러한 용어가 사용되는 문서 내에서 각 단어에 대한 정의는 바뀔 수 있음.

- **MUST** : 명세상(specification) 절대적으로 필요한것. "REQUIRED"나 "SHALL"과 같음.
- **MUST NOT** : 명세상 절대적으로 금지되는 것. "SHALL NOT"과 같음.
- **SHOULD** : 특정 상황의 특정 요소에 대해서는 무시할만한 타당한 이유가 있을 수 있지만, 다른 방식을 선택하기 전에 전체 의미를 이해하고 신중하게 따져봐야함. "RECOMMENDED"와 같음.
- **SHOULD NOT** : 특정 상황에서 용인할만하고, 심지어 유용할 수 있지만, 다른 방식을 선택하기 전에 전체 의미를 이해하고 신중하게 따져봐야함. "SHALL NOT"와 같음.
- **MAY** : 해당 항목이 완전히 선택적임. 하지만 특정 옵션을 포함하지 않는 경우에도 해당 옵션을 사용하는 아이템과 호환이 될 수 있도록 준비해야 하며 그 반대도 마찬가지임. "OPTIONAL"와 같음.