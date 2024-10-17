import 'package:firebase_core/firebase_core.dart';
import 'util/firebase_options.dart';

Future<void> main() async {
  _setupFirebase();

}








Future<void> _setupFirebase() async =>  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
