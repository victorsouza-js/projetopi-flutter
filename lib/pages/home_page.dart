import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:projeto_pi_flutter/pages/profile_page.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _lottieController;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  bool _isPasswordVisible = false;

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
    });
  }


  Future<bool> validarLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');
    final email = prefs.getString('email');

    return _usernameController.text == username &&
        _passwordController.text == password &&
        _emailController.text == email;
  }

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..forward();
    carregarDados();
  }

  @override
/*************  ✨ Windsurf Command ⭐  *************/
  /// Clean up animation controller resources used by the page.

/*******  3d99e73b-ed86-4713-ae3f-6fbb7256d0e1  *******/
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 200),
              Lottie.network(
                'https://lottie.host/d24168f4-e0c0-458c-8a7b-50c524716de0/uRiXGAp7La.json',
                width: 150,
                height: 150,
                repeat: true,
                controller: _lottieController,
                onLoaded: (composition) {
                  _lottieController.duration = composition.duration;
                  _lottieController.forward();
                },
              ),
              SizedBox(height: 30),
              Text(
                'Bem-vindo ao FitXpert',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Insira seus dados para continuar',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _usernameController,

                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.user,
                      color: Colors.black,
                    ),
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O campo de usuário não pode estar vazio.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.envelope,
                      color: Colors.black,
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O campo de e-mail deve ser preenchido.';
                    }
                    if (!emailRegex.hasMatch(value)) {
                      return 'Por favor, insira um e-mail válido.';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      color: Colors.black,
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O campo de senha não pode estar vazio.';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Não tem uma conta?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastro');
                    },
                    child: Text(
                      'Cadastre-se',
                      style: TextStyle(color: Colors.orange.shade700),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Ou entre com',
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.twitter, color: Colors.blue),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.github, color: Colors.black),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.google, color: Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (await validarLogin()) {
                      Navigator.pushNamed(context, '/home2');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Usuário, e-mail ou senha incorretos!'),
                        ),
                      );
                    }
                  }
                },
                child: Text('Entrar', style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
