import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;
  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..forward();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/d24168f4-e0c0-458c-8a7b-50c524716de0/uRiXGAp7La.json',
              width: 180,
              height: 180,
              controller: _lottieController,
              onLoaded: (composition) {
                _lottieController.duration = composition.duration;
                _lottieController.forward();
              },
            ),
            SizedBox(height: 24),
            Text(
              'Bem-vindo ao FitXpert',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Seu app de treino e saúde!',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
