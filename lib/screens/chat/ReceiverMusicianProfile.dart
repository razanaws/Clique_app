import 'package:clique/models/MusiciansModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiverMusicianProfile extends StatefulWidget {
  final String receiverEmail;

  const ReceiverMusicianProfile({Key? key, required this.receiverEmail})
      : super(key: key);

  @override
  State<ReceiverMusicianProfile> createState() =>
      _ReceiverMusicianProfileState();
}

class _ReceiverMusicianProfileState extends State<ReceiverMusicianProfile> {
  late Future<MusiciansModel?> musicianFuture;
  String? profileUrl;
  String? coverUrl;
  late bool isRecruiter = false;
  late bool isCurrentRecruiter = false;
  late bool isLabelled = false;

  @override
  void initState() {
    super.initState();
    musicianFuture = fetchUserInfo();
    isCurrentUserRecruiter();
  }

  Future isCurrentUserRecruiter() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final userSnapshot = await firestore
          .collection('Musicians')
          .doc(currentUser?.email.toString())
          .get();
      if (userSnapshot.exists) {
        setState(() {
          isCurrentRecruiter = false;
        });
        return true;
      } else {
        try {
          final secondUserSnapshot = await firestore
              .collection('Recruiters')
              .doc(currentUser?.email.toString())
              .get();

          if (secondUserSnapshot.exists) {
            setState(() {
              isCurrentRecruiter = true;
            });
            return true;
          } else {
            print("user doesn't exist");
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("user doesn't exist")));
            return "user doesn't exist";
          }
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Error occurred")));
          print("$e");
          return e;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error occurred")));
      print("$e");
      return e;
    }
  }

  labelAsRecruiter() async {
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentUserEmail != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference musicianRef =
          firestore.collection('Musicians').doc(widget.receiverEmail);

      await musicianRef.update({
        'recruited': true,
        'recruiterId': currentUserEmail,
      });

      DocumentReference recruiterRef =
          firestore.collection('Recruiters').doc(currentUserEmail);

      recruiterRef.update({
        'labeledMusicians': FieldValue.arrayUnion([widget.receiverEmail]),
      });

      setState(() {
        isLabelled = true;
      });
    }
  }

  Future<MusiciansModel?> fetchUserInfo() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final receiverSnapshot = await firestore
          .collection('Musicians')
          .doc(widget.receiverEmail)
          .get();

      if (receiverSnapshot.exists) {
        final receiverData = receiverSnapshot.data() as Map<String, dynamic>;
        final name = receiverData['name'] as String;
        final bio = receiverData['bio'] as String;
        final profileUrl = receiverData['profileUrl'];
        final coverUrl = receiverData['coverUrl'] as String;
        final location = receiverData['location'] as String;
        final genres = receiverData['genres'] as List;
        final instruments = receiverData['instruments'] as List;
        final recruited = receiverData['recruited'] as bool? ?? false;
        final recruiterId = receiverData['recruiterId'] as String?;

        final profileLink = (profileUrl != null) ? profileUrl as String : null;

        MusiciansModel model = MusiciansModel(
          name: name.toString(),
          profileLink: profileLink,
          coverLink: coverUrl,
          location: location,
          bio: bio,
          genres: genres,
          instruments: instruments,
          recruited: recruited,
          recruiterId: recruiterId,
        );

        model.name = name;
        model.profileLink = profileLink;
        model.coverLink = coverUrl;
        model.location = location;
        model.bio = bio;
        model.instruments = instruments;
        model.genres = genres;
        model.recruiterId = recruiterId;
        model.recruited = recruited;

        return model;
      } else {
        final secondReceiverSnapshot = await firestore
            .collection('Recruiters')
            .doc(widget.receiverEmail)
            .get();

        if (secondReceiverSnapshot.exists) {
          isRecruiter = true;
          final receiverData =
              secondReceiverSnapshot.data() as Map<String, dynamic>;
          final name = receiverData['name'] as String;
          final bio = receiverData['bio'] as String;
          final profileUrl = receiverData['profileUrl'];
          final coverUrl = receiverData['coverUrl'] as String;
          final location = receiverData['location'] as String;
          final genres = receiverData['genres'] as List;
          final requirements = receiverData['requirements'] as List;

          final profileLink =
              (profileUrl != null) ? profileUrl as String : null;

          MusiciansModel model = MusiciansModel(
            name: name.toString(),
            profileLink: profileLink,
            coverLink: coverUrl,
            location: location,
            bio: bio,
            genres: genres,
            instruments: requirements,
            recruited: false,
            recruiterId: null,
          );

          model.name = name;
          model.profileLink = profileLink;
          model.coverLink = coverUrl;
          model.location = location;
          model.bio = bio;
          model.instruments = requirements;
          model.genres = genres;
          return model;
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("User not found")));
          print("User not found");
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error occurred")));
      print("$e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 13, 20, 1),
      ),
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      body: SingleChildScrollView(
        child: FutureBuilder<MusiciansModel?>(
            future: musicianFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Text(
                  'User not found.',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                );
              } else {
                final musician = snapshot.data!;
                double height = MediaQuery.of(context).size.height;
                double width = MediaQuery.of(context).size.width;

                return Column(
                  children: <Widget>[
                    Stack(alignment: Alignment.topRight, children: <Widget>[
                      Container(
                        height: height * 0.38,
                        color: const Color.fromRGBO(37, 37, 37, 1),
                        child: Center(
                          child: musician.coverLink.toString() == "null"
                              ? const Center(
                                  child: Text(
                                      'Click here to upload a cover photo'))
                              : Image.network(
                                  musician.coverLink,
                                  fit: BoxFit.fitWidth,
                                  height: height * 0.3,
                                  width: width,
                                ),
                        ),
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
                                  color: const Color.fromRGBO(100, 13, 20, 1)),
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: musician.profileLink == null
                                ? const Center(
                                    child: const Icon(Icons.add, size: 30))
                                : ClipOval(
                                    child: Image.network(
                                      musician.profileLink!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      )
                    ]),
                    Container(
                      color: const Color.fromRGBO(37, 37, 37, 1),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  musician.name,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 25,
                                  ),
                                ),
                                musician.recruited != null &&
                                            musician.recruited ||
                                        isLabelled
                                    ? const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      )
                                    : const Text(""),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.05),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                            text: "  ${musician.location}",
                                            style: TextStyle(fontSize: 17))
                                      ]),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        musician.bio,
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
                                        children: musician.genres.map((genre) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
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
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: isRecruiter == true
                                            ? Text(
                                                "Requirements",
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              )
                                            : Text(
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
                                        children: musician.instruments
                                            .map((instrument) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
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
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                if (!isRecruiter &&
                                    isCurrentRecruiter &&
                                    musician.recruited != null &&
                                    musician.recruited == false &&
                                    !isLabelled) ...[
                                  const SizedBox(height: 7),
                                  ElevatedButton(
                                    onPressed: () {
                                      labelAsRecruiter();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(100, 13, 20, 1),
                                    ),
                                    child: const Text('Label as Recruited'),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
