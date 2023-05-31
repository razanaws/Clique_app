import 'package:flutter/material.dart';
import 'package:clique/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'CreateProfileRec.dart';

class WelcomePageRec extends StatelessWidget {
  final user User;
  const WelcomePageRec({Key? key, required this.User}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(100, 13, 20, 1),
      ),
      body: Container(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Image(
                image: AssetImage('images/welcome.png'),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: height * 0.08),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Hello ${User.name}!",
                style: const TextStyle(
                    fontSize: 30,
                    fontFamily: 'SanFrancisco',
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Lets get started",
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'SanFrancisco',
                    color: Colors.white70),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                width: 200,
                height: 60,
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(100, 13, 20, 1)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0))),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateProfileRec(User: User)));
                  },
                  child: const Text(
                    'Create my profile',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
