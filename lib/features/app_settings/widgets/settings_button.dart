import 'package:flutter/material.dart';

import '../../../config/routes/navigator.dart';
import '../settings_screen.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          push(SettingsScreen());
        },
        icon: const Icon(Icons.settings));
  }
}
