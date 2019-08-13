import 'package:nativemoon/routes.dart';
import 'env.dart';

void main(){
   BuildEnvironment.init(
      flavor: BuildFlavor.development, baseUrl: 'https://safira20.herokuapp.com');
  assert(env != null);
  new Routes();
}
