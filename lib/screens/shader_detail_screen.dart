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

  // Controller mode state
  bool _controllerModeEnabled = false;
  double _width = 800;
  double _height = 600;
  double _timeMultiplier = 20.0;
  bool _isPaused = false;

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

  void _toggleControllerMode() {
    setState(() {
      _controllerModeEnabled = !_controllerModeEnabled;
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _controller.stop();
      } else {
        _controller.repeat();
      }
    });
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
        actions: [
          IconButton(
            icon: Icon(
              _controllerModeEnabled ? Icons.tune : Icons.tune_outlined,
            ),
            onPressed: _toggleControllerMode,
            tooltip: 'Toggle controls',
          ),
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: _togglePause,
            tooltip: 'Play/Pause',
          ),
        ],
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
                        time: _controller.value * _timeMultiplier,
                        mouse: _mousePosition,
                        width: _controllerModeEnabled ? _width : null,
                        height: _controllerModeEnabled ? _height : null,
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
          // Control panel
          if (_controllerModeEnabled)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black.withOpacity(0.8),
              child: Column(
                children: [
                  _buildSlider(
                    'Width',
                    _width,
                    100,
                    2000,
                    (value) => setState(() => _width = value),
                  ),
                  _buildSlider(
                    'Height',
                    _height,
                    100,
                    2000,
                    (value) => setState(() => _height = value),
                  ),
                  _buildSlider(
                    'Time Multiplier',
                    _timeMultiplier,
                    1,
                    60,
                    (value) => setState(() => _timeMultiplier = value),
                  ),
                ],
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label: ${value.toStringAsFixed(1)}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: 100,
              onChanged: onChanged,
              activeColor: Colors.tealAccent,
              inactiveColor: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
