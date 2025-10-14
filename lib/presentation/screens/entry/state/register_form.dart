import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_form.freezed.dart';

@freezed
abstract class RegisterForm with _$RegisterForm {
  const factory RegisterForm({
    @Default('') String nickname,
    @Default('') String location, // 도, 시 (예: 서울특별시 강남구)
  }) = _RegisterForm;
}
