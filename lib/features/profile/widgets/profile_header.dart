import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {

  final String username;
  final String email;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xff001F8B),
            Color(0xff0052FF),
          ],
        ),
      ),
      child: Row(
        children: [

          const CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 38,
              color: Colors.blue,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}