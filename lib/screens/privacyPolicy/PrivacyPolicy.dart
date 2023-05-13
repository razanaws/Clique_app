import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(

            color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  Text(
                    "This Privacy Policy outlines the types of personal information that we collect, how we use it, and how we protect it. By using our website or application, you agree to the terms of this Privacy Policy."
                  ,style:TextStyle(color: Colors.white,fontSize: 20),),
                  SizedBox(height: 20,),
                  Text(
                    "We collect personal information that you voluntarily provide to us, such as your name, email address, and phone number. We may also collect information automatically when you use our website or application."
                    ,style:TextStyle(color: Colors.white,fontSize: 20),),
                  SizedBox(height: 20,),
                  Text("We do not share your personal information with third parties except as necessary to provide our services to you or as required by law. "
                    ,style:TextStyle(color: Colors.white,fontSize: 20),),
                  SizedBox(height: 20,),
                  Text("We take reasonable measures to protect your personal information from unauthorized access, disclosure, or misuse. We use industry-standard security technologies, such as firewalls and encryption, to protect your information."
                    ,style:TextStyle(color: Colors.white,fontSize: 20),),
                  SizedBox(height: 20,),
                ],
              ),
        ),
          ),
        ),
      )
    );
  }
}
