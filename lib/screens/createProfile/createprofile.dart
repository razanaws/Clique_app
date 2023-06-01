import 'dart:io';
import 'package:clique/database/loginForm.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clique/models/user.dart';



class CreateProfile extends StatefulWidget {
  final user User;
  const CreateProfile({required this.User});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  File? _profilePicture;
  File? _coverPhoto;
  List<String> _instruments = [];
  List<String> _genres = [];
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  TextEditingController bioController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController instrumentsController = TextEditingController();
  TextEditingController genresController = TextEditingController();

  String? _validateTalents(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your talents';
    }

    final regex = RegExp(r'^[a-zA-Z]+\s?(,\s?[a-zA-Z]+)*$');
    if (!regex.hasMatch(value)) {
      return 'Invalid format. Only talents separated by commas are allowed';
    }

    return null;
  }

  String? _validateGenres(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your genres';
    }

    final regex = RegExp(r'^[a-zA-Z]+\s?(,\s?[a-zA-Z]+)*$');
    if (!regex.hasMatch(value)) {
      return 'Invalid format. Only genres separated by commas are allowed';
    }

    return null;
  }


   _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _instruments = instrumentsController.text.replaceAll(' ', '').split(',');
        _genres = genresController.text.replaceAll(' ', '').split(',');

      });

      try {
        CollectionReference users = FirebaseFirestore.instance.collection('Musicians');
        await users.doc(widget.User.email).update({
          'bio': bioController.text.trim(),
          'location' : locationController.text.trim(),
          'instruments' : _instruments,
          'genres': _genres,
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("something went wrong please try again later")));
            return false;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );

    }
  }

  @override
  void dispose() {
    instrumentsController.dispose();
    super.dispose();
  }

  Future<void> _StoreProfileUrl(downloadUrl) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('Musicians');
      await users.doc(widget.User.email).update({
        'profileUrl': downloadUrl
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("something went wrong please try again later")));
    }

  }

  Future<void> _StorCoverUrl(downloadUrl) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('Musicians');
      await users.doc(widget.User.email).update({
        'coverUrl': downloadUrl
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("something went wrong please try again later")));
    }

  }


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

  Future<void> _pickCoverPhoto() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _coverPhoto = File(pickedFile.path);
        _saveImages();
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
      _StoreProfileUrl(downloadUrl);

    }
    if (_coverPhoto != null) {
      final Reference ref = storage
          .ref()
          .child('cover_photos/${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = ref.putFile(_coverPhoto!);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
      _StorCoverUrl(downloadUrl);

    }
    return imageUrls;
  }

  Future<void> _saveImages() async {
    final List<String> imageUrls = await _uploadImages();
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
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: <Widget>[
                InkWell(
                  child: Container(
                    width: width,
                    height: height * 0.3,
                    color: Colors.grey,
                    child: _coverPhoto == null
                        ? const Center(
                            child: Text('Click here to upload a cover photo'))
                        : Image.file(
                            _coverPhoto!,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                  ),
                  onTap: () {
                    _pickCoverPhoto();
                  },
                ),
                SizedBox(height: 100),
                
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Tell us more about you ${widget.User.name}",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              validator: (value){
                                if (value!.isEmpty) {
                                  return 'Please enter a bio';
                                }
                              },
                              style: TextStyle(color: Colors.white70),
                              maxLines: null,
                              controller: bioController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(30.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: Colors.white), // Set enabled border color
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: Colors.white), // Set focused border color
                                ),

                                label: const Text("About you",
                                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                hintStyle: const TextStyle(color: Colors.white70),
                                fillColor: Colors.grey,
                                labelStyle: TextStyle(color: Colors.black),
                                filled: false,

                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Where can people find you?",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              style: TextStyle(color: Colors.white70),
                              validator: (value){
                                if (value!.isEmpty) {
                                  return 'Please enter your location';
                                }
                              },
                              maxLines: 1,
                              controller: locationController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: Colors.white), // Set enabled border color
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: Colors.white), // Set focused border color
                                ),

                                label: const Text("Your Location",
                                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                hintStyle: const TextStyle(color: Colors.white70),
                                fillColor: Colors.grey,
                                labelStyle: TextStyle(color: Colors.black),
                                filled: false,

                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Tell us more about your instruments\n         seperated by a comma",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              validator: _validateTalents,
                              style: TextStyle(color: Colors.white70),
                              maxLines: 1,
                              controller: instrumentsController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: Colors.white), // Set enabled border color
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: Colors.white), // Set focused border color
                                ),

                                label: const Text("Talent1, talent2, talent3",
                                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                hintStyle: const TextStyle(color: Colors.white70),
                                fillColor: Colors.grey,
                                labelStyle: TextStyle(color: Colors.black),
                                filled: false,

                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "What genres are you interested in?\n       seperated by a comma",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              validator: _validateGenres,
                              style: TextStyle(color: Colors.white70),
                              maxLines: 1,
                              controller: genresController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: Colors.white), // Set enabled border color
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: Colors.white), // Set focused border color
                                ),

                                label: const Text("Genre1, Genre2, Genre3",
                                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                hintStyle: const TextStyle(color: Colors.white70),
                                fillColor: Colors.grey,
                                labelStyle: TextStyle(color: Colors.black),
                                filled: false,

                              ),
                            ),
                          ),
                        ),


                        SizedBox(height: 16.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(100, 13, 20, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          onPressed: _submitForm,
                          child: Text(
                              'Create profile',
                            style: TextStyle(
                              fontSize: 17
                            ),
                          ),
                        ),

                      ],
                    ),

                  ),
                ),

              ],
            ),
            Positioned(
              //(background container size) - (circle height / 2)
              top: (height * 0.3) - (120 / 2),
              right: width * 0.67,
              child: InkWell(
                child: Container(
                  height: 120.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color.fromRGBO(100, 13, 20, 1)),
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: _profilePicture == null
                      ? const Center(child: const Icon(Icons.add, size: 30))
                      : ClipOval(
                        child: Image.file(
                            _profilePicture!,
                            fit: BoxFit.cover,
                          ),
                      ),
                ),
                onTap: () {
                  _pickProfilePicture();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
