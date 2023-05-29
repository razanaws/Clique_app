import "package:clique/screens/profile/MusicianProfile.dart";
import "package:flutter/material.dart";

import "../screens/login/resetPasswordPage.dart";
import "ChangeCoverPicture.dart";
import "ChangeProfilePicture.dart";

class SubDrawer extends StatelessWidget {
  const SubDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,

      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(100, 13, 20, 1),
      ),
      body: Container(
        width: double.infinity,
        child: Drawer(
          child: Material(
            color: Colors.black,
            child: ListView(
              padding: EdgeInsets.zero,
              children:  [
                const SizedBox(height: 100,),

                buildMenuItem(
                    text:'Change Password',
                    icon:Icons.lock,
                    onClicked: ()=>selectedItem(context,0)),

                const SizedBox(height: 10,),
                const Divider(color: Colors.white,height: 5,),

                buildMenuItem(
                    text:'Edit Profile Picture',
                    icon:Icons.image,
                    onClicked: ()=>selectedItem(context,1)),

                const SizedBox(height: 10,),
                const Divider(color: Colors.white,height: 5,),


                buildMenuItem(
                    text:'Edit Cover Photo',
                    icon:Icons.gradient,
                    onClicked: ()=>selectedItem(context,2)),

                const SizedBox(height: 10,),
                const Divider(color: Colors.white,height: 5,),



              ],
            ),
          ),

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
          MaterialPageRoute(builder: (context)=>ResetPasswordPage()));
      break;

      case 1:Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>ChangeProfilePicture()));
      break;

      case 2:Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>ChangeCoverPicture()));
      break;


    }
  }


}
