# docker-compose-specification

> The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

> 이 문서의  “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL”는 RFC 2119 문서를 따름. [한글 참고](/RFC/rfc2119-keywords-for-use-in-RFCs.md)

Compose file은 [YAML(Ain't Markup Language)](https://yaml.org/) 파일로, 도커 어플리케이션을 위한 서비스(services), 네트워크(networks), 볼륨(volumes)을 정의한 파일임. Compose file format의 최신 추천 버전은 [Compose Specification 문서](https://docs.docker.com/compose/compose-file/)에 정의되어 있음.

커맨드 하나로 여러개의 `docker run` 과정을 수행해주는 느낌.

## The Compose application model

Compose 명세(specification)는 플랫폼에 구애받지 않고(platform-agnostic) 어플리케이션 기반의 컨테이너를 정의할 수 있게 해줌. 이 어플리케이션은 적절하게 자원을 공유하고 커뮤니케이션을 채널을 지니며 함께 동작하는 컨테이너들로 이루어짐. 

Compose 파일은 크게 `Services`, `Networks`, `Volumes` 로 구성됨.

`Services`는 컨테이너를 실행하는 플렛폼의 추상화된 환경이고, `Networks`는 `Services`가 소통하게 해주며 `Volumes`는 `Services`가 데이터를 저장하고 공유하는 공간임.

몇몇 `services`는 런타임이나 플랫폼에 의존하는 설정(configuration) 데이터를 필요로 한다. 이런 설정 데이터를 위하여 명세서(specification)에는 `Configs`가 있음. `Configs`는 컨테이너에 마운트 된다는 점에서 `Volumes`와 비교되지만 `Configs`는 구체적인 플렛폼의 자원이나 서비스를 포함한다.

`Secret`은 보안을 고려하지 않고 노출되면 안되는(SHOULD NOT) configuration 데이터를 위한것임. 

더 자세한 설명은 [링크](https://docs.docker.com/compose/compose-file/#the-compose-application-model) 참조

## Compose file

Compose file은 `version`(DEPRECATED), `services`(REQUIRED), `networks`, `volumes`, `configs`, `secrets`을 정의한 YAML 파일임. compose file의 default path는 워킹 디렉토리의 `compose.yaml`이나 `compose.yml` 이며, 하위 호환성을 위하여 `docker-compose.yaml`, `docker-compose.yml`도 지원함. 만약 여러 파일이 존재하면 `compose.yaml`을 사용해야함.(MUST)


---

docker-compose의 instruction들은 [공식문서](https://docs.docker.com/compose/compose-file/) 참조

# 참조

[docker compose file 공식문서](https://docs.docker.com/compose/compose-file/)