import 'package:clique/screens/navigationBar/NavBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clique/screens/signup/musicianSignUp.dart';
import 'package:clique/screens/signup/recruiterSignUp.dart';
import '../screens/login/resetPasswordPage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

  Future<bool> validateUserInfo() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
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

  submitForm() async {
    validateUserInfo().then((value) {
      if (value == true) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NavBar(
                  selectedIndexNavBar: 0,
                )));
      }
    });
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
              SizedBox(
                height: 40,
              ),
              Image.asset('images/cliqueClipArtLogin.png',
                  width: width * 0.3, height: height * 0.3),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
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
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
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
                  onPressed: () {
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
              const Padding(
                padding: EdgeInsets.all(14.0),
                child: Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
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
}
