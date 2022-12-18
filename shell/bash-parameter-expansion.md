# bash parameter expansion

## ${#parameter}

`parameter`의 글자 수를 반환

만약 parameter가 @나 \*로 지정되면, parameter의 각 요소의 글자 수를 반환

## $\{parameter#word\} - (1), $\{parameter##word\} - (2)

- `parameter`의 처음부터 탐색하면서, `word`와 매칭되는 짧은 부분 까지 삭제`(1)`, 매칭되는 가장 긴 부분 까지 삭제`(2)`

```bash
✨ ❯ local example=`ls`
✨ ❯ echo $example
bash-parameter-expansion.md
env-command.md
envsubst-command.md
if-else-statement.md
README.md
set-command.md
✨ ❯ example+=" HAHA"
✨ ❯ echo ${example#*.md}

env-command.md
envsubst-command.md
if-else-statement.md
README.md
set-command.md HAHA
✨ ❯ echo ${example##*.md}
 HAHA
```

- ${parameter##\*.} 같은 방식으로 파일의 확장자만 가져올 수 있음.

```bash
🔥 ❯ local example=test.cpp
🔥 ❯ echo ${example##*.}
cpp
```

- parameter가 @나 \*로 지정되면, parameter의 각 요소에 대해 적용
- parameter가 array 형태이고 [@] 나 [*]로 지정되면, 각 요소에 대해 적용

```bash
 ❯ echo ${exampleArr}
bash-parameter-expansion.md env-command.md envsubst-command.md if-else-statement.md README.md set-command.md HAHA
✨ ❯ echo ${exampleArr[@]##*.}
md md md md md md HAHA
✨ ❯ echo ${example##*.}
md HAHA
```

## $\{parameter%word\} - (1), $\{parameter%%word\} - (2)

- `parameter`의 끝 부터 탐색하면서, `word`와 매칭되는 가장 짧은 까지 삭제`(1)`, 매칭되는 가장 긴 부분 까지 삭제`(2)`

```bash
🤷 ❯ echo ${ex%.*}
test.md test1
✨ ❯ echo ${ex%%.*}
test
✨ ❯ echo ${ex}
test.md test1.md
```

- ${parameter%\*.} 같은 방식으로 파일의 확장자를 제외한 이름만 가져올 수 있음.

```bash
✨ ❯ echo ${example}
test.cpp
✨ ❯ echo ${example%%.*}
test
```

- parameter가 @나 \*로 지정되면, parameter의 각 요소에 대해 적용
- parameter가 array 형태이고 [@] 나 [*]로 지정되면, 각 요소에 대해 적용

```bash
 ❯ echo ${exampleArr}
bash-parameter-expansion.md env-command.md envsubst-command.md if-else-statement.md README.md set-command.md HAHA
✨ ❯ echo ${exampleArr[@]%.*}
bash-parameter-expansion env-command envsubst-command if-else-statement README set-command HAHA
```

## ${parameter/pattern/string} - (1), ${parameter//pattern/string} - (2), ${parameter/#pattern/string} - (3), ${parameter/%pattern/string} - (4)

- parameter의 처음부터 탐색하면서, pattern과 처음 매칭되는 부분을 string으로 치환`(1)`, 모든 매칭되는 부분을 string으로 치환`(2)`
- 첫 글자부터 매칭되는 부분을 string으로 치환`(3)`, 마지막 글자부터 매칭되는 부분을 string으로 치환`(4)`

```bash
✨ ❯ echo ${example}
test.cpp.hpp
✨ ❯ echo ${example/cpp/h}
test.h.hpp
✨ ❯ echo ${example//pp/h}
test.ch.hh
✨ ❯ echo ${example/#test/H}
H.cpp.hpp
✨ ❯ echo ${example/%hpp/tcc}
test.cpp.tcc
# #|%의 경우 처음|끝 부터 정확히 매칭되어야 함
✨ ❯ echo ${example/%cpp/tcc}
test.cpp.hpp
✨ ❯ echo ${example/#est/ask}
test.cpp.hpp
✨ ❯ echo ${example/#test/task}
task.cpp.hpp
```

- ${parameter/pattern} 과 같이 마지막 string이 없으면 규칙에 따라 pattern에 해당하는 부분들을 삭제
- parameter가 @나 \*로 지정되면, parameter의 각 요소에 대해 적용
- parameter가 array 형태이고 [@] 나 [*]로 지정되면, 각 요소에 대해 적용

[GNU Bash Shell Parametor Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html}
