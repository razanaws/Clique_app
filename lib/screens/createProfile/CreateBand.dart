import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../navigationBar/NavBar.dart";

class CreateBand extends StatefulWidget {
  const CreateBand({Key? key}) : super(key: key);

  @override
  State<CreateBand> createState() => _CreateBandState();
}

class _CreateBandState extends State<CreateBand> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _memberEmailController = TextEditingController();
  //List<Map<String, dynamic>> members = [];
  final List<String?> _memberEmails = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final formKey = GlobalKey<FormState>();


  void _addMember() async {
    final String memberEmail = _memberEmailController.text.trim();

    if (memberEmail.isNotEmpty) {
      final snapshot = await _firestore
          .collection('Musicians')
          .doc(memberEmail.toString())
          .get();


      if (snapshot.exists) {
        setState(() {
          _memberEmails.add(memberEmail);
          _memberEmailController.clear();
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('oops'),
              content: Text('User does not exist.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _createGroup() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final String groupName = _groupNameController.text.trim();
    if (groupName.isNotEmpty && _memberEmails.isNotEmpty) {

      if (_memberEmails.isNotEmpty) {
        _memberEmails.add(currentUser?.email.toString());
        final DocumentReference groupRef =
        _firestore.collection('bands').doc();
        final Map<String, dynamic> groupData = {
          'name': groupName,
          'admin': currentUser?.email.toString(),
          'members': _memberEmails,
        };
        await groupRef.set(groupData);


        for (final member in _memberEmails) {
          final DocumentReference userRef =
          _firestore.collection('Musicians').doc(member);
          final Map<String, dynamic> userData = {
            'bands': FieldValue.arrayUnion([groupRef]),
          };
          await userRef.update(userData);
        }

        // Clear the text fields and member list
        _groupNameController.clear();
        _memberEmailController.clear();
        setState(() {
          _memberEmails.clear();
        });

        // Show a success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Band created successfully.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => NavBar()));
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('error msg.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(100, 13, 20, 1),

        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    validator: (value) {
                      value == null || value.isEmpty ? "field is required" : null;
                    },
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      labelText: 'Group Name',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    validator: (value) {
                      value == null || value.isEmpty ? "field is required" : null;
                    },
                    controller: _memberEmailController,
                    decoration: InputDecoration(
                      labelText: 'Member Email',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _addMember();
                    },
                    child: Text(
                      'Add Member',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(100, 13, 20, 1)),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Members: ${_memberEmails.join(", ")}',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _createGroup();
                    },
                    child: Text(
                      'Create Group',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(100, 13, 20, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),



    );
  }
}


