import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class Authentication {

  final String token;

  Authentication({this.token});

  factory Authentication.fromJson(Map<String, dynamic> json) {
    return Authentication(token : json['jwt']);
  }
}

Future<Authentication> fetchAuthToken(String email, String password) async{

  final response = await http.post('https://safira20.herokuapp.com/api/auth/sign_in?email=' + email + '&password=' + password);

  if (response.statusCode == 200) {
      return Authentication.fromJson(json.decode(response.body));
  } else {
      throw Exception('Incorrect Email or Password');
  }
}