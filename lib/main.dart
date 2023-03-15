
//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';

import 'package:clique/database/loginForm.dart';
import 'package:flutter/material.dart';
import 'package:clique/screens/login.dart';
import 'package:clique/screens/signup/musicianSignUp.dart';
import 'package:clique/screens/signup/recruiterSignUp.dart';
import 'package:clique/screens/profile/MusicianProfile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home:MusicianProfile()
    );
  }
}

class loadingPage extends StatefulWidget {
  const loadingPage({Key? key}) : super(key: key);



  @override
  State<loadingPage> createState() => _loadingPageState();
}

class _loadingPageState extends State<loadingPage> {
  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return Scaffold(
      body:Container(
        height: height,
        width: width,
        color: Colors.black,
        child: Column(
        children: [
          SizedBox(height: height*0.3),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Image.asset(
                  'images/cliqueLogo.png',
                  width: width*0.4,
                  height: height*0.4,
                  //TODO: animation loading image
              )
            ],
          )
        ],
        ),
      ),
    );
  }
}
