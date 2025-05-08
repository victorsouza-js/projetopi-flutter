import 'package:flutter/material.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.signal_cellular_alt)),  // Ícone de sinal
              SizedBox(width: 10),
              PopupMenuButton<String>(
                icon: Icon(Icons.wifi, color: Colors.white), // Ícone de Wi-Fi
                onSelected: (String value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Conectado à rede: $value')),
                  );
                },
                itemBuilder:
                    (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'Rede 1',
                        child: Text('Rede 1'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Rede 2',
                        child: Text('Rede 2'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Rede 3',
                        child: Text('Rede 3'),
                      ),
                    ],
              ),
              SizedBox(width: 10),
              Icon(Icons.battery_full, color: Colors.white), // Ícone de bateria
              SizedBox(width: 10),
            ],
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text('Home Page 2'),
      ),
    );
  }
}
