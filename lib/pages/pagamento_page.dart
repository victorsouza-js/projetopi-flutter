import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:projeto_pi_flutter/data/repositories/pedidos_repository.dart';

class PagamentoPage extends StatefulWidget {
  final Map<String, dynamic>? pedido;

  const PagamentoPage({Key? key, this.pedido}) : super(key: key);

  @override
  State<PagamentoPage> createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage>
    with TickerProviderStateMixin {
  String metodoSelecionado = 'Cartão de Crédito';
  bool _loading = false;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> metodos = [
    {
      'nome': 'Cartão de Crédito',
      'icone': Icons.credit_card,
      'cor': Color(0xFF4A90E2),
      'corGradiente': [Color(0xFF4A90E2), Color(0xFF357ABD)],
      'descricao': 'Pague em até 2x sem juros',
    },
    {
      'nome': 'Pix',
      'icone': Icons.pix,
      'cor': Color(0xFF00B894),
      'corGradiente': [Color(0xFF00B894), Color(0xFF00A085)],
      'descricao': 'Pagamento instantâneo',
    },
    {
      'nome': 'Boleto Bancário',
      'icone': Icons.receipt_long,
      'cor': Color(0xFFE17055),
      'corGradiente': [Color(0xFFE17055), Color(0xFFD63031)],
      'descricao': 'Compensação em até 2 dias úteis',
    },
    {
      'nome': 'Dinheiro na Entrega',
      'icone': Icons.attach_money,
      'cor': Color(0xFF00CEC9),
      'corGradiente': [Color(0xFF00CEC9), Color(0xFF00B3B3)],
      'descricao': 'Pague ao receber o pedido',
    },
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _mostrarLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFF6B35),
        ),
      ),
    );
  }

  void _esconderLoading() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  Widget _buildResumoCard(List produtos, double total) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF8F9FA),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Color(0xFFFF6B35),
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Resumo do Pedido',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ...produtos.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item['imagem'] ?? '',
                          width: 70,
                          height: 70,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Color(0xFFFF6B35).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.image_outlined,
                              color: Color(0xFFFF6B35),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['nome'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Qtd: ${item['quantidade'] ?? 1}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'R\$ ${(item['preco'] * (item['quantidade'] ?? 1)).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Color(0xFFFF6B35),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final confirm = await _showRemoveConfirmation();
                            if (confirm == true) {
                              setState(() {
                                produtos.removeAt(i);
                                if (widget.pedido != null) {
                                  widget.pedido!['produtos'] = produtos;
                                }
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            Container(
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFE55A2B)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'R\$ ${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetodoPagamento(Map<String, dynamic> metodo, int index) {
    final isSelected = metodoSelecionado == metodo['nome'];
    
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: isSelected 
          ? LinearGradient(
              colors: metodo['corGradiente'],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
        color: isSelected ? null : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected 
              ? metodo['cor'].withOpacity(0.3)
              : Colors.black.withOpacity(0.05),
            blurRadius: isSelected ? 15 : 8,
            offset: Offset(0, isSelected ? 8 : 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              metodoSelecionado = metodo['nome'];
            });
            HapticFeedback.lightImpact();
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? Colors.white.withOpacity(0.2)
                      : metodo['cor'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    metodo['icone'],
                    color: isSelected ? Colors.white : metodo['cor'],
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metodo['nome'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSelected ? Colors.white : Color(0xFF2D3436),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        metodo['descricao'],
                        style: TextStyle(
                          color: isSelected 
                            ? Colors.white.withOpacity(0.9)
                            : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedScale(
                  scale: isSelected ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: metodo['cor'],
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showRemoveConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Confirmar remoção'),
          ],
        ),
        content: Text('Deseja remover este produto do carrinho?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text('Remover'),
          ),
        ],
      ),
    );
  }

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
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Pagamento',
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFFFF6B35)),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com ícone
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFE55A2B)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFF6B35).withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.payment_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Resumo do pedido
                _buildResumoCard(produtos, total),
                SizedBox(height: 30),

                // Título métodos de pagamento
                Text(
                  'Escolha o método de pagamento',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF2D3436),
                  ),
                ),
                SizedBox(height: 16),

                ...metodos.asMap().entries.map((entry) {
                  final index = entry.key;
                  final metodo = entry.value;
                  return _buildMetodoPagamento(metodo, index);
                }),

                SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFE55A2B)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFF6B35).withOpacity(0.4),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Icon(Icons.check_circle_outline, color: Colors.white),
                    label: Text(
                      'Confirmar Pagamento',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: _loading ? null : () async {
                      setState(() => _loading = true);
                      _mostrarLoading();

                      await Future.delayed(Duration(seconds: 2));

                      _esconderLoading();
                      setState(() => _loading = false);

                      if (metodoSelecionado == 'Pix') {
                        final _formKey = GlobalKey<FormState>();
                        String nome = '';
                        String cpf = '';
                        String email = '';
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            title: Column(
                              children: [
                                Icon(
                                  FontAwesomeIcons.pix,
                                  color: Colors.teal,
                                  size: 48,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Dados para Pagamento Pix',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            content: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Nome completo (igual CPF)',
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Informe o nome'
                                            : null,
                                    onChanged: (value) => nome = value,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'CPF',
                                    ),
                                    keyboardType: TextInputType.number,
                                    maxLength: 11,
                                    validator: (value) =>
                                        value == null || value.length != 11
                                            ? 'CPF inválido'
                                            : null,
                                    onChanged: (value) => cpf = value,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'E-mail',
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) =>
                                        value == null || !value.contains('@')
                                            ? 'E-mail inválido'
                                            : null,
                                    onChanged: (value) => email = value,
                                  ),
                                ],
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                    // Salva o pedido com os dados do usuário
                                    PedidosRepository().adicionarPedido({
                                      'id': DateTime.now().millisecondsSinceEpoch,
                                      'data': DateTime.now()
                                          .toString()
                                          .substring(0, 10),
                                      'total': total,
                                      'produtos': List.from(produtos),
                                      'nome': nome,
                                      'cpf': cpf,
                                      'email': email,
                                      'pagamento': 'Pix',
                                    });
                                    final chavePix =
                                        '123e4567-pix-chave-exemplo@banco.com';
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 20,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.pix,
                                              color: Colors.teal,
                                              size: 60,
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              'Pagamento via Pix',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.green[800],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Divider(height: 28),
                                            Text(
                                              'Use a chave Pix abaixo para efetuar o pagamento:',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 12),
                                            SelectableText(
                                              chavePix,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green[900],
                                                fontSize: 18,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 16),
                                            ElevatedButton.icon(
                                              icon: Icon(Icons.copy),
                                              label: Text(
                                                'Copiar chave Pix',
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12,
                                                ),
                                              ),
                                              onPressed: () {
                                                Clipboard.setData(
                                                  ClipboardData(text: chavePix),
                                                );
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Row(
                                                      children: [
                                                        Icon(Icons.check),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Chave Pix copiada!',
                                                        ),
                                                      ],
                                                    ),
                                                    backgroundColor:
                                                        Colors.green[700],
                                                    duration: Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context); // Fecha o dialog
                                              Navigator.pop(context); // Volta para tela anterior
                                            },
                                            child: Text(
                                              'Fechar',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Continuar',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (metodoSelecionado == 'Boleto Bancário') {
                        PedidosRepository().adicionarPedido({
                          'id': DateTime.now().millisecondsSinceEpoch,
                          'data': DateTime.now().toString().substring(0, 10),
                          'total': total,
                          'produtos': List.from(produtos),
                        });
                        final linhaDigitavel =
                            '23793.38128 60007.135308 04000.123456 1 81230000010000';
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FontAwesomeIcons.receipt,
                                  color: Colors.orange,
                                  size: 60,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Pagamento via Boleto',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.orange[800],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Divider(height: 28),
                                Text(
                                  'Use o código abaixo para pagar seu boleto:',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 12),
                                SelectableText(
                                  linhaDigitavel,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[900],
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                ElevatedButton.icon(
                                  icon: Icon(Icons.copy),
                                  label: Text('Copiar código'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: linhaDigitavel),
                                    );
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(Icons.check),
                                            SizedBox(width: 8),
                                            Text('Código do boleto copiado!'),
                                          ],
                                        ),
                                        backgroundColor: Colors.orange[700],
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Fecha o dialog
                                  Navigator.pop(context); // Volta para tela anterior
                                },
                                child: Text(
                                  'Fechar',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (metodoSelecionado == 'Cartão de Crédito') {
                        PedidosRepository().adicionarPedido({
                          'id': DateTime.now().millisecondsSinceEpoch,
                          'data': DateTime.now().toString().substring(0, 10),
                          'total': total,
                          'produtos': List.from(produtos),
                        });
                        final _formKey = GlobalKey<FormState>();
                        String nome = '';
                        String numero = '';
                        String validade = '';
                        String cvv = '';
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            content: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.network(
                                    'https://lottie.host/da68062b-106c-4eb1-b6e6-79ff1a4e5f83/43JC4FTMoZ.json',
                                    width: 130,
                                    height: 130,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Dados do Cartão',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue[800],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(height: 28),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Nome no cartão',
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Informe o nome'
                                            : null,
                                    onChanged: (value) => nome = value,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Número do cartão',
                                    ),
                                    keyboardType: TextInputType.number,
                                    maxLength: 16,
                                    validator: (value) =>
                                        value == null || value.length != 16
                                            ? 'Número inválido'
                                            : null,
                                    onChanged: (value) => numero = value,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Validade (MM/AA)',
                                          ),
                                          maxLength: 5,
                                          validator: (value) =>
                                              value == null || value.length != 5
                                                  ? 'Inválido'
                                                  : null,
                                          onChanged: (value) => validade = value,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'CVV',
                                          ),
                                          maxLength: 3,
                                          obscureText: true,
                                          validator: (value) =>
                                              value == null || value.length != 3
                                                  ? 'Inválido'
                                                  : null,
                                          onChanged: (value) => cvv = value,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 20,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.creditCard,
                                              color: Colors.green,
                                              size: 60,
                                            ),
                                            SizedBox(height: 12),
                                            Text(
                                              'Pagamento Realizado',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.green[800],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Divider(height: 28),
                                            Text(
                                              'Pagamento com cartão realizado com sucesso!\nObrigado por comprar conosco!',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context); // Fecha o dialog
                                              Navigator.pop(context); // Volta para tela anterior
                                            },
                                            child: Text(
                                              'Fechar',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Finalizar',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (metodoSelecionado == 'Dinheiro na Entrega') {
                        PedidosRepository().adicionarPedido({
                          'id': DateTime.now().millisecondsSinceEpoch,
                          'data': DateTime.now().toString().substring(0, 10),
                          'total': total,
                          'produtos': List.from(produtos),
                        });
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.teal,
                                  size: 60,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Pagamento em Dinheiro',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.teal[800],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Divider(height: 28),
                                Text(
                                  'Você escolheu pagar em dinheiro na entrega. Certifique-se de ter o valor exato.',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Fecha o dialog
                                  Navigator.pop(context); // Volta para tela anterior
                                },
                                child: Text(
                                  'Fechar',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),

                SizedBox(height: 20),

                // Botão editar carrinho
                Center(
                  child: TextButton.icon(
                    icon: Icon(Icons.edit_outlined, color: Color(0xFFFF6B35)),
                    label: Text(
                      'Editar Carrinho',
                      style: TextStyle(
                        color: Color(0xFFFF6B35),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}