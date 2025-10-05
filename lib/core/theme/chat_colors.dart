import 'package:flutter/material.dart';

class ChatColors {
  ChatColors._();

  // Overlay backgrounds with transparency
  static const Color chatOverlayBg = Color(0xB3DAFFF3); // 70% opacity mint
  static const Color sidebarBg = Color(0xF2FFFFFF); // 95% opacity white
  static const Color inputAreaBg = Color(0xFFFFFFFF); // Solid white

  // Message bubbles
  static const Color userMessageBg = Color(0xFF00F3A5); // Brand green
  static const Color aiMessageBg = Color(0xFFFFFFFF); // White
  static const Color userMessageText = Color(0xFF003D2B); // Dark green for contrast
  static const Color aiMessageText = Color(0xFF1A1A1A); // Near black

  // Borders and dividers
  static const Color divider = Color(0x1A000000); // 10% black
  static const Color inputBorder = Color(0x33000000); // 20% black
  static const Color focusedBorder = Color(0xFF00F3A5); // Brand green

  // Status colors
  static const Color deleteRed = Color(0xFFFF3B30);
  static const Color disabledGray = Color(0x61000000); // 38% black
  static const Color typingIndicator = Color(0xFF9E9E9E); // Gray
}
