import 'package:clique/screens/chat/Chat.dart';
import 'package:clique/screens/loadingScreen/LoadingScreen.dart';
import 'package:clique/screens/navigationBar/NavBar.dart';
import 'package:clique/screens/homepage.dart';
import 'package:clique/screens/privacyPolicy/PrivacyPolicy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:clique/screens/login/login.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:clique/database/authServiceGoogle.dart';


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
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NavBar(),

    );
  }
}

