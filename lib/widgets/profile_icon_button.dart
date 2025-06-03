import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';

class ProfileIconButton extends StatelessWidget {
  const ProfileIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person_outline),
      tooltip: 'Profile',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },
    );
  }
}
