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

  Future<void> _loadImages(model) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final bandRef =
      FirebaseFirestore.instance.collection('Musicians')
          .doc(currentUser?.email.toString());
      final bandDoc = await bandRef.get();
      final data = bandDoc.data() as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          model.profileUrl = data['profileUrl'];
          model.coverUrl = data['coverUrl'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Something went wrong. Please try again later.")),
      );
    }
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
        _loadImages(model);
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
        child: FutureBuilder<RecruitersModel?>(
            future: recruiterFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Text('User not found.'); // Show appropriate message if user not found
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
                            //TODO CALL UPLOAD METHOD
                              child: Text(
                                  'Click here to upload a cover photo'))
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
                                            text:  recruiter.location,
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
                                        recruiter.bio,
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
                                        children: recruiter.genres.map((genre) {
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
                                        children: recruiter.requirements.map((instrument) {
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
                                                  image: NetworkImage(recruiter.profileLink),
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
                                              children: [
                                                Text(
                                                  recruiter.name,
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



/*
class MultiSelectChipGenres extends StatefulWidget {
  final List<String> genreList;

  MultiSelectChip(this.genresList, {this.onSelectionChanged,this.canSelect = true});

  @override
  _MultiSelectChipStateGenres createState() => _MultiSelectChipStateGenres();
}

class MultiSelectChipInstruments extends StatefulWidget {
  final List<String> genreList;



  MultiSelectChip(this.genresList, {this.onSelectionChanged,this.canSelect = true});

  @override
  _MultiSelectChipStateInstruments createState() => _MultiSelectChipStateInstruments();
}



class _MultiSelectChipStateGenres extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.genresList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(3.0),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          label: Container(
              width: MediaQuery.of(context).size.width / 4.2,
              child: Text(
                item,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: selectedChoices.contains(item)
                        ? Colors.white
                        : Colors.black,
                    fontSize: 9),
              )),
          selected: selectedChoices.contains(item),
          selectedColor: Color.fromRGBO(100, 13, 20, 1),
          onSelected: (selected) {
            setState(() {
              if(widget.canSelect) {
                selectedChoices.contains(item)
                    ? selectedChoices.remove(item)
                    : selectedChoices.add(item);

                widget.onSelectionChanged!(selectedChoices);
              }
            });
          },
        ),
      ));
    });
    return choices;
  }





  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Wrap(
          children: _buildChoiceList(),
        )
      ],
    );
  }
}
class _MultiSelectChipStateInstruments extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.instrumentsList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(3.0),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          label: Container(
              width: MediaQuery.of(context).size.width / 4.2,
              child: Text(
                item,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: selectedChoices.contains(item)
                        ? Colors.white
                        : Colors.black,
                    fontSize: 9),
              )),
          selected: selectedChoices.contains(item),
          selectedColor: Color.fromRGBO(100, 13, 20, 1),
          onSelected: (selected) {
            setState(() {
              if(widget.canSelect) {
                selectedChoices.contains(item)
                    ? selectedChoices.remove(item)
                    : selectedChoices.add(item);

                widget.onSelectionChanged!(selectedChoices);
              }
            });
          },
        ),
      ));
    });
    return choices;
  }





  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Wrap(
          children: _buildChoiceList(),
        )
      ],
    );
  }
}

*/

