import 'dart:io';
import 'package:clique/screens/navigationBar/NavBar.dart';
import 'package:clique/screens/profile/MusicianProfile.dart';
import 'package:clique/screens/profile/RecruiterProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfilePicture extends StatefulWidget {
  const ChangeProfilePicture({Key? key}) : super(key: key);

  @override
  State<ChangeProfilePicture> createState() => _ChangeProfilePictureState();
}

class _ChangeProfilePictureState extends State<ChangeProfilePicture> {
  File? _profilePicture;
  String? profileUrl;
  final ImagePicker _picker = ImagePicker();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isRecruiter = false;

  Future<void> _pickProfilePicture() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _profilePicture = File(pickedFile.path);
        _saveImages();
      } else {
        print('No image selected.');
      }
    });
  }
  Future<void> _StoreProfileUrl(downloadUrl) async {
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
          } else {
            print("user doesn't exist");
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }

    if(!isRecruiter){
      try {
        final bandRef =
        FirebaseFirestore.instance.collection('Musicians').doc(currentUser?.email.toString());
        await bandRef.update({'profileUrl': downloadUrl});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("something went wrong please try again later")));
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavBar(selectedIndexNavBar: 3),
        ),
      );


    }else{
      try {
        final bandRef =
        FirebaseFirestore.instance.collection('Recruiters').doc(currentUser?.email.toString());
        await bandRef.update({'profileUrl': downloadUrl});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("something went wrong please try again later")));
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  NavBar(selectedIndexNavBar: 3),
        ),
      );


    }
  }

  Future<void> _saveImages() async {
    final List<String> imageUrls = await _uploadImages();
    print('Image URLs: $imageUrls');
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
      _StoreProfileUrl(downloadUrl);
    }
    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 13, 20, 1),
      ),
      body: Center(
        child: Container(
          width: 200.0,
          height: 200.0,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(100, 13, 20, 1)),
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: () {
              _pickProfilePicture();
            },
            child: _profilePicture == null
                ? const Center(
              child: Icon(Icons.add, size: 50),
            )
                : ClipOval(
              child: Image.file(
                _profilePicture!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
