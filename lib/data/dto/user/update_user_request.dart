import 'package:json_annotation/json_annotation.dart';

part 'update_user_request.g.dart';

@JsonSerializable(createFactory: false)
class UpdateUserRequest {
  /// 사용자 이름
  final String? username;

  /// 프로필 이미지 URL
  @JsonKey(name: 'user_img')
  final String? userImg;

  /// 사용자 지역
  final String? region;

  /// 보유 캐릭터 목록
  final List<String>? characters;

  const UpdateUserRequest({
    this.username,
    this.userImg,
    this.region,
    this.characters,
  });

  Map<String, dynamic> toJson() {
    final json = _$UpdateUserRequestToJson(this);
    // null 값인 필드는 JSON에서 제거 (서버에 전송하지 않음)
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
