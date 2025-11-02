import 'package:json_annotation/json_annotation.dart';

part 'create_user_request.g.dart';

@JsonSerializable(createFactory: false)
class CreateUserRequest {
  /// 사용자 ID (Supabase Auth에서 생성된 UUID)
  final String id;

  /// 사용자 이름
  final String username;

  /// 사용자 지역
  final String region;

  /// 사용자 프로필 이미지
  @JsonKey(name: 'user_img')
  final String? userImg;

  const CreateUserRequest({
    required this.id,
    required this.username,
    required this.region,
    this.userImg,
  });

  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);
}
