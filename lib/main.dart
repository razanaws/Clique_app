import 'package:clique/database/loginForm.dart';
import 'package:clique/screens/navigationBar/NavBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapShot) {
            if (userSnapShot.hasData) {
              return NavBar(
                selectedIndexNavBar: 0,
              );
            } else {
              return const Login();
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}
