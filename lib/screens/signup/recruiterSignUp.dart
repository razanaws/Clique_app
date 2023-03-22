import 'package:flutter/material.dart';
import 'package:clique/database/SignUpRecruiterForm.dart';

class RecruiterSignUp extends StatelessWidget {
  const RecruiterSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignUpRecruiterForm(),
      backgroundColor: Color.fromRGBO(37, 37, 37, 1),
    );
  }
}
