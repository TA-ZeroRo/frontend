import 'package:flutter/material.dart';
import '../components/character_notification/character_notification_controller.dart';
import '../components/character_notification/character_notification_widget.dart';

/// 캐릭터 알림을 쉽게 표시하기 위한 헬퍼 클래스
///
/// Overlay API를 사용하여 알림을 표시합니다.
///
/// 사용 예시:
/// ```dart
/// // 기본 사용
/// CharacterNotificationHelper.show(
///   context,
///   message: "업로드 완료!",
///   characterImage: "assets/images/smile_zeroro.png",
///   bubbleColor: AppColors.success,
/// );
///
/// // 더 많은 커스터마이징
/// CharacterNotificationHelper.show(
///   context,
///   message: "새로운 캠페인이 있어요",
///   characterImage: "assets/images/mock_zeroro.jpg",
///   bubbleColor: Colors.blue,
///   textColor: Colors.white,
///   characterSize: 60.0,
///   duration: Duration(seconds: 4),
/// );
/// ```
class CharacterNotificationHelper {
  CharacterNotificationHelper._();

  /// 현재 표시 중인 OverlayEntry
  static OverlayEntry? _currentEntry;

  /// 캐릭터 알림 표시
  ///
  /// [context]: BuildContext (Overlay에 접근하기 위해 필요)
  /// [message]: 표시할 메시지 (필수)
  /// [characterImage]: 캐릭터 이미지 경로 (필수)
  /// [bubbleColor]: 말풍선 배경색 (기본: 흰색)
  /// [textColor]: 텍스트 색상 (기본: 검정)
  /// [bubbleBorderColor]: 말풍선 테두리 색상 (선택)
  /// [characterSize]: 캐릭터 아바타 크기 (기본: 50.0)
  /// [duration]: 알림 지속 시간 (기본: 3초)
  /// [borderRadius]: 말풍선 모서리 둥글기 (기본: 16.0)
  static void show(
    BuildContext context, {
    required String message,
    required String characterImage,
    Color bubbleColor = Colors.white,
    Color textColor = Colors.black87,
    Color? bubbleBorderColor,
    double characterSize = 50.0,
    Duration duration = const Duration(seconds: 3),
    double borderRadius = 16.0,
  }) {
    // 기존 알림이 있으면 먼저 제거
    hide();

    final notification = CharacterNotification(
      message: message,
      characterImage: characterImage,
      bubbleColor: bubbleColor,
      textColor: textColor,
      bubbleBorderColor: bubbleBorderColor,
      characterSize: characterSize,
      duration: duration,
      borderRadius: borderRadius,
    );

    // OverlayEntry 생성
    _currentEntry = OverlayEntry(
      builder: (context) => CharacterNotificationWidget(
        notification: notification,
        onDismiss: hide,
      ),
    );

    // Overlay에 추가
    Overlay.of(context).insert(_currentEntry!);
  }

  /// 알림 숨기기
  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}
