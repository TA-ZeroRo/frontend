import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/logger/logger.dart';

/// Supabase Storage를 사용하여 파일을 업로드/삭제하는 서비스
@singleton
class StorageService {
  /// Supabase 클라이언트를 lazy getter로 접근
  SupabaseClient get _supabase => Supabase.instance.client;

  /// 프로필 이미지 버킷 이름
  static const String _profileImagesBucket = 'profile-images';

  /// 프로필 이미지 업로드
  ///
  /// [userId]: 사용자 ID
  /// [imageFile]: 업로드할 이미지 파일
  ///
  /// Returns: 업로드된 이미지의 Public URL
  Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${userId}_$timestamp.jpg';

      CustomLogger.logger.d('uploadProfileImage - 이미지 업로드 시작 (fileName: $fileName)');

      // 이미지 업로드
      final path = await _supabase.storage
          .from(_profileImagesBucket)
          .upload(fileName, imageFile);

      CustomLogger.logger.d('uploadProfileImage - 업로드 성공 (path: $path)');

      // Public URL 반환
      final publicUrl = _supabase.storage
          .from(_profileImagesBucket)
          .getPublicUrl(fileName);

      CustomLogger.logger.d('uploadProfileImage - Public URL 생성 완료: $publicUrl');
      return publicUrl;
    } catch (e) {
      CustomLogger.logger.e('uploadProfileImage - 업로드 실패', error: e);
      rethrow;
    }
  }

  /// 프로필 이미지 삭제
  ///
  /// [imageUrl]: 삭제할 이미지의 Public URL
  ///
  /// URL에서 파일명을 추출하여 Storage에서 삭제합니다.
  Future<void> deleteProfileImage(String imageUrl) async {
    try {
      // URL에서 파일명 추출
      final uri = Uri.parse(imageUrl);
      final fileName = uri.pathSegments.last;

      CustomLogger.logger.d('deleteProfileImage - 이미지 삭제 시작 (fileName: $fileName)');

      await _supabase.storage
          .from(_profileImagesBucket)
          .remove([fileName]);

      CustomLogger.logger.d('deleteProfileImage - 삭제 성공');
    } catch (e) {
      CustomLogger.logger.e('deleteProfileImage - 삭제 실패', error: e);
      // 삭제 실패는 치명적이지 않으므로 에러를 던지지 않음
      // (이미 삭제된 파일이거나 존재하지 않는 경우)
    }
  }

  /// 프로필 이미지 업데이트 (기존 이미지 삭제 후 새 이미지 업로드)
  ///
  /// [userId]: 사용자 ID
  /// [imageFile]: 업로드할 새 이미지 파일
  /// [oldImageUrl]: 삭제할 기존 이미지 URL (nullable)
  ///
  /// Returns: 업로드된 새 이미지의 Public URL
  Future<String> updateProfileImage({
    required String userId,
    required File imageFile,
    String? oldImageUrl,
  }) async {
    // 기존 이미지가 있으면 삭제
    if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
      await deleteProfileImage(oldImageUrl);
    }

    // 새 이미지 업로드
    return await uploadProfileImage(userId: userId, imageFile: imageFile);
  }
}
