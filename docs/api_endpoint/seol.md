## **📚 LeaderBoard API 명세서**

## **📚 mission_log API 명세서**

### **1. `사용자의 모든 미션 로그 조회`**

- **URL**: /mission-logs/users/{user_id}
- **Method**: GET
- 특정 사용자의 모든 미션 로그를 조회(started_at DESC) 로 정렬
- **Path Parameters**
  - `user_id` (UUID, Required): 조회할 유저의 ID
- Query Parameters
  - `include_template` (boolean, Optional - 기본값 : True) : 미션 템플릿 정보 포함 여부
  - `include_campaign` (boolean, Optional - 기본값 : True) : 캠페인 정보 포함 여부
- **Response (200 OK) `inluce_template = True` , `include_campaign = True`**

```bash
[
  {
    "id": 19,
    "user_id": "346b4ae4-ea3c-43c3-a9a8-5e5ccadd006f",
    "mission_template_id": 4,
    "status": "IN_PROGRESS",
    "started_at": "2025-11-11T13:09:37.527361+00:00",
    "completed_at": null,
    "proof_data": null,
    "created_at": "2025-11-11T13:09:37.562978+00:00",
    "updated_at": "2025-11-11T13:09:37.562978+00:00",
    "mission_templates": {
      "id": 4,
      "campaign_id": 3,
      "title": "미세먼지 줄이기 실천",
      "description": "실내외 환기, 공기정화 식물 관리, 친환경 이동수단(자전거, 대중교통) 이용 모습 인증사진 제출",
      "verification_type": "IMAGE",
      "reward_points": 100,
      "order": 3,
      "created_at": "2025-11-09T17:13:51.949843+00:00",
      "updated_at": "2025-11-09T17:13:51.949843+00:00",
      "campaigns": {
        "id": 3,
        "title": "탄탄대로 챌린지",
        "description": "환경 보호 활동",
        "host_organizer": "서울시",
        "campaign_url": "https://example.com/campaign",
        "image_url": "https://example.com/image.jpg",
        "start_date": "2025-01-01",
        "end_date": "2025-12-31",
        "region": "서울특별시",
        "category": "ZERO_WASTE",
        "status": "ACTIVE",
        "updated_at": "2025-11-09T17:13:51.949843+00:00"
      }
    }
  }
]
```

### **1. `리더보드 순위 조회`**

- **URL**: /leaderboard/ranking
- **Method**: GET
- 기본 limit 값(50)으로 상위 50명의 사용자를 조회
- total_points가 동점일 시 continuous_days 순으로 rank 결정
- **Response (200 OK)**

```bash
{
  [
    {
      "id": "f8d96697-c125-4715-8be9-524231057496" // Required(string),
      "username": "재우", //Optional(string, null가능)
      "user_img": null, //Optional(string, 기본값 : null)
      "total_points": 20, // Required(int)
      "continuous_days": 2, // Required(int)
      "rank": 1 //  --> schemas에서 왜 Optional로 되있는거 모르겠음(질문) rank변수를 추가할지 말지
    },
    {
      "id": "fa77a1bc-57da-457a-8130-b048918d03fe",
      "username": "홍길동",
      "user_img": null,
      "total_points": 20,
      "continuous_days": 2,
      "rank": 2
    },
    {
      "id": "0a6b92bf-9e2e-4ac5-9ad8-98fa7f9e102e",
      "username": "string",
      "user_img": "string",
      "total_points": 10,
      "continuous_days": 0,
      "rank": 3
    }
  ]
}
```

- **Error Responses**
  - `500` : 리더보드 데이터를 가져올 수 없습니다

---

## API 명세서: 사용자 리더보드 순위 조회

- **URL**: `/api/v1/leaderboard/ranking/{user_id}`
- **Method**: `GET`
- **설명**: 특정 사용자의 리더보드 정보와 순위를 조회합니다.

### Path Parameters

| 파라미터  | 타입 | 필수 | 설명                        |
| --------- | ---- | ---- | --------------------------- |
| `user_id` | UUID | Yes  | 조회할 사용자의 고유 식별자 |

### Request Example

```bash
GET /api/v1/leaderboard/ranking/123e4567-e89b-12d3-a456-426614174000
```

### Response

### 성공 응답 (200 OK)

```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "username": "user123",
  "user_img": "https://example.com/avatar.jpg",
  "total_points": 1500,
  "rank": 5
}
```

**Response Fields**

| 필드           | 타입          | Nullable | 설명                         |
| -------------- | ------------- | -------- | ---------------------------- |
| `id`           | UUID (string) | No       | 사용자 고유 식별자           |
| `username`     | string        | Yes      | 사용자 이름                  |
| `user_img`     | string        | Yes      | 사용자 프로필 이미지 URL     |
| `total_points` | integer       | No       | 사용자의 총 포인트           |
| `rank`         | integer       | Yes      | 리더보드 순위 (1위부터 시작) |

### 에러 응답

**404 Not Found** - 사용자를 찾을 수 없는 경우

```json
{
  "detail": "User not found"
}
```

**500 Internal Server Error** - 서버 오류 발생 시

```json
{
  "detail": "Error message"
}
```

## **📚 Campaign API 명세서**

### **1. `캠페인 목록 조회`**

- **URL**: /campaign/campaign
- **Method**: GET
- **Query Parameters**
  - `region` (string, Optional): 지역 필터 (예: "서울특별시", "경기도")
  - `category` (CampaignCategory, Optional): 카테고리 필터
    - `RECYCLING`: 재활용/분리수거
    - `TRANSPORTATION`: 대중교통/자전거
    - `ENERGY`: 에너지 절약
    - `ZERO_WASTE`: 제로웨이스트/다회용기
    - `CONSERVATION`: 자연보호/환경정화
    - `EDUCATION`: 교육/세미나
    - `OTHER`: 기타
  - `status` (CampaignStatus, Optional, Default: `ACTIVE`) : 상태 필터
    - `EXPECT`: 예정
    - `ACTIVE`: 진행중
    - `EXPIRED`: 종료
  - `SubmissionType`
    - `RPA_FORM_SUBMIT` : RPA 폼 자동 제출
    - `DIRECT_API` : 직접 API 연동
    - `MANUAL_GUIDE` : 수동 안내 (기본값)
  - RPA 관련 필드 설명
    - `rpa_site_config_id` : RPA 사이트 설정 ID (로그인 설정 참조)
    - `rpa_form_url` : RPA 폼 제출 페이지 URL
    - `rpa_form_config` : RPA 폼 셀렉터 설정 (JSON)
    - `rpa_field_mapping` : submission_data 필드명 → 폼 셀렉터 매핑 (JSON)
    - `rpa_form_selector_strategies` : Self-Healing용 폼 셀렉터 전략 (JSON)
  - `offset` (int, Optional, Default: `0`): 페이지네이션 오프셋 (≥0)
- **응답 특징**
  - 정렬: `updated_at` 기준 내림차순 (최신순)
  - 페이지 크기: 20개/페이지 (고정)
  - 기본 필터: `status=ACTIVE` (명시하지 않으면 진행중인 캠페인만 조회)
  - RPA 관련 필드 : `submission_type = RPA_FORM_SUBMIT` 인 경우에만 값이 있을 수 있음
- **Response (200 OK)**

```bash
[
  {
    "id": 1,
    "title": "서울시 에코마일리지 캠페인",
    "description": "서울시에서 진행하는 환경보호 캠페인입니다.",
    "host_organizer": "서울특별시",
    "campaign_url": "https://example.com/campaign/1",
    "image_url": "https://example.com/images/campaign1.jpg",
    "start_date": "2024-01-01",
    "end_date": "2024-12-31",
    "region": "서울특별시",
    "category": "RECYCLING",
    "status": "ACTIVE",
    "submission_type": "RPA_FORM_SUBMIT",
    "updated_at": "2024-01-01T10:00:00Z",
    "rpa_site_config_id": 1,
    "rpa_form_url": "https://example.com/form",
    "rpa_form_config": {
      "form_selector": "#campaign-form",
      "fields": {}
    },
    "rpa_field_mapping": {
      "name": "input[name='name']",
      "email": "input[name='email']"
    },
    "rpa_form_selector_strategies": {
      "fallback_selectors": ["#form", ".form-container"]
    }
  },
  {
    "id": 2,
    "title": "경기도 자전거 이용 캠페인",
    "description": null,
    "host_organizer": "경기도청",
    "campaign_url": "https://example.com/campaign/2",
    "image_url": null,
    "start_date": "2024-02-01",
    "end_date": null,
    "region": "경기도",
    "category": "TRANSPORTATION",
    "status": "ACTIVE",
    "submission_type": "MANUAL_GUIDE",
    "updated_at": "2024-01-15T14:30:00Z",
    "rpa_site_config_id": null,
    "rpa_form_url": null,
    "rpa_form_config": null,
    "rpa_field_mapping": null,
    "rpa_form_selector_strategies": null
  }
]
```

- **Error Responses**
  - `500 Internal Server Error`: 처리 중 오류 발생

---

## **📚 Campaign_agent API 명세서**

### **1. `캠페인 시작`**

- **URL**: /api/v1/campaign-agent/campaigns/{campaign_id}
- **Method**: POST
- **Path Parameters**
  - `campaign_id` (int, Required): 시작할 캠페인의 ID
- 최소 Request Body

```bash
{
  "user_id": "123e4567-e89b-12d3-a456-426614174000"  // Required (UUID)
}
```

- **Response (201 Created)**

```bash
{
  "success": true,
  "campaign_id": 1,
  "missions_created": 3,
  "mission_logs": [
    {
      "id": 1,
      "user_id": "123e4567-e89b-12d3-a456-426614174000",
      "mission_template_id": 1,
      "status": "IN_PROGRESS",
      "started_at": "2024-01-01T10:00:00Z",
      "created_at": "2024-01-01T10:00:00Z",
      "updated_at": "2024-01-01T10:00:00Z"
    },
    {
      "id": 2,
      "user_id": "123e4567-e89b-12d3-a456-426614174000",
      "mission_template_id": 2,
      "status": "IN_PROGRESS",
      "started_at": "2024-01-01T10:00:00Z",
      "created_at": "2024-01-01T10:00:00Z",
      "updated_at": "2024-01-01T10:00:00Z"
    }
  ]
}
```

- 동작 설명

  - 캠페인에 속한 모든 미션 템플릿에 대해 미션 로그를 생성합니다.
  - 이미 존재하는 미션 로그가 있으면 새로 생성하지 않고 기존 로그를 반환합니다.
  - 모든 미션 로그는 `IN_PROGRESS` 상태로 시작됩니다.

- Error Responses
  - `404 Not Found` : 캠페인을 찾을 수 없다 or 미션 템플릿이 없다.
  - `500 Internal Server Error` : 캠페인 시작에 실패했습니다.

### **2. `캠페인 진행 상황 조회`**

- **URL**: /api/v1/campaign-agent/campaigns/{campaign_id}
- **Method**: GET
- **Path Parameters**
  - `campaign_id` (int, Required): 조회할 캠페인의 ID
- Query Parameters
  - `user_id` (UUID, Required): 사용자 ID
- Response (200 OK)

```bash
{
  "campaign_id": 1,
  "total_missions": 3,
  "completed_missions": 1,
  "in_progress_missions": 2,
  "completion_rate": 33.33,
  "total_points_earned": 100,
  "missions": [
    {
      "mission_template": {
        "id": 1,
        "campaign_id": 1,
        "title": "에코마일리지 신청하기",
        "description": "서울시 에코마일리지에 신청합니다.",
        "verification_type": "RPA_ACTION",
        "order": 1,
        "reward_points": 100,
        "created_at": "2024-01-01T10:00:00Z"
      },
      "status": "COMPLETED",
      "log": {
        "id": 1,
        "user_id": "123e4567-e89b-12d3-a456-426614174000",
        "mission_template_id": 1,
        "status": "COMPLETED",
        "started_at": "2024-01-01T10:00:00Z",
        "completed_at": "2024-01-01T11:00:00Z",
        "proof_data": {
          "rpa_result": {
            "success": true
          },
          "submission_data": {}
        },
        "created_at": "2024-01-01T10:00:00Z",
        "updated_at": "2024-01-01T11:00:00Z"
      }
    },
    {
      "mission_template": {
        "id": 2,
        "campaign_id": 1,
        "title": "사진 인증하기",
        "description": "환경 활동 사진을 업로드합니다.",
        "verification_type": "IMAGE",
        "order": 2,
        "reward_points": 50,
        "created_at": "2024-01-01T10:00:00Z"
      },
      "status": "IN_PROGRESS",
      "log": {
        "id": 2,
        "user_id": "123e4567-e89b-12d3-a456-426614174000",
        "mission_template_id": 2,
        "status": "IN_PROGRESS",
        "started_at": "2024-01-01T10:00:00Z",
        "completed_at": null,
        "proof_data": null,
        "created_at": "2024-01-01T10:00:00Z",
        "updated_at": "2024-01-01T10:00:00Z"
      }
    },
    {
      "mission_template": {
        "id": 3,
        "campaign_id": 1,
        "title": "소감문 작성하기",
        "description": "환경 활동 소감문을 작성합니다.",
        "verification_type": "TEXT_REVIEW",
        "order": 3,
        "reward_points": 30,
        "created_at": "2024-01-01T10:00:00Z"
      },
      "status": "NOT_STARTED",
      "log": null
    }
  ]
}
```

- Error Responses
  - `404 Not Found` : 캠페인을 찾을 수 없습니다.
  - `500 Internal Server Error` : 진행 상황 조회에 실패했습니다.

### **3. `RPA를 통해 미션 제출`**

- **URL**: /api/v1/campaign-agent/mission-logs/{mission_log_id}
- **Method**: POST
- **Path Parameters**

  - `mission_log_id` (int, Required): 제출할 미션 로그의 ID

- 최소 Request Body

```bash
{
  "user_id": "123e4567-e89b-12d3-a456-426614174000",  // Required (UUID)
  "submission_data": {  // Required (dict)
    "name": "홍길동",  // Required (string)
    "birth": "900101",  // Required (string, 6자리 생년월일)
    "phone": "01012345678",  // Required (string)
    "activity_date": "2024-01-01",  // Required (string, YYYY-MM-DD)
    "activity_content": "에코마일리지 신청을 완료했습니다."  // Required (string)
  },
  "credentials": {  // Required (dict)
    "username": "user@example.com",  // Required (string)
    "password": "password123"  // Required (string)
  }
}
```

- Response (200 OK)

```bash
{
  "success": true,
  "message": "Mission submitted successfully via RPA",
  "rpa_result": {
    "success": true,
    "message": "Form submitted successfully"
  },
  "mission_log": {
    "id": 1,
    "user_id": "123e4567-e89b-12d3-a456-426614174000",
    "mission_template_id": 1,
    "status": "COMPLETED",
    "started_at": "2024-01-01T10:00:00Z",
    "completed_at": "2024-01-01T11:00:00Z",
    "proof_data": {
      "rpa_result": {
        "success": true,
        "message": "Form submitted successfully"
      },
      "submission_data": {
        "name": "홍길동",
        "birth": "900101",
        "phone": "01012345678",
        "activity_date": "2024-01-01",
        "activity_content": "에코마일리지 신청을 완료했습니다."
      },
      "submitted_at": "2024-01-01T11:00:00Z"
    },
    "created_at": "2024-01-01T10:00:00Z",
    "updated_at": "2024-01-01T11:00:00Z"
  }
}
```

- Response (200 OK) - 실패 시

```bash
{
  "success": false,
  "message": "RPA submission failed",
  "rpa_result": {
    "success": false,
    "error": "Login failed: Invalid credentials"
  },
  "mission_log": {
    "id": 1,
    "user_id": "123e4567-e89b-12d3-a456-426614174000",
    "mission_template_id": 1,
    "status": "FAILED",
    "started_at": "2024-01-01T10:00:00Z",
    "completed_at": null,
    "proof_data": {
      "rpa_result": {
        "success": false,
        "error": "Login failed: Invalid credentials"
      },
      "error": "Login failed: Invalid credentials",
      "attempted_at": "2024-01-01T11:00:00Z"
    },
    "created_at": "2024-01-01T10:00:00Z",
    "updated_at": "2024-01-01T11:00:00Z"
  }
}
```

- 동작 설명
  - RPA를 사용하여 자동으로 폼을 제출합니다.
  - 제출 전에 미션 상태를 `PENDING_VERIFICATION`으로 변경합니다.
  - RPA 실행 결과에 따라:
    - 성공 시: 미션 상태를 `COMPLETED`로 변경하고 `proof_data`에 결과 저장
    - 실패 시: 미션 상태를 `FAILED`로 변경하고 에러 정보 저장
      - 하이브리드 RPA 구조를 지원합니다 (campaign의 `rpa_site_config_id`와 `rpa_form_config`가 있으면 사용).
- Error Responses
  - `404 Not Found` : 미션 로그를 찾을 수 없습니다.
  - `404 Not Found` : 이 미션이 본인 소유가 아닙니다.
  - `404 Not Found` : 미션이 이미 완료되었습니다.
  - `404 Not Found` : 미션 템플릿을 찾을 수 없습니다.
  - `404 Not Found` : 캠페인을 찾을 수 없습니다.
  - `404 Not Found` : RPA 사이트 설정을 찾을 수 없습니다.
  - `500 Internal Server Error` : 미션 제출에 실패했습니다.

### 4. `실패한 미션 재시도`

- **URL**: /api/v1/campaign-agent/mission-logs/{mission_log_id}
- **Method**: PUT
- **Path Parameters**

  - `mission_log_id` (int, Required): 재시도할 미션 로그의 ID

- Request Body

```bash
{
  "user_id": "123e4567-e89b-12d3-a456-426614174000",  // Required (UUID)
  "submission_data": {  // Required (dict)
    "name": "홍길동",
    "birth": "900101",
    "phone": "01012345678",
    "activity_date": "2024-01-01",
    "activity_content": "에코마일리지 신청을 완료했습니다."
  },
  "credentials": {  // Required (dict)
    "username": "user@example.com",
    "password": "password123"
  }
}
```

- Response (200 OK)

```bash
{
  "success": true,
  "message": "Mission submitted successfully via RPA",
  "rpa_result": {
    "success": true,
    "message": "Form submitted successfully"
  },
  "mission_log": {
    "id": 1,
    "user_id": "123e4567-e89b-12d3-a456-426614174000",
    "mission_template_id": 1,
    "status": "COMPLETED",
    "started_at": "2024-01-01T10:00:00Z",
    "completed_at": "2024-01-01T11:30:00Z",
    "proof_data": {
      "rpa_result": {
        "success": true
      },
      "submission_data": {},
      "submitted_at": "2024-01-01T11:30:00Z"
    },
    "created_at": "2024-01-01T10:00:00Z",
    "updated_at": "2024-01-01T11:30:00Z"
  }
}
```

- 동작 설명
  - 실패한 미션(`FAILED` 상태)을 재시도합니다.
  - 실제로는 `submit_mission_with_rpa` 와 동일한 로직을 사용합니다.
  - 미션 상태가 `FAILED` 가 아니면 재시도할 수 없습니다.
- Error Responses
  - `404 Not Found` : 미션 로그를 찾을 수 없습니다.
  - `404 Not Found` : 이 미션이 본인 소유가 아닙니다.
  - `404 Not Found` : 실패한 미션만 재시도할 수 있습니다.
  - `500 Internal Server Error` : 미션 재시도에 실패했습니다.

```bash
## **📝 참고사항**

### **미션 상태 (MissionLogStatus)**

- `IN_PROGRESS`: 진행 중
- `PENDING_VERIFICATION`: 검증 대기 (RPA 제출 후)
- `COMPLETED`: 완료
- `FAILED`: 실패
- `NOT_STARTED`: 시작하지 않음 (로그가 없는 경우)

### **RPA 제출 방식**

1. **하이브리드 RPA** (권장)
   - Campaign에 `rpa_site_config_id`와 `rpa_form_config`가 설정되어 있는 경우
   - 로그인 설정은 사이트 설정에서 공유하고, 폼 설정은 Campaign별로 개별 관리
   - 더 유연하고 확장 가능한 구조

2. **레거시 RPA** (하위 호환성)
   - 하이브리드 설정이 없는 경우 기존 방식 사용
   - 서울시 에코마일리지 전용

### **submission_data 필드**

RPA 제출 시 필요한 필드 (캠페인별로 다를 수 있음):
- `name` (string): 신청자 이름
- `birth` (string): 생년월일 (6자리, YYMMDD)
- `phone` (string): 전화번호
- `activity_date` (string): 활동일자 (YYYY-MM-DD)
- `activity_content` (string): 활동내용

### **credentials 필드**

로그인에 필요한 정보:
- `username` (string): 사용자명 또는 이메일
- `password` (string): 비밀번호

---

**⚠️ 참고**:
- RPA 제출은 실제 웹사이트에 접속하여 폼을 제출하므로 시간이 걸릴 수 있습니다.
- 실패한 미션은 재시도할 수 있지만, 이미 완료된 미션은 재제출할 수 없습니다.
- 미션 로그는 사용자별로 관리되므로, 다른 사용자의 미션을 제출할 수 없습니다.
```

- status (string, Required): 미션 상태
  - "PROGRESS" : 진행
  - "VERIFICATION" : 검증 대기
  - "COMPLETED" : 성공
  - "FAILED" : 실패
- 정렬 순서: started_at 기준 내림차순 (최신순)
- Error Responses :
  - `500` : 미션 조회 중 오류

---

---

## **📚 Point API 명세서**

### 1. 포인트 로그 생성

- **URL:** /point/{user_id}
- **Method**: POST
- **Path Parameter**
  - user_id (UUID)
  - point (int)
- **Response**

```bash
{

	"message": "포인트 로그가 성공적으로 추가되었습니다.",
	"log": {
		"id": "uuid",
		"user_id": "user_uuid",
		"point": 100,
		"created_at": "timestamp"
	}
}
```

---

### 2. 포인트 로그 조회

- **URL:** /point/{user_id}
- **Method**: GET
- **Path Parameter**
  - user_id (UUID)
- **Response**

```bash
  [
    {
      "date": "2024-03-15",
      "score": 150
    },
    {
      "date": "2024-03-16",
      "score": 200
    }
    ...
  ]
```

---

## **📚 User API 명세서**

### **1. `유저 생성`**

- **URL**: /users
- **Method**: POST
- **Request Body**

```bash
{
  "id": "123e4567-e89b-12d3-a456-426614174000",  // Required (str)
  "username": "홍길동",  // Required (string)
  "region": "서울",  // Required (string)
  "user_img": "https://example.com/profile.jpg",  // Optional
  "total_points": 100,  // Optional (기본값: 0)
  "continuous_days": 5,  // Optional (기본값: 0)
  "characters": ["캐릭터1", "캐릭터2"],  // Optional
  "last_active_at": "2024-01-01T10:00:00Z"  // Optional (기본값: 현재 시각)
}
```

- **최소 Request Body**

```bash
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "username": "홍길동",
  "region": "서울"
}
```

- **Response (201 Created)**

```bash
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "username": "홍길동",
  "user_img": "https://example.com/profile.jpg",
  "total_points": 100,
  "continuous_days": 5,
  "region": "서울",
  "characters": ["캐릭터1", "캐릭터2"],
  "last_active_at": "2024-01-01T10:00:00Z",
  "created_at": "2024-01-01T10:00:00Z"
}
```

---

### **2. `유저 정보 조회`**

- **URL**: /users/{user_id}
- **Method**: GET
- **Path Parameters**
  - `user_id` (UUID, Required): 조회할 유저의 ID
- **Response (200 OK)**

```bash
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "username": "홍길동",
  "user_img": "https://example.com/profile.jpg",
  "total_points": 150,
  "continuous_days": 7,
  "region": "서울",
  "characters": ["캐릭터1", "캐릭터2"],
  "last_active_at": "2024-01-01T12:00:00Z",
  "created_at": "2024-01-01T10:00:00Z"
}
```

- **Error Responses**
  - `404 Not Found`: 해당 user를 찾을 수 없습니다.

---

### **3. `유저 정보 수정`**

- **URL**: /users/{user_id}
- **Method**: PUT
- **Path Parameters**
  - `user_id` (UUID, Required): 수정할 유저의 ID
- **Request Body** (모든 필드 Optional)

```bash
{
  "username": "새로운이름",  // Optional
  "user_img": "https://example.com/new-profile.jpg",  // Optional
  "total_points": 200,  // Optional
  "region": "부산",  // Optional
  "characters": ["새캐릭터1", "새캐릭터2"],  // Optional
  "last_active_at": "2024-01-01T15:00:00Z"  // Optional (미제공 시 서버에서 자동 설정)
}
```

- **부분수정예시**

```bash
{
  "username": "새이름"
}
```

- **Response (200 OK)**

```bash
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "username": "새로운이름",
  "user_img": "https://example.com/new-profile.jpg",
  "total_points": 200,
  "continuous_days": 10,
  "region": "부산",
  "characters": ["새캐릭터1", "새캐릭터2"],
  "last_active_at": "2024-01-01T15:30:00Z",
  "created_at": "2024-01-01T10:00:00Z"
}
```

- **Error Responses**
  - `400 Bad Request`: 업데이트할 데이터가 없습니다.
  - `500 Internal Server Error`: 유저 수정에 실패했습니다.

**⚠️ 제약사항:**

- `continuous_days`는 요청에 포함할 수 없음 (시스템 자동 관리)
- `last_active_at`을 명시하지 않으면 서버에서 자동으로 현재 시각으로 설정

---

### **4. `유저 삭제`**

- **URL**: `/users/{user_id}`
- **Method**: `DELETE`
- **Path Parameters**
  - `user_id` (UUID, Required): 삭제할 유저의 ID
- **Response (200 OK)**

```bash
{
  "message": "유저가 성공적으로 삭제되었습니다."
}
```

- **Error Responses**
  - `500 Internal Server Error`: 유저 삭제에 실패했습니다.

---
