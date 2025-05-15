import 'package:flutter/material.dart';

import '../data/shader_model.dart';
import '../services/shader_manager.dart';
import '../widgets/shader_preview.dart';

class ShadersListScreen extends StatelessWidget {
  const ShadersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shaderManager = ShaderManager();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fragment Shaders Gallery'),
        backgroundColor: Colors.black87,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: shaderManager.shaders.length,
        itemBuilder: (context, index) {
          final shader = shaderManager.shaders[index];
          return ShaderPreview(
            shader: shader,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/shader_detail',
                arguments: shader.id,
              );
            },
          );
        },
      ),
    );
  }
}
