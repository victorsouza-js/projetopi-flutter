import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/pages/cadastro.dart';
import 'package:projeto_pi_flutter/pages/home_page.dart';
import 'package:projeto_pi_flutter/pages/home_page_2.dart';
import 'package:projeto_pi_flutter/pages/profile_page.dart';
import 'package:projeto_pi_flutter/splashscreen.dart';


class AppWidget extends StatelessWidget {
  
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/home': (context) => HomePage(),
        '/home2': (context) => HomePage2(),
        '/cadastro': (context) => Cadastro(),
        '/profile': (context) => ProfilePage(),
        '/splash': (context) => SplashScreen(),
      },
      );
  }
}