import 'dart:io';

import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullImageScreen extends StatelessWidget {
  final String? imagePath;
  final String title;
  final int userId;

  const FullImageScreen({
    super.key,
    this.imagePath,
    required this.title,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColors.scaffoldDarkBackground,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: ChatColors.scaffoldDarkBackground,
        foregroundColor: Colors.white70,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
      body: Center(
        child: Hero(
          tag: userId,
          child: imagePath == null
              ? Text("No Profile Photo")
              : Image.file(
                  File(imagePath!),
                  fit: BoxFit.contain, // Adjust the fit as needed
                ),
        ),
      ),
    );
  }
}
