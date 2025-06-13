import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/data/repositories/pedidos_repository.dart';

class PedidosFinalizadosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pedidos = PedidosRepository().pedidos;

    return Scaffold(
      appBar: AppBar(title: Text('Pedidos Finalizados')),
      body:
          pedidos.isEmpty
              ? Center(child: Text('Nenhum pedido finalizado ainda.'))
              : ListView.builder(
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index];
                  return Card(
                    margin: EdgeInsets.all(12),
                    child: ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text(
                        'Pedido #${pedido['id']} - ${pedido['data']}',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...pedido['produtos']
                              .map<Widget>(
                                (p) => Text('${p['nome']} x${p['quantidade']}'),
                              )
                              .toList(),
                          SizedBox(height: 4),
                          Text(
                            'Total: R\$ ${pedido['total'].toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
