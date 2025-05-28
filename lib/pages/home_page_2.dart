import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_pi_flutter/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  Future<void> _mostrarContaUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 'Não informado';
    final email = prefs.getString('email') ?? 'Não informado';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Minha Conta'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(FontAwesomeIcons.userCircle, size: 40),
                SizedBox(height: 16),
                Text('Usuário: $username'),
                SizedBox(height: 8),
                Text('E-mail: $email'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fechar'),
              ),
            ],
          ),
    );
  }

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> produtos = [
    {
      'nome': 'Creatina Max 300g',
      'preco': 79.90,
      'imagem':
          'https://images.tcdn.com.br/img/img_prod/996597/creatina_300g_pote_max_titanium_6940_1_27fd86d998d9077967d06165be82a759.png',
    },
    {
      'nome': 'Creatina Monohidratada Dark Lab 300g',
      'preco': 54.90,
      'imagem':
          'https://acdn-us.mitiendanube.com/stores/002/218/616/products/crea1-abd8ff086c388782e017183634041853-1024-1024.png',
    },
    {
      'nome': 'Straps de Pulso',
      'preco': 12.00,
      'imagem':
          'https://m.media-amazon.com/images/S/aplus-media-library-service-media/009a7384-7174-42ad-8018-538a9f1ee631.__CR0,0,300,300_PT0_SX300_V1___.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 20),
            Icon(Icons.account_circle, color: Colors.white, size: 100),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text(
                'Configurações',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.white),
              title: Text('Sobre', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text('Sair', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/home'); // Fecha o Drawer
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Pesquisar...',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.orange),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 6),
            ),
          ),
        ),

        actions: [
          Row(
            children: [
              IconButton(
                onPressed: _mostrarContaUsuario,
                icon: Icon(FontAwesomeIcons.user),
              ),
              SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                icon: Icon(FontAwesomeIcons.cartShopping),
              ),
              SizedBox(width: 10),
              IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.bell)),
              SizedBox(width: 10),
            ],
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: produtos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final produto = produtos[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Image.network(
                        produto['imagem'],
                        fit: BoxFit.contain,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      produto['nome'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'R\$ ${produto['preco'].toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                    ),
                    child: Text('Comprar'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
