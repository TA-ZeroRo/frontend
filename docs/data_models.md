# Data Models Specification

이 문서는 Frontend 애플리케이션의 모든 데이터 모델에 대한 명세를 제공합니다.

## 📋 목차

- [모델 개요](#모델-개요)
- [인증 & 프로필](#인증--프로필)
- [채팅 & 대화](#채팅--대화)
- [커뮤니티](#커뮤니티)
- [캠페인](#캠페인)
- [검증 & 퀴즈](#검증--퀴즈)
- [차트](#차트)

---
## 인증 & 프로필

### Profile

사용자 프로필 정보를 담는 모델입니다.

**필드 설명:**

| 필드 | 타입 | 필수 | 기본값 | 설명 |
|------|------|------|--------|------|
| userId | String | ✅ | - | 사용자 고유 식별자 |
| username | String | ✅ | - | 사용자 이름 |
| userImg | String? | ❌ | null | 프로필 이미지 URL |
| totalPoints | int | ✅ | 0 | 누적 포인트 |
| continuousDays | int | ✅ | 0 | 연속 활동 일수 |
| birthDate | DateTime? | ❌ | null | 생년월일 |
| region | String? | ❌ | null | 지역 정보 |

---
## 커뮤니티

### Post

커뮤니티 게시글 모델입니다.

**필드 설명:**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| id | int | ✅ | 게시글 고유 ID |
| userId | String | ✅ | 작성자 ID |
| title | String | ✅ | 게시글 제목 |
| content | String | ✅ | 게시글 내용 |
| imageUrl | String? | ❌ | 첨부 이미지 URL |
| likesCount | int | ✅ | 좋아요 수 |
| createdAt | String | ✅ | 작성 시간 (ISO 8601 형식) |
| username | String | ✅ | 작성자 이름 |
| userImg | String? | ❌ | 작성자 프로필 이미지 URL |

### Comment

게시글 댓글 모델입니다.

**필드 설명:**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| id | int | ✅ | 댓글 고유 ID |
| postId | int | ✅ | 게시글 ID |
| userId | String | ✅ | 작성자 ID |
| content | String | ✅ | 댓글 내용 |
| createdAt | DateTime | ✅ | 작성 시간 |
| username | String | ✅ | 작성자 이름 |
| userImg | String? | ❌ | 작성자 프로필 이미지 URL |

---

## 캠페인

### CampaignRecruiting

환경 캠페인 모집 정보 모델입니다.

**필드 설명:**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| id | int | ✅ | 모집 공고 고유 ID |
| userId | String | ✅ | 작성자 ID |
| username | String | ✅ | 작성자 이름 |
| userImg | String? | ❌ | 작성자 프로필 이미지 URL |
| title | String | ✅ | 모집 공고 제목 |
| recruitmentCount | int | ✅ | 모집 인원 |
| campaignName | String | ✅ | 캠페인 이름 |
| requirements | String | ✅ | 모집 요건 |
| url | String? | ❌ | 관련 URL |
| createdAt | String | ✅ | 작성 시간 (ISO 8601 형식) |

---

## 검증 & 퀴즈

### VerificationResult

이미지 검증 결과 모델입니다.

**필드 설명:**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| isValid | bool | ✅ | 검증 통과 여부 |
| confidence | double | ✅ | 신뢰도 (0.0 ~ 1.0) |
| reason | String | ✅ | 검증 결과 사유 |

### QuizQuestion

환경 퀴즈 문제 모델입니다.

**필드 설명:**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| question | String | ✅ | 퀴즈 문제 |
| answer | String | ✅ | 정답 ('O' 또는 'X') |
| explanation | String | ✅ | 정답 해설 |

---

## 차트

### ChartData

차트 데이터 모델입니다.

**필드 설명:**

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| date | DateTime | ✅ | 날짜 |
| score | int | ✅ | 점수 |
