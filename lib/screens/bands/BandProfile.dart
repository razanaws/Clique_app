import 'dart:io';
import 'package:clique/models/BandsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BandProfile extends StatefulWidget {
  final String? bandId;
  final Map<String, dynamic> band;

  BandProfile({
    required this.bandId,
    required this.band,
  });

  @override
  State<BandProfile> createState() => _BandProfileState();
}

class _BandProfileState extends State<BandProfile> {
  late Future<BandsModel?> bandFuture;

  Map<String, dynamic>? band;
  File? _profilePicture;
  File? _coverPhoto;
  String? profileUrl;
  String? coverUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    band = widget.band;
    bandFuture = fetchUserInfo();
    _loadImages();
  }

  Future<BandsModel?> fetchUserInfo() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final userSnapshot =
          await firestore.collection('bands').doc(widget.bandId).get();

      if (userSnapshot.exists) {
          final userData = userSnapshot.data() as Map<String, dynamic>;
          final bio = userData['bio'] as String;
          final profileUrl = userData['profileUrl'] as String;
          final coverUrl = userData['coverUrl'] as String;
          final location = userData['location'] as String;
          final genres = userData['genres'] as List;
          final instruments = userData['instruments'] as List;

          BandsModel model = BandsModel(
              profileLink: profileUrl,
              coverLink: coverUrl,
              location: location,
              bio: bio,
              genres: genres,
              instruments: instruments);

          model.profileLink = profileUrl;
          model.coverLink = coverUrl;
        model.location = location;
        model.bio = bio;
        model.instruments = instruments;
        model.genres = genres;
        return model;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _loadImages() async {
    try {
      final bandRef =
          FirebaseFirestore.instance.collection('bands').doc(widget.bandId);
      final bandDoc = await bandRef.get();
      final data = bandDoc.data() as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          profileUrl = data['profileUrl'];
          coverUrl = data['coverUrl'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Something went wrong. Please try again later.")),
      );
    }
  }

  Future<void> _StoreProfileUrl(downloadUrl) async {
    try {
      final bandRef =
          FirebaseFirestore.instance.collection('bands').doc(widget.bandId);
      await bandRef.update({'profileUrl': downloadUrl});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("something went wrong please try again later")));
      return;
    }
    _loadImages();
  }

  Future<void> _StorCoverUrl(downloadUrl) async {
    try {
      final bandRef =
          FirebaseFirestore.instance.collection('bands').doc(widget.bandId);
      await bandRef.update({'coverUrl': downloadUrl});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("something went wrong please try again later")));
      return;
    }
    _loadImages();
  }

  Future<void> _pickProfilePicture() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        _profilePicture = File(pickedFile.path);
        _saveImages();
        _loadImages();
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
        _loadImages();
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
    final bandName = band?['name'] ?? '';
    final bandMembers = band?['members'] as List<dynamic>?;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 13, 20, 1),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<BandsModel?>(
            future: bandFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Text(
                    'User not found.'); // Show appropriate message if user not found
              } else {
                final band = snapshot.data!;
                double height = MediaQuery.of(context).size.height;
                double width = MediaQuery.of(context).size.width;

                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: width,
                                height: height * 0.3,
                                color: Colors.grey,
                                child: coverUrl == null
                                    ? const Center(
                                        child: Text(
                                            'Click here to upload a cover photo'))
                                    : Image.network(
                                        coverUrl!,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              onTap: () {
                                _pickCoverPhoto();
                              },
                            ),
                            SizedBox(height: 100),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    bandName,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.05),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(children: [
                                      //TODO: location
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.pin_drop_outlined,
                                                  size: 20,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: "  ${band.location}",
                                                  style:
                                                      TextStyle(fontSize: 17))
                                            ]),
                                          ),
                                        ],
                                      ),
                                      //TODO: bio
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              band.bio,
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 2.0, top: 1.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Genres",
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Wrap(
                                              alignment: WrapAlignment.start,
                                              spacing: 6,
                                              runSpacing: 6,
                                              children:
                                                  band.genres.map((genre) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Text(
                                                    genre,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            SizedBox(height: 7),
                                            const Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Instruments",
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 7),
                                            Wrap(
                                              alignment: WrapAlignment.start,
                                              spacing: 6,
                                              runSpacing: 6,
                                              children: band.instruments
                                                  .map((instrument) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Text(
                                                    instrument,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            SizedBox(height: 7),
                                            const Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Band Members",
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Wrap(
                                              alignment: WrapAlignment.start,
                                              spacing: 6,
                                              runSpacing: 6,
                                              children: bandMembers!.map((member) {
                                                final emailParts = member.split('@');
                                                final memberName = emailParts.isNotEmpty ? emailParts.first : member;

                                                return Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  child: Text(
                                                    memberName,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: 7,
                                      ),
                                    ]),
                                  ),
                                ],
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
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(100, 13, 20, 1)),
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: profileUrl == null
                                  ? const Center(
                                      child: const Icon(Icons.add, size: 30))
                                  : ClipOval(
                                      child: Image.network(
                                        profileUrl!,
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
                  ],
                );
              }
            }),
      ),
    );


  }
}
