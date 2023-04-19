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

  bool isValidPassword(value) {
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value);
  }

  bool isValidEmail(value) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }

  bool isValidName(value) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(value);
  }

  bool isValidUsername(value) {
    return RegExp(r'^(?=.{4,20}$)(?:[a-zA-Z\d]+(?:(?:\.|-|_)[a-zA-Z\d])*)+$').hasMatch(value);
  }


  bool isValidPhonenumber(value) {
    return RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$').hasMatch(value);
  }


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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height*0.09,),
                const Text(
                  "Create a new recruiter account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: height*0.05,),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      } else if (!isValidName(value)) {
                        return 'Invalid name';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      print("in validator");
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      } else if (value.contains(" ")) {
                        return 'Spaces are not allowed';
                      } else if (!isValidUsername(value)) {
                        return 'Invalid username';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      } else if (value.contains(" ")) {
                        return 'Spaces are not allowed';
                      } else if (!isValidPhonenumber(value)) {
                        return 'invalid Phone number';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      } else if (value.contains(" ")) {
                        return 'Spaces are not allowed';
                      } else if (!isValidPassword(value)) {
                        return 'Minimum eight characters, at least one letter and one number';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      print("in validator");
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      return null;
                    },
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

                      if (formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')));
                      }
                      //TODO:go back

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
      ),
    );
  }
}
