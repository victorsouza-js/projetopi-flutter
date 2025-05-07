import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> salvarValor(String chave, String valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(chave, valor);
  }

  Future<String?> recuperarValor(String chave) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(chave);
  }

  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final email = await recuperarValor('email');
    final username = await recuperarValor('username');
    final password = await recuperarValor('password');

    setState(() {
      _emailController.text = email ?? '';
      _usernameController.text = username ?? '';
      _passwordController.text = password ?? '';
    });
  }

  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              child: Icon(Icons.person, size: 100, color: Colors.white),
            ),
            ListTile(
              leading:  Icon(Icons.info),
              title:  Text('Sobre'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:  Icon(Icons.contact_page),
              title:  Text('Contatos'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading:  Icon(Icons.settings),
              title:  Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:  Icon(Icons.logout),
              title:  Text('Sair'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme:  IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title:  Text('FitXpert', style: TextStyle(color: Colors.white)),
        actions: [],
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 200),
            Image.network('https://sdmntprwestus2.oaiusercontent.com/files/00000000-a4e8-61f8-8c66-f118ccf99a48/raw?se=2025-05-07T03%3A05%3A14Z&sp=r&sv=2024-08-04&sr=b&scid=e55fd925-0ae8-55fe-a910-40066c9f2243&skoid=e4438ed3-2a6f-4fd3-bf63-222012dc627c&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-05-06T03%3A17%3A47Z&ske=2025-05-07T03%3A17%3A47Z&sks=b&skv=2024-08-04&sig=gvLvuJ4YHtW39iAjjGFvYMh0BDGLmr%2BJEyOnE3d85k8%3D',
                height: 200,
                width: 200,
              ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue[900]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue[900]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,

                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue[900]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: () async {
                if (_emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'O campo de e-mail deve ser preenchido corretamente.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (!emailRegex.hasMatch(_emailController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, insira um e-mail válido.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (_usernameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('O campo de usuário não pode estar vazio.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return; // Interrompe a execução se o campo estiver vazio
                }

                if (_passwordController.text.length >= 8) {
                  Navigator.pushNamed(context, '/home2');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'A senha deve ter pelo menos 8 caracteres.',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                await salvarValor('email', _emailController.text);
                await salvarValor('username', _usernameController.text);
                await salvarValor('password', _passwordController.text);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Todos os dados foram preenchidos corretamente!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Entrar', style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}
