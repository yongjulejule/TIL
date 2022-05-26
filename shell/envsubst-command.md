# envsubst-command

`envsubst` 명령어를 입력하면 표준입력으로 받은 문자열에서 환경변수를 치환해줌!

특정 환경변수만 지정해서 치환할 수 있으며 `envsubst '${VARIABLE}'` 같은 방식으로 사용하면 `${VARIABLE}`만 치환함.

단순한 작업이지만, 각종 config 파일에서 환경변수를 지원하지 않을때 유용하게 사용할 수 있음. 

![envsubst example](/image/envsubst.png)


