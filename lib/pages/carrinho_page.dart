import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/pages/pagamento_page.dart';

class CarrinhoPage extends StatefulWidget {
  final List<Map<String, dynamic>> carrinho;

  CarrinhoPage({Key? key, required this.carrinho}) : super(key: key);

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  double get total => widget.carrinho.fold(
    0.0,
    (soma, item) => soma + (item['preco'] * (item['quantidade'] ?? 1)),
  );

  @override
  void _removerItem(int index) {
    setState(() {
      widget.carrinho.removeAt(index);
    });
  }

  void _alterarQuantidade(int index, int delta) {
    setState(() {
      widget.carrinho[index]['quantidade'] =
          (widget.carrinho[index]['quantidade'] ?? 1) + delta;
      if (widget.carrinho[index]['quantidade'] <= 0) {
        widget.carrinho.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Carrinho', style: TextStyle(color: Colors.orange)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.orange),
        elevation: 1,
      ),
      body:
          widget.carrinho.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.orange[200],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Seu carrinho está vazio!',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                  ],
                ),
              )
              : ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: widget.carrinho.length,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = widget.carrinho[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item['imagem'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Icon(
                                    Icons.image,
                                    size: 60,
                                    color: Colors.orange,
                                  ),
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nome'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.orange[800],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'R\$ ${(item['preco']).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.orange,
                                      ),
                                      onPressed:
                                          () => _alterarQuantidade(index, -1),
                                    ),
                                    Text(
                                      '${item['quantidade']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add_circle_outline,
                                        color: Colors.orange,
                                      ),
                                      onPressed:
                                          () => _alterarQuantidade(index, 1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removerItem(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar:
          widget.carrinho.isNotEmpty
              ? Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.08),
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.orange[800],
                          ),
                        ),
                        Text(
                          'R\$ ${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.orange[800],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
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
                        icon: Icon(Icons.payment),
                        label: Text(
                          'Finalizar Pedido',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {
                          if (widget.carrinho.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PagamentoPage(
                                      pedido: {
                                        'produtos':
                                            List<Map<String, dynamic>>.from(
                                              widget.carrinho,
                                            ),
                                        'data':
                                            DateTime.now().toIso8601String(),
                                      },
                                    ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
              : null,
    );
  }
}
