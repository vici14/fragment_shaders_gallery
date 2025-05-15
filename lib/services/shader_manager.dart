import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

import '../data/shader_model.dart';

class ShaderManager {
  static final ShaderManager _instance = ShaderManager._internal();

  factory ShaderManager() => _instance;

  ShaderManager._internal();

  final List<ShaderModel> shaders = [
    ShaderModel(
      id: 'fractal_pyramid',
      name: 'Fractal Pyramid',
      assetKey: 'shaders/fractal_pyramid.frag',
      description: 'A colorful fractal pyramid shader with dynamic movement.',
      thumbnailColor: Colors.purpleAccent,
    ),
    ShaderModel(
      id: 'gradient_wave',
      name: 'Gradient Wave',
      assetKey: 'shaders/gradient_wave.frag',
      description: 'Smooth gradient waves with animated displacement.',
      thumbnailColor: Colors.blueAccent,
    ),
    ShaderModel(
      id: 'circle_pulse',
      name: 'Pulsing Circle',
      assetKey: 'shaders/circle_pulse.frag',
      description: 'A colorful pulsing circle with dynamic color shifts.',
      thumbnailColor: Colors.redAccent,
    ),
  ];

  ShaderModel? getShaderById(String id) {
    try {
      return shaders.firstWhere((shader) => shader.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<FragmentShader> loadShader(String assetKey) async {
    return await FragmentProgram.fromAsset(
      assetKey,
    ).then((program) => program.fragmentShader());
  }
}
