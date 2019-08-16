import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'badge.dart';

class Badges {
  final List<Badge> badges;

  Badges({this.badges});
}

Future<Badges> fetchBadges(String token) async {
  print(token);
  final response = await http.get(
    DotEnv().env['APP_URL'] + '/api/v1/badges',
    headers: {"Authorization": "Bearer " + token},
  );

  if (response.statusCode == 200) {
    Map m = json.decode(response.body);
    List l = m['data'];
    return Badges(badges: l.map((i)=> Badge.fromJson(i)).toList());
  } else {
    throw Exception('Failed to load badges');
  }
}