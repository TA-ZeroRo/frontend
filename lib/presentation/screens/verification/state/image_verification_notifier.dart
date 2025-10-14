import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../domain/model/verification_result/verification_result.dart';

// Mock Data
const _mockVerificationResults = [
  VerificationResult(
    isValid: true,
    confidence: 0.95,
    reason: '올바르게 분리배출된 페트병이 확인되었습니다.',
  ),
  VerificationResult(
    isValid: false,
    confidence: 0.78,
    reason: '라벨이 제거되지 않은 페트병입니다.',
  ),
  VerificationResult(
    isValid: true,
    confidence: 0.88,
    reason: '텀블러 사용이 확인되었습니다.',
  ),
];

class ImageVerificationState {
  final bool isLoading;
  final VerificationResult? result;
  final String? error;

  const ImageVerificationState({
    this.isLoading = false,
    this.result,
    this.error,
  });

  ImageVerificationState copyWith({
    bool? isLoading,
    VerificationResult? result,
    String? error,
  }) {
    return ImageVerificationState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}

class ImageVerificationNotifier extends Notifier<ImageVerificationState> {
  @override
  ImageVerificationState build() {
    return const ImageVerificationState();
  }

  Future<void> verifyImage(String imagePath, int categoryIndex) async {
    state = state.copyWith(isLoading: true, error: null);

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Return random mock result
      final mockResult = (_mockVerificationResults..shuffle()).first;
      state = state.copyWith(
        isLoading: false,
        result: mockResult,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = const ImageVerificationState();
  }
}

final imageVerificationProvider =
    NotifierProvider<ImageVerificationNotifier, ImageVerificationState>(
  ImageVerificationNotifier.new,
);
