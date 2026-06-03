import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;   // ← added

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,                // ← optional so existing code won't break
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,            // ← wraps column with tap
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              color: Colors.blue,
              size: 20,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}