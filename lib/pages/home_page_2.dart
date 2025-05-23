import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projeto_pi_flutter/pages/profile_page.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              onTap: () {
                Navigator.pushNamed(context, '/home'); // Fecha o Drawer
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
    ),
  ),
        
        actions: [
          Row(
            children: [
              IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.cartShopping)),
              SizedBox(width: 10,),
              IconButton(onPressed: (){}, icon: Icon(FontAwesomeIcons.bell)),
              SizedBox(width: 10,),
              IconButton(onPressed: 
              (){}, icon: Icon(FontAwesomeIcons.truckFast)),
            
            ],
          )],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
