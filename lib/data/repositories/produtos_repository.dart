class ProdutosRepository {
  static final ProdutosRepository _instance = ProdutosRepository._internal();
  factory ProdutosRepository() => _instance;
  ProdutosRepository._internal();

  final List<Map<String, dynamic>> _produtos = [];

  List<Map<String, dynamic>> get produtos => _produtos;

  void adicionarProduto(Map<String, dynamic> produto) {
    _produtos.add(produto);
  }
}
