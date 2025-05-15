import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

import '../data/shader_model.dart';
import '../services/shader_manager.dart';
import 'shader_painter.dart';

class ShaderPreview extends StatefulWidget {
  final ShaderModel shader;
  final VoidCallback onTap;

  const ShaderPreview({Key? key, required this.shader, required this.onTap})
    : super(key: key);

  @override
  State<ShaderPreview> createState() => _ShaderPreviewState();
}

class _ShaderPreviewState extends State<ShaderPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return ShaderBuilder(
                    assetKey: widget.shader.assetKey,
                    (context, shader, child) => CustomPaint(
                      painter: ShaderPainter(
                        shader: shader,
                        time: _controller.value * 10.0,
                      ),
                      size: Size.infinite,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: widget.shader.thumbnailColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shader.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.shader.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
