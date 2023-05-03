import 'package:clique/screens/Chat.dart';
import 'package:clique/screens/Notifications.dart';
import 'package:clique/screens/profile/MusicianProfile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'homepage.dart';


class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBar();
}

//https://github.com/surveshoeb/flutter-google-signin/blob/master/lib/pages/home_page.dart
//TODO:Refer back to the documentation above to link the profile info to the homepage,similar to the hi message
class _NavBar extends State<NavBar> {

  int selectedIndexNavBar=0;
  static const List<Widget> pages = <Widget>[
    Homepage(),
    Chat(),
    Notifications(),
    MusicianProfile(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      appBar: AppBar(
      ),
      body: IndexedStack(index: selectedIndexNavBar,children:pages,),
      bottomNavigationBar: Container(

        color:Colors.black,
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),

          child: GNav(
            backgroundColor: Colors.black ,
            color: Colors.white70,
            activeColor:  const Color.fromRGBO(120, 13, 20, 1),
            tabBackgroundColor: Colors.grey,
            padding: const EdgeInsets.all(10),
            gap: 4,
            selectedIndex: selectedIndexNavBar,
            onTabChange: (index) {
              setState(() {
                selectedIndexNavBar = index;
              });
            }, tabs:  const [
            GButton(icon:Icons.home,text: "Home",),
            GButton(icon:Icons.message,text: "Chat",),
            GButton(icon:Icons.notifications,text: "Notifications",),
            GButton(icon:Icons.account_box_rounded,text: "Profile",),
          ],


          ),
        ),
      ),
    );


  }
}

