class Errors {
  final Results results;

  Errors({this.results});

  factory Errors.fromJson(Map<String, dynamic> json) {
    return Errors(results: Results.fromJson(json['errors']));
  }
}

class Results {
  final String detail;
  final List<String> msgs;

  Results({this.detail, this.msgs});

  factory Results.fromJson(Map<String, dynamic> json) {
    var msgsFromJson = json['unique_attendee_badge'];
    List<String> msgList = msgsFromJson.cast<String>();

    return Results(detail: json['detail'], msgs: msgList);
  }
}
