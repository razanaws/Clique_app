import 'package:clique/screens/bands/bands.dart';
import 'package:clique/screens/profile/MusicianProfile.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../navigationBar/NavBar.dart';
import 'BackgroudCurveWidget.dart';
import 'CardsStackWidget.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

//https://github.com/surveshoeb/flutter-google-signin/blob/master/lib/pages/home_page.dart
//TODO:Refer back to the documentation above to link the profile info to the homepage,similar to the hi message
class _HomepageState extends State<Homepage> {

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        BackgroudCurveWidget(),
        CardsStackWidget(),
      ],
    );

  }
}
