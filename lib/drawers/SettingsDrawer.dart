import 'package:clique/database/loginForm.dart';
import 'package:clique/screens/profile/MusicianProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/createBand/CreateBand.dart';
import '../screens/privacyPolicy/PrivacyPolicy.dart';
import 'SettingsSubDrawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  late bool isRecruiter = false;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  logoutUser(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Redirect or show login screen
    } catch (e) {
      print('Error occurred while logging out: $e');
      return false;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
  }

  Future fetchUserInfo() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final userSnapshot = await firestore
          .collection('Musicians')
          .doc(currentUser?.email.toString())
          .get();
      if (userSnapshot.exists) {
        setState(() {
          isRecruiter = false;
        });
        return true;
      } else {
        try {
          final secondUserSnapshot = await firestore
              .collection('Recruiters')
              .doc(currentUser?.email.toString())
              .get();

          if (secondUserSnapshot.exists) {
            setState(() {
              isRecruiter = true;
            });
            return true;
          } else {
            print("user doesn't exist");
            return "user doesn't exist";
          }
        } catch (e) {
          print(e);
          return e;
        }
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Material(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text(
                  "Settings",
                  style: TextStyle(
                    backgroundColor: Colors.black,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            buildMenuItem(
              text: 'Edit Personal Information',
              icon: Icons.person,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.white,
              height: 5,
            ),
            buildMenuItem(
              text: 'Privacy and Security Policy',
              icon: Icons.shield,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(
              height: 10,
            ),
            if (!isRecruiter)
              const Divider(
              color: Colors.white,
              height: 5,
            ),
            if (!isRecruiter) // Only show if not a recruiter
              buildMenuItem(
                text: 'Create A Band',
                icon: Icons.add_circle,
                onClicked: () => selectedItem(context, 2),
              ),
            if (!isRecruiter)
            const SizedBox(
              height: 10,
            ),
            if (!isRecruiter)
            const Divider(
              color: Colors.white,
              height: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.white,
              height: 5,
            ),
            buildMenuItem(
              text: 'Log out',
              icon: Icons.logout,
              onClicked: () => selectedItem(context, 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop;
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SubDrawer()));
        break;

      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PrivacyPolicy()));
        break;

      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CreateBand()));
        break;

      case 3:
        logoutUser(context);
        break;
    }
  }
}
