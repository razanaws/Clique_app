import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;
  final String location;


  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.photoUrl,
    required this.displayName,
    required this.bio,
    required this.location,

  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
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