import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../../../core/config/env_var.dart';
import '../../../../core/di/injection.dart';
import '../../../../domain/model/user/user.dart';
import '../../../../domain/repository/user_repository.dart';

part 'auth_controller.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    User? currentUser,
    @Default(false) bool isLoading,
    String? error,
    @Default('') String registerNickname,
    @Default('') String registerLocation,
  }) = _AuthState;
}

class AuthNotifier extends Notifier<AuthState> {
  final UserRepository _userRepository = getIt<UserRepository>();
  final _supabase = Supabase.instance.client;

  @override
  AuthState build() {
    return const AuthState();
  }

  /// Google 로그인
  /// Supabase 인증 후 백엔드에서 유저 조회
  /// 유저가 없으면 Exception 발생 → UI에서 회원가입 페이지로 이동
  Future<void> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Google Sign In
      final GoogleSignIn googleSignIn = kIsWeb
          ? GoogleSignIn(clientId: EnvConfig.googleWebClientId)
          : GoogleSignIn(serverClientId: EnvConfig.googleWebClientId);

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google 로그인이 취소되었습니다');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Google 인증 토큰을 가져올 수 없습니다');
      }

      // Supabase 인증
      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final userId = _supabase.auth.currentSession?.user.id;
      if (userId == null) {
        throw Exception('사용자 ID를 가져올 수 없습니다');
      }

      // 백엔드에서 유저 조회
      try {
        final user = await _userRepository.getUser(userId);
        state = state.copyWith(currentUser: user, isLoading: false);
      } catch (e) {
        // 유저가 없으면 회원가입 필요
        state = state.copyWith(isLoading: false);
        throw Exception('USER_NOT_FOUND');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// 회원가입
  /// RegisterScreen에서 호출
  Future<void> register({
    required String nickname,
    required String region,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final userId = _supabase.auth.currentSession?.user.id;
      if (userId == null) {
        throw Exception('로그인이 필요합니다');
      }

      final user = await _userRepository.createUser(
        userId: userId,
        username: nickname,
        region: region,
      );
      state = state.copyWith(currentUser: user, isLoading: false);

      // 회원가입 성공 시 폼 초기화
      clearRegisterForm();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Google Sign Out
      final GoogleSignIn googleSignIn = kIsWeb
          ? GoogleSignIn(clientId: EnvConfig.googleWebClientId)
          : GoogleSignIn(serverClientId: EnvConfig.googleWebClientId);
      await googleSignIn.signOut();

      // Supabase Sign Out
      await _supabase.auth.signOut();

      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// 회원 탈퇴
  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final userId = _supabase.auth.currentSession?.user.id;
      if (userId == null) {
        throw Exception('로그인이 필요합니다');
      }

      // 백엔드에서 유저 삭제
      await _userRepository.deleteUser(userId);

      // Supabase에서도 로그아웃
      await logout();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// 프로필 수정
  Future<void> updateProfile(User updatedUser) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final userId = _supabase.auth.currentSession?.user.id;
      if (userId == null) {
        throw Exception('로그인이 필요합니다');
      }

      final user = await _userRepository.updateUser(
        userId: userId,
        username: updatedUser.username,
        userImg: updatedUser.userImg,
        region: updatedUser.region,
        characters: updatedUser.characters,
      );
      state = state.copyWith(currentUser: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// 세션 체크 및 자동 로그인
  /// SplashScreen에서 호출
  Future<void> checkAndRestoreSession() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final session = _supabase.auth.currentSession;

      if (session == null) {
        // 세션 없음
        state = state.copyWith(isLoading: false);
        return;
      }

      // 세션 만료 확인
      final now = DateTime.now();
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        session.expiresAt! * 1000,
      );

      if (now.isAfter(expiresAt)) {
        // 토큰 만료 → 리프레시 시도
        await _refreshSession();
        return;
      }

      // 유효한 세션 → 유저 정보 조회
      final userId = session.user.id;
      try {
        final user = await _userRepository.getUser(userId);
        state = state.copyWith(currentUser: user, isLoading: false);
      } catch (e) {
        await _supabase.auth.signOut();
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 토큰 리프레시
  Future<void> _refreshSession() async {
    try {
      final response = await _supabase.auth.refreshSession();
      if (response.session != null) {
        final userId = response.session!.user.id;
        try {
          final user = await _userRepository.getUser(userId);
          state = state.copyWith(currentUser: user, isLoading: false);
        } catch (e) {
          // 유저 정보 조회 실패 시 세션 정리
          await _supabase.auth.signOut();
          state = state.copyWith(isLoading: false);
        }
      } else {
        // 리프레시 실패 시 세션 정리
        await _supabase.auth.signOut();
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      // 리프레시 예외 발생 시 세션 정리
      await _supabase.auth.signOut();
      state = state.copyWith(isLoading: false);
    }
  }

  /// 회원가입 폼 - 닉네임 업데이트
  void updateRegisterNickname(String nickname) {
    state = state.copyWith(registerNickname: nickname);
  }

  /// 회원가입 폼 - 거주지 업데이트
  void updateRegisterLocation(String location) {
    state = state.copyWith(registerLocation: location);
  }

  /// 회원가입 폼 유효성 검증
  bool isRegisterFormValid() {
    return state.registerNickname.isNotEmpty &&
        state.registerLocation.isNotEmpty;
  }

  /// 회원가입 폼 초기화
  void clearRegisterForm() {
    state = state.copyWith(registerNickname: '', registerLocation: '');
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
