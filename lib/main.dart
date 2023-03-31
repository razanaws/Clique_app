import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:clique/screens/login.dart';
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
        debugShowCheckedModeBanner: false, home: loadingPage());
  }
}

class loadingPage extends StatefulWidget {
  const loadingPage({Key? key}) : super(key: key);

  @override
  State<loadingPage> createState() => _loadingPageState();
}

class _loadingPageState extends State<loadingPage> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    /*TODO: if is logged in direct to homepage without showing loading page
              else if not show this page and direct to log in page */
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      body: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            SizedBox(height: height * 0.3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/cliqueLogo.png',
                  width: width * 0.4,
                  height: height * 0.4,
                )
              ],
            ),
            LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white70, size: 40)
          ],
        ),
      ),
    );
  }
}
