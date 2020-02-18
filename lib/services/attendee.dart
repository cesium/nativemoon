import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Attendee {
  final String nick;
  final String avatar;

  Attendee({this.nick, this.avatar});

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(nick: json['nickname'], avatar: json['avatar']);
  }
}

Future<Attendee> fetchAttendee(String token, String id) async {
  print(token);
  final response = await http.get(
    DotEnv().env['API_URL'] + '/api/v1/attendees/' + id,
    headers: {"Authorization": "Bearer " + token},
  );

  if (response.statusCode == 200) {
    Map m = json.decode(response.body);
    Map l = m['data'];
    return Attendee.fromJson(l);
  } else {
    throw Exception('Failed to fetch attendee');
  }
}
