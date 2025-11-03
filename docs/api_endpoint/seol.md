## **📚 LeaderBoard API 명세서**

### **1. `리더보드 순위 조회`**

- **URL**: /leaderBoard/ranking
- **Method**: GET
- 기본 limit 값(50)으로 상위 50명의 사용자를 조회
- total_points가 동점일 시 continuous_days 순으로 rank 결정
- **Response (200 OK)**

```bash
{
  "leaderboard": [
    {
      "id": "f8d96697-c125-4715-8be9-524231057496" // Required(string),
      "username": "재우", //Optional(string, null가능)
      "user_img": null, //Optional(string, 기본값 : null)
      "total_points": 20, // Required(int)
      "continuous_days": 2, // Required(int)
      "rank": 1 //  --> schemas에서 왜 Optional로 되있는거 모르겠음(질문)
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

## **📚 Mission API 명세서**

### **1. `유저 미션 조회`**

- **URL**: /api/v1/mission/{user_id}
- **Method**: GET
- **Path Parameters**
  - `user_id` (UUID, Required): 조회할 유저의 ID
- missions_by_campaign(dict) : campaign_id를 키로 하는 딕셔너리
- **Response (200 OK)**

```bash
{
  "missions_by_campaign": {
    "1": [
      {
        "id": 1 // Required(int) - 자동 증가,
        "user_id": "123e4567-e89b-12d3-a456-426614174000", // Required(string)
        "campaign_id": 1, // Required(Int)
        "description": "플라스틱 재활용하기", // Optional (string, 기본값: null)
        "status": "PROGRESS", // Required (string)
        "started_at": "2024-01-01T10:00:00Z", //Required (datetime)
        "completed_at": null // Optional (datetime, 기본값: null)
      },
      {
        "id": 2,
        "user_id": "123e4567-e89b-12d3-a456-426614174000",
        "campaign_id": 1,
        "description": "텀블러 사용하기",
        "status": "COMPLETED",
        "started_at": "2024-01-01T09:00:00Z",
        "completed_at": "2024-01-01T18:00:00Z"
      }
    ],
    "2": [
      {
        "id": 3,
        "user_id": "123e4567-e89b-12d3-a456-426614174000",
        "campaign_id": 2,
        "description": "대중교통 이용하기",
        "status": "VERIFICATION",
        "started_at": "2024-01-02T08:00:00Z",
        "completed_at": null
      }
    ]
  }
}

```

- status (string, Required): 미션 상태
  - "PROGRESS" : 진행
  - "VERIFICATION" : 검증 대기
  - "COMPLETED" : 성공
  - "FAILED" : 실패
- 정렬 순서: started_at 기준 내림차순 (최신순)
- Error Responses :
  - `500` : 유저 생성 중 오류가 발생했습니다.

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
