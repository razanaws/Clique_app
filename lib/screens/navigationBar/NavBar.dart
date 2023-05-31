import 'package:clique/screens/bands/bands.dart';
import 'package:clique/drawers/SettingsDrawer.dart';
import 'package:clique/screens/chat/ChatsLists.dart';
import 'package:clique/screens/profile/MusicianProfile.dart';
import 'package:clique/screens/profile/RecruiterProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../RecruitingList/RecruiterLabels.dart';
import '../search/Search.dart';
import '../swipingCards/homepage.dart';

class NavBar extends StatefulWidget {
  int selectedIndexNavBar;
  NavBar({Key? key, required this.selectedIndexNavBar}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  late bool isRecruiter = false;
  late var Profile;

  List<Widget> pages = const <Widget>[];

  Future fetchUserInfo() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final userSnapshot = await firestore
          .collection('Musicians')
          .doc(currentUser?.email.toString())
          .get();
      if (userSnapshot.exists) {
        isRecruiter = false;
        return true;
      } else {
        try {
          final secondUserSnapshot = await firestore
              .collection('Recruiters')
              .doc(currentUser?.email.toString())
              .get();

          if (secondUserSnapshot.exists) {
            isRecruiter = true;
            return true;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("user doesn't exit")));
            print("user doesn't exist");
            return "user doesn't exist";
          }
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Error occurred")));
          print(e);
          return e;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error occurred")));
      print(e);
      return e;
    }
  }

  CreateList() async {
    if (isRecruiter) {
      pages = <Widget>[
        Homepage(),
        ChatLists(),
        RecruiterLabels(),
        RecruiterProfile()
      ];
    } else {
      pages = <Widget>[Homepage(), ChatLists(), Bands(), MusicianProfile()];
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo().then((value) {
      if (value == true) {
        setState(() {
          CreateList();
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("user doesn't exist")));
      }
    });
  }

  void search() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      body: IndexedStack(
        index: widget.selectedIndexNavBar,
        children: pages,
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white70,
            activeColor: const Color.fromRGBO(120, 13, 20, 1),
            tabBackgroundColor: Colors.grey,
            padding: const EdgeInsets.all(10),
            gap: 4,
            selectedIndex: widget.selectedIndexNavBar,
            onTabChange: (index) {
              setState(() {
                widget.selectedIndexNavBar = index;
              });
            },
            tabs: [
              const GButton(
                icon: Icons.home,
                text: "Home",
              ),
              const GButton(
                icon: Icons.message,
                text: "Chat",
              ),
              isRecruiter
                  ? const GButton(
                      icon: Icons.group,
                      text: "Labeled",
                    )
                  : const GButton(
                      icon: Icons.group,
                      text: "Bands",
                    ),
              const GButton(
                icon: Icons.account_box_rounded,
                text: "Profile",
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: search,
          ),
        ],
      ),
      drawer: SettingsDrawer(),
    );
  }
}
