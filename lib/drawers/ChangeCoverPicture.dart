import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "../screens/navigationBar/NavBar.dart";

class ChangeCoverPicture extends StatefulWidget {
  const ChangeCoverPicture({Key? key}) : super(key: key);

  @override
  State<ChangeCoverPicture> createState() => _ChangeCoverPictureState();
}

class _ChangeCoverPictureState extends State<ChangeCoverPicture> {
  File? _coverPicture;
  final ImagePicker _picker = ImagePicker();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isRecruiter = false;

  Future<void> _pickCoverPicture() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _coverPicture = File(pickedFile.path);
        _saveImages();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _StoreCoverUrl(downloadUrl) async {
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
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error occurred")));
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error occurred")));
    }

    if (!isRecruiter) {
      try {
        final bandRef = FirebaseFirestore.instance
            .collection('Musicians')
            .doc(currentUser?.email.toString());
        await bandRef.update({'coverUrl': downloadUrl});
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
    } else {
      try {
        final bandRef = FirebaseFirestore.instance
            .collection('Recruiters')
            .doc(currentUser?.email.toString());
        await bandRef.update({'coverUrl': downloadUrl});
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
    }
  }

  Future<void> _saveImages() async {
    final List<String> imageUrls = await _uploadImages();
    print('Image URLs: $imageUrls');
  }

  Future<List<String>> _uploadImages() async {
    final List<String> imageUrls = [];
    final FirebaseStorage storage = FirebaseStorage.instance;

    if (_coverPicture != null) {
      final Reference ref = storage
          .ref()
          .child('cover_pictures/${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = ref.putFile(_coverPicture!);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
      _StoreCoverUrl(downloadUrl);
    }
    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 13, 20, 1),
      ),
      body: Container(
        child: Column(
          children: [
            InkWell(
              child: Container(
                width: width,
                height: height * 0.3,
                color: Colors.grey,
                child: _coverPicture == null
                    ? const Center(
                        child: Text('Click here to change the cover photo'))
                    : Image.file(
                        _coverPicture!,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
              ),
              onTap: () {
                _pickCoverPicture();
              },
            ),
          ],
        ),
      ),
    );
  }
}
