import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 200),

            Lottie.network(
              'https://lottie.host/a2c7d00c-f27c-4698-9695-704163359045/QBmZOlh0mL.json',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 30),

            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Usuario',
                  hintStyle: TextStyle(fontWeight: FontWeight.w700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue[900]!,
                      width: 2.0,
                    ),
                  ),
                
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Senha',
                  hintStyle: TextStyle(fontWeight: FontWeight.w700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue[900]!,
                      width: 2.0,
                    ),
                  ),
                  
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  hintStyle: TextStyle(fontWeight: FontWeight.w700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue[900]!,
                      width: 2.0,
                    ),
                  ),
                
                ),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  color: Colors.blue[900]!,
                  width: 2.0,
                ),
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                
                
                padding: EdgeInsets.all(18.0),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },

              child: const Text('Finalizar Cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}
