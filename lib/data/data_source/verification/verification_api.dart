import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/verification/image_verification_response_dto.dart';
import '../../dto/verification/location_verification_request_dto.dart';
import '../../dto/verification/location_verification_response_dto.dart';

@injectable
class VerificationApi {
  final Dio _dio;

  VerificationApi(this._dio);

  /// 이미지 검증 요청 (Gemini AI)
  /// POST /verification/image
  ///
  /// [imageFile] 검증할 이미지 파일
  /// [mainCategoryIndex] 메인 카테고리 인덱스
  /// [subCategoryIndex] 서브 카테고리 인덱스
  ///
  /// Returns 검증 결과 (is_valid, confidence, reason)
  Future<ImageVerificationResultDto> verifyImage({
    required File imageFile,
    required int mainCategoryIndex,
    required int subCategoryIndex,
  }) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'image.jpg',
      ),
      'main_category_index': mainCategoryIndex,
      'sub_category_index': subCategoryIndex,
    });

    final response = await _dio.post(
      '/verification/image',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    final dto = ImageVerificationResponseDto.fromJson(response.data);
    return dto.result;
  }

  /// 위치 인증 요청
  /// POST /verification/location
  Future<LocationVerificationResponseDto> verifyLocation(
    LocationVerificationRequestDto request,
  ) async {
    final response = await _dio.post(
      '/verification/location',
      data: request.toJson(),
    );

    return LocationVerificationResponseDto.fromJson(response.data);
  }
}
