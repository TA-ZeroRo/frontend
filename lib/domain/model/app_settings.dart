class AppSettings {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final String language;

  const AppSettings({
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.language = 'ko',
  });

  AppSettings copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    String? language,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.isDarkMode == isDarkMode &&
        other.notificationsEnabled == notificationsEnabled &&
        other.language == language;
  }

  @override
  int get hashCode => Object.hash(isDarkMode, notificationsEnabled, language);

  @override
  String toString() =>
      'AppSettings(isDarkMode: $isDarkMode, notificationsEnabled: $notificationsEnabled, language: $language)';
}
