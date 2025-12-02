import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/utils/toast_helper.dart';
import '../../../../../data/data_source/campaign/campaign_api.dart';
import '../../../../../domain/model/campaign/campaign_webview_config.dart';
import '../../../../../domain/model/mission/mission_with_template.dart';
import 'state/campaign_mission_state.dart';

/// 캠페인 미션 WebView 제출 화면
class CampaignMissionWebViewScreen extends ConsumerStatefulWidget {
  final List<MissionWithTemplate> missions;
  final int campaignId;

  const CampaignMissionWebViewScreen({
    super.key,
    required this.missions,
    required this.campaignId,
  });

  @override
  ConsumerState<CampaignMissionWebViewScreen> createState() =>
      _CampaignMissionWebViewScreenState();
}

class _CampaignMissionWebViewScreenState
    extends ConsumerState<CampaignMissionWebViewScreen> {
  late final WebViewController _controller;
  final CampaignApi _campaignApi = getIt<CampaignApi>();

  CampaignWebviewConfig? _config;
  bool _isConfigLoaded = false;
  bool _isLoggedIn = false;
  bool _isOnSubmissionPage = false;
  bool _isFormFilled = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadConfigAndInitWebView();
  }

  /// WebView 설정 로드 및 초기화
  Future<void> _loadConfigAndInitWebView() async {
    try {
      final configDto = await _campaignApi.getWebviewConfig(
        campaignId: widget.campaignId,
      );

      if (configDto == null) {
        setState(() {
          _errorMessage = '이 캠페인은 자동 제출을 지원하지 않습니다.';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _config = configDto.toModel();
        _isConfigLoaded = true;
      });

      _initializeWebView();
    } catch (e) {
      debugPrint('[WebView] Error loading config: $e');
      setState(() {
        _errorMessage = '설정 로드 중 오류가 발생했습니다: $e';
        _isLoading = false;
      });
    }
  }

  void _initializeWebView() {
    if (_config == null) return;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)

      // JavaScript Channel 설정
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: _handleJavaScriptMessage,
      )

      // Navigation Delegate 설정 (로그인 감지)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);

            // 폼 입력 완료 상태에서 write 페이지를 벗어나면 제출 완료로 간주
            // (POST.submit() 후 페이지 이동 시 감지)
            if (_isFormFilled && !url.contains('bmode=write')) {
              debugPrint('[WebView] Submission detected! Navigating to: $url');
              _updateMissionLog();
            }
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            _handlePageFinished(url);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('[WebView] Error: ${error.description}');
          },
        ),
      )

      // login_url로 시작
      ..loadRequest(Uri.parse(_config!.loginUrl));

    // Android 파일 업로드 지원 설정
    if (Platform.isAndroid) {
      final androidController =
          _controller.platform as AndroidWebViewController;
      androidController.setOnShowFileSelector(_handleFilePicker);
    }

    setState(() {});
  }

  /// Android WebView 파일 선택기 핸들러
  Future<List<String>> _handleFilePicker(
    FileSelectorParams params,
  ) async {
    debugPrint('[WebView] File picker requested: ${params.acceptTypes}');

    // Android 13+ 사진 접근 권한 요청
    if (Platform.isAndroid) {
      final status = await Permission.photos.request();
      debugPrint('[WebView] Photo permission status: $status');
      if (!status.isGranted) {
        debugPrint('[WebView] Photo permission denied');
        ToastHelper.showError('사진 접근 권한이 필요합니다');
        return [];
      }
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: params.mode == FileSelectorMode.openMultiple,
      );

      if (result != null && result.files.isNotEmpty) {
        final paths = result.files
            .where((file) => file.path != null)
            .map((file) => 'file://${file.path}')
            .toList();
        debugPrint('[WebView] Selected files: $paths');
        return paths;
      }
    } catch (e) {
      debugPrint('[WebView] File picker error: $e');
    }

    return [];
  }

  /// 페이지 로드 완료 시 처리
  Future<void> _handlePageFinished(String currentUrl) async {
    if (_config == null) return;

    // 이미 submission 페이지에서 폼 입력 완료 상태면 스킵
    if (_isOnSubmissionPage && _isFormFilled) return;

    // submission URL에 도달했는지 확인 (bmode=write 파라미터로 판단)
    final currentUri = Uri.parse(currentUrl);
    final submissionUri = Uri.parse(_config!.submissionUrl);
    final isSubmissionPage = currentUri.path == submissionUri.path &&
        currentUri.queryParameters['bmode'] == 'write';

    if (isSubmissionPage) {
      debugPrint('[WebView] Reached submission page: $currentUrl');
      setState(() => _isOnSubmissionPage = true);

      // 폼 자동 입력 실행 (페이지 로드 대기)
      await Future.delayed(const Duration(milliseconds: 1000));
      await _autoFillForm();
      return;
    }

    // 로그인 감지 (페이지 로드 후 약간의 딜레이)
    if (!_isLoggedIn) {
      await Future.delayed(const Duration(milliseconds: 500));
      await _checkLoginStatus(currentUrl);
    }
  }

  /// 로그인 상태 감지
  Future<void> _checkLoginStatus(String currentUrl) async {
    if (_config == null || _isLoggedIn) return;

    // 로그인 페이지에서는 체크하지 않음 (이미 로그인된 상태에서 접근 시 오탐 방지)
    final loginUrl = Uri.parse(_config!.loginUrl);
    final currentUri = Uri.parse(currentUrl);
    if (currentUri.path == loginUrl.path) {
      debugPrint('[WebView] On login page, skipping login detection');
      return;
    }

    final loginDetection = _config!.loginDetection;
    final urlPattern = loginDetection['url_pattern'] as String?;
    final domSelector = loginDetection['dom_selector'] as String?;
    final strategy = loginDetection['strategy'] as String? ?? 'any';

    bool urlMatched = false;
    bool domMatched = false;

    // URL 패턴 체크
    if (urlPattern != null && urlPattern.isNotEmpty) {
      final regex = RegExp(urlPattern);
      urlMatched = regex.hasMatch(currentUrl);
      debugPrint('[WebView] URL pattern check: $urlMatched ($currentUrl)');
    }

    // DOM 셀렉터 체크
    if (domSelector != null && domSelector.isNotEmpty) {
      try {
        // Escape single quotes to prevent JavaScript syntax errors
        // e.g., a[href*='/shop_mypage'] → a[href*=\'\/shop_mypage\']
        final escapedSelector = domSelector.replaceAll("'", "\\'");
        final result = await _controller.runJavaScriptReturningResult(
          "document.querySelector('$escapedSelector') ? 'found' : 'not_found'",
        );
        final resultStr = result.toString();
        domMatched = resultStr.contains('found') && !resultStr.contains('not_found');
        debugPrint('[WebView] DOM selector check: $domMatched (raw: $resultStr)');
      } catch (e) {
        debugPrint('[WebView] DOM check failed: $e');
      }
    }

    // 전략에 따라 로그인 판정
    bool isLoggedIn = false;
    if (strategy == 'all') {
      isLoggedIn = urlMatched && domMatched;
    } else {
      // 'any' 또는 기본값
      isLoggedIn = urlMatched || domMatched;
    }

    // URL/DOM 둘 다 설정 안 된 경우: 로그인 페이지가 아니면 로그인 성공으로 간주
    if (urlPattern == null && domSelector == null) {
      isLoggedIn = !currentUrl.contains('/login') &&
          !currentUrl.contains('/signin') &&
          !currentUrl.contains('/auth');
    }

    if (isLoggedIn) {
      debugPrint('[WebView] Login detected! Redirecting to submission URL...');
      setState(() => _isLoggedIn = true);
      ToastHelper.showSuccess('로그인 성공! 제출 페이지로 이동합니다.');

      // submission_url로 리다이렉트
      await Future.delayed(const Duration(milliseconds: 500));
      await _controller.loadRequest(Uri.parse(_config!.submissionUrl));
    }
  }

  /// 폼 자동 입력
  Future<void> _autoFillForm() async {
    if (_config == null) return;

    try {
      final jsCode = _generateAutoFillScript();
      await _controller.runJavaScript(jsCode);
      debugPrint('[WebView] Auto-fill script executed');
    } catch (e) {
      debugPrint('[WebView] Error executing JavaScript: $e');
      ToastHelper.showError('폼 입력 중 오류가 발생했습니다: $e');
    }
  }

  /// 동적 JavaScript 생성
  String _generateAutoFillScript() {
    if (_config == null) return '';

    final fieldSelectors = _config!.fieldSelectors;
    final fieldMapping = _config!.fieldMapping;

    // proof_data에서 데이터 수집
    // fieldMapping 키는 'TEXT_REVIEW', 'IMAGE' 등 대문자이므로
    // verificationType.value를 사용해야 함 (toString()은 'textReview' 반환)
    final proofDataMap = <String, dynamic>{};
    for (final mission in widget.missions) {
      // verificationType.value는 'TEXT_REVIEW', 'IMAGE' 등 DB와 일치하는 값
      final verificationType = mission.missionTemplate.verificationType.value;
      final proofData = mission.missionLog.proofData;

      if (proofData != null) {
        proofDataMap[verificationType] = proofData;
        debugPrint('[WebView] proofDataMap[$verificationType] = $proofData');
      }
    }

    // JavaScript 코드 생성
    final jsBuffer = StringBuffer();
    jsBuffer.writeln('(function() {');
    jsBuffer.writeln('  try {');
    jsBuffer.writeln("    console.log('[RPA WebView] Starting form auto-fill...');");

    // fieldMapping 기반으로 각 필드 입력
    for (final entry in fieldMapping.entries) {
      final missionType = entry.key; // e.g., "TEXT_REVIEW", "IMAGE"
      final mapping = entry.value as Map<String, dynamic>;
      final source = mapping['source'] as String?; // e.g., "proof_data.text"
      final target = mapping['target'] as String?; // e.g., "content"
      final action = mapping['action'] as String? ?? 'fill'; // "fill" or "highlight"

      if (target == null) continue;

      final selector = fieldSelectors[target];
      if (selector == null) continue;

      // Escape single quotes in selector for JavaScript
      final escapedSelector = selector.replaceAll("'", "\\'");

      // source에서 값 추출
      String? value;
      if (source != null && source.startsWith('proof_data.')) {
        final key = source.replaceFirst('proof_data.', '');
        // missionType은 fieldMapping 키로 이미 'TEXT_REVIEW' 형태
        // proofDataMap 키도 verificationType.value로 'TEXT_REVIEW' 형태
        final missionProofData = proofDataMap[missionType];
        debugPrint('[WebView] Looking up proofDataMap[$missionType].$key = ${missionProofData is Map ? missionProofData[key] : 'N/A'}');
        if (missionProofData is Map) {
          value = missionProofData[key]?.toString();
        }
      }

      if (action == 'highlight') {
        // 이미지 필드는 하이라이트만
        jsBuffer.writeln('''
    // Highlight: $target
    const ${target}Input = document.querySelector('$escapedSelector');
    if (${target}Input) {
      ${target}Input.scrollIntoView({behavior: 'smooth', block: 'center'});
      ${target}Input.style.border = '3px solid #4CAF50';
      ${target}Input.style.boxShadow = '0 0 15px rgba(76, 175, 80, 0.5)';
      ${target}Input.style.animation = 'pulse 1.5s infinite';
      console.log('[RPA WebView] $target highlighted');
    }
''');
      } else if (value != null) {
        // 텍스트 필드는 값 입력
        final escapedValue = value
            .replaceAll('\\', '\\\\')
            .replaceAll("'", "\\'")
            .replaceAll('\n', '<br>')
            .replaceAll('\r', '');

        // contenteditable div (Froala Editor 등)인지 일반 input인지 확인하여 처리
        jsBuffer.writeln('''
    // Fill: $target
    const ${target}Input = document.querySelector('$escapedSelector');
    if (${target}Input) {
      // contenteditable div인 경우 innerHTML 사용, 일반 input은 value 사용
      if (${target}Input.contentEditable === 'true' || ${target}Input.classList.contains('fr-element')) {
        ${target}Input.innerHTML = '<p>$escapedValue</p>';
        ${target}Input.dispatchEvent(new Event('input', {bubbles: true}));
        console.log('[RPA WebView] $target filled (contenteditable)');
      } else {
        ${target}Input.value = '$escapedValue';
        ${target}Input.dispatchEvent(new Event('input', {bubbles: true}));
        ${target}Input.dispatchEvent(new Event('change', {bubbles: true}));
        console.log('[RPA WebView] $target filled (input)');
      }
    }
''');
      }
    }

    // CSS 애니메이션 추가
    jsBuffer.writeln('''
    // Add pulse animation CSS
    if (!document.getElementById('rpa-styles')) {
      const style = document.createElement('style');
      style.id = 'rpa-styles';
      style.textContent = `
        @keyframes pulse {
          0% { box-shadow: 0 0 10px rgba(76, 175, 80, 0.5); }
          50% { box-shadow: 0 0 25px rgba(76, 175, 80, 0.8); }
          100% { box-shadow: 0 0 10px rgba(76, 175, 80, 0.5); }
        }
      `;
      document.head.appendChild(style);
    }

    // 제출 버튼 클릭 이벤트 감지
    const submitBtn = document.querySelector('button._save_post');
    if (submitBtn) {
      submitBtn.addEventListener('click', function() {
        console.log('[RPA WebView] Submit button clicked');
        // 제출 처리 후 Flutter로 알림 (2초 대기)
        setTimeout(() => {
          if (window.FlutterChannel) {
            window.FlutterChannel.postMessage(JSON.stringify({
              status: 'submitted',
              message: '제출이 완료되었습니다!'
            }));
          }
        }, 2000);
      });
      console.log('[RPA WebView] Submit button listener attached');
    }
''');

    // Flutter로 완료 알림
    jsBuffer.writeln('''
    // Notify Flutter
    if (window.FlutterChannel) {
      window.FlutterChannel.postMessage(JSON.stringify({
        status: 'filled',
        message: '폼 입력이 완료되었습니다. 이미지를 선택하고 제출해주세요.'
      }));
    }

    return 'success';
  } catch (error) {
    console.error('[RPA WebView] Error:', error);
    if (window.FlutterChannel) {
      window.FlutterChannel.postMessage(JSON.stringify({
        status: 'error',
        message: error.toString()
      }));
    }
    return 'error';
  }
})();
''');

    return jsBuffer.toString();
  }

  /// JavaScript에서 온 메시지 처리
  void _handleJavaScriptMessage(JavaScriptMessage message) {
    try {
      final data = jsonDecode(message.message) as Map<String, dynamic>;
      final status = data['status'] as String?;
      final msg = data['message'] as String?;

      debugPrint('[WebView] JS Message: status=$status, message=$msg');

      if (status == 'filled') {
        setState(() => _isFormFilled = true);
        ToastHelper.showSuccess(msg ?? '폼 입력 완료');
      } else if (status == 'submitted') {
        _updateMissionLog();
      } else if (status == 'error') {
        ToastHelper.showError(msg ?? '오류가 발생했습니다');
      }
    } catch (e) {
      debugPrint('[WebView] Error parsing JS message: $e');
    }
  }

  /// 미션 완료 업데이트
  Future<void> _updateMissionLog() async {
    try {
      if (mounted) {
        ToastHelper.showSuccess('미션이 완료되었습니다!');

        // 서버 동기화 대기 (1초)
        await Future.delayed(const Duration(seconds: 1));

        // Provider 새로고침 (invalidate 대신 refresh 사용 - 에러 핸들링 개선)
        await ref.read(campaignMissionProvider.notifier).refresh();

        // 안전하게 pop (pop 가능한 경우에만)
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          debugPrint('[WebView] Cannot pop, navigation stack is empty');
        }
      }
    } catch (e) {
      debugPrint('[WebView] Error updating mission log: $e');
      // 에러가 나도 일단 pop (사용자가 수동 새로고침 가능)
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 에러 상태
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('미션 제출'),
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('돌아가기'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 설정 로드 중
    if (!_isConfigLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('미션 제출'),
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF4CAF50)),
              SizedBox(height: 16),
              Text('설정을 불러오는 중...'),
            ],
          ),
        ),
      );
    }

    // WebView 화면
    return Scaffold(
      appBar: AppBar(
        title: const Text('미션 제출'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 진행 상태 표시
          _buildProgressIndicator(),

          // WebView
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),

                // 로딩 인디케이터
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4CAF50),
                    ),
                  ),
              ],
            ),
          ),

          // 안내 메시지
          if (_isFormFilled) _buildPhotoUploadGuide(),
        ],
      ),
    );
  }

  /// 진행 상태 표시
  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 1단계: 로그인
          _buildStepIndicator(
            step: 1,
            label: '로그인',
            isCompleted: _isLoggedIn,
            isActive: !_isLoggedIn,
          ),

          _buildStepConnector(_isLoggedIn),

          // 2단계: 제출 페이지
          _buildStepIndicator(
            step: 2,
            label: '폼 입력',
            isCompleted: _isFormFilled,
            isActive: _isLoggedIn && !_isFormFilled,
          ),

          _buildStepConnector(_isFormFilled),

          // 3단계: 제출
          _buildStepIndicator(
            step: 3,
            label: '제출',
            isCompleted: false,
            isActive: _isFormFilled,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator({
    required int step,
    required String label,
    required bool isCompleted,
    required bool isActive,
  }) {
    final color = isCompleted
        ? const Color(0xFF4CAF50)
        : isActive
            ? const Color(0xFF2196F3)
            : Colors.grey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? color : Colors.transparent,
            border: Border.all(color: color, width: 2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(bool isCompleted) {
    return Container(
      width: 24,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isCompleted ? const Color(0xFF4CAF50) : Colors.grey[300],
    );
  }

  /// 사진 업로드 안내
  Widget _buildPhotoUploadGuide() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        border: Border(
          top: BorderSide(
            color: Colors.orange[300]!,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.photo_camera,
            color: Colors.orange[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '초록색으로 표시된 영역을 눌러 사진을 선택한 후,\n제출 버튼을 눌러주세요.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.orange[900],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
