
## 뜯어보는 Nginx
- [ ] 한땀 한땀 뜯어 봅시다.
<br>

### 초기  사용 방법
- `init.sh` 을 실행
<br>

### 디버깅 모드
- `src/core/nginx.c`: main 함수 위치
- `data 폴더`: 각종 생성 파일
- `data/logs`: 로그 파일
- `data/www`: index.html 위치 (nginx.conf에 작성된 root 위치)

<br>

### 서버 실행 모드
- 루트 위치에 있는 `nginx` 실행
- 에러 발생시 Activity Monitor에서 nginx 종료 후 실행

  -`nginx: [emerg] bind() to 0.0.0.0:80 failed (48: Address already in use)`

</br>

# nginx
An official read-only mirror of http://hg.nginx.org/nginx/ which is updated hourly. Pull requests on GitHub cannot be accepted and will be automatically closed. The proper way to submit changes to nginx is via the nginx development mailing list, see http://nginx.org/en/docs/contributing_changes.html

