import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_pi_flutter/pages/historico_pagamento.dart';
import 'package:projeto_pi_flutter/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:projeto_pi_flutter/pages/pagamento_page.dart';
import 'package:projeto_pi_flutter/pages/carrinho_page.dart';
import 'package:badges/badges.dart' as badges;
import 'package:projeto_pi_flutter/pages/produto_detalhe_page.dart';
import 'package:projeto_pi_flutter/pages/pedidos.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

  Future<void> _salvarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoritos', favoritos);
  }

  Future<void> _carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoritos = prefs.getStringList('favoritos') ?? [];
    });
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
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header com gradiente
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Endereço de Entrega',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Preencha os dados para entrega',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Formulário
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: cpfController,
                            label: 'CPF',
                            icon: Icons.person_outline_rounded,
                            keyboardType: TextInputType.number,
                            hint: '000.000.000-00',
                          ),
                          SizedBox(height: 16),

                          _buildTextField(
                            controller: ruaController,
                            label: 'Rua',
                            icon: Icons.streetview_rounded,
                            hint: 'Nome da rua',
                          ),
                          SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildTextField(
                                  controller: numeroController,
                                  label: 'Número',
                                  icon: Icons.home_outlined,
                                  keyboardType: TextInputType.number,
                                  hint: '123',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                flex: 3,
                                child: _buildTextField(
                                  controller: bairroController,
                                  label: 'Bairro',
                                  icon: Icons.location_city_outlined,
                                  hint: 'Nome do bairro',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          _buildTextField(
                            controller: cidadeController,
                            label: 'Cidade',
                            icon: Icons.map_outlined,
                            hint: 'Nome da cidade',
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Botões de ação
                  Container(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shadowColor: Colors.orange.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            icon: Icon(Icons.save_rounded, size: 20),
                            label: Text(
                              'Salvar Endereço',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () async {
                              // Validação básica
                              if (_validarCampos(
                                cpfController,
                                ruaController,
                                numeroController,
                                bairroController,
                                cidadeController,
                              )) {
                                await _salvarEndereco({
                                  'cpf': cpfController.text.trim(),
                                  'rua': ruaController.text.trim(),
                                  'numero': numeroController.text.trim(),
                                  'bairro': bairroController.text.trim(),
                                  'cidade': cidadeController.text.trim(),
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.orange.shade600, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        ),
      ),
    );
  }

  bool _validarCampos(
    TextEditingController cpf,
    TextEditingController rua,
    TextEditingController numero,
    TextEditingController bairro,
    TextEditingController cidade,
  ) {
    if (cpf.text.trim().isEmpty ||
        rua.text.trim().isEmpty ||
        numero.text.trim().isEmpty ||
        bairro.text.trim().isEmpty ||
        cidade.text.trim().isEmpty) {
      // Mostrar snackbar de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text('Por favor, preencha todos os campos'),
            ],
          ),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _carregarCarrinho();
    _carregarEndereco();
    _carregarFavoritos(); // Carrega favoritos ao iniciar
  }

  List<Map<String, dynamic>> carrinho = [];

  final TextEditingController _searchController = TextEditingController();

  String searchText = '';

  // Variáveis de filtro:
  String _ordenacaoSelecionada = 'Relevância';
  double _precoMin = 0;
  double _precoMax = 200;
  double _avaliacaoMin = 0;

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
    {
      'nome': '',
      'preco': 130.00,
      'imagem':
          'https://http2.mlstatic.com/D_NQ_NP_686396-MLA85101318922_052025-O.webp',
      'avaliacao': 4.8,
    },
    {
      'nome':
          'Creatina Monohidratada 1Kg 100% Pura Soldiers Nutrition Sem Sabor',
      'preco': 130.00,
      'imagem':
          'https://http2.mlstatic.com/D_NQ_NP_686396-MLA85101318922_052025-O.webp',
      'avaliacao': 4.8,
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

  bool mostrarFavoritos = false;

  // Função para abrir o filtro estilizado:
  void _abrirFiltros() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.orange[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Filtrar Produtos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.orange[800],
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(Icons.sort, color: Colors.orange),
                      SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _ordenacaoSelecionada,
                          decoration: InputDecoration(
                            labelText: 'Ordenar por',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items:
                              [
                                    'Relevância',
                                    'Menor preço',
                                    'Maior preço',
                                    'Melhor avaliação',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setModalState(() => _ordenacaoSelecionada = value!);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.attach_money, color: Colors.orange),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Faixa de preço',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            RangeSlider(
                              values: RangeValues(_precoMin, _precoMax),
                              min: 0,
                              max: 200,
                              divisions: 20,
                              labels: RangeLabels(
                                'R\$ ${_precoMin.toStringAsFixed(0)}',
                                'R\$ ${_precoMax.toStringAsFixed(0)}',
                              ),
                              activeColor: Colors.orange,
                              onChanged: (values) {
                                setModalState(() {
                                  _precoMin = values.start;
                                  _precoMax = values.end;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('R\$ ${_precoMin.toStringAsFixed(0)}'),
                                Text('R\$ ${_precoMax.toStringAsFixed(0)}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Avaliação mínima',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            RatingBar.builder(
                              initialRating: _avaliacaoMin,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 32,
                              unratedColor: Colors.grey[300],
                              itemPadding: EdgeInsets.symmetric(
                                horizontal: 2.0,
                              ),
                              itemBuilder:
                                  (context, _) =>
                                      Icon(Icons.star, color: Colors.amber),
                              onRatingUpdate: (rating) {
                                setModalState(() => _avaliacaoMin = rating);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              _ordenacaoSelecionada = 'Relevância';
                              _precoMin = 0;
                              _precoMax = 200;
                              _avaliacaoMin = 0;
                            });
                          },
                          child: Text('Limpar'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {}); // Atualiza a tela principal
                            Navigator.pop(context);
                          },
                          child: Text('Aplicar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtro dos produtos
    List<Map<String, dynamic>> produtosFiltrados =
        produtos.where((produto) {
          final nome = produto['nome'].toString().toLowerCase();
          final preco = produto['preco'] as double;
          final avaliacao = produto['avaliacao'] as double;
          if (!nome.contains(searchText.toLowerCase())) return false;
          if (preco < _precoMin || preco > _precoMax) return false;
          if (avaliacao < _avaliacaoMin) return false;
          if (mostrarFavoritos! && !favoritos.contains(produto['nome']))
            return false;
          return true;
        }).toList();

    // Ordenação
    if (_ordenacaoSelecionada == 'Menor preço') {
      produtosFiltrados.sort(
        (a, b) => (a['preco'] as double).compareTo(b['preco'] as double),
      );
    } else if (_ordenacaoSelecionada == 'Maior preço') {
      produtosFiltrados.sort(
        (a, b) => (b['preco'] as double).compareTo(a['preco'] as double),
      );
    } else if (_ordenacaoSelecionada == 'Melhor avaliação') {
      produtosFiltrados.sort(
        (a, b) =>
            (b['avaliacao'] as double).compareTo(a['avaliacao'] as double),
      );
    }

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          children: [
            // Header do Drawer
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 50,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.orange[800]!, Colors.orange[600]!],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.fitness_center,
                        size: 35,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'FitXpert',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sua jornada fitness',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10),
                children: [
                  // Home
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.home, color: Colors.orange, size: 20),
                      ),
                      title: Text(
                        'Home',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white30,
                        size: 14,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/home');
                      },
                    ),
                  ),

                  // Configurações
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.settings,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        'Configurações',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white30,
                        size: 14,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      },
                    ),
                  ),

                  // Divisor
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    height: 1,
                    color: Colors.white.withOpacity(0.1),
                  ),

                  // Suporte
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.contact_support,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        'Suporte',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      subtitle: Text(
                        'Precisa de ajuda?',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white30,
                        size: 14,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.contact_support,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Suporte',
                                      style: TextStyle(
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        FontAwesomeIcons.whatsapp,
                                        color: Colors.green,
                                      ),
                                      title: Text('WhatsApp'),
                                      subtitle: Text('(81) 9995-1743'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Abrindo WhatsApp...',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.email,
                                        color: Colors.blue,
                                      ),
                                      title: Text('Email'),
                                      subtitle: Text('suporte@fitxpert.com'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('Abrindo email...'),
                                          ),
                                        );
                                      },
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
                  ),

                  // Feedback
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.feedback,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        'Feedback',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      subtitle: Text(
                        'Compartilhe sua opinião',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white30,
                        size: 14,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        TextEditingController feedbackController =
                            TextEditingController();
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Row(
                                  children: [
                                    Icon(Icons.feedback, color: Colors.orange),
                                    SizedBox(width: 10),
                                    Text(
                                      'Seu Feedback',
                                      style: TextStyle(
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Conte-nos sua experiência:'),
                                    SizedBox(height: 15),
                                    TextField(
                                      controller: feedbackController,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        hintText: 'Digite seu feedback...',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Obrigado pelo seu feedback!',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    ),
                                    child: Text(
                                      'Enviar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ),

                  // Ajuda
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.help, color: Colors.orange, size: 20),
                      ),
                      title: Text(
                        'Ajuda',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      subtitle: Text(
                        'FAQ e tutoriais',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white30,
                        size: 14,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Row(
                                  children: [
                                    Icon(Icons.help, color: Colors.orange),
                                    SizedBox(width: 10),
                                    Text(
                                      'Central de Ajuda',
                                      style: TextStyle(
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                  ],
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Como fazer um pedido?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '1. Navegue pelos produtos\n2. Adicione ao carrinho\n3. Vá para o checkout\n4. Confirme o pedido',
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Formas de pagamento',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '• Cartão de crédito\n• Cartão de débito\n• PIX\n• Boleto bancário',
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Prazos de entrega',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Região Metropolitana: 1-2 dias úteis\nInterior: 3-5 dias úteis',
                                      ),
                                    ],
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
                      },
                    ),
                  ),

                  // Divisor
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    height: 1,
                    color: Colors.white.withOpacity(0.1),
                  ),

                  // Privacidade
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.privacy_tip,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        'Privacidade',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      subtitle: Text(
                        'Política de privacidade',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white30,
                        size: 14,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.privacy_tip,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Privacidade',
                                      style: TextStyle(
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                  ],
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Política de Privacidade',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Seus dados pessoais são protegidos e utilizados apenas para:',
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '• Processamento de pedidos\n• Comunicação sobre entregas\n• Melhorias no atendimento\n• Ofertas personalizadas (opcional)',
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Nunca compartilhamos seus dados com terceiros sem autorização.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Entendi'),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ),

                  // Notificações
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        'Notificações',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      subtitle: Text(
                        'Gerenciar alertas',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white30,
                        size: 14,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Configurações de notificação em desenvolvimento...',
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Divisor
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    height: 1,
                    color: Colors.white.withOpacity(0.1),
                  ),

                  // Avaliar App
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.star, color: Colors.orange, size: 20),
                      ),
                      title: Text(
                        'Avaliar App',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      subtitle: Text(
                        'Deixe sua avaliação',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white30,
                        size: 14,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.orange),
                                    SizedBox(width: 10),
                                    Text(
                                      'Avaliar App',
                                      style: TextStyle(
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Gostou do FitXpert?',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Sua avaliação nos ajuda a melhorar!',
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Mais tarde'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Redirecionando para Play Store...',
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    ),
                                    child: Text(
                                      'Avaliar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ),

                  // Sobre
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.info, color: Colors.orange, size: 20),
                      ),
                      title: Text(
                        'Sobre',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      subtitle: Text(
                        'Conheça o FitXpert',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white30,
                        size: 14,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Colors.orange,
                                      size: 28,
                                    ),
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
                                        Icon(
                                          Icons.verified,
                                          color: Colors.orange,
                                        ),
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
                  ),

                  SizedBox(height: 10),

                  // Divisor
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    height: 1,
                    color: Colors.white.withOpacity(0.1),
                  ),

                  // Endereço
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.orange,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Endereço de Entrega',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          enderecoEntrega.isEmpty
                              ? 'Toque para cadastrar seu endereço'
                              : '${enderecoEntrega['rua'] ?? ''}, Nº ${enderecoEntrega['numero'] ?? ''}\n${enderecoEntrega['bairro'] ?? ''} - ${enderecoEntrega['cidade'] ?? ''}',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: _mostrarDialogEndereco,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              enderecoEntrega.isEmpty ? 'Cadastrar' : 'Editar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Botão Sair
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton(
                      onPressed: () async {
                        await _salvarCarrinho();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Sair',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
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
                icon: Icon(Icons.history, color: Color(0xFFFF6B35)),
                tooltip: 'Histórico de Pagamentos',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoricoPagamentosPage(),
                    ),
                  );
                },
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.filter_list),
                tooltip: 'Filtros',
                onPressed: _abrirFiltros,
              ),
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
              IconButton(
                icon: Icon(
                  (mostrarFavoritos ?? false)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                tooltip: 'Mostrar Favoritos',
                onPressed: () {
                  setState(() {
                    mostrarFavoritos = !mostrarFavoritos;
                  });
                },
              ),
              SizedBox(width: 10),
              
            ],
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        itemCount: produtosFiltrados.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 20,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          final produto = produtosFiltrados[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.orange.withOpacity(0.04),
                  blurRadius: 40,
                  offset: Offset(0, 16),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                splashColor: Colors.orange.withOpacity(0.1),
                highlightColor: Colors.orange.withOpacity(0.05),
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
                    // Container da imagem com gradiente sutil
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.grey[50]!, Colors.white],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Imagem do produto
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Image.network(
                                  produto['imagem'],
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.image_outlined,
                                          size: 60,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                          // Botão de favorito estilizado
                          Positioned(
                            top: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  final nome = produto['nome'];
                                  if (favoritos.contains(nome)) {
                                    favoritos.remove(nome);
                                  } else {
                                    favoritos.add(nome);
                                  }
                                  _salvarFavoritos();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  favoritos.contains(produto['nome'])
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      favoritos.contains(produto['nome'])
                                          ? Colors.red[400]
                                          : Colors.grey[500],
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          // Badge de desconto (opcional)
                          if (produto.containsKey('desconto') &&
                              produto['desconto'] > 0)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red[500],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '-${produto['desconto']}%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Conteúdo do produto
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nome do produto
                            Text(
                              produto['nome'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.grey[800],
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            SizedBox(height: 8),

                            // Avaliação com estrelas
                            Row(
                              children: [
                                ...List.generate(5, (star) {
                                  double nota = produto['avaliacao'] ?? 4.6;
                                  return Icon(
                                    star < nota.floor()
                                        ? Icons.star_rounded
                                        : (star < nota
                                            ? Icons.star_half_rounded
                                            : Icons.star_border_rounded),
                                    color: Colors.amber[600],
                                    size: 16,
                                  );
                                }),
                                SizedBox(width: 4),
                                Text(
                                  '(${(produto['avaliacao'] ?? 4.6).toStringAsFixed(1)})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),

                            Spacer(),

                            // Preço
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'R\$ ${produto['preco'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ),

                            SizedBox(height: 12),

                            // Botão de adicionar ao carrinho
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange[600],
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    final idx = carrinho.indexWhere(
                                      (item) => item['nome'] == produto['nome'],
                                    );
                                    if (idx != -1) {
                                      carrinho[idx]['quantidade'] =
                                          (carrinho[idx]['quantidade'] ?? 1) +
                                          1;
                                    } else {
                                      final novoProduto =
                                          Map<String, dynamic>.from(produto);
                                      novoProduto['quantidade'] = 1;
                                      carrinho.add(novoProduto);
                                    }
                                  });
                                  _salvarCarrinho();

                                  // Feedback visual melhorado
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              '${produto['nome']} adicionado!',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Colors.green[600],
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin: EdgeInsets.all(16),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_shopping_cart_rounded,
                                      size: 18,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Adicionar',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
