import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clique/screens/signup/musicianSignUp.dart';
import 'package:clique/screens/signup/recruiterSignUp.dart';
import 'package:clique/screens/swipingCards/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../screens/login/resetPasswordPage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
//Google Sign In
  final GoogleSignIn _googleSignIn = GoogleSignIn(
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

//FB
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

//Google
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) async {
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
  final formKey = GlobalKey<FormState>();

  bool isValidEmail(value) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }

  bool isValidPassword(value) {
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value);
  }

  //TODO: stay logged in
   submitForm() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      //navigate to homepage after signing in.
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("invalid username or password")));
        return false;

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("invalid username or password")));
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      body: SingleChildScrollView(
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
                    } else if (value.contains(" ")) {
                      return 'Spaces are not allowed';
                    } else if (!isValidEmail(value)) {
                      return 'Invalid Email Address';
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
                    hintText: 'example_123@example.com',
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
                    } else if (value.contains(" ")) {
                      return 'Spaces are not allowed';
                    } else if (!isValidPassword(value)) {
                      return 'Minimum eight characters, at least one letter and one number';
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
                  onPressed:  (){
                    if (formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')));

                    }

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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ResetPasswordPage()));
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
                    onPressed: // signInWithFacebook
                        null,
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
                    onPressed: //signInWithApple
                        null,
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
                    onPressed: /*() async {
                      await _handleSignIn();
                    }*/
                        null,
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

              Padding(
                padding: const EdgeInsets.all(14.0),
                child: const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white),
                ),
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
