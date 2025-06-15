import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/data/repositories/pedidos_repository.dart';

class HistoricoPagamentosPage extends StatefulWidget {
  @override
  _HistoricoPagamentosPageState createState() => _HistoricoPagamentosPageState();
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

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pago':
      case 'concluído':
        return Colors.green;
      case 'pendente':
        return Colors.orange;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pago':
      case 'concluído':
        return Icons.check_circle;
      case 'pendente':
        return Icons.access_time;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.receipt_long;
    }
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
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
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
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
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
    final status = pedido['status'] ?? pedido['pagamento'] ?? 'Pendente';
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to order details if needed
          // Navigator.push(context, MaterialPageRoute(
          //   builder: (context) => DetalhePedidoPage(pedido: pedido),
          // ));
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
                        Icon(
                          statusIcon,
                          size: 14,
                          color: statusColor,
                        ),
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
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    _formatarData(pedido['data']),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.payment,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 8),
                      Text(
                        pedido['metodoPagamento'] ?? pedido['pagamento'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}