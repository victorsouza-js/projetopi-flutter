class PedidosRepository {
  static final PedidosRepository _instance = PedidosRepository._internal();
  factory PedidosRepository() => _instance;
  PedidosRepository._internal();

  final List<Map<String, dynamic>> _pedidos = [];

  List<Map<String, dynamic>> get pedidos => _pedidos;

  void adicionarPedido(Map<String, dynamic> pedido) {
    _pedidos.add(pedido);
  }
}
