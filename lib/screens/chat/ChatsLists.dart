import 'package:clique/screens/chat/ChatAfterSwiping.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clique/screens/chat/ChatBloc.dart';
import 'package:clique/models/ChatModel.dart';

class ChatLists extends StatefulWidget {
  @override
  State<ChatLists> createState() => _ChatListsState();
}

class _ChatListsState extends State<ChatLists> {
  final String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  List<ChatModel> chatModels = [];
  List<String> otherUserEmail = [];
  String? profileUrl = "";
  String? otherUserName = "";

  Future<bool> fetchUserInfo() async {
    late bool isRecruiter;
    final currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final userSnapshot = await firestore
          .collection('Musicians')
          .doc(currentUser?.email.toString())
          .get();
      if (userSnapshot.exists) {
        setState(() {
          isRecruiter = false;
        });
        return false;
      } else {
        try {
          final secondUserSnapshot = await firestore
              .collection('Recruiters')
              .doc(currentUser?.email.toString())
              .get();

          if (secondUserSnapshot.exists) {
            setState(() {
              isRecruiter = true;
            });
            return true;
          } else {
            print("user doesn't exist");
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
    return isRecruiter;
  }

  fetchChat() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: currentUserEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      List<String> documentIds =
          querySnapshot.docs.map((doc) => doc.id).toList();

      if (documentIds.isNotEmpty) {
        for (String documentId in documentIds) {
          final messagesSnapshot = await FirebaseFirestore.instance
              .collection('chats')
              .doc(documentId)
              .collection('messages')
              .get();

          if (messagesSnapshot.docs.isNotEmpty) {
            var lastMessageDoc = messagesSnapshot.docs.last;
            var lastMessageData = lastMessageDoc.data();
            var sender = lastMessageData['sender'];
            var receiver = lastMessageData['receiver'];
            var message = lastMessageData['message'];
            var timestamp =
                (lastMessageData['timestamp'] as Timestamp).toDate();

            if (sender == currentUserEmail) {
              otherUserName = receiver;
              profileUrl = await fetchProfileUrl(receiver);
            } else {
              otherUserName = sender;
              profileUrl = await fetchProfileUrl(sender);
            }

            ChatModel chatModel = ChatModel(
              docId: documentId,
              sender: sender,
              receiver: receiver,
              message: message,
              timestamp: timestamp,
              profileUrl: profileUrl,
              otherUserName: otherUserName,
            );

            chatModels.add(chatModel);
          }
        }
      }
    }

    setState(() {});
  }

  fetchProfileUrl(String receiverEmail) async {
    print("is receiverEmail $receiverEmail");

    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('Musicians')
          .doc(receiverEmail)
          .get();
      if (userSnapshot.exists) {

        String? profileUrl = userSnapshot.data()?['profileUrl'];
        return profileUrl;
      } else {
        try {
          final secondUserSnapshot = await FirebaseFirestore.instance
              .collection('Recruiters')
              .doc(receiverEmail)
              .get();

          if (secondUserSnapshot.exists) {
            print("HEEREEEE $receiverEmail");
            print("HEEREEEE DATAA ${secondUserSnapshot.data()}");
            String? profileUrl = secondUserSnapshot.data()?['profileUrl'];
            print("HEEREEEE profileUrl $profileUrl");

            return profileUrl;
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      body: ListView.builder(
        itemCount: chatModels.length,
        itemBuilder: (BuildContext context, int index) {
          var chatModel = chatModels[index];

          return ListTile(
            title: Text(
              chatModel.otherUserName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              chatModel.message,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Text(
              chatModel.timestamp.toString(), // Format the timestamp as desired
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Navigate to ChatAfterSwiping screen when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatAfterSwiping(
                    profileName: chatModel.receiver,
                    profileImage: chatModel.profileUrl,
                    currentUserEmail: currentUserEmail!,
                    otherUserEmail: chatModel.otherUserName,
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
