import 'package:clique/models/RecruitersModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecruiterProfile extends StatefulWidget {
  const RecruiterProfile({Key? key}) : super(key: key);

  @override
  State<RecruiterProfile> createState() => _RecruiterProfileState();
}

class _RecruiterProfileState extends State<RecruiterProfile> {
  late Future<RecruitersModel?> recruiterFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      recruiterFuture = fetchUserInfo();
    });
  }

  Future<RecruitersModel?> fetchUserInfo() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final userSnapshot = await firestore
          .collection('Recruiters')
          .doc(currentUser?.email?.toString())
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final name = userData['name'] as String;
        final bio = userData['bio'] as String;
        final profileUrl = userData['profileUrl'] as String;
        final coverUrl = userData['coverUrl'] as String;
        final location = userData['location'] as String;
        final genres = userData['genres'] as List;
        final requirements = userData['requirements'] as List;

        RecruitersModel model = RecruitersModel(
            name: name.toString(),
            profileLink: profileUrl,
            coverLink: coverUrl,
            location: location,
            bio: bio,
            genres: genres,
            requirements: requirements);

        model.name = name;
        model.profileLink = profileUrl;
        model.coverLink = coverUrl;
        model.location = location;
        model.bio = bio;
        model.requirements = requirements;
        model.genres = genres;
        return model;
      } else {
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error occurred")));
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      body: SingleChildScrollView(
        child: FutureBuilder<RecruitersModel?>(
            future: recruiterFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text(
                    'User not found.',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                );
              } else {
                final recruiter = snapshot.data!;
                double height = MediaQuery.of(context).size.height;
                double width = MediaQuery.of(context).size.width;

                return Column(
                  children: <Widget>[
                    Stack(alignment: Alignment.topRight, children: <Widget>[
                      Container(
                        height: height * 0.38,
                        color: const Color.fromRGBO(37, 37, 37, 1),
                        child: Center(
                          child: recruiter.coverLink.toString() == "null"
                              ? const Center(
                                  child: Text('upload a cover photo'))
                              : Image.network(
                                  recruiter.coverLink,
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
                            child: recruiter.profileLink == null
                                ? const Center(
                                    child: const Icon(Icons.add, size: 30))
                                : ClipOval(
                                    child: Image.network(
                                      recruiter.profileLink,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          onTap: () {
                            null;
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
                            child: Text(
                              recruiter.name,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 25,
                              ),
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
                                            text: recruiter.location,
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
                                        recruiter.bio,
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
                                        children: recruiter.genres.map((genre) {
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
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Requirements",
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
                                        children: recruiter.requirements
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
                                SizedBox(
                                  height: 7,
                                ),
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
