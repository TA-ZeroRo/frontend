import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Settings keys
class _SettingsKeys {
  static const String notificationsEnabled = 'notificationsEnabled';
  static const String language = 'language';
  static const String selectedCharacter = 'selectedCharacter';
  static const String selectedPersonality = 'selectedPersonality';
}

// Settings state model
class SettingsState {
  final bool notificationsEnabled;
  final String language;
  final String selectedCharacter;
  final String selectedPersonality;

  const SettingsState({
    this.notificationsEnabled = true,
    this.language = 'ko',
    this.selectedCharacter = 'earth_zeroro', // 'earth_zeroro' or 'dust_zeroro'
    this.selectedPersonality = 'friendly', // 기본 성격
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    String? language,
    String? selectedCharacter,
    String? selectedPersonality,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
      selectedPersonality: selectedPersonality ?? this.selectedPersonality,
    );
  }
}

class AppSettingsNotifier extends Notifier<SettingsState> {
  SharedPreferences? _prefs;

  @override
  SettingsState build() {
    _loadSettings();
    return const SettingsState();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    state = SettingsState(
      notificationsEnabled:
          _prefs?.getBool(_SettingsKeys.notificationsEnabled) ?? true,
      language: _prefs?.getString(_SettingsKeys.language) ?? 'ko',
      selectedCharacter:
          _prefs?.getString(_SettingsKeys.selectedCharacter) ?? 'earth_zeroro',
      selectedPersonality:
          _prefs?.getString(_SettingsKeys.selectedPersonality) ?? 'friendly',
    );
  }

  Future<void> toggleNotifications() async {
    final newValue = !state.notificationsEnabled;
    state = state.copyWith(notificationsEnabled: newValue);
    await _prefs?.setBool(_SettingsKeys.notificationsEnabled, newValue);
  }

  Future<void> updateLanguage(String language) async {
    state = state.copyWith(language: language);
    await _prefs?.setString(_SettingsKeys.language, language);
  }

  Future<void> updateCharacter(String character) async {
    state = state.copyWith(selectedCharacter: character);
    await _prefs?.setString(_SettingsKeys.selectedCharacter, character);
  }

  Future<void> updatePersonality(String personality) async {
    state = state.copyWith(selectedPersonality: personality);
    await _prefs?.setString(_SettingsKeys.selectedPersonality, personality);
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, SettingsState>(
      AppSettingsNotifier.new,
    );
