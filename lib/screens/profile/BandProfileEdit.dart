// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../../utils/user_preferences.dart';
// import 'lib/models/user.dart';
// import 'package:clique/screens/profile/lib/models/user.dart';
//
//
// class BandProfileEdit extends StatefulWidget {
//
//   final String currentUserId;
//    BandProfileEdit({ required this.currentUserId});
//
//   //const BandProfileEdit({Key? key}) : super(key: key);
//
//
//   @override
//   State<BandProfileEdit> createState() => _BandProfileEditState();
// }
//
// /*
// class MultiSelectChipGenres extends StatefulWidget {
//   final List<String> genreList;
//
//   MultiSelectChip(this.genresList, {this.onSelectionChanged,this.canSelect = true});
//
//   @override
//   _MultiSelectChipStateGenres createState() => _MultiSelectChipStateGenres();
// }
//
// class MultiSelectChipInstruments extends StatefulWidget {
//   final List<String> genreList;
//
//
//
//   MultiSelectChip(this.genresList, {this.onSelectionChanged,this.canSelect = true});
//
//   @override
//   _MultiSelectChipStateInstruments createState() => _MultiSelectChipStateInstruments();
// }
//
//
//
// class _MultiSelectChipStateGenres extends State<MultiSelectChip> {
//   List<String> selectedChoices = [];
//
//   _buildChoiceList() {
//     List<Widget> choices = [];
//     widget.genresList.forEach((item) {
//       choices.add(Container(
//         padding: const EdgeInsets.all(3.0),
//         child: ChoiceChip(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
//           label: Container(
//               width: MediaQuery.of(context).size.width / 4.2,
//               child: Text(
//                 item,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: selectedChoices.contains(item)
//                         ? Colors.white
//                         : Colors.black,
//                     fontSize: 9),
//               )),
//           selected: selectedChoices.contains(item),
//           selectedColor: Color.fromRGBO(100, 13, 20, 1),
//           onSelected: (selected) {
//             setState(() {
//               if(widget.canSelect) {
//                 selectedChoices.contains(item)
//                     ? selectedChoices.remove(item)
//                     : selectedChoices.add(item);
//
//                 widget.onSelectionChanged!(selectedChoices);
//               }
//             });
//           },
//         ),
//       ));
//     });
//     return choices;
//   }
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       shrinkWrap: true,
//       children: [
//         Wrap(
//           children: _buildChoiceList(),
//         )
//       ],
//     );
//   }
// }
// class _MultiSelectChipStateInstruments extends State<MultiSelectChip> {
//   List<String> selectedChoices = [];
//
//   _buildChoiceList() {
//     List<Widget> choices = [];
//     widget.instrumentsList.forEach((item) {
//       choices.add(Container(
//         padding: const EdgeInsets.all(3.0),
//         child: ChoiceChip(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
//           label: Container(
//               width: MediaQuery.of(context).size.width / 4.2,
//               child: Text(
//                 item,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: selectedChoices.contains(item)
//                         ? Colors.white
//                         : Colors.black,
//                     fontSize: 9),
//               )),
//           selected: selectedChoices.contains(item),
//           selectedColor: Color.fromRGBO(100, 13, 20, 1),
//           onSelected: (selected) {
//             setState(() {
//               if(widget.canSelect) {
//                 selectedChoices.contains(item)
//                     ? selectedChoices.remove(item)
//                     : selectedChoices.add(item);
//
//                 widget.onSelectionChanged!(selectedChoices);
//               }
//             });
//           },
//         ),
//       ));
//     });
//     return choices;
//   }
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       shrinkWrap: true,
//       children: [
//         Wrap(
//           children: _buildChoiceList(),
//         )
//       ],
//     );
//   }
// }
//
// */
//
// SnackBar CustomSnackBar(message) => SnackBar(
//   backgroundColor: Colors.black,
//   content: Text(
//     message,
//     style: TextStyle(color: Colors.white),
//   ),
// );
//
// class _BandProfileEditState extends State<BandProfileEdit> {
//   @override
//   Widget build(BuildContext context) {
//
//     double height=MediaQuery.of(context).size.height;
//     double width=MediaQuery.of(context).size.width;
//
//     final _scaffoldKey = GlobalKey<ScaffoldState>();
//
//     TextEditingController displayNameController = TextEditingController();
//     TextEditingController bioController = TextEditingController();
//     TextEditingController locationController = TextEditingController();
//
//
//     bool _displayNameValid = true;
//     bool _bioValid = true;
//
//     bool isLoading = false;
//     Users user;
//     final usersRef = FirebaseFirestore.instance.collection('users').where("displayName", isEqualTo: "${user.displayName).getDocuments().then((val)=>
//         val.documents.forEach((doc)=> {
//           doc.reference.updateData({"displayName": displayNameController})
//         }));
//
//
//
//     // final postsRef = FirebaseFirestore.instance.collection('posts');
//
//
//     /*getData() async {
//       setState(() {
//         isLoading = true;
//       });
//       try {
//         var userSnap = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(widget.currentUserId)
//             .get();
//         var postSnap = await FirebaseFirestore.instance
//             .collection('posts')
//             .where(
//           'uid',
//           isEqualTo: FirebaseAuth.instance.currentUser!.uid,
//         )
//             .get();
//
//         userData = userSnap.data()!;
//         //postLength = postSnap.docs.length;
//         //followers = userSnap.data()!['followers'].length;
//         //following = userSnap.data()!['following'].length;
//         //isFollowing = userSnap
//         // .data()!['followers']
//         // .contains(FirebaseAuth.instance.currentUser!.uid);
//         setState(() {});
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar;
//       }
//       setState(() {
//         isLoading = false;
//       });
//     }*/
//
//
//     getUser() async {
//       setState(() {
//         isLoading = true;
//       });
//       //DocumentSnapshot doc = await usersRef.doc(widget.currentUserId).get();
//       //user = usersRef.uid as User;//
//       usersRef.doc(id);
//       displayNameController.text = user.displayName!;
//       bioController.text = user.uid;
//       locationController.text=user.location;
//       setState(() {
//         isLoading = false;
//       });
//     }
//
//     @override
//     void initState() {
//       super.initState();
//       /*
//       displayNameController.addListener(() {
//         final String displayName = displayNameController.text.toLowerCase();
//         displayNameController.value = displayNameController.value.copyWith(
//           text: displayName,
//           selection:
//           TextSelection(baseOffset: displayName.length, extentOffset: displayName.length),
//           composing: TextRange.empty,
//         );
//
//         bioController.addListener(() {
//           final String bio = bioController.text.toLowerCase();
//           bioController.value = bioController.value.copyWith(
//             text: bio,
//             selection:
//             TextSelection(baseOffset: bio.length, extentOffset: bio.length),
//             composing: TextRange.empty,);
//         });
//
//         locationController.addListener(() {
//           final String location = locationController.text.toLowerCase();
//           locationController.value = locationController.value.copyWith(
//             text: location,
//             selection:
//             TextSelection(baseOffset: location.length, extentOffset: location.length),
//             composing: TextRange.empty,
//           );});
//       }
//       );*/
//       getUser();
//       //getData();
//     }
//
//
//
//
//     /*
//     @override
//     void dispose() {
//       displayNameController.dispose();
//       bioController.dispose();
//       locationController.dispose();
//
//       super.dispose();
//     }*/
//
//     //validate bio, displayName
//     updateProfileData() {
//       setState(() {
//         displayNameController.text.trim().length < 3 ||
//             displayNameController.text.isEmpty
//             ? _displayNameValid = false
//             : _displayNameValid = true;
//         bioController.text.trim().length > 100
//             ? _bioValid = false
//             : _bioValid = true;
//       });
//
//       if (_displayNameValid && _bioValid) {
//         usersRef.doc(widget.currentUserId).updateData({
//           "displayName": displayNameController.text,
//           "bio": bioController.text,
//         });
//         SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
//         ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(snackbar),);
//       }
//     }
//
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: const Color.fromRGBO(37, 37, 37,1),
//       body: Stack(
//
//         alignment: Alignment.center,
//         children: <Widget>[
//           Column(
//
//             children: <Widget>[
//
//               //TODO: Cover Picture should be added
//               Container(
//                 height: height*0.3,
//                 color: Colors.grey,
//                 child: Center(
//                   child: Image.asset(
//                     "images/bandCover.jpg",
//                     fit: BoxFit.fitWidth,
//                     height: height*0.3,
//                     width: width,
//                   ),
//                 ),
//               ),
//
//               Expanded(
//                 //Band's name
//                 child: Container(
//                   color: const Color.fromRGBO(37, 37, 37,1),
//                   child: Column(
//                     children: [
//
//                       //TODO: Name should be added by user
//                       Padding(
//                         padding: EdgeInsets.only(top:15,left:30),
//                         child:  TextField(
//                           controller:displayNameController,
//                           decoration: InputDecoration(
//                             hintText: "Update Display Name",
//                             errorText: _displayNameValid? null: "Display Name Too Short"
//                           ),
//                           style:  TextStyle(
//                               color: Colors.white70, fontSize: 20
//                           ),
//                         ),
//
//                       ),
//
//
//                       SizedBox(height: height*0.005),
//
//                       Padding(
//                         padding: const EdgeInsets.only(left: 10),
//                         child: Column(
//                           children: [
//
//                             //TODO: location
//                             Row(
//                               mainAxisAlignment:MainAxisAlignment.start,
//                               children: [
//                                 RichText(
//                                   text:  TextSpan(
//                                     children: [
//                                       WidgetSpan(
//                                         child: Icon(
//                                           Icons.pin_drop_outlined,
//                                           size: 20,
//                                           color: Colors.white70,),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 TextField(
//                                   controller: locationController,
//                                   decoration: InputDecoration(
//                                       hintText: "Update Location",
//                                       //errorText: _locationValid? null: "Location Too Short"
//                                   ),
//                                   //style: TextStyle(fontSize: 17),
//                                 ),
//                               ],
//                             ),
//                             //TODO: bio
//                             Row(
//                               children:  [
//                                 Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: TextField(
//                                     controller:bioController,
//                                     decoration: InputDecoration(
//                                         hintText: "Update Bio",
//                                         errorText: _bioValid? null: "Bio Too Long"
//                                     ),
//                                     style: TextStyle(
//                                         color: Colors.white70,
//                                         fontSize: 17
//                                     ),
//                                   ),
//                                 ),
//
//                               ],
//                             ),
//
//                             //Genres
//                             Align(
//                               alignment: Alignment.topLeft,
//                               child: Text(
//                                 "Genres",
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w700,
//
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom:2.0,top: 1.0),
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Container(
//                                       height:25,
//                                       width: MediaQuery.of(context).size.width /5.2,
//                                       decoration:BoxDecoration(
//                                         color: Colors.grey,
//                                         border: Border.all(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ) ,
//                                       child: const Center(
//                                         child:Text(
//                                           "Rock",
//                                           style:TextStyle(
//                                             color: Colors.black,
//                                           ),
//
//                                         ),
//                                       ) ,
//
//                                     ),
//                                   ),
//
//                                   Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Container(
//                                       height:25,
//                                       width: MediaQuery.of(context).size.width /5.2,
//                                       decoration:BoxDecoration(
//                                         color: Colors.grey,
//                                         border: Border.all(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ) ,
//                                       child: const Center(
//                                         child:Text(
//                                           "Metal",
//                                           style:TextStyle(
//                                             color: Colors.black,
//                                           ),
//
//                                         ),
//                                       ) ,
//
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Container(
//                                       height:25,
//                                       width: MediaQuery.of(context).size.width /5.2,
//                                       decoration:BoxDecoration(
//                                         color: Colors.grey,
//                                         border: Border.all(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ) ,
//                                       child: const Center(
//                                         child:Text(
//                                           "Nu metal",
//                                           style:TextStyle(
//                                             color: Colors.black,
//                                           ),
//
//                                         ),
//                                       ) ,
//
//                                     ),
//                                   ),
//
//
//                                 ],
//                               ),
//                             ),
//
//
//
//                             //TODO: rock etc
//                             //Instruments
//                             Align(
//                               alignment: Alignment.topLeft,
//                               child: Text(
//                                 "Instruments",
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w700,
//
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom:2.0,top: 1.0),
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Container(
//                                       height:25,
//                                       width: MediaQuery.of(context).size.width /5.2,
//                                       decoration:BoxDecoration(
//                                         color: Colors.grey,
//                                         border: Border.all(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ) ,
//                                       child: const Center(
//                                         child:Text(
//                                           "Drums",
//                                           style:TextStyle(
//                                             color: Colors.black,
//                                           ),
//
//                                         ),
//                                       ) ,
//
//                                     ),
//                                   ),
//
//                                   Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Container(
//                                       height:25,
//                                       width: MediaQuery.of(context).size.width /5.2,
//                                       decoration:BoxDecoration(
//                                         color: Colors.grey,
//                                         border: Border.all(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ) ,
//                                       child: const Center(
//                                         child:Text(
//                                           "Bass",
//                                           style:TextStyle(
//                                             color: Colors.black,
//                                           ),
//
//                                         ),
//                                       ) ,
//
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Container(
//                                       height:25,
//                                       width: MediaQuery.of(context).size.width /5.2,
//                                       decoration:BoxDecoration(
//                                         color: Colors.grey,
//                                         border: Border.all(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ) ,
//                                       child: const Center(
//                                         child:Text(
//                                           "Vocals",
//                                           style:TextStyle(
//                                             color: Colors.black,
//                                           ),
//
//                                         ),
//                                       ) ,
//
//                                     ),
//                                   ),
//
//
//                                 ],
//                               ),
//                             ),
//
//                             //Members
//                             const Align(
//                               alignment: Alignment.topLeft,
//                               child: Text(
//                                 "Band Members",
//                                 style: TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w700,
//
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom:2.0,top: 1.0),
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Container(
//                                       height: 25,
//                                       width: MediaQuery.of(context).size.width /5.2,
//                                       decoration:BoxDecoration(
//                                         color: Colors.grey,
//                                         border: Border.all(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ) ,
//                                       child: const Center(
//                                         child:Text(
//                                           "Member",
//                                           style:TextStyle(
//                                             color: Colors.black,
//                                           ),
//
//                                         ),
//                                       ) ,
//
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Container(
//                                       height:25,
//                                       width: MediaQuery.of(context).size.width /5.2,
//                                       decoration:BoxDecoration(
//                                         color: Colors.grey,
//                                         border: Border.all(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ) ,
//                                       child: const Center(
//                                         child:Text(
//                                           "Member",
//                                           style:TextStyle(
//                                             color: Colors.black,
//                                           ),
//
//                                         ),
//                                       ) ,
//
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Container(
//                                       height:25,
//                                       width: MediaQuery.of(context).size.width /5.2,
//                                       decoration:BoxDecoration(
//                                         color: Colors.grey,
//                                         border: Border.all(
//                                           color: Colors.grey,
//                                         ),
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ) ,
//                                       child: const Center(
//                                         child:Text(
//                                           "Member",
//                                           style:TextStyle(
//                                             color: Colors.black,
//                                           ),
//
//                                         ),
//                                       ) ,
//
//                                     ),
//                                   ),
//
//
//                                 ],
//                               ),
//                             ),
//
//
//                             //Post
//                             Row(
//                               children: [
//
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom:240.0),
//                                   child: Column(
//                                     //crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         height: 60.0,
//                                         width: 60.0,
//                                         decoration: const BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colors.red,
//                                           image: DecorationImage(
//                                             image: AssetImage("images/bandProfilePicture.jpeg"),
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),)
//                                     ],
//                                   ),
//                                 ),
//
//                                 Padding(
//                                   padding: const EdgeInsets.only(left:8.0),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.only(bottom:2.0),
//                                         child: Row(
//                                           children: [
//                                             Text(
//                                               "Name",
//                                               style: TextStyle(color: Colors.white70),
//
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(bottom:2.0),
//                                         child: Row(
//                                           children: [Text(
//                                             "2d ago",
//                                             style: TextStyle(color: Colors.white70),
//                                           )],//TODO: time-postTime
//                                         ),
//                                       ),
//                                       Center(
//                                         child: Row(
//                                             children: [
//                                               Image.asset(
//                                                 "images/bandProfilePicture.jpeg",
//                                                 fit: BoxFit.fill,
//                                                 height: height*0.3,
//                                                 width: width*0.8,
//                                               ),]
//
//                                         ),
//                                       ),
//
//
//
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                           ],
//                         ),
//
//                       ),
//
//                     ],
//                   ),
//                 ),
//               )
//
//             ],
//           ),
//
//           // TODO: Profile image
//           Positioned(
//             //(background container size) - (circle height / 2)
//             top: (height*0.28) - (120/2),
//             right: width*0.67,
//             child: Container(
//               height: 120.0,
//               width: 120.0,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.red,
//                 image: DecorationImage(
//                   image: AssetImage("images/bandProfilePicture.jpeg"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//
//           ElevatedButton(
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(
//                   const Color.fromRGBO(100, 13, 20, 1)),
//               shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50.0))),
//             ),
//             onPressed: () {
//               updateProfileData();
//             },
//             child: const Text(
//               'Save Changes',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//
//         ],
//       ),
//     );
//
//   }
// }
