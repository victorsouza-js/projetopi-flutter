import 'package:url_launcher/url_launcher.dart';

Future<void> loginWithGitHub() async {
  final url = Uri.parse('meuapp://callback');

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Não foi possível abrir o navegador.';
  }
}
