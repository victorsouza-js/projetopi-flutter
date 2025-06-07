import 'package:flutter/material.dart';

class PagamentoPage extends StatefulWidget {

  
  final Map<String, dynamic>? pedido; 
  // Passe o pedido ao navegar

  const PagamentoPage({Key? key, this.pedido}) : super(key: key);

  @override
  State<PagamentoPage> createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage> {
  String metodoSelecionado = 'Cartão de Crédito';

  final List<Map<String, dynamic>> metodos = [
    {
      'nome': 'Cartão de Crédito',
      'icone': Icons.credit_card,
      'cor': Colors.blue,
      'descricao': 'Pague em até 12x sem juros',
    },
    {
      'nome': 'Pix',
      'icone': Icons.pix,
      'cor': Colors.green,
      'descricao': 'Pagamento instantâneo',
    },
    {
      'nome': 'Boleto Bancário',
      'icone': Icons.receipt_long,
      'cor': Colors.orange,
      'descricao': 'Compensação em até 2 dias úteis',
    },
    {
      'nome': 'Dinheiro na Entrega',
      'icone': Icons.attach_money,
      'cor': Colors.teal,
      'descricao': 'Pague ao receber o pedido',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final pedido = widget.pedido;
    double total = 0.0;
    List produtos = [];

    if (pedido != null) {
      produtos = pedido['produtos'] ?? [];
      total = produtos.fold(
        0.0,
        (soma, item) => soma + (item['preco'] * (item['quantidade'] ?? 1)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pagamento',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.orange),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Icon(Icons.payments, color: Colors.orange, size: 60)),
            SizedBox(height: 12),
            Center(
              child: Text(
                'Resumo do Pedido',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...produtos.asMap().entries.map((entry) {
                      final i = entry.key;
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['imagem'] ?? '',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) =>
                                        Icon(Icons.image, color: Colors.orange),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item['nome'],
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              'Qtd: ${item['quantidade'] ?? 1}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'R\$ ${(item['preco'] * (item['quantidade'] ?? 1)).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.orange[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Remover produto',
                              onPressed: () {
                                setState(() {
                                  produtos.removeAt(i);
                                  if (widget.pedido != null) {
                                    widget.pedido!['produtos'] = produtos;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    Divider(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Total: R\$ ${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Escolha o método de pagamento',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 12),
            ...metodos.map(
              (metodo) => Card(
                color:
                    metodoSelecionado == metodo['nome']
                        ? metodo['cor'].withOpacity(0.15)
                        : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: metodoSelecionado == metodo['nome'] ? 4 : 1,
                child: ListTile(
                  leading: Icon(
                    metodo['icone'],
                    color: metodo['cor'],
                    size: 32,
                  ),
                  title: Text(
                    metodo['nome'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(metodo['descricao']),
                  trailing:
                      metodoSelecionado == metodo['nome']
                          ? Icon(Icons.check_circle, color: metodo['cor'])
                          : null,
                  onTap: () {
                    setState(() {
                      metodoSelecionado = metodo['nome'];
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.check),
                label: Text(
                  'Confirmar Pagamento',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Row(
                            children: [
                              Icon(Icons.verified, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Pagamento Realizado'),
                            ],
                          ),
                          content: Text(
                            'Seu pagamento via "$metodoSelecionado" foi confirmado!\nObrigado por comprar conosco!',
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Fecha o dialog
                                Navigator.pop(
                                  context,
                                ); // Volta para tela anterior
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
