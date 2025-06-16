import 'package:flutter/material.dart';

class ProdutoDetalhePage extends StatefulWidget {
  final Map<String, dynamic> produto;

  const ProdutoDetalhePage({super.key, required this.produto});

  @override
  State<ProdutoDetalhePage> createState() => _ProdutoDetalhePageState();
}

class _ProdutoDetalhePageState extends State<ProdutoDetalhePage> {
  bool _isFavorito = false;
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.produto['nome'] ?? 'Produto',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              const SizedBox(height: 20),
              _buildProductInfo(),
              const SizedBox(height: 24),
              _buildDescription(),
              const SizedBox(height: 24),
              _buildPaymentMethods(),
              const SizedBox(height: 32),
              _buildAddToCartButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[50],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child:
            widget.produto['imagem'] != null
                ? Image.network(
                  widget.produto['imagem'],
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                        color: Colors.orange,
                      ),
                    );
                  },
                  errorBuilder:
                      (context, error, stackTrace) => _buildImageError(),
                )
                : _buildImageError(),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Imagem não disponível',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.produto['nome'] ?? 'Produto sem nome',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              'R\$ ${_formatPrice(widget.produto['preco'])}',
              style: TextStyle(
                fontSize: 28,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            _buildFavoriteButton(),
          ],
        ),
        const SizedBox(height: 12),
        _buildRatingSection(),
      ],
    );
  }

  Widget _buildRatingSection() {
    double rating = (widget.produto['avaliacao'] ?? 4.6).toDouble();

    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < rating.floor()
                  ? Icons.star
                  : (index < rating ? Icons.star_half : Icons.star_border),
              color: Colors.amber,
              size: 20,
            );
          }),
        ),
        const SizedBox(width: 8),
        Text(
          '${rating.toStringAsFixed(1)} (${widget.produto['avaliacoes'] ?? 0} avaliações)',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFavorito = !_isFavorito;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorito
                  ? 'Produto adicionado aos favoritos!'
                  : 'Produto removido dos favoritos!',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: _isFavorito ? Colors.red : Colors.grey,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isFavorito ? Colors.red[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _isFavorito ? Icons.favorite : Icons.favorite_border,
          color: _isFavorito ? Colors.red : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    String description =
        widget.produto['descricao'] ??
        'Este é um produto de alta qualidade que atende às suas necessidades. '
            'Confira todos os detalhes e especificações antes da compra.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descrição',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.orange[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    final paymentMethods = [
      {'icon': Icons.credit_card, 'label': 'Cartão', 'color': Colors.blue},
      {'icon': Icons.pix, 'label': 'Pix', 'color': Colors.green},
      {'icon': Icons.receipt_long, 'label': 'Boleto', 'color': Colors.orange},
      {'icon': Icons.attach_money, 'label': 'Dinheiro', 'color': Colors.teal},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Formas de pagamento',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.orange[800],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              paymentMethods.map((method) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        method['icon'] as IconData,
                        color: method['color'] as Color,
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        method['label'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange[800],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon:
            _isAddingToCart
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Icon(Icons.add_shopping_cart),
        label: Text(
          _isAddingToCart ? 'Adicionando...' : 'Adicionar ao Carrinho',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onPressed: _isAddingToCart ? null : _handleAddToCart,
      ),
    );
  }

  void _handleAddToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    // Simula uma operação async (como chamada de API)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isAddingToCart = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${widget.produto['nome']} adicionado ao carrinho!',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'Ver Carrinho',
            textColor: Colors.white,
            onPressed: () {
              // Navegar para o carrinho
            },
          ),
        ),
      );

      // Volta para a tela anterior após um delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context, widget.produto);
        }
      });
    }
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '0,00';

    if (price is num) {
      return price.toStringAsFixed(2).replaceAll('.', ',');
    }

    return price.toString();
  }
}
