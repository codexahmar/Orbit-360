# 🌍 GeoOrbit



GeoOrbit is a stunning interactive 3D globe application that lets you explore Earth and other celestial bodies with beautiful visualizations. Navigate through space, add custom location markers, create connections between points, and switch between different planet textures - all with smooth animations and an immersive cyberpunk-inspired UI.

## ✨ Features

- 🌐 **Interactive 3D Globe** - Smooth rotation and zoom controls
- 📍 **Location Markers** - Add and customize points of interest
- 🔗 **Connections** - Draw animated paths between locations
- 🎨 **Multiple Textures** - Switch between Earth, Mars, Jupiter, and more
- 📱 **Responsive Design** - Works seamlessly on mobile, tablet, and desktop
- 🎭 **Modern UI** - Cyberpunk-inspired design with gradients and glow effects
- ⚡ **Performance Optimized** - Smooth 60fps animations
- 🌙 **Dark Theme** - Eye-friendly dark mode interface

## 🚀 Installation

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/codexahmar/GeoOrbit-V2/
   cd orbit360
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Usage

### Basic Controls

- **Rotate Globe**: Drag with mouse/finger
- **Zoom**: Pinch gesture or mouse wheel
- **Add Points**: Use the left control panel
- **Change Texture**: Use the right panel to select different planets
- **Create Connections**: Enable connections from the control panel

### Features Overview

#### Control Panel (Left)
- Toggle automatic rotation
- Adjust rotation speed
- Control zoom level
- Manage location points
- Enable/disable connections

#### Texture Panel (Right)
- Browse available textures
- Switch between planets
- Real-time texture preview

#### Coordinate Display (Bottom)
- Shows clicked location coordinates
- Displays latitude and longitude
- Real-time updates

## 🏗️ Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/       # App-wide constants
│   ├── theme/          # Theme configuration
│   └── utils/          # Utility functions
├── data/
│   └── models/         # Data models
├── presentation/
│   ├── screens/        # App screens
│   └── widgets/        # Reusable widgets
└── services/           # Business logic
```

## 🛠️ Built With

- [Flutter](https://flutter.dev/) - UI framework
- [flutter_earth_globe](https://pub.dev/packages/flutter_earth_globe) - 3D globe rendering
- [Material Design 3](https://m3.material.io/) - Design system


## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Ahmaryar Khan**

- GitHub: [@codexahmar](https://github.com/codexahmar)


<div align="center">

Made with ❤️ and Flutter

⭐ Star this repo if you find it helpful!

</div>
