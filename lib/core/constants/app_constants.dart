class AppConstants {
  // App Info
  static const String appName = 'Cosmic Globe';
  static const String appVersion = '2.0.0';
  static const String appAuthor = 'Manahil Tareen';
  
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration verySlowAnimation = Duration(milliseconds: 800);
  
  // Globe Settings
  static const double defaultRotationSpeed = 0.05;
  static const double minRotationSpeed = 0.01;
  static const double maxRotationSpeed = 0.15;
  static const double defaultZoom = 0.5;
  static const double minZoom = 0.3;
  static const double maxZoom = 1.5;
  
  // UI Constants
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 24.0;
  static const double borderRadiusXLarge = 32.0;
  
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // Panel Widths
  static const double panelWidthMobile = 280.0;
  static const double panelWidthDesktop = 320.0;
}