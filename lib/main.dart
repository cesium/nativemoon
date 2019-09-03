import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nativemoon/routes.dart';

void main() async {
  await DotEnv().load('.env');
  new Routes();
  
}
