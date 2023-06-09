import 'package:clique/screens/bands/BandProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bands extends StatefulWidget {
  const Bands({Key? key}) : super(key: key);

  @override
  State<Bands> createState() => _BandsState();
}

class _BandsState extends State<Bands> {
  late Stream<QuerySnapshot> bandsStream;

  @override
  void initState() {
    super.initState();
    bandsStream = const Stream<QuerySnapshot>.empty();
    fetchBands();
  }

  Future<void> fetchBands() async {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentUserEmail != null) {
      bandsStream = FirebaseFirestore.instance
          .collection('bands')
          .where('members', arrayContains: currentUserEmail)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      body: StreamBuilder<QuerySnapshot>(
        stream: bandsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final bands = snapshot.data?.docs;

          if (bands == null || bands.isEmpty) {
            return Center(
              child: Text('No bands found.'),
            );
          }

          return ListView.builder(
            itemCount: bands.length,
            itemBuilder: (context, index) {
              final band = bands[index].data() as Map<String, dynamic>;
              final bandName = band['name'] ?? '';
              final bandId = bands[index].id;

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: const Color.fromRGBO(100, 20, 30, 1),
                  child: ListTile(
                    title: Text(
                      bandName.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BandProfile(
                              bandId: bandId,
                              band: band,
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        CupertinoIcons.arrow_right_circle_fill,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
