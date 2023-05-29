class ChatModel {
  var docId;
  var sender;
  var receiver;
  var message;
  var timestamp;
  var profileUrl;
  var otherUserName;

  ChatModel({ required  this.docId, required this.sender,
    required this.receiver, required this.message,
    required this.timestamp, this.profileUrl, this.otherUserName});
}
