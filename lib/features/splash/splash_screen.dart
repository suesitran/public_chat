import 'package:flutter/material.dart';
import 'package:public_chat/features/login/ui/login_screen.dart';
import 'package:public_chat/repository/language_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    await Future.wait([
      LanguageRepository.instance.getLanguages(),
      Future.delayed(const Duration(seconds: 2)),
    ]);
    if (mounted) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Hello",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
