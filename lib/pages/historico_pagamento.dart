import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/data/repositories/pedidos_repository.dart';

class HistoricoPagamentosPage extends StatefulWidget {
  @override
  _HistoricoPagamentosPageState createState() =>
      _HistoricoPagamentosPageState();
}

class _HistoricoPagamentosPageState extends State<HistoricoPagamentosPage> {
  final PedidosRepository _pedidosRepository = PedidosRepository();
  List<Map<String, dynamic>> _pedidos = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
  }

  Future<void> _carregarPedidos() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // If listarPedidos is async, use await
      final pedidos = await _pedidosRepository.listarPedidos();

      // If it's sync, use this instead:
      // final pedidos = _pedidosRepository.listarPedidos();

      setState(() {
        _pedidos = pedidos;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Erro ao carregar histórico: $error';
        _isLoading = false;
      });
    }
  }

  String _formatarData(dynamic data) {
    if (data == null) return 'Data não disponível';

    // Handle different date formats
    if (data is DateTime) {
      return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
    } else if (data is String) {
      return data;
    }

    return data.toString();
  }

  String _formatarValor(dynamic valor) {
    if (valor == null) return '0,00';

    if (valor is num) {
      return valor.toStringAsFixed(2).replaceAll('.', ',');
    }

    return valor.toString();
  }

  // Sempre retorna cor laranja para pendente
  Color _getStatusColor(String? status) {
    return Colors.orange;
  }

  // Sempre retorna ícone de relógio para pendente
  IconData _getStatusIcon(String? status) {
    return Icons.access_time;
  }

  // Função para analisar o pedido
  void _analisarPedido(Map<String, dynamic> pedido) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.analytics_outlined, color: Color(0xFFFF6B35)),
              SizedBox(width: 8),
              Text(
                'Análise do Pedido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnaliseItem(
                  'ID do Pedido',
                  pedido['id']?.toString() ?? 'N/A',
                ),
                _buildAnaliseItem('Data', _formatarData(pedido['data'])),
                _buildAnaliseItem('Status', 'Pendente'),
                _buildAnaliseItem(
                  'Valor Total',
                  'R\$ ${_formatarValor(pedido['total'])}',
                ),
                _buildAnaliseItem(
                  'Método de Pagamento',
                  pedido['metodoPagamento'] ?? pedido['pagamento'] ?? 'N/A',
                ),

                // Informações adicionais se disponíveis
                if (pedido['cliente'] != null)
                  _buildAnaliseItem('Cliente', pedido['cliente'].toString()),
                if (pedido['itens'] != null)
                  _buildAnaliseItem(
                    'Quantidade de Itens',
                    pedido['itens'].length.toString(),
                  ),
                if (pedido['observacoes'] != null)
                  _buildAnaliseItem(
                    'Observações',
                    pedido['observacoes'].toString(),
                  ),

                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Este pedido está aguardando processamento. Verifique os detalhes e tome as ações necessárias.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fechar', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Aqui você pode adicionar ações específicas como processar o pedido
                _processarPedido(pedido);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Processar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnaliseItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _processarPedido(Map<String, dynamic> pedido) {
    // Aqui você pode implementar a lógica para processar o pedido
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processando pedido #${pedido['id']}...'),
        backgroundColor: Color(0xFFFF6B35),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Histórico de Pagamentos',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Color(0xFFFF6B35)),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _carregarPedidos,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
            ),
            SizedBox(height: 16),
            Text('Carregando histórico...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(fontSize: 16, color: Colors.red[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregarPedidos,
              child: Text('Tentar Novamente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6B35),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_pedidos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum pagamento encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Seus pagamentos aparecerão aqui quando forem realizados',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarPedidos,
      color: Color(0xFFFF6B35),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _pedidos.length,
        itemBuilder: (context, index) {
          final pedido = _pedidos[index];
          return _buildPedidoCard(pedido);
        },
      ),
    );
  }

  Widget _buildPedidoCard(Map<String, dynamic> pedido) {
    // Sempre define como "Pendente"
    final status = 'Pendente';
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Chama a função de análise do pedido
          _analisarPedido(pedido);
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Pedido #${pedido['id'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        SizedBox(width: 4),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    _formatarData(pedido['data']),
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.payment, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        pedido['metodoPagamento'] ??
                            pedido['pagamento'] ??
                            'N/A',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Text(
                    'R\$ ${_formatarValor(pedido['total'])}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Indicador visual de que o card é clicável
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Toque para analisar',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey[500],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
