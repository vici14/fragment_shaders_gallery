import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  ShaderPainter({
    required this.shader,
    this.time = 0.0,
    this.mouse = Offset.zero,
  });

  final ui.FragmentShader shader;
  final double time;
  final Offset mouse;

  @override
  void paint(Canvas canvas, Size size) {
    // Always set the required parameters
    shader.setFloat(0, 1000);
    shader.setFloat(1, 2500);
    shader.setFloat(2, time);

    // Try to set mouse parameters if shader supports them
    try {
      shader.setFloat(3, mouse.dx);
      shader.setFloat(4, mouse.dy);
    } catch (e) {
      // Shader doesn't support mouse parameters, which is fine
    }

    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(ShaderPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.shader != shader ||
        oldDelegate.mouse != mouse;
  }
}
