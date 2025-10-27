import 'package:flutter/material.dart';

void coloredDebugPrint(String message, {String color = '\x1B[0m'}) {
  debugPrint('$color$message\x1B[0m');
}

/// Red debugPrint
void errorDebugPrint(String message) =>
    coloredDebugPrint(message, color: '\x1B[31m');

/// Green debugPrint
void infoDebugPrint(String message) =>
    coloredDebugPrint(message, color: '\x1B[32m');

/// Yellow debugPrint
void warningDebugPrint(String message) =>
    coloredDebugPrint(message, color: '\x1B[33m');
