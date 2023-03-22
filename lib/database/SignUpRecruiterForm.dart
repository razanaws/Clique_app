import 'package:flutter/material.dart';
import 'package:clique/screens/login.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:clique/screens/homepage.dart';

class SignUpRecruiterForm extends StatefulWidget {
  const SignUpRecruiterForm({Key? key}) : super(key: key);

  @override
  State<SignUpRecruiterForm> createState() => _SignUpRecruiterFormState();
}

class _SignUpRecruiterFormState extends State<SignUpRecruiterForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController companyController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //TODO: stay logged in

  submitForm() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Recruiters');
      // Call the user's CollectionReference to connect user email
      await users.doc(emailController.text).set({
        //TODO: Validate data + password
        'name': nameController.text,
        'number': numberController.text,
        'username': usernameController.text,
        'company': companyController.text
      });

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Homepage()));

      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        height: height,
        width: width,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30.0, horizontal: 7.0),
                child: const Text(
                  "Create a new recruiter account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    label: const Text("Name",
                        style: TextStyle(color: Colors.black, fontSize: 13)),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'Emma Micheals',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    label: const Text(
                      "Username",
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'emma_micheals',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    label: const Text(
                      "Email",
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'Emma@example.com',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: numberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    label: const Text(
                      "Number",
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: '123-456-789',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    label: const Text(
                      "Password",
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: '*********',
                    hintStyle: const TextStyle(color: Colors.black26),
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: companyController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    label: const Text(
                      "Company",
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'Company name',
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
                      borderRadius: BorderRadius.circular(50.0),
                    )),
                  ),
                  onPressed: () {
                    submitForm();
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AuthScreen()));
                  },
                  child: const Text(
                    "I already have an account",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
