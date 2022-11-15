# Todo App

youtube 개발하는남자님의 코딩레이스 참여 결과물!


## 상태관리

상태관리는 getx 라이브러리를 사용해서 개발했고, 모든 변수 및 함수들은 하나의 컨트롤러안에 작성했습니다.


## UI/UX
개발하는남자님이 디자인 해주신 시안에서 약간의 추가사항을(하단 내용) 더해 만들었습니다.

1. 할 일 개수 표시/한 일 개수 표시
2. sliding up panel 내에 tabbar/tabbarview 구현
3. 할 일 완료시 progressbar 애니메이션으로 구현
4. 할 일 작성/완료/삭제 시 상단에 Get에서 제공하는 snackbar 사용


## 화면 스크린샷
<img src=https://user-images.githubusercontent.com/85559690/201880866-bd0d49aa-d9b1-4de2-804a-f4507556b41e.png width="25%"><img src=https://user-images.githubusercontent.com/85559690/201880468-2cd2ed51-6088-4612-bed0-eb8322fcb52d.png width="25%"><img src=https://user-images.githubusercontent.com/85559690/201880988-efbac768-1b91-46b6-8e75-a4f6300556ac.png width="25%"><img src=https://user-images.githubusercontent.com/85559690/201881202-c65b6d5d-056c-4ca2-ba77-990b127f91c2.png width="25%">

## 개발 후기
한 컨트롤러 내에서 너무 많은 함수와 변수를 사용해서 복잡하다고 느껴졌고, widget의 size를 구해서 만든게 아니라 size를 하드코딩해서 만들었기 때문에, 해상도가 다른 화면에서는 문제가 발생할 수 있다.
전체적인 프로젝트 디렉토리 구성이나, 코드리팩토링이 필요한 부족한 프로젝트라고 생각한다. (개남님 소스와 비교하면서 깨우칠 예정)
