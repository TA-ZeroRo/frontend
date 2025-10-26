## **📚 LeaderBoard API 명세서**

### **1. `리더보드 순위 조회`**

- **URL**: /leaderBoard/ranking
- **Method**: GET
- **Response**

```bash
  {
    "ranking": [
      {
     "id": "7332782a-a109-4c8a-8187-f5d154eab3fe",
      "username": "ZeroRo Dev",
      "user_img": "https://aldghxocvhbscghaztfk.supabase.co/storage/v1/object/public/zeroro-post-bucket//zeroro_icon.png",
      "total_points": 0,
      "continuous_days": 0,
      "rank": 1
      },
    ]
  }
```

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

---

## **📚 User API 명세서**

### **1. `유저 생성`**

- **URL**: /users
- **Method**: POST
- **Request Body**

```bash
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "username": "홍길동",
  "user_img": "https://example.com/profile.jpg",
  "total_points": 100,
  "continuous_days": 5,
  "region": "서울",
  "characters": ["캐릭터1", "캐릭터2"],
  "last_active_at": "2024-01-01T10:00:00Z"
}
```

- **Response**

```bash
{
  "user": {
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
}
```

---

### **2. `유저 정보 조회`**

- **URL**: /users/{user_id}
- **Method**: GET
- **Response**

```bash
{
  "user": {
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
}
```

---

### **3. `유저 정보 수정`**

- **URL**: /users/{user_id}
- **Method**: PUT
- **Request Body**

```bash
{
  "username": "새로운이름",
  "user_img": "https://example.com/new-profile.jpg",
  "total_points": 200,
  "continuous_days": 10,
  "region": "부산",
  "characters": ["새캐릭터1", "새캐릭터2"],
  "last_active_at": "2024-01-01T15:00:00Z"
}
```

- **Response**

```bash
{
  "user": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "username": "새로운이름",
    "user_img": "https://example.com/new-profile.jpg",
    "total_points": 200,
    "continuous_days": 10,
    "region": "부산",
    "characters": ["새캐릭터1", "새캐릭터2"],
    "last_active_at": "2024-01-01T15:00:00Z",
    "created_at": "2024-01-01T10:00:00Z"
  }
}
```

---

### **4. `유저 삭제`**

- **URL**: /users/{user_id}
- **Method**: DELETE
- **Response**

```bash
  {
    "message": "유저가 성공적으로 삭제되었습니다."
  }

```

---
