import 'package:flutter/material.dart';

class RecruiterProfile extends StatefulWidget {
  const RecruiterProfile({Key? key}) : super(key: key);

  @override
  State<RecruiterProfile> createState() => _RecruiterProfileState();
}

/*
class MultiSelectChipGenres extends StatefulWidget {
  final List<String> genreList;

  MultiSelectChip(this.genresList, {this.onSelectionChanged,this.canSelect = true});

  @override
  _MultiSelectChipStateGenres createState() => _MultiSelectChipStateGenres();
}

class MultiSelectChipInstruments extends StatefulWidget {
  final List<String> genreList;



  MultiSelectChip(this.genresList, {this.onSelectionChanged,this.canSelect = true});

  @override
  _MultiSelectChipStateInstruments createState() => _MultiSelectChipStateInstruments();
}



class _MultiSelectChipStateGenres extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.genresList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(3.0),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          label: Container(
              width: MediaQuery.of(context).size.width / 4.2,
              child: Text(
                item,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: selectedChoices.contains(item)
                        ? Colors.white
                        : Colors.black,
                    fontSize: 9),
              )),
          selected: selectedChoices.contains(item),
          selectedColor: Color.fromRGBO(100, 13, 20, 1),
          onSelected: (selected) {
            setState(() {
              if(widget.canSelect) {
                selectedChoices.contains(item)
                    ? selectedChoices.remove(item)
                    : selectedChoices.add(item);

                widget.onSelectionChanged!(selectedChoices);
              }
            });
          },
        ),
      ));
    });
    return choices;
  }





  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Wrap(
          children: _buildChoiceList(),
        )
      ],
    );
  }
}
class _MultiSelectChipStateInstruments extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.instrumentsList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(3.0),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          label: Container(
              width: MediaQuery.of(context).size.width / 4.2,
              child: Text(
                item,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: selectedChoices.contains(item)
                        ? Colors.white
                        : Colors.black,
                    fontSize: 9),
              )),
          selected: selectedChoices.contains(item),
          selectedColor: Color.fromRGBO(100, 13, 20, 1),
          onSelected: (selected) {
            setState(() {
              if(widget.canSelect) {
                selectedChoices.contains(item)
                    ? selectedChoices.remove(item)
                    : selectedChoices.add(item);

                widget.onSelectionChanged!(selectedChoices);
              }
            });
          },
        ),
      ));
    });
    return choices;
  }





  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Wrap(
          children: _buildChoiceList(),
        )
      ],
    );
  }
}

*/

class _RecruiterProfileState extends State<RecruiterProfile> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              //TODO: Cover Picture should be added
              Container(
                height: height * 0.3,
                color: Colors.grey,
                child: Center(
                  child: Image.asset(
                    "images/recruiterSkyscrapers.jpeg",
                    fit: BoxFit.fitWidth,
                    height: height * 0.3,
                    width: width,
                  ),
                ),
              ),
              SizedBox(height: height * 0.5),

              SizedBox(
                child: Container(
                  color: const Color.fromRGBO(37, 37, 37, 1),
                  child: Column(
                    children: [
                      //TODO: Name should be added by user

                      const Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          "Recruiter's NAME HERE",
                          style: TextStyle(color: Colors.white70, fontSize: 20),
                        ),
                      ),

                      SizedBox(height: height * 0.05),

                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Column(
                          children: [
                            //TODO: location
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.pin_drop_outlined,
                                        size: 20,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    TextSpan(
                                        text: "  Country, city..etc",
                                        style: TextStyle(fontSize: 17))
                                  ]),
                                ),
                              ],
                            ),
                            //TODO: bio
                            Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "Bio goes here",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 17),
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
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromRGBO(
                                                    100, 13, 20, 1)),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        50.0)))),
                                    child: const Text('Create a Band',
                                        style: TextStyle(color: Colors.white)),
                                  )
                                ],
                              ),
                            ),

                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Genres",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            //TODO: rock etc

                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Requirements",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 240.0),
                                  child: Column(
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 60.0,
                                        width: 60.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "images/recruiterProfilePicture.jpeg"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2.0),
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Recruiter's Name",
                                              style: TextStyle(
                                                  color: Colors.white70),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2.0),
                                        child: Row(
                                          children: const [
                                            Text(
                                              "2d ago",
                                              style: TextStyle(
                                                  color: Colors.white70),
                                            )
                                          ], //TODO: time-postTime
                                        ),
                                      ),
                                      Center(
                                        child: Row(children: [
                                          /*Image.asset(
                                                "images/splashingDrums.png",
                                                fit: BoxFit.fill,
                                                height: height*0.3,
                                                width: width*0.8,
                                              ),*/

                                          Flexible(
                                            child: Column(
                                              children: <Widget>[
                                                const Divider(
                                                    color: Colors.grey),
                                                //TODO:Recruiter
                                                const Text(
                                                    "Users Recruited by Recruiter's Name"),
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Column(
                                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  height: 60.0,
                                                                  width: 60.0,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .red,
                                                                    image:
                                                                        DecorationImage(
                                                                      image: AssetImage(
                                                                          "images/drummerMan.jpg"),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        //TODO: connect the recruited users
                                                        Row(
                                                          children: const [
                                                            Text(
                                                                "Musician's Name"),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Column(
                                                              //crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                  height: 60.0,
                                                                  width: 60.0,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .red,
                                                                    image:
                                                                        DecorationImage(
                                                                      image: AssetImage(
                                                                          "images/drummerMan.jpg"),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: const [
                                                            Text("Band's Name"),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
            top: (height * 0.3) - (120 / 2),
            right: width * 0.67,
            child: Container(
              height: 120.0,
              width: 120.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                image: DecorationImage(
                  image: AssetImage("images/recruiterProfilePicture.jpeg"),
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
