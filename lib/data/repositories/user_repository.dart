import 'package:projeto_pi_flutter/data/http/endpoints.dart';
import 'package:projeto_pi_flutter/data/http/exceptions.dart';
import 'package:projeto_pi_flutter/data/http/http_client.dart';
import 'package:projeto_pi_flutter/data/local/local_storage.dart';
import 'package:projeto_pi_flutter/data/models/user_model.dart';

class UserRepository {
  final IHttpClient client;

  UserRepository({required this.client});

  Future<UserModel> login({Map<String, dynamic>? data}) async {
    final response = await client.post(
      url: '${Endpoints.baseUrl}/login',
      data: data,
    );

    if (response.statusCode == 200) {
      final body = response.data;

      if (body is Map<String, dynamic>) {
        UserModel user = UserModel.fromMap(body['user']);
        return user;
      } else {
        throw const FormatException('Formato de resposta inválido');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Não autorizado');
    } else if (response.statusCode == 404) {
      throw Exception('Não encontrado');
    } else {
      throw NotFoundException('Não foi possível carregar os produtos');
    }
  }

  Future<List<UserModel>> get() async {
    final token = await LocalStorage.getString('token');

    final response = await client.get(
      url: '${Endpoints.baseUrl}/user',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<UserModel> users = [];

      final body = response.data;

      body.map((item) {
        final UserModel produto = UserModel.fromMap(item);
        users.add(produto);
      }).toList();

      return users;
    } else if (response.statusCode == 401) {
      throw Exception('Não autorizado');
    } else if (response.statusCode == 404) {
      throw Exception('Não encontrado');
    } else {
      throw NotFoundException('Não foi possível carregar os dados');
    }
  }
}
