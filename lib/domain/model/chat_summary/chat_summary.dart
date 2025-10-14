import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_summary.freezed.dart';
part 'chat_summary.g.dart';

@freezed
abstract class ChatSummary with _$ChatSummary {
  const factory ChatSummary({
    required String id,
    required String title,
    required String preview,
    required DateTime lastMessageTime,
  }) = _ChatSummary;

  factory ChatSummary.fromJson(Map<String, dynamic> json) =>
      _$ChatSummaryFromJson(json);
}
