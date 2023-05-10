import 'package:clique/screens/chat/ConversationList.dart';
import 'package:clique/screens/notifications/Notifications.dart';
import 'package:clique/drawers/SettingsDrawer.dart';
import 'package:clique/screens/profile/BandProfile.dart';
import 'package:clique/screens/profile/MusicianProfile.dart';
import 'package:clique/screens/profile/RecruiterProfile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../chat/ChatPreviewList.dart';
import '../swipingCards/homepage.dart';


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
    ChatPreviewList(),
    Notifications(),
    MusicianProfile(),
    //BandProfile(),
    //RecruiterProfile()
    //TODO:If the user is a different kind, they should it instead of the musicianprofile
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,

      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),

      //Navigation Bar
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





      //Drawer Menu
      appBar: AppBar(

        backgroundColor: Colors.black,
        leading: Builder(
          builder:(context) {
            return IconButton(
              icon: const Icon(Icons.settings),
              onPressed: ()=>Scaffold.of(context).openDrawer(),);
          }
        ),

      ),
      drawer: SettingsDrawer(),
    );


  }
}

