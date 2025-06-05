import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_pi_flutter/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:projeto_pi_flutter/pages/pagamento_page.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  List<Map<String, dynamic>> pedidos = [];
  Map<String, String> enderecoEntrega = {};

  void _mostrarPedidos() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: Row(
              children: [
                Icon(Icons.receipt_long, color: Colors.orange, size: 28),
                SizedBox(width: 10),
                Text(
                  'Meus Pedidos',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            content:
                pedidos.isEmpty
                    ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox, size: 60, color: Colors.grey[400]),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum pedido realizado ainda.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                    : SizedBox(
                      width: 340,
                      height: 350,
                      child: ListView.builder(
                        itemCount: pedidos.length,
                        itemBuilder: (context, index) {
                          final pedido = pedidos[index];
                          final data = DateTime.parse(pedido['data']);
                          final double totalPedido = pedido['produtos'].fold(
                            0.0,
                            (soma, item) =>
                                soma +
                                (item['preco'] * (item['quantidade'] ?? 1)),
                          );
                          return Card(
                            color: Colors.orange.shade50,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.orange[200],
                                        child: Icon(
                                          Icons.shopping_bag,
                                          color: Colors.orange[800],
                                        ),
                                        radius: 18,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Pedido #${index + 1}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.orange[800],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Divider(),
                                  ...List.generate(
                                    pedido['produtos'].length,
                                    (i) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.orange,
                                            size: 18,
                                          ),
                                          SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              '${pedido['produtos'][i]['nome']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Qtd: ${pedido['produtos'][i]['quantidade'] ?? 1}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Total: R\$ ${totalPedido.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[800],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            actions: [
              if (pedidos.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      pedidos.clear();
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Todos os pedidos foram removidos!'),
                      ),
                    );
                  },
                  child: Text(
                    'Limpar Pedidos',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                icon: Icon(Icons.payment),
                label: Text(
                  'Finalizar Compra',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);

                  // Junta todos os produtos de todos os pedidos
                  final List<Map<String, dynamic>> todosProdutos = [];
                  double totalGeral = 0.0;
                  for (var pedido in pedidos) {
                    for (var produto in pedido['produtos']) {
                      todosProdutos.add(produto);
                      totalGeral +=
                          produto['preco'] * (produto['quantidade'] ?? 1);
                    }
                  }

                  final pedidoCompleto = {
                    'produtos': todosProdutos,
                    'data': DateTime.now().toString(),
                    'total': totalGeral,
                  };

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PagamentoPage(pedido: pedidoCompleto),
                    ),
                  );
                },
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fechar'),
              ),
            ],
          ),
    );
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

  Future<void> _carregarPedidos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('pedidos');
    if (jsonStr != null) {
      setState(() {
        pedidos = List<Map<String, dynamic>>.from(jsonDecode(jsonStr));
      });
    }
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
    _carregarPedidos();
  }

  void _mostrarCarrinho() {
    double total = carrinho.fold(
      0.0,
      (soma, item) => soma + (item['preco'] * (item['quantidade'] ?? 1)),
    );

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.orange, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Meu Carrinho',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey[700]),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Divider(),
                  if (carrinho.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        'Seu carrinho está vazio.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: carrinho.length,
                        separatorBuilder: (_, __) => Divider(),
                        itemBuilder: (context, index) {
                          final item = carrinho[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['imagem'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['nome'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'R\$ ${item['preco'].toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.orange[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Qtd: ${item['quantidade'] ?? 1}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  setState(() {
                                    carrinho.removeAt(index);
                                  });
                                  await _salvarCarrinho();
                                  Navigator.pop(context);
                                  _mostrarCarrinho();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  if (carrinho.isNotEmpty) ...[
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[800],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(Icons.shopping_bag),
                        label: Text(
                          'Concluir Pedido',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          if (carrinho.isNotEmpty) {
                            setState(() {
                              pedidos.add({
                                'produtos': List<Map<String, dynamic>>.from(
                                  carrinho,
                                ),
                                'data': DateTime.now().toString(),
                              });
                              carrinho.clear();
                            });
                            _salvarCarrinho();
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pedido realizado com sucesso!'),
                            ),
                          );
                          setState(() {
                            carrinho.clear();
                          });
                          _salvarCarrinho();
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Text(
                  'Minha Conta',
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
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.orange.shade100,
                  child: Icon(
                    FontAwesomeIcons.user,
                    color: Colors.orange,
                    size: 50,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  username,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  email,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
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
  }

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
              IconButton(
                onPressed: _mostrarPedidos,
                icon: Icon(Icons.receipt_long),
              ),
              SizedBox(width: 10),
              IconButton(
                onPressed: _mostrarDialogEndereco,
                icon: Icon(FontAwesomeIcons.locationDot),
              ),
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
                              Icon(Icons.info, color: Colors.orange),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  produto['nome'],
                                  style: TextStyle(
                                    color: Colors.orange[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  produto['imagem'],
                                  height: 120,
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context, error, stackTrace) => Icon(
                                        Icons.image,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
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
                                    size: 20,
                                  );
                                }),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Preço: R\$ ${produto['preco'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800],
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Formas de pagamento:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.credit_card,
                                        color: Colors.blue,
                                        size: 28,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Crédito',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 18),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.pix,
                                        color: Colors.green,
                                        size: 28,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Pix',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 18),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.receipt_long,
                                        color: Colors.orange,
                                        size: 28,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Boleto',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 18),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.attach_money,
                                        color: Colors.teal,
                                        size: 28,
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Dinheiro',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Fechar'),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(Icons.add_shopping_cart),
                              label: Text('Adicionar ao Carrinho'),
                              onPressed: () {
                                setState(() {
                                  final idx = carrinho.indexWhere(
                                    (item) => item['nome'] == produto['nome'],
                                  );
                                  if (idx != -1) {
                                    carrinho[idx]['quantidade'] =
                                        (carrinho[idx]['quantidade'] ?? 1) + 1;
                                  } else {
                                    final novoProduto =
                                        Map<String, dynamic>.from(produto);
                                    novoProduto['quantidade'] = 1;
                                    carrinho.add(novoProduto);
                                  }
                                });
                                _salvarCarrinho();
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${produto['nome']} adicionado ao carrinho!',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                  );
                  // Aqui você pode abrir detalhes do produto futuramente
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
                            height: 140,
                            width: double.infinity,
                            errorBuilder:
                                (context, error, stackTrace) => Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[800],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'R\$ ${produto['preco'].toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
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
                    Spacer(),
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
