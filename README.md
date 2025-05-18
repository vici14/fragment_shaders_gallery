# Fragment Shaders Gallery

A Flutter project showcasing fragment shaders in a clean gallery format.

## Features

- **Shader Gallery**: Browse a collection of fragment shaders in a grid layout
- **Detailed View**: View each shader in full-screen with shader details
- **Interactive Shaders**: Interact with shaders through gestures
- **Centralized Management**: All shaders are managed through a central service

## Project Structure

The project is structured as follows:

```
lib/
  ├── data/
  │   └── shader_model.dart         # Model for shader data
  ├── screens/
  │   ├── shaders_list_screen.dart  # Gallery screen for shader list
  │   └── shader_detail_screen.dart # Detail screen for individual shader
  ├── services/
  │   └── shader_manager.dart       # Central service for managing shaders
  ├── widgets/
  │   ├── shader_painter.dart       # Custom painter for rendering shaders
  │   └── shader_preview.dart       # Widget for shader preview in gallery
  └── main.dart                     # Main application entry
```

## Shaders Included

- **Fractal Pyramid**: A colorful fractal pyramid shader with dynamic movement
- **Gradient Wave**: Smooth gradient waves with animated displacement
- **Pulsing Circle**: A colorful pulsing circle with dynamic color shifts
- **Fractal Color**: A hypnotic fractal pattern with dynamic colors based on distance functions
- **Star Nest**: A mesmerizing 3D star field with volumetric rendering and interactive rotation
- **Seascape**: Dynamic ocean simulation with realistic waves, reflections, and interactive camera movement
- **Retrowave Scene**: A synthwave/retrowave aesthetic scene featuring a sunset, Mount Fuji, grid, and clouds
- **Singularity**: A whirling blackhole with colorful accretion disk and interactive touch control
- **Pinky**: A pinky shader with dynamic clouds and sun rays based on raymarching and turbulence

## Dependencies

- Flutter 3.7.2 or higher
- flutter_shaders: ^0.1.3

## Adding New Shaders

To add a new shader:

1. Add your `.frag` file to the `shaders/` directory
2. Register it in the `pubspec.yaml` under the `shaders:` section
3. Add its details to the `shaderManager` service in `lib/services/shader_manager.dart`

## How to Use

1. Start the app to view the shader gallery
2. Tap on any shader to view it in detail
3. In the detail view, interact with the shader by using touch gestures

## Learning Resources

This project serves as a reference for learning about fragment shaders in Flutter, from basic implementation to interactive effects. For more information about fragment shaders in Flutter, visit the [Flutter website](https://docs.flutter.dev/ui/design/graphics/fragment-shaders).

## Requirements

- Flutter 3.7.2 or higher
- Dart 3.0.0 or higher
- A device that supports fragment shaders (most modern devices)
