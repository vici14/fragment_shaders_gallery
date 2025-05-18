# Fragment Shaders Gallery

A Flutter project showcasing fragment shaders in a clean gallery format.

## Features

- **Shader Gallery**: Browse a collection of fragment shaders in a grid layout
- **Detailed View**: View each shader in full-screen with shader details
- **Interactive Shaders**: Interact with shaders through gestures
- **Centralized Management**: All shaders are managed through a central service

## Live Demo

Check out the live demo of the Fragment Shaders Gallery:
[https://app-prod-abf9e.web.app/](https://app-prod-abf9e.web.app/)

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

## Dependencies

- Flutter 3.7.2 or higher
- flutter_shaders: ^0.1.3

## Adding New Shaders

To add a new shader:

1. Add your `.frag` file to the `shaders/` directory
2. Register it in the `pubspec.yaml` under the `shaders:` section
3. Add its details to the `shaderManager` service in `lib/services/shader_manager.dart`
4. Create a GIF demo and add it to `assets/demos/`

## How to Use

1. Start the app to view the shader gallery
2. Tap on any shader to view it in detail
3. In the detail view, interact with the shader by using touch gestures

## Creating Shader Demos

To create the shader demo GIFs:

1. Run the app and record each shader's animation for 3-5 seconds
2. Convert the recording to a GIF using tools like:
   - [FFmpeg](https://ffmpeg.org/) (command line)
   - [EzGif](https://ezgif.com/) (online)
   - [ScreenToGif](https://www.screentogif.com/) (Windows)
   - [Gifski](https://gif.ski/) (Mac)
3. Optimize your GIFs to keep them under 2MB each
4. Place them in the `assets/demos/` directory

## Learning Resources

This project serves as a reference for learning about fragment shaders in Flutter, from basic implementation to interactive effects. For more information about fragment shaders in Flutter, visit the [Flutter website](https://docs.flutter.dev/ui/design/graphics/fragment-shaders).

## Requirements

- Flutter 3.7.2 or higher
- Dart 3.0.0 or higher
- A device that supports fragment shaders (most modern devices)
