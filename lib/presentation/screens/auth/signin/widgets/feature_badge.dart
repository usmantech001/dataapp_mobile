import 'package:dataplug/presentation/misc/color_manager/color_manager.dart';
import 'package:flutter/material.dart';

class FeatureBadges extends StatelessWidget {
  const FeatureBadges({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
        _Badge(
          icon: Icons.flash_on,
          text: 'Instant',
          iconColor: ColorManager.kPrimary,
        ),
        SizedBox(width: 12),
        _Badge(
          icon: Icons.verified_user,
          text: 'Secure',
          iconColor: ColorManager.kPrimary,
        ),
        SizedBox(width: 12),
        _Badge(
          icon: Icons.auto_awesome,
          text: 'Easy to use',
          iconColor: ColorManager.kPrimary,
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const _Badge({
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}
