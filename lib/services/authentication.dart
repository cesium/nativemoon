import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Authentication {
  final String token;
  final bool valid;

  Authentication({this.token, this.valid});

  factory Authentication.fromJson(Map<String, dynamic> json) {
    return Authentication(token: json['jwt'], valid: true);
  }
}

Future<Authentication> fetchAuthToken(String email, String password) async {

  final response = await http.post(DotEnv().env['API_URL'] + '/api/auth/sign_in?email=' + email + '&password=' + password);

  if (response.statusCode == 200) {
    return Authentication.fromJson(json.decode(response.body));
  } else {
    return new Authentication(token: '', valid: false);
  }
}