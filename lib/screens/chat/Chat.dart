import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final webViewController = WebViewController()
    ..loadRequest(Uri.parse('http://deadsimplechat.com/DEp-EWR0b'))
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ;

//Customize the Chat through the following link
  //https://deadsimplechat.com/dashboard/chatrooms/edit/6455405b245a84081957dcb4/customize

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: webViewController,),

    );

  }
}
