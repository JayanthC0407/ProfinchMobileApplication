import 'package:flutter/material.dart';
import 'package:mobileproject/constants/colors.dart';

class SecurityBadge extends StatelessWidget {
  const SecurityBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            size: 14,
            color: AppColors.light,
          ),
          const SizedBox(width: 5),
          Text(
            '256-bit SSL encrypted  ·  Bank-grade security',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.light.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}