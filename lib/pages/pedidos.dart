import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/data/repositories/pedidos_repository.dart';

class PedidosFinalizadosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pedidos = PedidosRepository().pedidos;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [],
        title: Text(
          'Pedidos Finalizados',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body:
          pedidos.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, color: Colors.orange, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'Nenhum pedido finalizado ainda.',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.green[100],
                        radius: 28,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 32,
                        ),
                      ),
                      title: Text(
                        'Pedido #${pedido['id']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.orange[800],
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data: ${pedido['data']}',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            SizedBox(height: 6),
                            ...pedido['produtos']
                                .map<Widget>(
                                  (p) => Text(
                                    '${p['nome']} x${p['quantidade']}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                )
                                .toList(),
                            SizedBox(height: 8),
                            Text(
                              'Total: R\$ ${pedido['total'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.orange,
                      ),
                      // ...dentro do onTap do ListTile do pedido...
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Column(
                                  children: [
                                    Icon(
                                      Icons.receipt_long,
                                      color: Colors.orange,
                                      size: 48,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Detalhes do Pedido',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Pedido #${pedido['id']} - ${pedido['data']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange[800],
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      if (pedido['nome'] != null) ...[
                                        Text('Nome: ${pedido['nome']}'),
                                        Text('CPF: ${pedido['cpf']}'),
                                        Text('E-mail: ${pedido['email']}'),
                                        SizedBox(height: 8),
                                      ],
                                      Text(
                                        'Produtos:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      ...pedido['produtos'].map<Widget>(
                                        (item) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          child: Text(
                                            '${item['nome']} x${item['quantidade']} - R\$ ${(item['preco'] * (item['quantidade'] ?? 1)).toStringAsFixed(2)}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Text(
                                        'Total: R\$ ${pedido['total'].toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[800],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Fechar',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
