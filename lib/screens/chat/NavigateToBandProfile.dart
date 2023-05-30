import 'package:clique/screens/bands/BandProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NavigateToBandProfile extends StatefulWidget {
  final String? bandName;
  const NavigateToBandProfile({required this.bandName});

  @override
  State<NavigateToBandProfile> createState() => _NavigateToBandProfileState();
}
class _NavigateToBandProfileState extends State<NavigateToBandProfile> {
  String? bandId;
  late final Map<String, dynamic> band;

  fetchBandProfile() async {

    final snapshot = await FirebaseFirestore.instance
        .collection("bands")
        .where("name", isEqualTo: widget.bandName)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final bandData = snapshot.docs.first.data();

      setState(() {
        bandId = snapshot.docs.first.id;
        band = bandData;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    fetchBandProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (bandId == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return BandProfile(bandId: bandId!, band: band);
    }
  }
}
