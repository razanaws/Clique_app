import 'package:clique/screens/profile/MusicianProfile.dart';
import 'package:flutter/material.dart';

import '../screens/createProfile/CreateBand.dart';
import '../screens/createProfile/ViewBands.dart';
import '../screens/login/Logout.dart';
import '../screens/privacyPolicy/PrivacyPolicy.dart';
import 'SettingsSubDrawer.dart';


class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: Colors.black ,

      child: Material(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,

          children:  [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black,),
              child: Padding(
                padding: EdgeInsets.only(top:8.0,left:8.0),
                child: Text(
                  "Settings",
                  style: TextStyle(
                    backgroundColor: Colors.black,
                    color: Colors.white,
                    fontWeight:FontWeight.bold,
                    fontSize: 30,
                  ),),
              ),
            ),

            const SizedBox(height: 30,),

            buildMenuItem(
              text:'Edit Personal Information',
              icon:Icons.person,
              onClicked: ()=>selectedItem(context,0)),

            const SizedBox(height: 10,),
            const Divider(color: Colors.white,height: 5,),

            buildMenuItem(
              text:'Privacy and Security Policy',
              icon:Icons.shield,
              onClicked: ()=>selectedItem(context,1)
            ),

            const SizedBox(height: 10,),
            const Divider(color: Colors.white,height: 5,),

            buildMenuItem(
              text:'Create A Band',
              icon:Icons.add_circle,
              onClicked: ()=>selectedItem(context,2)
    ),

            const SizedBox(height: 10,),
            const Divider(color: Colors.white,height: 5,),

            buildMenuItem(
              text:'View Bands',
              icon:Icons.groups,
              onClicked: ()=>selectedItem(context,3)),

            const SizedBox(height: 10,),
            const Divider(color: Colors.white,height: 5,),



            buildMenuItem(
              text:'Log out',
              icon:Icons.logout,
              onClicked: ()=>selectedItem(context,4)),



          ],
        ),
      ),
    );
  }


  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
      }){
        final color=Colors.white;

        return ListTile(
          leading: Icon(icon,color:color),
           title: Text(text,style: const TextStyle(color: Colors.white,)),
            onTap: onClicked,
        );

   }

    void selectedItem(BuildContext context, int index){
    Navigator.of(context).pop;
      switch(index){

        case 0:Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>SubDrawer()));
        break;

        case 1:Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>PrivacyPolicy()));
        break;
      //TODO:CreateBand functionality

        case 2:Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>CreateBand()));
        break;
      //TODO: ViewBands functionality

        case 3:Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>ViewBands()));
        break;
        //TODO:Log out page or functionality
        case 4:Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>Logout()));
        break;




      }
    }

}

