import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

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
                                width: 60,
                                height: 60,
                                fit: BoxFit.contain,
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
                // ...existing code...
                // ...existing code...
                // ...existing code...
                // Adicione no topo do arquivo:
                onPressed: () {
                  // ...dentro do onPressed do botão Confirmar Pagamento...

                  if (metodoSelecionado == 'Pix') {
                    final chavePix = '123e4567-pix-chave-exemplo@banco.com';
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
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
                                  style: TextStyle(fontSize: 16),
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
                                  label: Text('Copiar chave Pix'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
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
                                      ClipboardData(text: chavePix),
                                    );
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(Icons.check),
                                            SizedBox(width: 8),
                                            Text('Chave Pix copiada!'),
                                          ],
                                        ),
                                        backgroundColor: Colors.green[700],
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
                                  Navigator.pop(
                                    context,
                                  ); // Volta para tela anterior
                                },
                                child: Text(
                                  'Fechar',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                    );
                  } else if (metodoSelecionado == 'Boleto Bancário') {
                    final linhaDigitavel =
                        '23793.38128 60007.135308 04000.123456 1 81230000010000';
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
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
                                            Icon(
                                              Icons.check,
                                            ),
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
                                  Navigator.pop(
                                    context,
                                  ); // Volta para tela anterior
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
                    final _formKey = GlobalKey<FormState>();
                    String nome = '';
                    String numero = '';
                    String validade = '';
                    String cvv = '';
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
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
                                    validator:
                                        (value) =>
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
                                    validator:
                                        (value) =>
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
                                          validator:
                                              (value) =>
                                                  value == null ||
                                                          value.length != 5
                                                      ? 'Inválido'
                                                      : null,
                                          onChanged:
                                              (value) => validade = value,
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
                                          validator:
                                              (value) =>
                                                  value == null ||
                                                          value.length != 3
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
                                      builder:
                                          (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
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
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                    context,
                                                  ); // Fecha o dialog
                                                  Navigator.pop(
                                                    context,
                                                  ); // Volta para tela anterior
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
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
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
                                  Navigator.pop(
                                    context,
                                  ); // Volta para tela anterior
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
            TextButton.icon(
              icon: Icon(Icons.shopping_cart, color: Colors.orange),
              label: Text('Editar Carrinho'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
