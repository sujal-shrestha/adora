// lib/features/ads/presentation/view/full_screen_image_view.dart

import 'dart:convert';
import 'package:flutter/material.dart';

class FullScreenImageView extends StatelessWidget {
  final String imageUri;
  const FullScreenImageView({Key? key, required this.imageUri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageUri.startsWith('data:')) {
      // it's a base64 data URI
      final base64Str = imageUri.split(',').last;
      final bytes = base64Decode(base64Str);
      imageWidget = Image.memory(bytes, fit: BoxFit.contain);
    } else {
      // it's a network URL
      imageWidget = Image.network(
        imageUri,
        fit: BoxFit.contain,
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (ctx, _, __) =>
            const Center(child: Icon(Icons.broken_image, size: 64, color: Colors.grey)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(child: imageWidget),
    );
  }
}
