import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../core/theme/app_color.dart';
import '../../../../../core/utils/toast_helper.dart';

class CampaignWebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const CampaignWebViewScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<CampaignWebViewScreen> createState() => _CampaignWebViewScreenState();
}

class _CampaignWebViewScreenState extends State<CampaignWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _progress = 0.0;
  String? _pendingCampaignUrl; // 로그인 전 원래 캠페인 URL 저장
  bool _isLoginRedirect = false; // 로그인 리다이렉트 상태 추적

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });

            // 로그인 페이지로 이동 감지
            if (_isLoginPage(url) && _pendingCampaignUrl == null) {
              _pendingCampaignUrl = widget.url; // 원래 캠페인 URL 저장
              _isLoginRedirect = true;
            }

            // 로그인 후 메인 페이지로 리다이렉트 감지
            if (_isMainPage(url) && _isLoginRedirect && _pendingCampaignUrl != null) {
              // 저장된 캠페인 URL로 다시 이동
              Future.delayed(const Duration(milliseconds: 500), () {
                _controller.loadRequest(Uri.parse(_pendingCampaignUrl!));
                _isLoginRedirect = false;
                _pendingCampaignUrl = null;
              });
            }
          },
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // 로그인 리다이렉트 중에는 에러 무시
            if (_isLoginRedirect) return;

            // 중요한 에러만 표시 (메인 프레임 에러)
            if (error.isForMainFrame ?? true) {
              ToastHelper.showError('페이지 로드 중 오류가 발생했습니다');
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  /// 로그인 페이지 URL 패턴 감지
  bool _isLoginPage(String url) {
    return url.contains('로그인') ||
           url.contains('login') ||
           url.contains('member') ||
           url.contains('auth');
  }

  /// 메인 페이지 URL 패턴 감지
  bool _isMainPage(String url) {
    // 1365 메인 페이지 패턴
    return url.contains('1365.go.kr') &&
           !url.contains('login') &&
           !url.contains('member') &&
           (url.endsWith('1365.go.kr') ||
            url.endsWith('1365.go.kr/') ||
            url.contains('main') ||
            url.contains('index'));
  }

  @override
  void dispose() {
    // WebView 리소스 정리 - 빈 페이지로 이동하여 렌더러 프로세스 크래시 방지
    _controller.loadRequest(Uri.parse('about:blank'));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
