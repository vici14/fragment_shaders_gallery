import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  ShaderPainter({
    required this.shader,
    this.time = 0.0,
    this.mouse = Offset.zero,
    this.isLeftPressed = false,
    this.isRightPressed = false,
  });

  final ui.FragmentShader shader;
  final double time;
  final Offset mouse;
  final bool isLeftPressed;
  final bool isRightPressed;

  @override
  void paint(Canvas canvas, Size size) {
    // Set uniforms according to shader expectations
    // location 0: vec2 resolution (viewport dimensions)
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    // location 1: float time (animation time)
    shader.setFloat(2, time);

    // location 2: vec4 mouse (position and click states)
    shader.setFloat(3, mouse.dx);
    shader.setFloat(4, mouse.dy);
    shader.setFloat(5, isLeftPressed ? 1.0 : 0.0); // mouse.z = left click
    shader.setFloat(6, isRightPressed ? 1.0 : 0.0); // mouse.w = right click

    final paint = Paint()..shader = shader;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(ShaderPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.shader != shader ||
        oldDelegate.mouse != mouse ||
        oldDelegate.isLeftPressed != isLeftPressed ||
        oldDelegate.isRightPressed != isRightPressed;
  }
}
