import 'package:flutter/material.dart';

class QuickActionItem extends StatelessWidget {

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const QuickActionItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
      
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xffEEF3FF),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 30, 137, 224),
            ),
          ),
      
          const SizedBox(height: 10),
      
          Text(title),
        ],
      ),
    );
  }
}