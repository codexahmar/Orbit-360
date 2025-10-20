import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../providers/globe_provider.dart';
import '../widgets/control_panel.dart';
import '../widgets/texture_selector.dart';
import '../widgets/location_manager.dart';
import '../widgets/stats_display.dart';
import '../widgets/animated_globe_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();

    // Initialize provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GlobeProvider>(context, listen: false).initialize();
    });

    // Background animation
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final isTablet = size.width >= AppConstants.mobileBreakpoint &&
        size.width < AppConstants.desktopBreakpoint;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.primaryDark,
      drawer: isMobile ? _buildMobileDrawer(isLeft: true) : null,
      endDrawer: isMobile ? _buildMobileDrawer(isLeft: false) : null,
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // App Bar
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: isMobile
                      ? IconButton(
                          icon: const Icon(Icons.menu),
                          color: AppColors.textPrimary,
                          onPressed: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                        )
                      : null,
                  actions: isMobile
                      ? [
                          IconButton(
                            icon: const Icon(Icons.palette),
                            color: AppColors.textPrimary,
                            onPressed: () =>
                                _scaffoldKey.currentState?.openEndDrawer(),
                          ),
                        ]
                      : null,
                ),

                // Main Content Area
                Expanded(
                  child: Row(
                    children: [
                      // Left Panel (Desktop only)
                      if (!isMobile && !isTablet) const ControlPanel(),

                      // Globe Container
                      Expanded(
                        child: Stack(
                          children: [
                            const Center(
                              child: AnimatedGlobeContainer(),
                            ),

                            // Stats Display
                            const StatsDisplay(),
                          ],
                        ),
                      ),

                      // Right Panel (Desktop only)
                      if (!isMobile && !isTablet) const TextureSelector(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.cosmicGradient,
              stops: [
                0.0,
                0.5 + (_backgroundController.value * 0.1),
                1.0,
              ],
            ),
          ),
          child: CustomPaint(
            painter: StarfieldPainter(
              animation: _backgroundController.value,
            ),
            child: Container(),
          ),
        );
      },
    );
  }

  Widget _buildMobileDrawer({required bool isLeft}) {
    return Drawer(
      backgroundColor: AppColors.primaryDark,
      child: isLeft
          ? Column(
              children: [
                _buildDrawerHeader('Controls', Icons.tune),
                const Expanded(child: ControlPanel()),
                Divider(color: AppColors.glassBorder),
                // _buildDrawerHeader('Locations', Icons.location_on),
                // const Expanded(child: LocationManager()),
              ],
            )
          : Column(
              children: [
                const Expanded(child: TextureSelector()),
              ],
            ),
    );
  }

  Widget _buildDrawerHeader(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.nebulaGradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Starfield Background
class StarfieldPainter extends CustomPainter {
  final double animation;

  StarfieldPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Generate stars
    for (int i = 0; i < 100; i++) {
      final x = (i * 73.7) % size.width;
      final y = ((i * 91.3) % size.height + (animation * 50)) % size.height;
      final brightness = ((i * 17) % 100) / 100.0;

      paint.color = Colors.white.withOpacity(brightness * 0.6);
      canvas.drawCircle(
        Offset(x, y),
        brightness * 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(StarfieldPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
