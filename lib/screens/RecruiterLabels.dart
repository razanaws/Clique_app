import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat/ReceiverMusicianProfile.dart';

class RecruiterLabels extends StatefulWidget {
  const RecruiterLabels({Key? key}) : super(key: key);

  @override
  State<RecruiterLabels> createState() => _RecruiterLabelsState();
}

class _RecruiterLabelsState extends State<RecruiterLabels> {
  Stream<QuerySnapshot> profilesStream = const Stream<QuerySnapshot>.empty();

  fetchProfiles() async {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentUserEmail != null) {
      profilesStream = FirebaseFirestore.instance
          .collection("Musicians")
          .where("recruiterId", isEqualTo: currentUserEmail)
          .snapshots();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfiles();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      body: StreamBuilder<QuerySnapshot>(
        stream: profilesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final profiles = snapshot.data?.docs;
            return ListView.builder(
              itemCount: profiles?.length ?? 0,
              itemBuilder: (context, index) {
                final musicianEmail = profiles?[index].id;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromRGBO(100, 13, 20, 1),
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          musicianEmail ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20, // Adjust the font size as desired
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReceiverMusicianProfile(
                              receiverEmail: musicianEmail ?? '',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );


              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
