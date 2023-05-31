import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final String currentUserEmail;
  final String otherUserEmail;

  late Stream<QuerySnapshot> _chatStream;

  ChatBloc({required this.currentUserEmail, required this.otherUserEmail})
      : super(ChatInitial()) {
    _chatStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId())
        .set({
          'participants': [currentUserEmail, otherUserEmail]..sort()
        }, SetOptions(merge: true))
        .then((_) => print('Participants field updated successfully.'))
        .catchError(
            (error) => print('Failed to update participants field: $error'));
  }

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is SendMessage) {
      yield* _mapSendMessageToState(event);
    }
  }

  Stream<ChatState> _mapSendMessageToState(SendMessage event) async* {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(getChatId())
          .collection('messages')
          .add({
        'sender': currentUserEmail,
        'receiver': otherUserEmail,
        'message': event.message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      yield SendMessageSuccess();
    } catch (e) {
      yield SendMessageFailure(error: e.toString());
    }
  }

  String getChatId() {
    List<String> emails = [currentUserEmail, otherUserEmail];
    emails.sort();
    return emails.join('_');
  }

  Stream<QuerySnapshot> getChatStream() {
    return _chatStream;
  }
}
abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  final String message;

  SendMessage({required this.message});
}

abstract class ChatState {}

class ChatInitial extends ChatState {}

class SendMessageSuccess extends ChatState {}

class SendMessageFailure extends ChatState {
  final String error;

  SendMessageFailure({required this.error});
}
