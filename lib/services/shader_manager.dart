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
    ShaderModel(
      id: 'fractal_color',
      name: 'Fractal Color',
      assetKey: 'shaders/fractal_color.frag',
      description:
          'A hypnotic fractal pattern with dynamic colors based on distance functions.',
      thumbnailColor: Colors.orangeAccent,
    ),
    ShaderModel(
      id: 'star_nest',
      name: 'Star Nest',
      assetKey: 'shaders/star_nest.frag',
      description:
          'A mesmerizing 3D star field with volumetric rendering and interactive rotation.',
      thumbnailColor: Colors.deepPurpleAccent,
    ),
    ShaderModel(
      id: 'seascape',
      name: 'Seascape',
      assetKey: 'shaders/seascape.frag',
      description:
          'Dynamic ocean simulation with realistic waves, reflections, and interactive camera movement.',
      thumbnailColor: Colors.tealAccent,
    ),
    ShaderModel(
      id: 'retrowave_scene',
      name: 'Retrowave Scene',
      assetKey: 'shaders/retrowave_scene.frag',
      description:
          'A synthwave/retrowave aesthetic scene featuring a sunset, Mount Fuji, grid, and clouds.',
      thumbnailColor: Colors.pinkAccent,
    ),
    ShaderModel(
      id: 'singularity',
      name: 'Singularity',
      assetKey: 'shaders/singularity.frag',
      description:
          'A whirling blackhole with colorful accretion disk and interactive touch control.',
      thumbnailColor: Colors.indigoAccent,
    ),
    ShaderModel(
      id: 'pinky',
      name: 'Pinky',
      assetKey: 'shaders/pinky.frag',
      description:
          'A pinky shader with dynamic clouds and sun rays based on raymarching and turbulence.',
      thumbnailColor: Colors.pinkAccent,
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
