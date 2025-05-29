import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/app_widget.dart';

void main(List<String> args) {
  runApp(AppWidget());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Container()));
  }
}
