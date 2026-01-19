import 'package:flutter/material.dart';

class AuthSuccessModel {
  final String title;
  final String description;
  final String btnText;
  final VoidCallback onTap;

  AuthSuccessModel({
    required this.title,
    required this.description,
    required this.onTap,
    required this.btnText
  });
}