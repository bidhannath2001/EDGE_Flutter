import 'package:fire_conn/firebase_options.dart';
import 'package:fire_conn/homePage.dart';
import 'package:fire_conn/pages/signIn.dart';
import 'package:fire_conn/pages/signUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => signUp(),
        'signin': (context) => SignIn(),
        'homePage': (context) => homePage(),
      },
      // home: signUp(),
    );
  }
}
