import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../providers/globe_provider.dart';
import 'location_manager.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({Key? key}) : super(key: key);

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  final List<bool> _expanded = List.generate(3, (i) => i == 0 || i == 2);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth < 900;
        final isMobile = constraints.maxWidth < 600;
        final panelWidth = isMobile
            ? double.infinity
            : isTablet
                ? constraints.maxWidth * 0.4
                : AppConstants.panelWidthDesktop;

        return Consumer<GlobeProvider>(
          builder: (context, provider, _) {
            return Container(
              width: panelWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryDark,
                    AppColors.secondaryDark.withOpacity(0.95),
                  ],
                ),
                border: Border(
                  right: BorderSide(color: AppColors.glassBorder, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonBlue.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    isMobile
                        ? AppConstants.paddingSmall
                        : AppConstants.paddingLarge,
                  ),
                  child: Column(
                    children: [
                      _buildSection(
                        index: 0,
                        icon: Icons.public,
                        title: "Globe Controls",
                        child: Column(
                          children: [
                            _buildRotationControl(provider, isMobile),
                            const SizedBox(height: 12),
                            _buildRotationSpeedSlider(provider, isMobile),
                            const SizedBox(height: 12),
                            _buildZoomControl(provider, isMobile),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSection(
                        index: 1,
                        icon: Icons.analytics,
                        title: "Statistics",
                        child: _buildStatistics(provider, isMobile),
                      ),
                      const SizedBox(height: 12),
                      _buildSection(
                        index: 2,
                        icon: Icons.location_on,
                        title: "Locations",
                        child: const LocationManager(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSection({
    required int index,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: ExpansionTile(
        initiallyExpanded: _expanded[index],
        onExpansionChanged: (expanded) =>
            setState(() => _expanded[index] = expanded),
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        iconColor: AppColors.neonBlue,
        collapsedIconColor: AppColors.textSecondary,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppColors.nebulaGradient),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        children: [child],
      ),
    );
  }

  Widget _buildRotationControl(GlobeProvider provider, bool isMobile) {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Icon(
                      provider.isRotating
                          ? Icons.play_circle_filled
                          : Icons.pause_circle_filled,
                      color: AppColors.neonBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    const Flexible(
                      child: Text(
                        'Auto Rotation',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: isMobile ? 0.9 : 1.1,
                child: Switch(
                  value: provider.isRotating,
                  onChanged: (_) => provider.toggleRotation(),
                  activeColor: AppColors.neonBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: provider.isRotating ? provider.resetRotation : null,
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Reset Position'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.glassBackground,
                foregroundColor: AppColors.neonBlue,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 10 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.neonBlue.withOpacity(0.3)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRotationSpeedSlider(GlobeProvider provider, bool isMobile) {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelWithValue(
            label: 'Rotation Speed',
            value: provider.rotationSpeed.toStringAsFixed(2),
          ),
          Slider(
            value: provider.rotationSpeed,
            min: AppConstants.minRotationSpeed,
            max: AppConstants.maxRotationSpeed,
            activeColor: AppColors.neonBlue,
            inactiveColor: AppColors.tertiaryDark,
            onChanged: provider.isRotating ? provider.setRotationSpeed : null,
          ),
        ],
      ),
    );
  }

  Widget _buildZoomControl(GlobeProvider provider, bool isMobile) {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelWithValue(
              label: 'Zoom Level', value: '${(provider.zoom * 100).toInt()}%'),
          Slider(
            value: provider.zoom,
            min: AppConstants.minZoom,
            max: AppConstants.maxZoom,
            divisions: 12,
            activeColor: AppColors.neonBlue,
            inactiveColor: AppColors.tertiaryDark,
            onChanged: provider.setZoom,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: provider.zoomOut,
                icon: const Icon(Icons.remove_circle_outline),
                color: AppColors.neonBlue,
                iconSize: 22,
              ),
              IconButton(
                onPressed: provider.zoomIn,
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.neonBlue,
                iconSize: 22,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(GlobeProvider provider, bool isMobile) {
    return Column(
      children: [
        _buildStatCard(
          icon: Icons.location_on,
          label: 'Active Locations',
          value: provider.locations.where((l) => l.isVisible).length.toString(),
          color: AppColors.neonBlue,
        ),
        const SizedBox(height: 8),
        _buildStatCard(
          icon: Icons.link,
          label: 'Connections',
          value: provider.showConnections
              ? provider.connections.length.toString()
              : '0',
          color: AppColors.neonPurple,
        ),
        const SizedBox(height: 8),
        _buildStatCard(
          icon: Icons.public,
          label: 'Current Body',
          value: provider.selectedBody?.name ?? 'None',
          color: AppColors.neonPink,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return _buildGlassContainer(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    )),
                Text(value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelWithValue({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.neonBlue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.neonBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: child,
    );
  }
}
