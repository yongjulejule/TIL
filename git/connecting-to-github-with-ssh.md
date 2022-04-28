# Connecting to github with ssh

## 1. SSH 키 생성
`ssh-keygen -t rsa -b 4096 -C "email@example.com"` 으로 키 생성 
[깃허브 공식 문서](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) `ssh-keygen -t ed25519 -C "your_email@example.com"` 으로 생성하는걸 추천하고, ed25519를 지원하지 않는 레거시 환경에서 rsa를 쓰길 추천하고 있음.

## 2. SSH 키를 ssh-agent에 추가

`eval "$(ssh-agent -s)"` 커멘드를 통하여 ssh-agent를 백그라운드에서 실행
`ssh-add ~/.ssh/id_ed25519` 커멘드를 통하여 ssh-agent에 새로운 키를 추가

## 3. Github에 공개키 등록

`setting > SSH and GPG keys > New SSH Key` 에서 공개 키 등록

---

git remote 에 ssh 주소를 등록하면 ssh키를 이용한 깃허브 접근 가능!