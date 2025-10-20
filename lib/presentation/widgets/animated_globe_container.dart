import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../providers/globe_provider.dart';

class AnimatedGlobeContainer extends StatefulWidget {
  const AnimatedGlobeContainer({Key? key}) : super(key: key);

  @override
  State<AnimatedGlobeContainer> createState() => _AnimatedGlobeContainerState();
}

class _AnimatedGlobeContainerState extends State<AnimatedGlobeContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: AppConstants.verySlowAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // ✅ Delay provider initialization until after the first build frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<GlobeProvider>(context, listen: false);
      provider.initialize();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final radius = _calculateRadius(size);

    return Consumer<GlobeProvider>(
      builder: (context, provider, child) {
        if (!provider.isInitialized) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            // Animated Background Glow
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: radius * 2.5,
                  height: radius * 2.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.neonBlue
                            .withOpacity(0.1 * _fadeAnimation.value),
                        AppColors.neonPurple
                            .withOpacity(0.05 * _fadeAnimation.value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),

            // Orbit Ring
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value * 0.3,
                  child: Container(
                    width: radius * 2.2,
                    height: radius * 2.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.neonBlue.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Globe
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FlutterEarthGlobe(
                  controller: provider.controller,
                  radius: radius,
                  onTap: (coordinates) =>
                      provider.setClickCoordinates(coordinates),
                  onHover: (coordinates) =>
                      provider.setHoverCoordinates(coordinates),
                ),
              ),
            ),

            // Floating Particles
            ...List.generate(8, (index) {
              return _buildFloatingParticle(index: index, radius: radius);
            }),
          ],
        );
      },
    );
  }

  Widget _buildFloatingParticle({required int index, required double radius}) {
    final angle = (index * 45) * (3.14159 / 180);
    final distance = radius * 1.4;
    final x = distance * cos(angle);
    final y = distance * sin(angle);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(x * value, y * value),
          child: Opacity(
            opacity: value * 0.6,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    index % 2 == 0 ? AppColors.neonBlue : AppColors.neonPurple,
                boxShadow: [
                  BoxShadow(
                    color: (index % 2 == 0
                            ? AppColors.neonBlue
                            : AppColors.neonPurple)
                        .withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateRadius(Size size) {
    if (size.width < AppConstants.mobileBreakpoint) {
      return (size.width / 3.5).clamp(100, 180);
    } else if (size.width < AppConstants.tabletBreakpoint) {
      return 160.0;
    } else {
      return 200.0;
    }
  }

  double cos(double angle) => angle.cos();
  double sin(double angle) => angle.sin();
}

extension on double {
  double cos() {
    return this;
  }

  double sin() {
    return this;
  }
}
