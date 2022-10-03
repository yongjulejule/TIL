#!/usr/bin/env bash

cat <<EOF
# TIL

Today I Learned

새로 알게 된 내용들을 저장하는 곳입니다.

# Index
EOF

dirs=$(file * | grep directory | tr -d ":" | cut -d ' ' -f 1)
 
for d in $dirs; do
	if [[ $d = "image" ]]; then
		continue
	fi
	echo -e "\n## $d\n"
	filepath=$(find $d -type f ! -name "README.md")
	#filename=$(find $d -type f ! -name "README.md" -exec basename -s .md {} +)
	filename=$(echo $filepath | xargs basename -s .md)
	length=$(( $(echo $filepath | wc -w) - 1 ))
	filepath=($filepath)
	filename=($filename)
	for i in `seq 0 $length`; do
		echo "  - [${filename[$i]}](${filepath[$i]})"
	done;
done

