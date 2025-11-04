import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import '../theme/app_color.dart';

/// 토스트 메시지 헬퍼 클래스
class ToastHelper {
  /// AppBar 높이 상수
  static const double appBarHeight = 60;

  /// 성공 메시지 표시
  static void showSuccess(String message) {
    toastification.show(
      margin: const EdgeInsets.only(bottom: 50),
      alignment: Alignment.bottomCenter,
      style: ToastificationStyle.flatColored,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 2),
      primaryColor: AppColors.primary,
    );
  }

  /// 에러 메시지 표시
  static void showError(String message) {
    toastification.show(
      margin: const EdgeInsets.only(bottom: 50),
      alignment: Alignment.bottomCenter,
      style: ToastificationStyle.flatColored,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 2),
      primaryColor: AppColors.error,
    );
  }

  /// 경고 메시지 표시
  static void showWarning(String message) {
    toastification.show(
      margin: const EdgeInsets.only(bottom: 50),
      alignment: Alignment.bottomCenter,
      style: ToastificationStyle.flatColored,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 2),
      primaryColor: AppColors.warning,
    );
  }

  /// 정보 메시지 표시
  static void showInfo(String message) {
    toastification.show(
      margin: const EdgeInsets.only(bottom: 50),
      alignment: Alignment.bottomCenter,
      style: ToastificationStyle.flatColored,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 2),
      primaryColor: AppColors.success,
    );
  }
}
