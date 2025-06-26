import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String apiKey;

  AuthService({required this.apiKey});

  Future<String?> signInWithEmailPassword(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey');

    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200 && data['idToken'] != null) {
      return data['idToken']; // JWT
    } else {
      throw Exception(data['error']['message'] ?? 'Authentication failed');
    }
  }
}
