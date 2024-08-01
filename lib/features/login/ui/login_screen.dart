import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: TextButton(
        onPressed: () {
          // TODO login with Google
        },
        child: Text(AppLocalizations.of(context)?.login ?? ''),
      ),
    ),
  );
}
