# CGI (Common Gateway Interface)

## CGI

- Common Gateway Interfaced의 약자. html만 제공하다가 외부 앱과 상호작용을 할 필요성을 느껴서 나온 동적 페이지를 제공하기 위한 규격화된 약속. 웹서버와 서로 데이터를 주고받는 방식으로 작동함!
- 어떤 언어로든 작성될 수 있으며 url에 `<protocol>://<domain>/(cgi-bin/<cgi_program_name>|<program>.cgi)` 방식을 주로 씀. 만약 URL에 query string이 있으면 환경변수로 QUERY_STRING이 설정되어 cgi 프로그램에서 사용할 수 있음.
- `CGI` 프로그램이 요청된 작업을 수행하고 `html`문서 형태로 `stdout`으로 쏴주면, 서버가 받아서 `html` 문서를 유저에게 쏴주는 방식.

    ![cgi](/image/cgi-1.jpeg)

- 하지만 1 요청당 1 프로세스를 생성하고, 요청이 끝나면 프로세스가 종료되는 방식이라서 성능이 구림
    
    ![cgi processing](/image/cgi-2.jpeg)

## fCGI

- FastCGI는 프로세스들을 생성해두고, 한 프로세스당 여러개의 요청을 계속 처리함.
- FastCGI가 메모리를 더 많이 소모하지만 더 빠름!

    ![fast CGI](/image/fcgi.jpeg)
		
