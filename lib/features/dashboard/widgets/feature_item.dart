import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        CircleAvatar(
          radius: 22,                         // ✅ reduced from 28
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            color: Colors.blue,
            size: 20,                         // ✅ reduced from 28
          ),
        ),

        const SizedBox(height: 6),            // ✅ reduced from 10

        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,                        // ✅ no wrapping
          overflow: TextOverflow.ellipsis,    // ✅ no overflow
          style: const TextStyle(
            fontSize: 11,                     // ✅ smaller text
            color: Colors.white,              // ✅ white for dark bg
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
    );
  }
}