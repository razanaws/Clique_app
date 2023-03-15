import 'package:flutter/material.dart';

class MusicianProfile extends StatefulWidget {
  const MusicianProfile({Key? key}) : super(key: key);

  @override
  State<MusicianProfile> createState() => _MusicianProfileState();
}

class _MusicianProfileState extends State<MusicianProfile> {
  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37,1),
      body: Stack(

        alignment: Alignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[

              //TODO: Cover Picture should be added
              Container(
                height: height*0.3,
                color: Colors.grey,
                child: Center(
                  child: Image.asset(
                    "images/bandCover2.jpg",
                    fit: BoxFit.fitWidth,
                    height: height*0.3,
                    width: width,
                  ),
                ),
              ),

              Expanded(

                child: Container(
                  color: const Color.fromRGBO(37, 37, 37,1),
                  child: Column(
                    children: [

                      //TODO: Name should be added by user
                      Padding(
                        padding: const EdgeInsets.only(top:15),
                        child:  Text(
                          "NAME HERE",
                          style:  TextStyle(
                              color: Colors.white70, fontSize: 20
                          ),
                        ),

                      ),


                      SizedBox(height: height*0.05),

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [

                            //TODO: location
                            Row(
                              mainAxisAlignment:MainAxisAlignment.start,
                              children: [
                                RichText(
                                    text: const TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.pin_drop_outlined,
                                            size: 20,
                                            color: Colors.white70,),
                                        ),
                                        TextSpan(
                                          text: "  Country, city..etc",
                                          style: TextStyle(fontSize: 17)
                                        )
                                      ]
                                    ),
                                ),
                              ],
                            ),
                            //TODO: bio
                            Row(
                              children: const [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                   "Bio goes here",
                                   style: TextStyle(
                                       color: Colors.white70,
                                       fontSize: 17
                                   ),
                                  ),
                                ),

                              ],
                            ),

                            //TODO: onPress
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                   ElevatedButton(
                                     onPressed: null,
                                     style: ButtonStyle(
                                         backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(100, 13, 20, 1)),
                                         shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(50.0)))
                                     ),
                                     child: const Text(
                                         'Create a Band',
                                         style: TextStyle(
                                             color: Colors.white)
                                     ),

                                  )
                                ],
                              ),
                            )

                          ],
                        ),

                      ),

                    ],
                  ),
                ),
              )

            ],
          ),

          // TODO: Profile image
          Positioned(
            //(background container size) - (circle height / 2)
          top: (height*0.3) - (120/2),
            right: width*0.67,
            child: Container(
              height: 120.0,
              width: 120.0,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                image: DecorationImage(
                  image: const AssetImage("images/drummerMan.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
