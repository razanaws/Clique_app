import 'package:clique/screens/chat/ChatAfterSwiping.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("user doesn't exit")));
            print("user doesn't exist");
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error occurred")));
          print(e);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error occurred")));
      print(e);
    }
    return isRecruiter;
  }

  Future<void> fetchChat() async {
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

            setState(() {
              chatModels.add(chatModel);
            });
          }
        }
      }
    }
  }

  Future<String?> fetchProfileUrl(String receiverEmail) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('Musicians')
          .doc(receiverEmail)
          .get();
      if (userSnapshot.exists) {
        String? profileUrl = userSnapshot.data()?['profileUrl'];
        return profileUrl;
      } else {
        final secondUserSnapshot = await FirebaseFirestore.instance
            .collection('Recruiters')
            .doc(receiverEmail)
            .get();

        if (secondUserSnapshot.exists) {
          String? profileUrl = secondUserSnapshot.data()?['profileUrl'];
          return profileUrl;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error occurred")));
      print(e);
    }

    return null;
  }

  Future<void> refreshChat() async {
    setState(() {
      chatModels.clear();
    });
    await fetchChat();
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo().then((isRecruiter) {
      fetchChat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 13, 20, 1),
        title: Text('Chat List'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshChat,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatModels.length,
        itemBuilder: (BuildContext context, int index) {
          var chatModel = chatModels[index];

          return ListTile(
            title: Text(
              chatModel.otherUserName!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              chatModel.message!,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Text(
              chatModel.timestamp.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatAfterSwiping(
                    profileName: chatModel.receiver!,
                    profileImage: chatModel.profileUrl!,
                    currentUserEmail: currentUserEmail!,
                    otherUserEmail: chatModel.otherUserName!,
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
