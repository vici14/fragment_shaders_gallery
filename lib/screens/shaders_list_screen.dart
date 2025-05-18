import 'package:flutter/material.dart';

import '../data/shader_model.dart';
import '../services/shader_manager.dart';

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
          return Card(
            clipBehavior: Clip.antiAlias,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/shader_detail',
                  arguments: shader.id,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      color: Colors.grey[800],
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.auto_awesome,
                        size: 48,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shader.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          shader.description ?? 'Fragment Shader',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
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
        },
      ),
    );
  }
}
