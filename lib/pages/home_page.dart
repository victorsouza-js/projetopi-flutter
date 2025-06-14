import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:projeto_pi_flutter/pages/profile_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:projeto_pi_flutter/data/repositories/user_repository.dart';
import 'package:projeto_pi_flutter/pages/login/store/user_store.dart';
import 'package:projeto_pi_flutter/data/http/http_client.dart';

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
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  bool _isPasswordVisible = false;
  bool _lembrarDeMim = false;

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lembrarDeMim = prefs.getBool('lembrar_de_mim') ?? false;
      if (_lembrarDeMim) {
        _usernameController.text = prefs.getString('username') ?? '';
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _salvarDadosLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lembrar_de_mim', _lembrarDeMim);
    if (_lembrarDeMim) {
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
    }
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
    _carregarDados();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dioClient = Provider.of<DioClient>(context);
    final userRepository = UserRepository(client: dioClient);

    UserStore store = UserStore(repository: UserRepository(client: dioClient));

    final width = MediaQuery.of(context).size.width;

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
              SizedBox(height: 20),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _lembrarDeMim,
                      onChanged: (value) {
                        setState(() {
                          _lembrarDeMim = value ?? false;
                        });
                      },
                      activeColor: Colors.orange,
                    ),
                    Text(
                      'Lembre-se de mim',
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                  ],
                ),
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

              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    UserModel user = await userRepository.login(
                      data: {
                        'email': _emailController.text,
                        'password': _passwordController.text,
                      },
                    );
                    if (user.name != '') {
                      await _salvarDadosLogin();
                      Navigator.pushNamed(context, '/home2');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('E-mail e Senha Incorretos!')),
                      );
                    }
                  }

                  /* if (_formKey.currentState!.validate()) {
                    if (await validarLogin()) {
                      await _salvarDadosLogin();
                      Navigator.pushNamed(context, '/home2');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('E-mail e Senha Incorretos!')),
                      );
                    }
                  } */
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
