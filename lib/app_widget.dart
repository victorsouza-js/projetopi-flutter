import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/pages/cadastro.dart';
import 'package:projeto_pi_flutter/pages/home_page.dart';
import 'package:projeto_pi_flutter/pages/home_page_2.dart';
import 'package:projeto_pi_flutter/pages/profile_page.dart';
import 'package:projeto_pi_flutter/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:projeto_pi_flutter/data/http/http_client.dart';
import 'package:projeto_pi_flutter/pages/pagamento_page.dart';
import 'package:projeto_pi_flutter/pages/carrinho_page.dart';
import 'package:projeto_pi_flutter/pages/produto_detalhe_page.dart';


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
          '/pagamento': (context) => PagamentoPage(),
          '/carrinho':
              (context) => CarrinhoPage(
                carrinho: [
                  {
                    'nome': 'Creatina Max 300g',
                    'preco': 79.90,
                    'imagem':
                        'https://m.media-amazon.com/images/I/51gt4U5kD-L._AC_UL320_.jpg',
                    'avaliacao': 4.5,
                  },
                  {
                    'nome': 'Creatina Monohidratada Dark Lab 300g',
                    'preco': 54.90,
                    'imagem':
                        'https://m.media-amazon.com/images/I/81IObjtLiML._AC_UL320_.jpg',
                    'avaliacao': 4.7,
                  },
                  {
                    'nome': 'Creatina Monohidratada Growth Supplements 300g',
                    'preco': 68.90,
                    'imagem':
                        'https://m.media-amazon.com/images/I/61hrHdSCq7L._AC_UL320_.jpg',
                    'avaliacao': 4.0,
                  },
                  {
                    'nome': 'Creatina Monohidratada Integralmedica 300g',
                    'preco': 70.00,
                    'imagem':
                        'https://m.media-amazon.com/images/I/81UashXoAxL._AC_UL320_.jpg',
                    'avaliacao': 4.6,
                  },
                  {
                    'nome': 'Creatina Monohidratada Probiótica 300g',
                    'preco': 56.90,
                    'imagem':
                        'https://m.media-amazon.com/images/I/514imF5uGPL._AC_UL320_.jpg',
                    'avaliacao': 4.7,
                  },
                  {
                    'nome': 'Creatina Monohudratada Dux 300g',
                    'preco': 67.99,
                    'imagem':
                        'https://m.media-amazon.com/images/I/61fB7PV3A7L._AC_UL320_.jpg',
                    'avaliacao': 4.7,
                  },

                  {
                    'nome':
                        'Whey Max Titanium x Dr. Peanut 900g s:Doce de Leite',
                    'preco': 120.99,
                    'imagem':
                        'https://m.media-amazon.com/images/I/61IpPwe99OL._AC_UL320_.jpg',
                    'avaliacao': 5.0,
                  },
                  {
                    'nome': 'Whey Max Titanium x Dr. Peanut 900g s:Bueníssimo',
                    'preco': 120.99,
                    'imagem':
                        'https://m.media-amazon.com/images/I/611DbOCRmFL._AC_UL320_.jpg',
                    'avaliacao': 4.7,
                  },
                  {
                    'nome': 'Whey Max Titanium x Dr. Peanut 900g s:Avelã',
                    'preco': 120.99,
                    'imagem':
                        'https://m.media-amazon.com/images/I/61zXQDYWmcL._AC_UL320_.jpg',
                    'avaliacao': 4.8,
                  },
                  {
                    'nome': 'Creatina Monohidratada Soldiers 300g',
                    'preco': 49.90,
                    'imagem':
                        'https://m.media-amazon.com/images/I/71ZNQQKAUzL._AC_UL320_.jpg',
                    'avaliacao': 5.0,
                  },
                  {
                    'nome': 'Creatina Monohidratada Vitafor 300g',
                    'preco': 60.00,
                    'imagem':
                        'https://m.media-amazon.com/images/I/51MhtOlCGVL._AC_UL320_.jpg',
                    'avaliacao': 4.3,
                  },
                  {
                    'nome':
                        '3VS Nutrition Pré Treino Prohibido 180g Sabor Maça Verde',
                    'preco': 60.00,
                    'imagem':
                        'https://m.media-amazon.com/images/I/61UESDpLUJL.AC_UL320.jpg',
                    'avaliacao': 4.3,
                  },
                  {
                    'nome': 'FTW Pré-Treino Diabo Verde 300g',
                    'preco': 68.05,
                    'imagem':
                        'https://m.media-amazon.com/images/I/612LVlrz2jL.AC_UL320.jpg',
                    'avaliacao': 4.2,
                  },
                  {
                    'nome':
                        '3VS Nutrition Pré-Treino Beast 300g Sabor Frutas Vermelhas',
                    'preco': 57.81,
                    'imagem':
                        'https://m.media-amazon.com/images/I/610o1NRDbML.AC_UL320.jpg',
                    'avaliacao': 4.7,
                  },
                  {
                    'nome': 'Pré-Treino Venom 300g Dark Lab',
                    'preco': 99.00,
                    'imagem':
                        'https://m.media-amazon.com/images/I/81pdnNjl82L.AC_UL320.jpg',
                    'avaliacao': 5.0,
                  },
                  {
                    'nome': 'Panic Pré Workout Morango 300g',
                    'preco': 78.95,
                    'imagem':
                        'https://m.media-amazon.com/images/I/71D+u3oWo0L.AC_UL320.jpg',
                    'avaliacao': 4.8,
                  },
                  {
                    'nome': 'Top Whey 3W Max 900g Sabor: Brigadeiro',
                    'preco': 130.90,
                    'imagem':
                        'https://lojamaxtitanium.vtexassets.com/arquivos/ids/157615-1920-0/top-whey-3w-max-titanium-900g-sabor-brigadeiro-1.jpg?v=638351456579070000',
                    'avaliacao': 5.0,
                  },
                  {
                    'nome': '100% Whey Dino Pote Max 900G Sabor: Cappuccino',
                    'preco': 150.00,
                    'imagem':
                        'https://lojamaxtitanium.vtexassets.com/arquivos/ids/157990-1920-0/100-Whey-Pote-900g-LinhaDino-Cappuccino.png?v=638524935006700000',
                    'avaliacao': 4.4,
                  },
                ],
              ),
        },
      ),
    );
  }
}
