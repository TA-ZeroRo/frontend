import 'package:shared_preferences/shared_preferences.dart';

/// 캐릭터 선택 정보를 로컬에 저장/조회하는 유틸리티 클래스
///
/// Shared Preferences를 사용하여 사용자가 선택한 AI 캐릭터를 저장합니다.
///
/// 사용 가능한 캐릭터:
/// - earth_zeroro (지구 제로로) - 기본 캐릭터
/// - dust_zeroro (먼지 제로로) - 300 포인트로 해금
class CharacterPreferences {
  CharacterPreferences._();

  static const String _selectedCharacterKey = 'selected_character';
  static const String _unlockedCharactersKey = 'unlocked_characters';
  static const String _defaultCharacter = 'earth_zeroro';

  /// 사용 가능한 캐릭터 목록
  static const List<String> availableCharacters = [
    'earth_zeroro',
    'dust_zeroro',
  ];

  /// 캐릭터 표시 이름 매핑
  static const Map<String, String> characterNames = {
    'earth_zeroro': '지구 제로로',
    'dust_zeroro': '먼지 제로로',
  };

  /// 캐릭터 해금 비용 매핑 (포인트)
  static const Map<String, int> characterUnlockCosts = {
    'earth_zeroro': 0,      // 기본 캐릭터
    'dust_zeroro': 300,     // 300 포인트 필요
  };

  /// 현재 선택된 캐릭터 ID 가져오기
  ///
  /// Returns: 선택된 캐릭터 ID (기본값: earth_zeroro)
  static Future<String> getSelectedCharacter() async {
    final prefs = await SharedPreferences.getInstance();
    final character = prefs.getString(_selectedCharacterKey) ?? _defaultCharacter;

    // 유효하지 않은 캐릭터 ID인 경우 기본값 반환
    if (!availableCharacters.contains(character)) {
      return _defaultCharacter;
    }

    return character;
  }

  /// 캐릭터 선택 저장
  ///
  /// [characterId]: 선택할 캐릭터 ID (earth_zeroro, dust_zeroro)
  ///
  /// Throws: [ArgumentError] - 유효하지 않은 캐릭터 ID인 경우
  static Future<void> setSelectedCharacter(String characterId) async {
    if (!availableCharacters.contains(characterId)) {
      throw ArgumentError(
        'Invalid character ID: $characterId. Must be one of: ${availableCharacters.join(", ")}'
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedCharacterKey, characterId);
  }

  /// 캐릭터 선택 초기화 (기본값으로 복원)
  static Future<void> clearSelectedCharacter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedCharacterKey);
  }

  /// 캐릭터 ID로 표시 이름 가져오기
  ///
  /// [characterId]: 캐릭터 ID
  ///
  /// Returns: 캐릭터 표시 이름 (예: "제로로")
  static String getCharacterName(String characterId) {
    return characterNames[characterId] ?? characterId;
  }

  /// 캐릭터 ID로 설명 가져오기
  ///
  /// [characterId]: 캐릭터 ID
  ///

  /// 캐릭터 ID가 유효한지 확인
  ///
  /// [characterId]: 확인할 캐릭터 ID
  ///
  /// Returns: 유효하면 true, 그렇지 않으면 false
  static bool isValidCharacter(String characterId) {
    return availableCharacters.contains(characterId);
  }

  /// 해금된 캐릭터 목록 가져오기
  ///
  /// Returns: 해금된 캐릭터 ID 목록 (기본 캐릭터는 항상 포함)
  static Future<List<String>> getUnlockedCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedList = prefs.getStringList(_unlockedCharactersKey) ?? [];

    // 기본 캐릭터는 항상 해금된 상태
    if (!unlockedList.contains(_defaultCharacter)) {
      unlockedList.add(_defaultCharacter);
      await prefs.setStringList(_unlockedCharactersKey, unlockedList);
    }

    return unlockedList;
  }

  /// 캐릭터가 해금되었는지 확인
  ///
  /// [characterId]: 확인할 캐릭터 ID
  ///
  /// Returns: 해금되었으면 true, 그렇지 않으면 false
  static Future<bool> isCharacterUnlocked(String characterId) async {
    // 기본 캐릭터는 항상 해금
    if (characterId == _defaultCharacter) {
      return true;
    }

    final unlockedCharacters = await getUnlockedCharacters();
    return unlockedCharacters.contains(characterId);
  }

  /// 캐릭터 해금
  ///
  /// [characterId]: 해금할 캐릭터 ID
  ///
  /// Returns: 성공하면 true, 그렇지 않으면 false
  ///
  /// Throws: [ArgumentError] - 유효하지 않은 캐릭터 ID인 경우
  static Future<bool> unlockCharacter(String characterId) async {
    if (!availableCharacters.contains(characterId)) {
      throw ArgumentError(
        'Invalid character ID: $characterId. Must be one of: ${availableCharacters.join(", ")}'
      );
    }

    // 이미 해금된 캐릭터인지 확인
    if (await isCharacterUnlocked(characterId)) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final unlockedList = await getUnlockedCharacters();
    unlockedList.add(characterId);
    await prefs.setStringList(_unlockedCharactersKey, unlockedList);

    return true;
  }

  /// 캐릭터 해금 비용 가져오기
  ///
  /// [characterId]: 캐릭터 ID
  ///
  /// Returns: 해금 비용 (포인트)
  static int getUnlockCost(String characterId) {
    return characterUnlockCosts[characterId] ?? 0;
  }

  /// 해금된 캐릭터 초기화 (테스트용)
  static Future<void> clearUnlockedCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_unlockedCharactersKey);
  }
}
