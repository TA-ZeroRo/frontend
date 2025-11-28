import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Settings keys
class _SettingsKeys {
  static const String notificationsEnabled = 'notificationsEnabled';
  static const String language = 'language';
  static const String selectedCharacter = 'selectedCharacter';
}

// Settings state model
class SettingsState {
  final bool notificationsEnabled;
  final String language;
  final String selectedCharacter;

  const SettingsState({
    this.notificationsEnabled = true,
    this.language = 'ko',
    this.selectedCharacter = 'earth', // 'earth' or 'cloud'
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    String? language,
    String? selectedCharacter,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      selectedCharacter: selectedCharacter ?? this.selectedCharacter,
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
          _prefs?.getString(_SettingsKeys.selectedCharacter) ?? 'earth',
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
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, SettingsState>(
      AppSettingsNotifier.new,
    );
