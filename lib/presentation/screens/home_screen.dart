import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../providers/globe_provider.dart';
import '../widgets/control_panel.dart';
import '../widgets/texture_selector.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GlobeProvider>(context, listen: false).initialize();
    });

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
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: isMobile
                ? IconButton(
                    icon: const Icon(Icons.menu),
                    color: AppColors.textPrimary,
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
          Expanded(
            child: Row(
              children: [
                if (!isMobile && !isTablet) const ControlPanel(),
                const Expanded(
                  child: Center(child: AnimatedGlobeContainer()),
                ),
                if (!isMobile && !isTablet) const TextureSelector(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer({required bool isLeft}) {
    return Drawer(
      backgroundColor: AppColors.primaryDark,
      child: Column(
        children: [
          const SizedBox(height: 100),
          Expanded(
            child: isLeft ? const ControlPanel() : const TextureSelector(),
          ),
        ],
      ),
    );
  }
}
