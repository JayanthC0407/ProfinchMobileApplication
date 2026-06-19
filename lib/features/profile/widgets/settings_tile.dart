import 'package:flutter/material.dart';
import 'package:profinch_mobile_application/core/constants/colors.dart';

class SettingsTile extends StatelessWidget {

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return ListTile(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      tileColor: AppColors.light,

      leading: CircleAvatar(
        backgroundColor: const Color(0xffEEF3FF),
        child: Icon(
          icon,
          color: Colors.blue,
        ),
      ),

      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: onTap,
    );
  }
}