import 'package:flutter/material.dart';

class ProdutoDetalhePage extends StatelessWidget {
  final Map<String, dynamic> produto;

  const ProdutoDetalhePage({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          produto['nome'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    produto['imagem'],
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Icon(Icons.image, size: 80, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 18),
              Text(
                produto['nome'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[900],
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'R\$ ${produto['preco'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 16),
                  Row(
                    children: List.generate(5, (star) {
                      double nota = produto['avaliacao'] ?? 4.6;
                      return Icon(
                        star < nota.floor()
                            ? Icons.star
                            : (star < nota
                                ? Icons.star_half
                                : Icons.star_border),
                        color: Colors.amber,
                        size: 22,
                      );
                    }),
                  ),
                  SizedBox(width: 8),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.favorite_border, color: Colors.red),
                      onPressed: () {
                        // Lógica para favoritar
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Text(
                'Formas de pagamento',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.orange[800],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.credit_card, color: Colors.blue, size: 32),
                      SizedBox(height: 2),
                      Text('Crédito', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.pix, color: Colors.green, size: 32),
                      SizedBox(height: 2),
                      Text('Pix', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.receipt_long, color: Colors.orange, size: 32),
                      SizedBox(height: 2),
                      Text('Boleto', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.attach_money, color: Colors.teal, size: 32),
                      SizedBox(height: 2),
                      Text('Dinheiro', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 28),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.add_shopping_cart),
                  label: Text(
                    'Adicionar ao Carrinho',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onPressed: () {
                    // Mostra animação/feedback antes de voltar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.orange[700],
                        duration: Duration(milliseconds: 900),
                        content: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${produto['nome']} adicionado ao carrinho!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                    // Aguarda um pouco para o usuário ver a animação
                    Future.delayed(Duration(milliseconds: 900), () {
                      Navigator.pop(context, produto);
                    });
                  },
                ),
              ),
              
            ],
          ),
        ),
        
      ),
    );
  }
}
