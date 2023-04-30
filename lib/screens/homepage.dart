import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

//https://github.com/surveshoeb/flutter-google-signin/blob/master/lib/pages/home_page.dart
//TODO:Refer back to the documentation above to link the profile info to the homepage,similar to the hi message
class _HomepageState extends State<Homepage> {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  late GoogleSignInAccount user;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      if (account != null) {
        setState(() {
          user = account;
        });
      }
    });
    _googleSignIn.signInSilently();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
    );
  }
}
