//import 'package:flutter/cupertino.dart';
import 'package:clique/models/MusiciansModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MusicianProfile extends StatefulWidget {
  const MusicianProfile({Key? key}) : super(key: key);

  @override
  State<MusicianProfile> createState() => _MusicianProfileState();
}

class _MusicianProfileState extends State<MusicianProfile> {
  late Future<MusiciansModel?> musicianFuture;
  String? profileUrl;
  String? coverUrl;
  late bool isLabelled = false;
  late String? recruiterId = "no recruiter";

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    musicianFuture = fetchUserInfo();
    initializeIsLabelled();
  }

  void initializeIsLabelled() async {
    bool fetchedIsLabelled = await getIsLabeled();
    setState(() {
      isLabelled = fetchedIsLabelled;
    });
  }

  Future<bool> getIsLabeled() async {
    bool Labelled = false;
    final snapshot = await FirebaseFirestore.instance.collection("Musicians")
        .doc(currentUser?.email.toString()).get();

    if(snapshot.exists){
      final userData = snapshot.data() as Map<String, dynamic>;
      Labelled = userData['recruited'] as bool? ?? false;
      recruiterId = userData['recruiterId'] as String?;

    }
    return Labelled;
  }

  Future<MusiciansModel?> fetchUserInfo() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final userSnapshot = await firestore
          .collection('Musicians')
          .doc(currentUser?.email.toString())
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final name = userData['name'] as String;
        final bio = userData['bio'] as String;
        final profileUrl = userData['profileUrl'] as String;
        final coverUrl = userData['coverUrl'] as String;
        final location = userData['location'] as String;
        final genres = userData['genres'] as List;
        final instruments = userData['instruments'] as List;
        final recruited = userData['recruited'] as bool;
        final recruiterId = userData['recruiterId'] as String?;

        MusiciansModel model = MusiciansModel(
            name: name.toString(),
            profileLink: profileUrl,
            coverLink: coverUrl,
            location: location,
            bio: bio,
            genres: genres,
            instruments: instruments,
            recruited: recruited,
            recruiterId:recruiterId
        );

        model.name = name;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      body: SingleChildScrollView(
        child: FutureBuilder<MusiciansModel?>(
            future: musicianFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Text('User not found.'); // Show appropriate message if user not found
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
                                  //TODO CALL UPLOAD METHOD
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
                          onTap: () {
                            //_pickProfilePicture();
                          },
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
                                musician.recruited != null && musician.recruited || isLabelled?
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ): const Text(""),
                              ],
                            ),
                          ),

                          SizedBox(height: height * 0.05),

                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              children: [
                                //TODO: location
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
                                //TODO: bio
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
                                SizedBox(height: 7,),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0, top: 1.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(10.0),
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
                                        children: musician.instruments.map((instrument) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(10.0),
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

                                SizedBox(height: 7,),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 240.0),
                                      child: Column(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 60.0,
                                            width: 60.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                              image: DecorationImage(
                                                image: NetworkImage(musician.profileLink!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 2.0),
                                            child: Row(
                                              children:  [
                                                Text(
                                                  musician.name,
                                                  style: TextStyle(
                                                      color: Colors.white70),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 2.0),
                                            child: Row(
                                              children: const [
                                                Text(
                                                  "2d ago",
                                                  style: TextStyle(
                                                      color: Colors.white70),
                                                )
                                              ], //TODO: time-postTime
                                            ),
                                          ),
                                          SizedBox(height: 7,),
                                          Center(
                                            child: Row(children: [
                                              Image.asset(
                                                "images/splashingDrums.png",
                                                fit: BoxFit.fill,
                                                height: height * 0.3,
                                                width: width * 0.8,
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // TODO: Profile image
                  ],
                );
              }
            }),
      ),
    );
  }
}
