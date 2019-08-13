import 'package:nativemoon/routes.dart';
import 'env.dart';

void main(){
   BuildEnvironment.init(
      flavor: BuildFlavor.production, baseUrl: 'https://safira20.herokuapp.com');
  assert(env != null);
  new Routes();
}
