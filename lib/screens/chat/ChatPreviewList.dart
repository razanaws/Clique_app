import 'package:clique/screens/chat/ChatInstances.dart';
import 'package:clique/screens/chat/ChatModel.dart';
import 'package:flutter/material.dart';

import 'ConversationList.dart';
class ChatPreviewList extends StatefulWidget {
  const ChatPreviewList({Key? key}) : super(key: key);

  @override
  State<ChatPreviewList> createState() => _ChatPreviewListState();
}

class _ChatPreviewListState extends State<ChatPreviewList> {


  List<ChatUsers> chatUsers = [
    ChatUsers(name: "Jenna A.", messageText: "Hey", image: "images/userImage1.jpg", time: "Now", ),
    ChatUsers(name: "Perla M.", messageText: "That's Great", image: "images/userImage2.jpeg", time: "Yesterday"),
    ChatUsers(name: "Deandra R.", messageText: "Hey, where are you?", image: "images/userImage3.jpeg", time: "31 Mar"),
    ChatUsers(name: "Ron M.", messageText: "Busy! Call me in 20 mins", image: "images/userImage4.jpeg", time: "28 Mar"),
    ChatUsers(name: "Reese H.", messageText: "Thank you, It's awesome", image: "images/userImage5.jpeg", time: "23 Mar"),
    ChatUsers(name: "Jacob R.", messageText: "Will update you in the evening", image: "images/userImage6.jpeg", time: "17 Mar"),
    ChatUsers(name: "Dennis A.", messageText: "Can you please share the file?", image: "images/userImage7.jpeg", time: "24 Feb"),
    ChatUsers(name: "Ellie W.", messageText: "How are you?", image: "images/userImage8.jpeg", time: "18 Feb"),
  ];


  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: chatUsers.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
        return ConversationList(
          name: chatUsers[index].name,
          messageText: chatUsers[index].messageText,
          image: chatUsers[index].image,
          time: chatUsers[index].time,
          isMessageRead: (index == 0 || index == 3)?true:false,
        );
      },
    );
  }


  }
  void selectedItem(BuildContext context, int index){
    Navigator.of(context).pop;
    switch(index){
      case 0:Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>const ChatInstance0()));
      break;
    }
  }








