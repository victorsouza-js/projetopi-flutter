import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _finalizarCadastro() {
    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O campo de usuário não pode estar vazio.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text.isEmpty ||
        _passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A senha deve ter pelo menos 8 caracteres.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_emailController.text.isEmpty ||
        !RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        ).hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um e-mail válido.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cadastro realizado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.network(
            'https://wallpapers.com/images/hd/bodybuilder-doing-monkey-bar-hd-quhhvbjveujf57gf.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Conteúdo sobreposto
          Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Lottie.network(
                      'https://lottie.host/d24168f4-e0c0-458c-8a7b-50c524716de0/uRiXGAp7La.json',
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Usuário',
                          hintStyle: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.orange.shade700,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          hintStyle: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.orange.shade700,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'E-mail',
                          hintStyle: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.orange.shade700,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.all(18.0),
                      ),
                      onPressed: _finalizarCadastro,
                      child: Text('Finalizar Cadastro'),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      child: Text(
                        'Voltar',
                        style: TextStyle(color: Colors.orange.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
