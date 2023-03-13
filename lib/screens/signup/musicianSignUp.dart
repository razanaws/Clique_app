import 'package:flutter/material.dart';
import 'package:clique/database/SignUpMusicianForm.dart';

class MusicianSignUp extends StatelessWidget {
  const MusicianSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignUpMusicianForm(),
      backgroundColor: Color.fromRGBO(37, 37, 37,1),
    );
  }
}
