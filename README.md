![Image](https://github.com/user-attachments/assets/bf67fe15-c1a2-4918-83c8-8b3a0f3d5e13)
# Pingo

Pingo는 위치 기반으로 주변 사용자를 추천하고, 키워드 필터링을 통해 이상형을 찾을 수 있는 소개팅 앱입니다. </br>
이용자가 서로 좋아요를 누르면 매칭되어 채팅할 수 있으며, 연애 팁과 데이트 장소를 공유하는 커뮤니티도 제공하고 있습니다.


## 📌 제작 기간
- 2025년 01월 20일 ~ 2025년 03월 06일

## 📌 기술 스택
- **Frontend**: Flutter
- **Backend**: Java, Spring Boot
- **Database**: Oracle, MongoDB

## 📌 깃허브 주소
- [Frontend Repository](https://github.com/NAIMJAE/pingo_front)
- [Backend Repository](https://github.com/NAIMJAE/pingo_back)

## 📌 담당 역할
- **팀장**: 프로젝트 기획 및 진행 관리
- **커뮤니티 게시판**: 사용자가 연애 팁과 데이트 장소를 공유할 수 있는 기능 구현
- **시그널 페이지**: 유저가 관심 표현을 할 수 있는 인터랙션 기능 개발
- **결제 시스템**: 토스 결제 API 연동하여 유료 서비스 제공

---
![Image](https://github.com/user-attachments/assets/fc880dbc-2c16-4168-9531-08b54c44fcad)
**🏷️ 커뮤니티 페이지 - 장소 추천 게시판**
- 사용자가 방문한 장소를 추천할 수 있는 게시판

**📌 주요 기능**
- **장소 검색 및 추천**
    - 카카오 장소 검색 API를 활용하여 장소 검색 지원
    - API를 통해 얻은 위치 정보를 기반으로 게시글 작성 지원

- **위치 정보 활용**
    - 카카오 맵 API를 사용하여 위도·경도 기반 장소 출력
    - 장소 추천 게시글 검색 시, 위치 정보를 기반으로 정렬 기능 제공

- **자동 이미지 등록**
    - 장소 추천 게시글 작성 시, 웹 크롤링을 통해 기본 이미지 제공

- **채팅 기능 연동**
    - 공유하기 기능을 통해 채팅으로 장소 공유 기능 제공
 ---
![Image](https://github.com/user-attachments/assets/330cae54-0873-42d8-af9f-356d08dfcdf3)
**🏷️ 커뮤니티 페이지 - 데이팅 가이드 게시판**
- 데이트 팁과 가이드를 공유하는 게시판
- 연애와 관련된 정보 및 노하우를 공유하며, 직접 게시글을 작성할 수 있음

**📌 주요 기능**
- **다양한 연애 가이드 제공**
    - 소개팅 앱의 특성을 반영하여 연애와 관련된 다양한 주제의 가이드 게시글 작성

- **카테고리별 정리**
    - 사용자들은 3가지 카테고리에 맞는 데이팅 가이드 게시글을 작성할 수 있음
---
![Image](https://github.com/user-attachments/assets/b0c69df6-a8fb-4e3e-831a-75d0a1e26265)
**🏷️ 시그널 페이지 - 핑목록**
- 나를 Ping(좋아요)한 사람들의 목록을 확인할 수 있는 페이지
- 회원의 구독 상태에 따라 기능이 제한되며, 상세 정보를 확인 가능

**📌 주요 기능**
- 사용자는 무료 회원/유료 회원 여부에 따라 정보 확인 가능
- 무료 회원의 경우, "Pingo 구독권 결제하기" 버튼을 눌러 결제 페이지로 이동
- 유료 회원의 경우 나를 Ping(좋아요)한 사람의 상세 정보를 확인 가능
---
![Image](https://github.com/user-attachments/assets/410e7eac-e367-4ae5-871f-fb37e23c783e)
**🏷️ 시그널 페이지 - 키워드**
- 사용자의 이상형을 키워드를 기반으로 메인 페이지에 추천되는 이용자 필터링

**📌 주요 기능**
- **성향 분석 추천**
    - 회원가입 시 입력한 성향 키워드를 분석하여 비슷한 성향의 사용자 추천

- **계층형 키워드 적용**
    - 성향 키워드를 계층형 카테고리 구조로 적용하여 보다 정밀한 추천 구현
---
![Image](https://github.com/user-attachments/assets/89fc3086-ede8-457a-8c55-b25ab29fbc5b)
**🏷️ 결제 페이지**
- 유료 멤버십을 선택하고 결제

**📌 주요 기능**
- **간편한 결제 진행**
    - 토스 API를 활용하여 빠르고 안전한 결제 페이지 구현
---
![Image](https://github.com/user-attachments/assets/a019eb21-888b-4fc1-aacd-54a70f9aae7d)
**🏷️ 커스텀 Dio 클래스 구현 (JWT 인증)**
- Dio 패키지를 커스텀하여 서버와의 통신을 최적화
- JWT 기반 인증을 처리하고, 로그인 후 JWT 토큰을 자동으로 저장 및 관리
- 모든 페이지에서 CustomDio 싱글톤을 사용하여 API 요청 시 자동으로 JWT 포함
- 인증이 필요한 API 요청에서 자동으로 JWT 토큰을 포함하여 요청을 실행

**🏷️ Spring 서버의 전역 예외처리 로직 구현**
- 서버에서 발생 가능한 예외를 전역적으로 처리하기 위한 예외처리 클래스 구현
- 비즈니스 로직에서 CustomException을 발생시키고, @RestControllerAdvice
를 활용해 예외를 감지하여 적절한 응답 반환
- 예외 코드 및 메시지를 Enum으로 관리하여 유지보수성과 확장성을 높임

---
**📌 자료**
몽고DB 덤프 : [pingochat.chatMsg.json](https://github.com/user-attachments/files/19104292/pingochat.chatMsg.json)
