import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'register_form.dart';

class RegisterNotifier extends Notifier<RegisterForm> {
  @override
  RegisterForm build() {
    return const RegisterForm();
  }

  void updateNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  void updateLocation(String location) {
    state = state.copyWith(location: location);
  }

  bool isValid() {
    return state.nickname.isNotEmpty && state.location.isNotEmpty;
  }
}

final registerProvider = NotifierProvider<RegisterNotifier, RegisterForm>(
  RegisterNotifier.new,
);
