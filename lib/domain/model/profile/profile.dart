import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String userId,
    required String username,
    String? userImg,
    @Default(0) int totalPoints,
    @Default(0) int continuousDays,
    DateTime? birthDate, // 생년월일
    String? region, // 지역
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
