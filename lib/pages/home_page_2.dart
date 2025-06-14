import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_pi_flutter/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:projeto_pi_flutter/pages/pagamento_page.dart';
import 'package:projeto_pi_flutter/pages/carrinho_page.dart';
import 'package:badges/badges.dart' as badges;
import 'package:projeto_pi_flutter/pages/produto_detalhe_page.dart';
import 'package:projeto_pi_flutter/pages/pedidos.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  List<Map<String, dynamic>> pedidos = [];
  Map<String, String> enderecoEntrega = {};
  List<String> favoritos = [];

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

  Future<void> _carregarEndereco() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('endereco_entrega');
    setState(() {
      enderecoEntrega =
          jsonStr != null ? Map<String, String>.from(jsonDecode(jsonStr)) : {};
    });
  }

  Future<void> _salvarEndereco(Map<String, String> endereco) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('endereco_entrega', jsonEncode(endereco));
    setState(() {
      enderecoEntrega = endereco;
    });
  }

  void _mostrarDialogEndereco() async {
    final TextEditingController cpfController = TextEditingController(
      text: enderecoEntrega['cpf'] ?? '',
    );
    final TextEditingController ruaController = TextEditingController(
      text: enderecoEntrega['rua'] ?? '',
    );
    final TextEditingController numeroController = TextEditingController(
      text: enderecoEntrega['numero'] ?? '',
    );
    final TextEditingController bairroController = TextEditingController(
      text: enderecoEntrega['bairro'] ?? '',
    );
    final TextEditingController cidadeController = TextEditingController(
      text: enderecoEntrega['cidade'] ?? '',
    );

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            titlePadding: EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
              bottom: 0,
            ),
            title: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.orange.shade100,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.orange,
                    size: 36,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Endereço de Entrega',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 8),
                  TextField(
                    controller: cpfController,
                    decoration: InputDecoration(
                      labelText: 'CPF',
                      prefixIcon: Icon(Icons.badge, color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      filled: true,
                      fillColor: Colors.orange.withOpacity(0.04),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 14),
                  TextField(
                    controller: ruaController,
                    decoration: InputDecoration(
                      labelText: 'Rua',
                      prefixIcon: Icon(Icons.streetview, color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      filled: true,
                      fillColor: Colors.orange.withOpacity(0.04),
                    ),
                  ),
                  SizedBox(height: 14),
                  TextField(
                    controller: numeroController,
                    decoration: InputDecoration(
                      labelText: 'Número',
                      prefixIcon: Icon(Icons.home, color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      filled: true,
                      fillColor: Colors.orange.withOpacity(0.04),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 14),
                  TextField(
                    controller: bairroController,
                    decoration: InputDecoration(
                      labelText: 'Bairro',
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      filled: true,
                      fillColor: Colors.orange.withOpacity(0.04),
                    ),
                  ),
                  SizedBox(height: 14),
                  TextField(
                    controller: cidadeController,
                    decoration: InputDecoration(
                      labelText: 'Cidade',
                      prefixIcon: Icon(Icons.map, color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      filled: true,
                      fillColor: Colors.orange.withOpacity(0.04),
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                icon: Icon(Icons.save),
                label: Text(
                  'Salvar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await _salvarEndereco({
                    'cpf': cpfController.text,
                    'rua': ruaController.text,
                    'numero': numeroController.text,
                    'bairro': bairroController.text,
                    'cidade': cidadeController.text,
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _carregarCarrinho();
    _carregarEndereco();
  }

  List<Map<String, dynamic>> carrinho = [];

  final TextEditingController _searchController = TextEditingController();

  String searchText = '';

  final List<Map<String, dynamic>> produtos = [
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
      'nome': 'Whey Max Titanium x Dr. Peanut 900g s:Doce de Leite',
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
      'nome': '3VS Nutrition Pré Treino Prohibido 180g Sabor Maça Verde',
      'preco': 60.00,
      'imagem': 'https://m.media-amazon.com/images/I/61UESDpLUJL.AC_UL320.jpg',
      'avaliacao': 4.3,
    },
    {
      'nome': 'FTW Pré-Treino Diabo Verde 300g',
      'preco': 68.05,
      'imagem': 'https://m.media-amazon.com/images/I/612LVlrz2jL.AC_UL320.jpg',
      'avaliacao': 4.2,
    },
    {
      'nome': '3VS Nutrition Pré-Treino Beast 300g Sabor Frutas Vermelhas',
      'preco': 57.81,
      'imagem': 'https://m.media-amazon.com/images/I/610o1NRDbML.AC_UL320.jpg',
      'avaliacao': 4.7,
    },
    {
      'nome': 'Pré-Treino Venom 300g Dark Lab',
      'preco': 99.00,
      'imagem': 'https://m.media-amazon.com/images/I/81pdnNjl82L.AC_UL320.jpg',
      'avaliacao': 5.0,
    },
    {
      'nome': 'Panic Pré Workout Morango 300g',
      'preco': 78.95,
      'imagem': 'https://m.media-amazon.com/images/I/71D+u3oWo0L.AC_UL320.jpg',
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
    {
      'nome': 'Insane Original - 300g Orange Demon - Demons Lab',
      'preco': 106.00,
      'imagem':
          'https://m.media-amazon.com/images/I/61RwjMrWnWL._AC_UL320_.jpg',
      'avaliacao': 4.7,
    },
    {
      'nome':
          'Pré Treino Insane Clown 350g Pre Workout - Demons Lab (Blue Crystal)',
      'preco': 105.95,
      'imagem':
          'https://m.media-amazon.com/images/I/61YW0lLDqLL._AC_UL320_.jpg',
      'avaliacao': 5.0,
    },
    {
      'nome': 'Suplemento em Pó Insane Clown 350g Demons Lab Tutti Frutii',
      'preco': 109.05,
      'imagem':
          'https://http2.mlstatic.com/D_Q_NP_2X_650678-MLA79685725483_102024-E.webp',
      'avaliacao': 4.7,
    },
    {
      'nome': 'Pré Treino Insane Clown Blue Vanilha 350g - Demons Lab',
      'preco': 114.05,
      'imagem':
          'https://http2.mlstatic.com/D_Q_NP_2X_941875-MLB78274642433_082024-E-pre-treino-insane-clown-blue-vanilha-350g-demons-lab.webp',
      'avaliacao': 4.5,
    },
    {
      'nome':
          'Creatina Monohidratada 1Kg 100% Pura Soldiers Nutrition Sem Sabor',
      'preco': 130.00,
      'imagem':
          'https://http2.mlstatic.com/D_NQ_NP_686396-MLA85101318922_052025-O.webp',
      'avaliacao': 4.8,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
              leading: Icon(Icons.add_box, color: Colors.orange),
              title: Text('Cadastrar Produto', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/admin/add-produto');
              },
            ),
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
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        title: Row(
                          children: [
                            Icon(Icons.info, color: Colors.orange, size: 28),
                            SizedBox(width: 8),
                            Text(
                              'Sobre o FitXpert',
                              style: TextStyle(
                                color: Colors.orange[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Row(
                              children: [
                                Icon(
                                  Icons.fitness_center,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'O FitXpert é um aplicativo criado para facilitar a compra de suplementos e produtos para quem busca saúde, bem-estar e performance.',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.flag, color: Colors.orange),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Nosso objetivo é oferecer praticidade, segurança e variedade para você atingir seus objetivos de forma eficiente!',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.verified, color: Colors.orange),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '• Produtos de qualidade\n• Entrega rápida\n• Atendimento personalizado',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.developer_mode,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Desenvolvido por alunos de Análise e Desenvolvimento de Sistemas.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.white),
              title: Text(
                enderecoEntrega.isEmpty
                    ? 'Endereço não cadastrado'
                    : '${enderecoEntrega['rua'] ?? ''}, Nº ${enderecoEntrega['numero'] ?? ''}\nBairro: ${enderecoEntrega['bairro'] ?? ''}\nCidade: ${enderecoEntrega['cidade'] ?? ''}\nCPF: ${enderecoEntrega['cpf'] ?? ''}',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              onTap: _mostrarDialogEndereco,
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
              SizedBox(width: 10),
              IconButton(
                tooltip: 'Carrinho',
                icon: badges.Badge(
                  showBadge: carrinho.isNotEmpty,
                  badgeContent: Text(
                    carrinho
                        .fold<int>(
                          0,
                          (soma, item) =>
                              soma + ((item['quantidade'] ?? 1) as int),
                        )
                        .toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: Colors.red,
                    padding: EdgeInsets.all(6),
                  ),
                  child: Icon(Icons.shopping_cart),
                ),
                onPressed: () async {
                  // Aguarda o retorno da tela do carrinho
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarrinhoPage(carrinho: carrinho),
                    ),
                  );
                  setState(() {}); // Atualiza o badge ao voltar
                },
              ),

              SizedBox(width: 10),
              IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.bell)),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.receipt_long), // Ícone de pedidos
                tooltip: 'Pedidos Finalizados',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              PedidosFinalizadosPage(), // Crie essa página!
                    ),
                  );
                },
              ),

              SizedBox(width: 10),
              IconButton(
                tooltip: 'Endereço de Entrega',
                onPressed: _mostrarDialogEndereco,
                icon: Icon(FontAwesomeIcons.locationDot),
              ),
              SizedBox(width: 10),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) async {
                  if (value == 'logout') {
                    // Aqui você pode salvar o carrinho, limpar dados, etc.
                    await _salvarCarrinho();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Sair'),
                          ],
                        ),
                      ),
                    ],
              ),
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
          childAspectRatio: 0.68,
        ),
        itemBuilder: (context, index) {
          final produto = produtosFiltrados[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.08),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () async {
                  final produtoSelecionado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProdutoDetalhePage(produto: produto),
                    ),
                  );
                  if (produtoSelecionado != null) {
                    setState(() {
                      final idx = carrinho.indexWhere(
                        (item) => item['nome'] == produtoSelecionado['nome'],
                      );
                      if (idx != -1) {
                        carrinho[idx]['quantidade'] =
                            (carrinho[idx]['quantidade'] ?? 1) + 1;
                      } else {
                        final novoProduto = Map<String, dynamic>.from(
                          produtoSelecionado,
                        );
                        novoProduto['quantidade'] = 1;
                        carrinho.add(novoProduto);
                      }
                    });
                    _salvarCarrinho();
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(18),
                          ),
                          child: Image.network(
                            produto['imagem'],
                            fit: BoxFit.contain,
                            height: 180,
                            width: double.infinity,
                            errorBuilder:
                                (context, error, stackTrace) => Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Text(
                        produto['nome'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey[900],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'R\$ ${produto['preco'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.orange[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer(),
                    SizedBox(height: 6),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (star) {
                          double nota = produto['avaliacao'] ?? 4.6;
                          return Icon(
                            star < nota.floor()
                                ? Icons.star
                                : (star < nota
                                    ? Icons.star_half
                                    : Icons.star_border),
                            color: Colors.amber,
                            size: 18,
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 6),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[800],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            final idx = carrinho.indexWhere(
                              (item) => item['nome'] == produto['nome'],
                            );
                            if (idx != -1) {
                              carrinho[idx]['quantidade'] =
                                  (carrinho[idx]['quantidade'] ?? 1) + 1;
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_shopping_cart, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Adicionar ao Carrinho',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
