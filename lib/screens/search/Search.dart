import 'package:clique/screens/chat/NavigateToBandProfile.dart';
import 'package:clique/screens/chat/ReceiverMusicianProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _memberEmailController = TextEditingController();
  final TextEditingController _bandEmailController = TextEditingController();

  void _searchUser() async {
    final String memberEmail = _memberEmailController.text.trim();

    if (memberEmail.isNotEmpty) {
      final snapshot = await FirebaseFirestore.instance
          .collection('Musicians')
          .doc(memberEmail.toString())
          .get();

      if (snapshot.exists) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReceiverMusicianProfile(
                receiverEmail: memberEmail.toString())));
        setState(() {
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

  void _searchBand() async {
    final String bandName = _bandEmailController.text.trim();

    if (bandName.isNotEmpty) {
      final snapshot = await FirebaseFirestore.instance
          .collection('bands')
          .where('name', isEqualTo: bandName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NavigateToBandProfile(bandName: bandName),
        ));
        setState(() {
          _bandEmailController.clear();
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Oops'),
              content: Text('Band does not exist.'),
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
                      value == null || value.isEmpty
                          ? "field is required"
                          : null;
                    },
                    controller: _memberEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Musician Email',
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
                      _searchUser();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(100, 13, 20, 1)),
                    ),
                    child: Text(
                      'Search Musician',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    validator: (value) {
                      value == null || value.isEmpty
                          ? "field is required"
                          : null;
                    },
                    controller: _bandEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Band Name',
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
                      _searchBand();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(100, 13, 20, 1)),
                    ),
                    child: Text(
                      'Search Band',
                      style: TextStyle(color: Colors.white),
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
