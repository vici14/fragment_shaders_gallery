import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

  // Replace direct state variables with ValueNotifier objects
  final ValueNotifier<Offset> _mousePosition = ValueNotifier<Offset>(
    Offset.zero,
  );
  final ValueNotifier<bool> _isLeftPressed = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isRightPressed = ValueNotifier<bool>(false);

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
    _mousePosition.dispose();
    _isLeftPressed.dispose();
    _isRightPressed.dispose();
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
                    (context, shader, child) => Center(
                      child: Listener(
                        onPointerDown: (event) {
                          if (event.buttons & 0x01 != 0) {
                            // Primary/left button
                            _isLeftPressed.value = true;
                          }
                          if (event.buttons & 0x02 != 0) {
                            // Secondary/right button
                            _isRightPressed.value = true;
                          }
                        },
                        onPointerUp: (event) {
                          _isLeftPressed.value = false;
                          _isRightPressed.value = false;
                        },
                        onPointerMove: (event) {
                          _mousePosition.value = event.localPosition;
                          // Update button states in case they changed
                          _isLeftPressed.value = event.buttons & 0x01 != 0;
                          _isRightPressed.value = event.buttons & 0x02 != 0;
                        },
                        child: MouseRegion(
                          onHover: (event) {
                            _mousePosition.value = event.localPosition;
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: ValueListenableBuilder3<Offset, bool, bool>(
                              first: _mousePosition,
                              second: _isLeftPressed,
                              third: _isRightPressed,
                              builder: (
                                context,
                                mousePosition,
                                isLeftPressed,
                                isRightPressed,
                                _,
                              ) {
                                return CustomPaint(
                                  painter: ShaderPainter(
                                    shader: shader,
                                    time: _controller.value * 50.0,
                                    mouse: mousePosition,
                                    isLeftPressed: isLeftPressed,
                                    isRightPressed: isRightPressed,
                                  ),
                                  size: const Size(1.0, 1.0),
                                  isComplex: true,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
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

// Custom ValueListenableBuilder for three values
class ValueListenableBuilder3<A, B, C> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final ValueListenable<C> third;
  final Widget? child;
  final Widget Function(BuildContext context, A a, B b, C c, Widget? child)
  builder;

  const ValueListenableBuilder3({
    Key? key,
    required this.first,
    required this.second,
    required this.third,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, a, _) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, _) {
            return ValueListenableBuilder<C>(
              valueListenable: third,
              builder: (context, c, _) {
                return builder(context, a, b, c, child);
              },
            );
          },
        );
      },
    );
  }
}
