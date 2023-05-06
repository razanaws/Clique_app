import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatInstance0 extends StatefulWidget {
  const ChatInstance0({Key? key}) : super(key: key);
  @override
  State<ChatInstance0> createState() => _ChatInstance0State();
}
class _ChatInstance0State extends State<ChatInstance0> {
  final webViewController = WebViewController()
    ..loadRequest(Uri.parse('http://deadsimplechat.com/DEp-EWR0b'))
    ..setJavaScriptMode(JavaScriptMode.unrestricted);
//Customize the Chat through the following link
  //https://deadsimplechat.com/dashboard/chatrooms/edit/6455405b245a84081957dcb4/customize
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: webViewController,),
    );
  }
}

