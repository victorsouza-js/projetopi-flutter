import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/pages/cadastro.dart';
import 'package:projeto_pi_flutter/pages/home_page.dart';
import 'package:projeto_pi_flutter/pages/home_page_2.dart';
import 'package:projeto_pi_flutter/pages/profile_page.dart';
import 'package:projeto_pi_flutter/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:projeto_pi_flutter/data/http/http_client.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return MultiProvider(
      providers: [
        Provider<Dio>.value(value: dio),
        ProxyProvider<Dio, DioClient>(
          update: (context, dio, dioClient) {
            return DioClient(dio);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Projeto PI Flutter',

        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/home': (context) => HomePage(),
          '/home2': (context) => HomePage2(),
          '/cadastro': (context) => Cadastro(),
          '/profile': (context) => ProfilePage(),
          '/splash': (context) => SplashScreen(),
        },
      ),
    );
  }
}
