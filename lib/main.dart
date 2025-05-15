import 'package:flutter/material.dart';
import 'screens/shader_detail_screen.dart';
import 'screens/shaders_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fragment Shaders Gallery',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {'/': (context) => const ShadersListScreen()},
      onGenerateRoute: (settings) {
        if (settings.name == '/shader_detail') {
          final shaderId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ShaderDetailScreen(shaderId: shaderId),
          );
        }
        return null;
      },
    );
  }
}
