import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/data/repositories/produtos_repository.dart';

class AdminAddProdutoPage extends StatefulWidget {
  @override
  State<AdminAddProdutoPage> createState() => _AdminAddProdutoPageState();
}

class _AdminAddProdutoPageState extends State<AdminAddProdutoPage> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String descricao = '';
  String imagem = '';
  double preco = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.add_box, color: Colors.white),
            SizedBox(width: 10),
            Text('Adicionar Produto', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.orange[100],
                      child: Icon(
                        Icons.shopping_bag,
                        color: Colors.orange,
                        size: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      labelText: 'Nome do produto', labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.label, color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    validator:
                        (v) => v == null || v.isEmpty ? 'Informe o nome' : null,
                    onChanged: (v) => nome = v,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      labelText: 'Descrição',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.description, color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (v) => descricao = v,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      labelText: 'URL da imagem',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.image, color: Colors.orange),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (v) => imagem = v,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      labelText: 'Preço',
                      labelStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: Colors.orange,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator:
                        (v) =>
                            v == null || double.tryParse(v) == null
                                ? 'Preço inválido'
                                : null,
                    onChanged: (v) => preco = double.tryParse(v) ?? 0.0,
                  ),
                  SizedBox(height: 28),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.save, color: Colors.white),
                    label: Text(
                      'Salvar Produto',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ProdutosRepository().adicionarProduto({
                          'nome': nome,
                          'descricao': descricao,
                          'imagem': imagem,
                          'preco': preco,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 8),
                                Text('Produto adicionado!'),
                              ],
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
