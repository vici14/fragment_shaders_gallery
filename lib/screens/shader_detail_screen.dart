import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

import '../data/shader_model.dart';
import '../services/shader_manager.dart';
import '../widgets/shader_painter.dart';

class ShaderDetailScreen extends StatefulWidget {
  final String shaderId;

  const ShaderDetailScreen({Key? key, required this.shaderId})
    : super(key: key);

  @override
  State<ShaderDetailScreen> createState() => _ShaderDetailScreenState();
}

class _ShaderDetailScreenState extends State<ShaderDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _mousePosition = Offset.zero;
  final ShaderManager shaderManager = ShaderManager();
  late ShaderModel? shader;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    shader = shaderManager.getShaderById(widget.shaderId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (shader == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Shader Not Found')),
        body: const Center(
          child: Text('The requested shader could not be found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(shader!.name),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _mousePosition = details.localPosition;
                });
              },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return ShaderBuilder(
                    assetKey: shader!.assetKey,
                    (context, shaderInstance, child) => CustomPaint(
                      painter: ShaderPainter(
                        shader: shaderInstance,
                        time: _controller.value * 20.0,
                        mouse: _mousePosition,
                      ),
                      size: Size.infinite,
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 8,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black87,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shader!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  shader!.description,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Interact with the shader by dragging your finger or mouse across the screen.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
