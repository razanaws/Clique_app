import 'package:clique/screens/chat/ChatBloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ReceiverMusicianProfile.dart';

class ChatAfterSwiping extends StatelessWidget {
  final String profileName;
  final String profileImage;
  final String currentUserEmail;
  final String otherUserEmail;

  ChatAfterSwiping({
    required this.profileName,
    required this.profileImage,
    required this.currentUserEmail,
    required this.otherUserEmail,
  });

  @override
  Widget build(BuildContext context) {
    final String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    final chatBloc = ChatBloc(
      currentUserEmail: currentUserEmail as String,
      otherUserEmail: otherUserEmail,
    );

    // Use a BlocBuilder to listen to chat state changes and update the UI accordingly
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: chatBloc,
      builder: (context, state) {
        if (state is SendMessageSuccess) {
          // Handle successful message sending
        } else if (state is SendMessageFailure) {
          // Handle failed message sending
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(100, 13, 20, 1),
            title: Text(
              otherUserEmail,
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                InkWell(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(profileImage),
                    radius: 50,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiverMusicianProfile(
                            receiverEmail: otherUserEmail,
                          ),
                        ));
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Chat with $otherUserEmail",
                  style: TextStyle(color: Colors.white),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: chatBloc.getChatStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> messages = snapshot.data!.docs;
                      messages.sort((a, b) => (b['timestamp'] as Timestamp).compareTo(a['timestamp'] as Timestamp));

                      return Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            String sender = messages[index]['sender'];
                            String message = messages[index]['message'];
                            bool isCurrentUser = sender == currentUserEmail;

                            return Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isCurrentUser
                                        ? const Color.fromRGBO(100, 13, 20, 1)
                                        : const Color.fromRGBO(45, 45, 45, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isCurrentUser ? "You" : sender,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        message,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            );
                          },
                        ),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),

                // Input field for sending messages
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Type a message',
                        labelStyle: TextStyle(color: Colors.white),
                        border: InputBorder
                            .none,
                      ),
                      style: const TextStyle(color: Colors.white),
                      onFieldSubmitted: (value) {
                        chatBloc.add(SendMessage(message: value));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
