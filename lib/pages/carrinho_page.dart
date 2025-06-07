import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/pages/pagamento_page.dart';
import 'package:lottie/lottie.dart';

class CarrinhoPage extends StatefulWidget {
  final List<Map<String, dynamic>> carrinho;

  CarrinhoPage({Key? key, required this.carrinho}) : super(key: key);

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double get total => widget.carrinho.fold(
    0.0,
    (soma, item) => soma + (item['preco'] * (item['quantidade'] ?? 1)),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _removerItem(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 8),
                Text('Remover item'),
              ],
            ),
            content: Text('Deseja remover este produto do carrinho?'),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.pop(context, false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Remover', style: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );
    if (confirm == true) {
      setState(() {
        widget.carrinho.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produto removido do carrinho!'),
          backgroundColor: Colors.red[400],
        ),
      );
    }
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
                    SizedBox(height: 16),
                    Icon(                      Icons.shopping_cart_outlined,
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
                separatorBuilder: (_, __) => SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = widget.carrinho[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.08),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Hero(
                        tag: item['imagem'] + index.toString(),
                        child: ClipRRect(
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
                      ),
                      title: Text(
                        item['nome'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange[800],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            'R\$ ${(item['preco']).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.orange,
                                ),
                                onPressed: () => _alterarQuantidade(index, -1),
                              ),
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 250),
                                child: Text(
                                  '${item['quantidade']}',
                                  key: ValueKey(item['quantidade']),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.orange,
                                ),
                                onPressed: () => _alterarQuantidade(index, 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removerItem(index),
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
                          elevation: 4,
                          shadowColor: Colors.orange[200],
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
