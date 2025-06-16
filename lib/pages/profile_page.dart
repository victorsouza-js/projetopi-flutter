import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  String username = '';
  String email = '';
  bool isLoading = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _carregarDados();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    setState(() => isLoading = true);

    // Simula um pequeno delay para mostrar o loading
    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Usuário não definido';
      email = prefs.getString('email') ?? 'E-mail não definido';
      _usernameController.text = prefs.getString('username') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      isLoading = false;
    });

    _animationController.forward();
  }

  Future<void> _atualizarDados() async {
    // Validação simples
    if (_usernameController.text.trim().isEmpty) {
      _mostrarSnackBar('Por favor, insira um nome de usuário', isError: true);
      return;
    }

    if (_emailController.text.trim().isEmpty ||
        !_emailController.text.contains('@')) {
      _mostrarSnackBar('Por favor, insira um e-mail válido', isError: true);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text.trim());
    await prefs.setString('email', _emailController.text.trim());

    setState(() {
      username = _usernameController.text.trim();
      email = _emailController.text.trim();
    });

    Navigator.pop(context);
    _mostrarSnackBar('Dados atualizados com sucesso!', isError: false);
  }

  void _mostrarSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red[400] : Colors.green[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _mostrarDialogAtualizar() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 16,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.orange.shade50],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: Colors.orange.shade700,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Atualizar Dados',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Edite suas informações pessoais',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _usernameController,
                    label: 'Nome de usuário',
                    icon: Icons.person_rounded,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'E-mail',
                    icon: Icons.email_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _atualizarDados,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Salvar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.orange.shade700, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.orange.shade50],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildInfoRow(
              icon: Icons.person_rounded,
              label: 'Usuário',
              value: username,
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
              icon: Icons.email_rounded,
              label: 'E-mail',
              value: email,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.orange.shade700, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor ?? Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          shadowColor: backgroundColor.withOpacity(0.3),
        ),
        icon: Icon(icon, size: 22),
        onPressed: onPressed,
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Meu Perfil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              )
              : FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Avatar com gradiente
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.orange.shade700],
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.orange.shade100,
                            child: Icon(
                              Icons.person_rounded,
                              size: 60,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Título elegante
                      Text(
                        'Informações do Perfil',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gerencie suas informações pessoais',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 32),

                      // Card de informações
                      _buildInfoCard(),
                      const SizedBox(height: 32),

                      // Botões de ação
                      _buildActionButton(
                        icon: Icons.edit_rounded,
                        label: 'Atualizar Dados',
                        onPressed: _mostrarDialogAtualizar,
                        backgroundColor: Colors.orange,
                      ),
                      _buildActionButton(
                        icon: Icons.arrow_back_rounded,
                        label: 'Voltar',
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: Colors.grey[400]!,
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
