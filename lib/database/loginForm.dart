import 'package:clique/database/authServiceGoogle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:clique/screens/signup/musicianSignUp.dart';
import 'package:clique/screens/signup/recruiterSignUp.dart';
import 'package:clique/screens/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:clique/database/authServiceGoogle.dart';


//Google Sign In
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

//Apple Sign In
Future signInWithApple() async {
  final appleProvider = AppleAuthProvider();
  if (kIsWeb) {
    await FirebaseAuth.instance.signInWithPopup(appleProvider);
  } else {
    await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }
}



//Facebook Sign In
//Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  //final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  //final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken.token);

  // Once signed in, return the UserCredential
  //return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
//}




class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

//Google
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account)  async {
      if (account != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(),
          ),
        );
      }
    });
    _googleSignIn.signInSilently();
  }






//Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //TODO: stay logged in

  submitForm() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      //navigate to homepage after signing in.

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Homepage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //TODO: input red with warning msg
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //TODO: input red with warning msg
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37,1),

      body: SizedBox(
        height: height,
        width: width,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/cliqueClipArtLogin.png',
                  width: width * 0.3, height: height * 0.3),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      //TODO: Validate email "xxx@xxx.com"
                      return 'This field is required.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    label: const Text(
                      "Email",
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'example_123',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: true, //Hides password
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      //TODO: Validate password ">6"
                      return 'This field is required.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    label: const Text(
                      "Password",
                      style: TextStyle(color: Colors.black),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: '*********',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                ),
              ),

              Container(
                width: double.maxFinite,
                height: 60,
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(100, 13, 20, 1)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0))),
                  ),
                  onPressed: () {
                    submitForm();
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              TextButton(
                  onPressed: () {
                    //setState(() {
                    //  isLoginPage=!isLoginPage;
                    //});
                  },
                  child: const Text(
                    "Forgot Password? Reset your password.",
                    style: TextStyle(color: Colors.white),
                  )),

              SizedBox(
                width: width * 0.005,
                height: height * 0.005,
              ),

              const Text(
                "Or Sign In with",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(
                width: width * 0.005,
                height: height * 0.005,
              ),

              Row(
                children: [
                  SizedBox(
                    width: width * 0.1,
                    height: height * 0.1,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.white54),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                    ),
                    onPressed: null,
                    child: Image.asset(
                      "images/facebookSymbol.png",
                      height: 70,
                      width: 70,
                    ),
                  )),
                  SizedBox(
                    width: width * 0.1,
                    height: height * 0.1,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.white54),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                    ),
                    onPressed: signInWithApple,
                    child: Image.asset(
                      "images/appleSymbol.png",
                      height: 70,
                      width: 70,
                    ),
                  )),
                  SizedBox(
                    width: width * 0.1,
                    height: height * 0.1,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.white54),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                    ),
                    onPressed: () async {
                                await _handleSignIn();

                              },
                    child: Image.asset(
                      "images/googleSymbol.png",
                      height: 70,
                      width: 70,
                    ),
                  )),
                  SizedBox(
                    width: width * 0.1,
                    height: height * 0.1,
                  ),
                ],
              ),

              SizedBox(
                width: width * 0.05,
                height: height * 0.05,
              ),
              const Text(
                "Don't have an account?",
                style: TextStyle(color: Colors.white),
              ),
              //SizedBox(width: width*0.05,height: height*0.05,),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MusicianSignUp()));
                      },
                      child: const Text(
                        "Register as a musician.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RecruiterSignUp()));
                        },
                        child: const Text(
                          "Register as a recruiter.",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
}
