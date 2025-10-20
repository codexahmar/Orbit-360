import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../providers/globe_provider.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({Key? key}) : super(key: key);

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  // Track which sections are expanded
  final List<bool> _expanded = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        return Container(
          width: AppConstants.panelWidthDesktop,
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
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            children: [
              _buildSection(
                index: 0,
                icon: Icons.public,
                title: "Globe Controls",
                child: Column(
                  children: [
                    _buildRotationControl(provider),
                    const SizedBox(height: 12),
                    _buildRotationSpeedSlider(provider),
                    const SizedBox(height: 12),
                    _buildZoomControl(provider),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildSection(
                index: 1,
                icon: Icons.flash_on,
                title: "Quick Actions",
                child: _buildQuickActions(provider),
              ),
              const SizedBox(height: 12),
              _buildSection(
                index: 2,
                icon: Icons.analytics,
                title: "Statistics",
                child: _buildStatistics(provider),
              ),
            ],
          ),
        );
      },
    );
  }

  /// --------------------------
  /// Collapsible Section Builder
  /// --------------------------
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
        onExpansionChanged: (expanded) {
          setState(() => _expanded[index] = expanded);
        },
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
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

  /// --------------------------
  /// Section Widgets (same as before)
  /// --------------------------

  Widget _buildRotationControl(GlobeProvider provider) {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    provider.isRotating
                        ? Icons.play_circle_filled
                        : Icons.pause_circle_filled,
                    color: AppColors.neonBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Auto Rotation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Transform.scale(
                scale: 1.1,
                child: Switch(
                  value: provider.isRotating,
                  onChanged: (_) => provider.toggleRotation(),
                  activeColor: AppColors.neonBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: provider.resetRotation,
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Reset Position'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.glassBackground,
                foregroundColor: AppColors.neonBlue,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildRotationSpeedSlider(GlobeProvider provider) {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rotation Speed',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neonBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  provider.rotationSpeed.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neonBlue,
                  ),
                ),
              ),
            ],
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

  Widget _buildZoomControl(GlobeProvider provider) {
    return _buildGlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Zoom Level',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: provider.zoomOut,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.neonBlue,
                    iconSize: 26,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.neonBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(provider.zoom * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neonBlue,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: provider.zoomIn,
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.neonBlue,
                    iconSize: 26,
                  ),
                ],
              ),
            ],
          ),
          Slider(
            value: provider.zoom,
            min: AppConstants.minZoom,
            max: AppConstants.maxZoom,
            divisions: 12,
            activeColor: AppColors.neonBlue,
            inactiveColor: AppColors.tertiaryDark,
            onChanged: provider.setZoom,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(GlobeProvider provider) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildQuickActionButton(
          icon: provider.showConnections ? Icons.link : Icons.link_off,
          label: 'Connections',
          onPressed: provider.toggleConnections,
          isActive: provider.showConnections,
        ),
        _buildQuickActionButton(
          icon: provider.showLabels ? Icons.label : Icons.label_off,
          label: 'Labels',
          onPressed: provider.toggleLabels,
          isActive: provider.showLabels,
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isActive,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive
            ? AppColors.neonBlue.withOpacity(0.2)
            : AppColors.glassBackground,
        foregroundColor:
            isActive ? AppColors.neonBlue : AppColors.textSecondary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isActive
                ? AppColors.neonBlue.withOpacity(0.5)
                : AppColors.glassBorder,
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics(GlobeProvider provider) {
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
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    )),
                Text(value,
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
