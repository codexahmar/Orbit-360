import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/celestial_body_model.dart';
import '../providers/globe_provider.dart';

class TextureSelector extends StatelessWidget {
  const TextureSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, child) {
        return Container(
          width: AppConstants.panelWidthDesktop,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryDark,
                AppColors.secondaryDark,
              ],
            ),
            border: Border(
              left: BorderSide(color: AppColors.glassBorder, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonPurple.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  itemCount: CelestialBodyModel.allBodies.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final body = CelestialBodyModel.allBodies[index];
                    final isSelected = provider.selectedBody?.id == body.id;
                    return _CelestialBodyCard(
                      body: body,
                      isSelected: isSelected,
                      onTap: () => provider.selectCelestialBody(body),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CelestialBodyCard extends StatelessWidget {
  final CelestialBodyModel body;
  final bool isSelected;
  final VoidCallback onTap;

  const _CelestialBodyCard({
    Key? key,
    required this.body,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.normalAnimation,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [
                    AppColors.neonBlue.withOpacity(0.2),
                    AppColors.neonPurple.withOpacity(0.2),
                  ]
                : [AppColors.glassBackground, AppColors.glassBackground],
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.neonBlue : AppColors.glassBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.neonBlue.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with optional glow
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    body.texturePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                if (body.hasGlow)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: RadialGradient(
                          colors: [
                            body.glowColor!.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                if (isSelected)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.neonBlue,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Body Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    children: [
                      Icon(
                        body.icon,
                        color: isSelected
                            ? AppColors.neonBlue
                            : AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          body.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.neonBlue
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.neonBlue,
                          child:
                              Icon(Icons.check, color: Colors.white, size: 14),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (body.hasGlow) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.wb_sunny, size: 14, color: body.glowColor),
                        const SizedBox(width: 4),
                        Text(
                          'Has Glow Effect',
                          style: TextStyle(
                            fontSize: 11,
                            color: body.glowColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
