import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Badge {

  final int type;
  final String name;
  final String end;
  final String description;
  final String begin;
  final String avatar;

  Badge({this.type, this.name, this.end, this.description, this.begin, this.avatar});

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(type: json['type'],
                 name: json['name'],
                 end: json['end'],
                 description: json['description'],
                 begin: json['begin'],
                 avatar: json['avatar']);
  }
} 
Future<List<Badge>> fetchBadges(String token) async {
  print(token);
    final response = await http.get(
    DotEnv().env['API_URL'] + '/api/v1/badges',
    headers: {"Authorization": "Bearer " + token},
  );

  if (response.statusCode == 200) {
    Map m = json.decode(response.body);
    List l = m['data'];
    return l.map((i)=> Badge.fromJson(i)).toList();
  } else {
    throw Exception('Failed to load badges');
  }
}