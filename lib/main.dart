import 'package:flutter/material.dart';
import 'package:pictures/pages/homepage.dart';
import 'package:pictures/pages/lofin_p.dart';
import 'package:pictures/pages/register_p.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:pictures/services/firebase_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.instance.registerSingleton<FirebaseServices>(
    FirebaseServices(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pictures',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: 'login',
      routes: {
        'register': (context) => Register(),
        'login': (context) => Login(),
        'homepage': (context) => Homepage(),
      },
    );
  }
}
