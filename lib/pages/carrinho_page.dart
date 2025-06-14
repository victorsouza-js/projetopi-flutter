import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_pi_flutter/pages/pagamento_page.dart';
import 'package:lottie/lottie.dart';

class CarrinhoPage extends StatefulWidget {
  final List<Map<String, dynamic>> carrinho;

  CarrinhoPage({Key? key, required this.carrinho}) : super(key: key);

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _totalController;
  late Animation<double> _totalAnimation;

  double get total => widget.carrinho.fold(
    0.0,
    (soma, item) => soma + (item['preco'] * (item['quantidade'] ?? 1)),
  );

  int get totalItens => widget.carrinho.fold(
    0,
    (soma, item) => soma + (item['quantidade'] ?? 1) as int,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _totalController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _totalAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _totalController, curve: Curves.elasticOut),
    );

    _totalController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _animateTotal() {
    _totalController.reset();
    _totalController.forward();
  }

  void _removerItem(int index) async {
    HapticFeedback.lightImpact();

    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            elevation: 10,
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red[600],
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Remover produto',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              'Tem certeza que deseja remover este produto do seu carrinho?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[500],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Remover',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirm == true) {
      setState(() {
        widget.carrinho.removeAt(index);
      });
      _animateTotal();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Produto removido com sucesso!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  void _alterarQuantidade(int index, int delta) {
    HapticFeedback.selectionClick();

    setState(() {
      widget.carrinho[index]['quantidade'] =
          (widget.carrinho[index]['quantidade'] ?? 1) + delta;
      if (widget.carrinho[index]['quantidade'] <= 0) {
        widget.carrinho.removeAt(index);
      }
    });
    _animateTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          leading: IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.orange[700],
                size: 20,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Column(
            children: [
              Text(
                'Meu Carrinho',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              if (widget.carrinho.isNotEmpty)
                Text(
                  '$totalItens ${totalItens == 1 ? 'item' : 'itens'}',
                  style: TextStyle(
                    color: Colors.orange[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
      body:
          widget.carrinho.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Colors.orange[300],
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Seu carrinho está vazio',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Adicione produtos e eles aparecerão aqui',
                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                      ),
                      icon: Icon(Icons.shopping_bag_outlined),
                      label: Text(
                        'Continuar Comprando',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  // Header com resumo
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange[400]!, Colors.orange[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total do Pedido',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              AnimatedBuilder(
                                animation: _totalAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 0.8 + (_totalAnimation.value * 0.2),
                                    child: Text(
                                      'R\$ ${total.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Lista de produtos
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: widget.carrinho.length,
                      itemBuilder: (context, index) {
                        final item = widget.carrinho[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Imagem do produto
                                Hero(
                                  tag: item['imagem'] + index.toString(),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey[200]!,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        item['imagem'],
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (_, __, ___) => Icon(
                                              Icons.image_outlined,
                                              size: 40,
                                              color: Colors.grey[400],
                                            ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: 16),

                                // Informações do produto
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['nome'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'R\$ ${(item['preco']).toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.orange[600],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 12),

                                      // Controles de quantidade
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.remove,
                                                    color: Colors.orange[600],
                                                    size: 20,
                                                  ),
                                                  onPressed:
                                                      () => _alterarQuantidade(
                                                        index,
                                                        -1,
                                                      ),
                                                  constraints: BoxConstraints(
                                                    minWidth: 40,
                                                    minHeight: 40,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                                  child: AnimatedSwitcher(
                                                    duration: Duration(
                                                      milliseconds: 200,
                                                    ),
                                                    child: Text(
                                                      '${item['quantidade']}',
                                                      key: ValueKey(
                                                        item['quantidade'],
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey[800],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: Colors.orange[600],
                                                    size: 20,
                                                  ),
                                                  onPressed:
                                                      () => _alterarQuantidade(
                                                        index,
                                                        1,
                                                      ),
                                                  constraints: BoxConstraints(
                                                    minWidth: 40,
                                                    minHeight: 40,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Spacer(),

                                          // Botão remover
                                          IconButton(
                                            icon: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.red[50],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.delete_outline,
                                                color: Colors.red[500],
                                                size: 20,
                                              ),
                                            ),
                                            onPressed:
                                                () => _removerItem(index),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

      // Bottom bar com botão de finalizar
      bottomNavigationBar:
          widget.carrinho.isNotEmpty
              ? Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Resumo final
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            color: Colors.orange[600],
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '$totalItens ${totalItens == 1 ? 'produto' : 'produtos'}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Total: R\$ ${total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Botão finalizar
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor: Colors.orange.withOpacity(0.4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.payment, size: 22),
                              SizedBox(width: 12),
                              Text(
                                'Finalizar Pedido',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                          onPressed: () {
                            HapticFeedback.mediumImpact();
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
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : null,
    );
  }
}
