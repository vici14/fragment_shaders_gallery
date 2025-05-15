import 'package:flutter/material.dart';

class ShaderModel {
  final String id;
  final String name;
  final String assetKey;
  final String description;
  final Color thumbnailColor;

  ShaderModel({
    required this.id,
    required this.name,
    required this.assetKey,
    required this.description,
    required this.thumbnailColor,
  });
}
