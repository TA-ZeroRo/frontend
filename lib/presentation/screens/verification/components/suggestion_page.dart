import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/toast_helper.dart';
import 'gallery_picker.dart';
import 'info_dialog.dart';
import 'info_button.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final TextEditingController _contentController = TextEditingController();
  final List<String> _selectedImages = [];
  final GalleryPicker _galleryPicker = GalleryPicker();

  @override
  void initState() {
    super.initState();
    _maybeShowInfoDialog(); // 설명문 표시 함수 호출
  }

  Future<void> _maybeShowInfoDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final shouldShow = !(prefs.getBool('showSuggestionDialog') ?? false);

    if (shouldShow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomInfoDialog(
            title: '건의하기 안내',
            content:
                '앱에서 불편한 점, 추가되었으면 하는 카테고리, 버그 제보 등을 자유롭게 작성해주세요!\n\n사진을 첨부하면 더 좋아요!',
            preferenceKey: 'showSuggestionDialog',
            onClose: (_) {},
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final file = await _galleryPicker.pickImageFromGallery();
    if (file != null) {
      setState(() => _selectedImages.add(file.path));
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  void _submitSuggestion() {
    final hasText = _contentController.text.trim().isNotEmpty;

    if (!hasText) {
      _showWarning('내용을 입력해주세요');
      return;
    }

    _showsuccessMessage('건의가 정상적으로 제출되었습니다!');

    Future.delayed(const Duration(milliseconds: 2300), () {
      if (mounted) {
        Navigator.pop(context, '건의가 정상적으로 제출되었습니다!');
      }
    });
  }

  void _showWarning(String message) {
    ToastHelper.showError(message);
  }

  void _showsuccessMessage(String message) {
    ToastHelper.showSuccess(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '건의하기',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton(
              onPressed: _submitSuggestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('제출'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _contentController,
                    minLines: 8,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: '건의할 내용을 작성해주세요',
                      hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedImages.isNotEmpty) ...[
                    const Text(
                      '첨부된 이미지',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_selectedImages[index]),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo_library_outlined),
                ),
                const Spacer(),
                const InfoButton(
                  title: '건의하기 안내',
                  content:
                      '앱에서 불편한 점, 추가되었으면 하는 카테고리, 버그 제보 등을 자유롭게 작성해주세요!\n\n사진을 첨부하면 더 좋아요!',
                  preferenceKey: 'showSuggestionDialog',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
