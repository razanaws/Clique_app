import 'package:clique/database/loginForm.dart';
import 'package:clique/screens/navigationBar/NavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool isValidEmail(value) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        final currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser?.email == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavBar(selectedIndexNavBar: 3),
            ),
          );
        }
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text("Password reset link sent please check your email"),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future SendResetLink() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      showAlertDialog(context);
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(content: Text(e.message.toString()));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 13, 20, 1),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Please enter your email",
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required.';
                } else if (!isValidEmail(value)) {
                  return 'Invalid Email.';
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
                SendResetLink();
              },
              child: const Text(
                'Send Link',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
    );
  }
}
