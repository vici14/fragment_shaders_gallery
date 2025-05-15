# Flutter Web Shader Compatibility

This project demonstrates how to make Flutter shaders work in both native and web platforms.

## The Problem

When running shaders on Flutter Web, the framework expects shaders to be provided in a specific JSON format, not raw GLSL. The error you'll see is something like:

```
FormatException: SyntaxError: Unexpected token '#', "#version 300 es"... is not valid JSON
```

This indicates Flutter is trying to parse your shader as JSON but encounters the GLSL directive `#version 300 es` instead.

## The Solution

For Flutter Web, you need to wrap your shader in a JSON structure with a specific format. This project shows two approaches:

### Approach 1: Manual JSON Wrapping (in `fire_shader_demo.dart`)

1. Created a JSON wrapper for the shader in `assets/shaders/fire_shader.json`
2. Added conditional loading based on platform detection
3. Uses native shader for desktop/mobile and JSON wrapper for web

### Approach 2: Using flutter_shaders package (in `fire_shader_web_demo.dart`)

1. Uses the `ShaderBuilder` widget from `flutter_shaders` package
2. Automatically handles platform differences
3. Provides a cleaner, simpler implementation

## JSON Shader Format

The JSON shader format looks like this:

```json
{
  "name": "FireShader",
  "uniforms": [
    {"name": "resolution", "type": "vec2"},
    {"name": "time", "type": "float"},
    {"name": "mouse", "type": "vec2"}
  ],
  "source": "your GLSL code as a string with escaped newlines and special characters"
}
```

## Implementation Details

The `main.dart` file uses platform detection to choose the appropriate implementation:

```dart
home: kIsWeb 
    ? const FireShaderWebDemo() // Web-compatible implementation
    : const FireShaderDemo(),   // Native implementation
```

## Important Notes

1. Make sure to add your shader files in `pubspec.yaml` under both `shaders:` and `assets:` sections
2. All newlines in your GLSL code need to be escaped in the JSON format
3. All quotes within the GLSL code need to be escaped
4. The JSON structure must define all uniforms your shader expects

## Further Reading

- [Flutter Shaders Documentation](https://docs.flutter.dev/ui/design/graphics/fragment-shaders)
- [flutter_shaders Package](https://pub.dev/packages/flutter_shaders) 