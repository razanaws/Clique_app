import 'dart:io';

import 'package:clique/screens/createProfile/welcomepage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  File? _profilePicture;
  File? _coverPhoto;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfilePicture() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _profilePicture = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _pickCoverPhoto() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _coverPhoto = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<List<String>> _uploadImages() async {
    final List<String> imageUrls = [];
    final FirebaseStorage storage = FirebaseStorage.instance;
    if (_profilePicture != null) {
      final Reference ref = storage
          .ref()
          .child('profile_pictures/${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = ref.putFile(_profilePicture!);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    if (_coverPhoto != null) {
      final Reference ref = storage
          .ref()
          .child('cover_photos/${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = ref.putFile(_coverPhoto!);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    return imageUrls;
  }

  Future<void> _saveImages() async {
    final List<String> imageUrls = await _uploadImages();
    // TODO: Save the image URLs to Firebase Firestore or Realtime Database.
    print('Image URLs: $imageUrls');
  }
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 13, 20, 1),
      ),

      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: <Widget>[

              InkWell(
                child: Container(
                  child: Center(child: const Text('Click here to upload a cover photo')),
                  width: width,
                  height: height*0.3,
                  color: Colors.grey,
                ),
                onTap: (){
                  _pickCoverPhoto();
                },
              ),


            ],
          ),

          Positioned(
            //(background container size) - (circle height / 2)
            top: (height*0.3) - (120/2),
            right: width*0.67,
            child: InkWell(
              child: Container(
                height: 120.0,
                width: 120.0,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromRGBO(100, 13, 20, 1)),
                  color: Colors.grey,
                  shape: BoxShape.circle,

                ),
                child: const Icon(Icons.add, size: 30),
              ),

              onTap: (){
                _pickProfilePicture();
              },
            ),
          )
        ],

      ),

    );
  }
}
