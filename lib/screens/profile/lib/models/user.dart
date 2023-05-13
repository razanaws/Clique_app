// TODO Implement this library.

import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;
  final String location;


  Users({
    required this.uid,
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.displayName,
    required this.bio,
    required this.location,

  });

  factory Users.fromDocument(DocumentSnapshot doc) {
    return Users(
      uid: doc['uid'],
      email: doc['email'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
      bio: doc['bio'],
      location:doc['location'],
    );
  }
}