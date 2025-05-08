import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/cadastro.dart';
import 'package:projeto_pi_flutter/home_page.dart';
import 'package:projeto_pi_flutter/home_page_2.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/home2': (context) => HomePage2(),
        '/cadastro': (context) => Cadastro(),

      },
      );
  
  }
}