import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../core/utils/toast_helper.dart';
import '../../../../../domain/model/mission/mission_with_template.dart';
import '../activity/state/activity_state.dart';

/// 캠페인 미션 WebView 제출 화면
class CampaignMissionWebViewScreen extends ConsumerStatefulWidget {
  final MissionWithTemplate mission;

  const CampaignMissionWebViewScreen({
    super.key,
    required this.mission,
  });

  @override
  ConsumerState<CampaignMissionWebViewScreen> createState() =>
      _CampaignMissionWebViewScreenState();
}

class _CampaignMissionWebViewScreenState
    extends ConsumerState<CampaignMissionWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoggedIn = false;
  bool _isFormFilled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
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
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            _checkLoginStatus(url);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('[WebView] Error: ${error.description}');
          },
        ),
      )

      // 초기 URL 로드
      ..loadRequest(Uri.parse(widget.mission.campaign.rpaFormUrl ?? ''));
  }

  /// 로그인 상태 감지
  Future<void> _checkLoginStatus(String currentUrl) async {
    if (_isLoggedIn) return;

    // URL 체크: /login이 없고 form URL을 포함하면 로그인 성공으로 간주
    final formUrl = widget.mission.campaign.rpaFormUrl ?? '';
    final isNotLoginPage = !currentUrl.contains('/login');
    final isFormPage = currentUrl.contains(Uri.parse(formUrl).host);

    if (isNotLoginPage && isFormPage) {
      debugPrint('[WebView] Login detected: $currentUrl');

      // DOM 체크로 추가 검증 (선택적)
      try {
        final result = await _controller.runJavaScriptReturningResult(
          "document.querySelector('.user-profile, .user-info, [class*=\"user\"]') ? 'true' : 'false'",
        );

        if (result.toString().contains('true') || isNotLoginPage) {
          setState(() => _isLoggedIn = true);
          ToastHelper.showSuccess('로그인 성공! 폼을 자동으로 입력합니다.');
          await Future.delayed(const Duration(milliseconds: 500));
          await _autoFillForm();
        }
      } catch (e) {
        // DOM 체크 실패해도 URL 기반으로 로그인 감지
        debugPrint('[WebView] DOM check failed, using URL-based detection');
        setState(() => _isLoggedIn = true);
        ToastHelper.showSuccess('로그인 감지! 폼을 자동으로 입력합니다.');
        await Future.delayed(const Duration(milliseconds: 500));
        await _autoFillForm();
      }
    }
  }

  /// 폼 자동 입력
  Future<void> _autoFillForm() async {
    try {
      // TODO: Backend API 호출하여 JavaScript 생성
      // 현재는 임시로 간단한 JavaScript 실행
      final title = widget.mission.missionTemplate.title;
      final description = widget.mission.missionTemplate.description;

      // 임시 JavaScript (실제로는 Backend에서 생성)
      final jsCode = '''
        (function() {
          try {
            console.log('[RPA WebView] Starting form auto-fill...');

            // 제목 입력
            const titleInput = document.querySelector('input[placeholder*="제목"]');
            if (titleInput) {
              titleInput.value = `$title`;
              titleInput.dispatchEvent(new Event('input', {bubbles: true}));
              titleInput.dispatchEvent(new Event('change', {bubbles: true}));
              console.log('[RPA WebView] Title filled');
            }

            // 내용 입력
            const contentInput = document.querySelector('textarea[placeholder*="내용"]');
            if (contentInput) {
              contentInput.value = `$description`;
              contentInput.dispatchEvent(new Event('input', {bubbles: true}));
              contentInput.dispatchEvent(new Event('change', {bubbles: true}));
              console.log('[RPA WebView] Content filled');
            }

            // 사진 필드 하이라이트
            const photoInput = document.querySelector('input[type="file"]');
            if (photoInput) {
              photoInput.scrollIntoView({behavior: 'smooth', block: 'center'});
              photoInput.style.border = '3px solid #4CAF50';
              photoInput.style.boxShadow = '0 0 10px #4CAF50';
            }

            // Flutter로 완료 알림
            if (window.FlutterChannel) {
              window.FlutterChannel.postMessage(JSON.stringify({
                status: 'filled',
                message: '폼 입력 완료'
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
      ''';

      await _controller.runJavaScript(jsCode);
      debugPrint('[WebView] JavaScript executed');
    } catch (e) {
      debugPrint('[WebView] Error executing JavaScript: $e');
      ToastHelper.showError('폼 입력 중 오류가 발생했습니다: $e');
    }
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
      // TODO: API 호출하여 mission log 상태 업데이트
      // await ref.read(missionLogProvider.notifier).updateStatus(
      //   logId: widget.mission.missionLog.id,
      //   status: MissionStatus.completed,
      // );

      if (mounted) {
        Navigator.pop(context);
        ToastHelper.showSuccess('미션이 완료되었습니다!');

        // Activity 화면 새로고침
        ref.invalidate(campaignMissionProvider);
      }
    } catch (e) {
      debugPrint('[WebView] Error updating mission log: $e');
      ToastHelper.showError('미션 완료 처리 중 오류가 발생했습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mission.campaign.title),
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
      padding: const EdgeInsets.all(16),
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
          Icon(
            _isLoggedIn ? Icons.check_circle : Icons.radio_button_unchecked,
            color: _isLoggedIn ? const Color(0xFF4CAF50) : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '1. 로그인',
            style: TextStyle(
              fontSize: 14,
              fontWeight: _isLoggedIn ? FontWeight.w600 : FontWeight.w400,
              color: _isLoggedIn ? const Color(0xFF4CAF50) : Colors.grey[700],
            ),
          ),

          const SizedBox(width: 24),

          // 2단계: 폼 입력
          Icon(
            _isFormFilled ? Icons.check_circle : Icons.radio_button_unchecked,
            color: _isFormFilled ? const Color(0xFF4CAF50) : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '2. 폼 입력',
            style: TextStyle(
              fontSize: 14,
              fontWeight: _isFormFilled ? FontWeight.w600 : FontWeight.w400,
              color: _isFormFilled ? const Color(0xFF4CAF50) : Colors.grey[700],
            ),
          ),

          const SizedBox(width: 24),

          // 3단계: 제출
          Icon(
            Icons.radio_button_unchecked,
            color: Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '3. 사진 업로드 & 제출',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
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
            Icons.info_outline,
            color: Colors.orange[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '사진을 직접 업로드한 후 제출 버튼을 눌러주세요.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.orange[900],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
