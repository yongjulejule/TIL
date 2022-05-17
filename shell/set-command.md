# set-command

```bash
set [--abefhkmnptuvxBCEHPT] [-o option-name] [argument …]
set [+abefhkmnptuvxBCEHPT] [+o option-name] [argument …]
```

`set` 커멘드는 쉘에 여러 설정을 해줄 수 있으며, 인자 없이 사용하면 쉘에 모든 변수와 설정을 보여줌.

+-는 옵션 on/off에 해당하며 쉘 스크립트를 간편하게 해주는 몇가지 옵션이 있음.

## set -e

exit_status가 0이 아니면 거기서 종료함.

그냥 쉘에서 실행하면 쉘이 종료되고, 쉘 스크립트를 실행하면 스크립트가 종료됨!
`while`, `until`, `&&`, `||`와 결합되어 더 다양한 작동을 하는데, 이는 GNU 문서 참고

## set -x

입력된 명령어를 터미널에 출력함. set -e와 결합하여 사용되면 어디서 종료됐는지 알 수 있어 좋음.

## set -u

초기화 해주는 느낌... `@` 나 `*`같은 special parameter를 제외하고 variable를 모두 삭제하고, error message는 stderr로 출력되게 만들며, interactive하지 않은 shell들은 모두 종료됨.

## set -o pipefail

쉘에서 `ls | non-exist | ls`와 같이 pipe로 명령어가 구성되면 가장 마지막 명령어의 종료 상태에 따라 exit status가 저장되는데, `pipefail`이 설정되어 있으면 중간에 실패해도 exit status가 저장됨.

![pipefail-example](/image/shell-set-pipefail.png)

맥 `zsh`, `bash` 기준으로 가장 마지막에 실패한 명령어의 exit status가 저장됨.(사진은 zsh에서 실행한 것)

[GNU 문서 참조](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)