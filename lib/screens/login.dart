import 'package:flutter/material.dart';

import 'package:clique/database/loginForm.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: Login(),
      backgroundColor: Color.fromRGBO(37, 37, 37,1),
    );
  }
}
