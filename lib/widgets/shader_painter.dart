import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  ShaderPainter({
    required this.shader,
    this.time = 0.0,
    this.mouse = Offset.zero,
    this.width,
    this.height,
    this.drawOutline = false,
    this.outlineColor = Colors.white,
    this.outlineWidth = 2.0,
  });

  final ui.FragmentShader shader;
  final double time;
  final Offset mouse;
  final double? width;
  final double? height;
  final bool drawOutline;
  final Color outlineColor;
  final double outlineWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Use provided width/height or fallback to canvas size
    final shaderWidth = width ?? size.width;
    final shaderHeight = height ?? size.height;

    // Always set the required parameters
    shader.setFloat(0, shaderWidth);
    shader.setFloat(1, shaderHeight);
    shader.setFloat(2, time);

    // Try to set mouse parameters if shader supports them
    try {
      shader.setFloat(3, mouse.dx);
      shader.setFloat(4, mouse.dy);
    } catch (e) {
      // Shader doesn't support mouse parameters, which is fine
    }

    // Draw the shader-filled rectangle
    final paint = Paint()..shader = shader;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    // Draw outline if requested
    if (drawOutline) {
      final outlinePaint =
          Paint()
            ..style = PaintingStyle.stroke
            ..color = outlineColor
            ..strokeWidth = outlineWidth;

      canvas.drawRect(rect, outlinePaint);
    }
  }

  @override
  bool shouldRepaint(ShaderPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.shader != shader ||
        oldDelegate.mouse != mouse ||
        oldDelegate.width != width ||
        oldDelegate.height != height ||
        oldDelegate.drawOutline != drawOutline ||
        oldDelegate.outlineColor != outlineColor ||
        oldDelegate.outlineWidth != outlineWidth;
  }
}
