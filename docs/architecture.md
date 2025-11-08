## 개요

이 문서는 Zeroro 프론트엔드 프로젝트의 아키텍처, 코드 스타일, 사용 패키지 및 규칙을 정의합니다. 모든 개발 작업은 이 문서에 설명된 원칙을 따라야 합니다.

## 프로젝트 구조

### 클린 아키텍처

이 프로젝트는 클린 아키텍처 원칙을 따르며, 다음과 같이 4개의 레이어로 구성됩니다.

### 레이어별 책임

#### 1. 코어 레이어 (Core Layer)

- 전역 상수 및 설정
- 공통 유틸리티 함수
- 확장 함수
- 공통 오류 처리

#### 2. 데이터 레이어 (Data Layer)

- **data_source**: 외부 API, 로컬 DB 등에 접근
- **dto**: 네트워크/DB 응답을 위한 엔티티, 직렬화에 적합
- **repository_impl**: 도메인 저장소 인터페이스 구현

규칙:

- DTO는 `toModel()` 메서드를 통해 도메인 모델로 변환됩니다.
- 데이터 소스는 예외를 처리하고, 이는 저장소에서 처리됩니다.
- 저장소에는 비즈니스 로직이 포함되지 않습니다.

#### 3. 도메인 레이어 (Domain Layer)

- **model**: 비즈니스 로직에 사용되는 순수 Dart 엔티티 (`Freezed`패키지 사용)
- **repository**: 데이터 접근을 위한 추상 인터페이스

규칙:

- Flutter 프레임워크에 대한 의존성이 없습니다.
- 순수 Dart 코드로만 작성됩니다.
- 모델은 불변(immutable)입니다.
- 저장소에는 인터페이스만 정의됩니다.

#### 4. 프레젠테이션 레이어 (Presentation Layer)

- **screens**: 최상위 라우트 컨테이너
- **pages**

규칙:

- UI 로직과 비즈니스 로직을 분리합니다.
- 상태는 Riverpod의 사용합니다.
- 위젯은 가능한 한 Stateless로 작성해야 합니다.

## 코드 스타일

### Dart 스타일 가이드

- [Effective Dart](https://dart.dev/guides/language/effective-dart) 가이드를 따릅니다.
- `analysis_options.yaml`의 린트 규칙을 준수합니다.
- `flutter_lints` 패키지를 사용합니다.

#### 네트워킹

- `dio`: HTTP 클라이언트
- `retrofit`: 타입-세이프(Type-safe) REST 클라이언트
- `pretty_dio_logger`: HTTP 로깅

#### 로컬 저장소

- `shared_preferences`: 간단한 키-값 저장소
- `hive`: 로컬 데이터베이스
- `flutter_secure_storage`: 보안 저장소

#### JSON 직렬화

- `json_serializable`: 자동 JSON 직렬화
- `freezed`: 불변 모델 생성. 오류 처리를 위해 "abstract class" 사용

#### 유틸리티

- `intl`: 국제화/날짜 형식
- `logger`: 로깅
- `equatable`: 값 동등성 비교

#### UI

- `cached_network_image`: 이미지 캐싱
- `flutter_svg`: SVG 지원
- `shimmer`: 쉬머 효과 로딩 <- 로딩이 전체페이지를 마비시키는 것을 방지하고 데이터를 불러와야하는 요소에게 쉬머를 적용해서 UX를 향상시키도록 ㄱㄱ

## 추가 참고 사항

**이미지 캐싱:** 네트워크 이미지 캐싱을 사용하세요.
**지연 로딩(Lazy Loading):** 무거운 리소스의 로딩을 지연시키세요.
**빌드 최적화:** 불필요한 리빌드를 방지하세요.
