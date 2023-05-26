import 'package:flutter/material.dart';
class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 13, 20, 1),        title: Text('Privacy Policy'),
      ),
      body: Container(
        color: Colors.black,
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(50.0),
          child: Column(
            children: [
              Text(
                "This Privacy Policy outlines the types of personal information that we collect, how we use it, and how we protect it. By using our website or application, you agree to the terms of this Privacy Policy.",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                "We collect personal information that you voluntarily provide to us, such as your name, email address, and phone number. We may also collect information automatically when you use our website or application.",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                "We do not share your personal information with third parties except as necessary to provide our services to you or as required by law.",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                "We take reasonable measures to protect your personal information from unauthorized access, disclosure, or misuse. We use industry-standard security technologies, such as firewalls and encryption, to protect your information.",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
