import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_pi_flutter/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  bool isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  Future<void> _salvarCarrinho() async {
    final prefs = await SharedPreferences.getInstance();
    final carrinhoJson = jsonEncode(carrinho);
    await prefs.setString('carrinho', carrinhoJson);
  }

  Future<void> _carregarCarrinho() async {
    final prefs = await SharedPreferences.getInstance();
    final carrinhoJson = prefs.getString('carrinho');
    if (carrinhoJson != null) {
      setState(() {
        carrinho = List<Map<String, dynamic>>.from(jsonDecode(carrinhoJson));
      });
    }
  }

  void initState() {
    super.initState();
    _carregarCarrinho();
  }

  void _mostrarCarrinho() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Carrinho'),
            content:
                carrinho.isEmpty
                    ? Text('Seu carrinho está vazio.')
                    : SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: carrinho.length,
                        itemBuilder: (context, index) {
                          final item = carrinho[index];
                          return ListTile(
                            leading: Image.network(
                              item['imagem'],
                              width: 70,
                              height: 70,
                            ),
                            title: Text(item['nome']),
                            subtitle: Text(
                              'R\$ ${item['preco'].toStringAsFixed(2)}\nQtd: ${item['quantidade'] ?? 1}',
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                setState(() {
                                  carrinho.removeAt(index);
                                });
                                await _salvarCarrinho();
                                Navigator.pop(context);
                                _mostrarCarrinho(); // Atualiza o dialog
                              },
                            ),
                          );
                        },
                      ),
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

  List<Map<String, dynamic>> carrinho = [];

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

  String searchText = '';

  final List<Map<String, dynamic>> produtos = [
    {
      'nome': 'Creatina Max 300g',
      'preco': 79.90,
      'imagem':
          'https://m.media-amazon.com/images/I/51gt4U5kD-L._AC_UL320_.jpg',
    },
    {
      'nome': 'Creatina Monohidratada Dark Lab 300g',
      'preco': 54.90,
      'imagem':
          'https://m.media-amazon.com/images/I/81IObjtLiML._AC_UL320_.jpg',
    },
    {
      'nome': 'Creatina Monohidratada Growth Supplements 300g',
      'preco': 68.90,
      'imagem':
          'https://m.media-amazon.com/images/I/61hrHdSCq7L._AC_UL320_.jpg',
    },
    {
      'nome': 'Creatina Monohidratada Integralmedica 300g',
      'preco': 70.00,
      'imagem':
          'https://m.media-amazon.com/images/I/81UashXoAxL._AC_UL320_.jpg',
    },
    {
      'nome': 'Creatina Monohidratada Probiótica 300g',
      'preco': 56.90,
      'imagem':
          'https://m.media-amazon.com/images/I/514imF5uGPL._AC_UL320_.jpg',
    },
    {
      'nome': 'Creatina Monohudratada Dux 300g',
      'preco': 67.99,
      'imagem':
          'https://m.media-amazon.com/images/I/61fB7PV3A7L._AC_UL320_.jpg',
    },

    {
      'nome': 'Whey Max Titanium x Dr. Peanut 900g s:Doce de Leite',
      'preco': 120.99,
      'imagem':
          'https://m.media-amazon.com/images/I/61IpPwe99OL._AC_UL320_.jpg',
    },
    {
      'nome': 'Whey Max Titanium x Dr. Peanut 900g s:Bueníssimo',
      'preco': 120.99,
      'imagem':
          'https://m.media-amazon.com/images/I/611DbOCRmFL._AC_UL320_.jpg',
    },
    {
      'nome': 'Whey Max Titanium x Dr. Peanut 900g s:Avelã',
      'preco': 120.99,
      'imagem':
          'https://m.media-amazon.com/images/I/61zXQDYWmcL._AC_UL320_.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool dark = isDarkMode;
    final Color background = dark ? Colors.black : Colors.white;
    final Color cardColor = dark ? Colors.grey[900]! : Colors.white;
    final Color textColor = dark ? Colors.white : Colors.black;
    final Color drawerColor = dark ? Colors.grey[900]! : Colors.black;
    final Color appBarColor = dark ? Colors.grey[850]! : Colors.orange;

    final List<Map<String, dynamic>> produtosFiltrados =
        produtos.where((produto) {
          final nome = produto['nome'].toString().toLowerCase();
          return nome.contains(searchText.toLowerCase());
        }).toList();

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
              onTap: () async {
                await _salvarCarrinho();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(
                dark ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
              title: Text(
                dark ? 'Tema Claro' : 'Tema Escuro',
                style: TextStyle(color: Colors.white),
              ),
              onTap: _toggleTheme,
            ),
            SizedBox(height: 20),
            Divider(color: Colors.white),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.contact_support, color: Colors.white),
              title: Text('Suporte', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/support');
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback, color: Colors.white),
              title: Text('Feedback', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/feedback');
              },
            ),
            SizedBox(height: 20),
            Divider(color: Colors.white),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.help, color: Colors.white),
              title: Text('Ajuda', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/help');
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip, color: Colors.white),
              title: Text('Privacidade', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/privacy');
              },
            ),
            SizedBox(height: 20),
            Divider(color: Colors.white),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.language, color: Colors.white),
              title: Text('Idioma', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/language');
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.white),
              title: Text(
                'Notificações',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            SizedBox(height: 20),
            Divider(color: Colors.white),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.star, color: Colors.white),
              title: Text('Avaliar App', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/rate');
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
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
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
              Stack(
                children: [
                  IconButton(
                    onPressed: _mostrarCarrinho,
                    icon: Icon(FontAwesomeIcons.cartShopping),
                  ),
                  if (carrinho.isNotEmpty)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${carrinho.length}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
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
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: produtosFiltrados.length,

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          final produto = produtosFiltrados[index];
          return Card(
            margin: EdgeInsets.all(8),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Image.network(
                      produto['imagem'],
                      fit: BoxFit.contain,
                      height: 120,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Icon(Icons.image, size: 80, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    produto['nome'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'R\$ ${produto['preco'].toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: Icon(Icons.add_shopping_cart),
                    label: Text('Comprar'),
                    onPressed: () {
                      setState(() {
                        final index = carrinho.indexWhere(
                          (item) => item['nome'] == produto['nome'],
                        );
                        if (index != -1) {
                          carrinho[index]['quantidade'] =
                              (carrinho[index]['quantidade'] ?? 1) + 1;
                        } else {
                          final novoProduto = Map<String, dynamic>.from(
                            produto,
                          );
                          novoProduto['quantidade'] = 1;
                          carrinho.add(novoProduto);
                        }
                      });
                      _salvarCarrinho();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${produto['nome']} adicionado ao carrinho!',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
