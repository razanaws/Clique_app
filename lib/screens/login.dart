import 'package:flutter/material.dart';

import 'package:clique/database/loginForm.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: const Login(),
    );
  }
}
