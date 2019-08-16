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