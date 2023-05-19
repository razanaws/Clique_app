import 'package:clique/screens/navigationBar/NavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clique/database/loginForm.dart';


class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: StreamBuilder(
          stream:  FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapShot) {
            //userSnapShot checks if signed in or not
            if (userSnapShot.hasData) {
              return NavBar();
            }else {
              return const Login();
            }
          }
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
