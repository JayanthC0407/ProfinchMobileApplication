import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {

  final IconData icon;
  final String title;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            color: Colors.blue,
            size: 28,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          title,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}