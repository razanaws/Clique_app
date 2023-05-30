import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../chat/ChatAfterSwiping.dart';
import '../chat/NavigateToBandProfile.dart';
import 'ActionButtonWidget.dart';
import 'DragWidget.dart';
import 'ProfileModel.dart';

class CardsStackWidget extends StatefulWidget {
  const CardsStackWidget({Key? key}) : super(key: key);

  @override
  State<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends State<CardsStackWidget>
    with SingleTickerProviderStateMixin {
  List<Profile> profiles = [];
  List<String> bands = [];
  late bool isRecruiter = false;
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

  fetchUserInfo() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final userSnapshot = await firestore
          .collection('Musicians')
          .doc(currentUser?.email.toString())
          .get();
      if (userSnapshot.exists) {
        setState(() {
          isRecruiter = false;
        });
        return true;
      } else {
        try {
          final secondUserSnapshot = await firestore
              .collection('Recruiters')
              .doc(currentUser?.email.toString())
              .get();

          if (secondUserSnapshot.exists) {
            setState(() {
              isRecruiter = true;
            });
            return true;
          } else {
            print("user doesn't exist");
            return "user doesn't exist";
          }
        } catch (e) {
          print(e);
          return e;
        }
      }
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<List<Profile>> fetchProfiles() async {
    try {
      QuerySnapshot musiciansSnapshot =
          await FirebaseFirestore.instance.collection('Musicians').get();
      musiciansSnapshot.docs.forEach((musicianDoc) {
        if (musicianDoc.exists) {
          String username = musicianDoc['username'];
          String location = musicianDoc['location'];
          String? profileUrl;
          Map<String, dynamic>? musicianData =
              musicianDoc.data() as Map<String, dynamic>?;

          if (musicianData != null && musicianData.containsKey('profileUrl')) {
            dynamic profileUrlValue = musicianData['profileUrl'];
            if (profileUrlValue != null) {
              profileUrl = profileUrlValue.toString();
            }
          }

          if (username.isNotEmpty && location.isNotEmpty) {
            Profile profile = Profile(
                name: username,
                distance: location,
                imageAsset: profileUrl);
            profiles.add(profile);
          }
        }
      });

      // Fetch users from "Bands" collection
      QuerySnapshot bandsSnapshot =
          await FirebaseFirestore.instance.collection('bands').get();
      bandsSnapshot.docs.forEach((bandDoc) {
        if (bandDoc.exists) {
          String username = bandDoc['name'];
          String location = bandDoc['location'];
          String? profileUrl;

          Map<String, dynamic>? bandData =
              bandDoc.data() as Map<String, dynamic>?;
          if (bandData != null && bandData.containsKey('profileUrl')) {
            dynamic profileUrlValue = bandData['profileUrl'];
            if (profileUrlValue != null) {
              profileUrl = profileUrlValue.toString();
            }
          }

          if (username.isNotEmpty && location.isNotEmpty) {
            Profile profile = Profile(
              name: username,
              distance: location,
              imageAsset: profileUrl,
            );
            bands.add(username);
            profiles.add(profile);
          }
        }
      });
    } catch (e) {
      print('Error fetching profiles: $e');
    }
    return profiles;
  }

  void navigateToChat(profile) async {
    final String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    final String receiverEmail = await getReceiverEmail(profile.name);

    if (receiverEmail.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatAfterSwiping(
            profileName: profile.name,
            profileImage: profile.imageAsset,
            currentUserEmail: currentUserEmail!,
            otherUserEmail: receiverEmail,
          ),
        ),
      );
    } else {
      // Handle receiver email not found scenario
    }
  }

  Future<String> getReceiverEmail(String profileName) async {
    List<String> uids = [];

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Musicians')
        .where('username', isEqualTo: profileName)
        .get();

    snapshot.docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String? uid = document.id;
      if (uid != null) {
        uids.add(uid);
      }
    });
    debugPrint(uids.toString());

    if (uids.isNotEmpty) {
      final email = uids[0];
      return email;
    } else {
      return 'no user';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchProfiles().then((fetchedProfiles) {
      setState(() {
        profiles = fetchedProfiles;
      });
    });
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        profiles.removeLast();
        _animationController.reset();
        swipeNotifier.value = Swipe.none;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ValueListenableBuilder(
            valueListenable: swipeNotifier,
            builder: (context, swipe, _) => Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: List.generate(profiles.length, (index) {
                if (index == profiles.length - 1) {
                  return PositionedTransition(
                    rect: RelativeRectTween(
                      begin: RelativeRect.fromSize(
                          const Rect.fromLTWH(0, 0, 580, 340),
                          const Size(580, 340)),
                      end: RelativeRect.fromSize(
                          Rect.fromLTWH(
                              swipe != Swipe.none
                                  ? swipe == Swipe.left
                                      ? -300
                                      : 300
                                  : 0,
                              0,
                              580,
                              340),
                          const Size(580, 340)),
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.easeInOut,
                    )),
                    child: RotationTransition(
                      turns: Tween<double>(
                              begin: 0,
                              end: swipe != Swipe.none
                                  ? swipe == Swipe.left
                                      ? -0.1 * 0.3
                                      : 0.1 * 0.3
                                  : 0.0)
                          .animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve:
                              const Interval(0, 0.4, curve: Curves.easeInOut),
                        ),
                      ),
                      child: DragWidget(
                        profile: profiles[index],
                        index: index,
                        swipeNotifier: swipeNotifier,
                        isLastCard: true,
                      ),
                    ),
                  );
                } else {
                  return DragWidget(
                    profile: profiles[index],
                    index: index,
                    swipeNotifier: swipeNotifier,
                  );
                }
              }),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 46.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionButtonWidget(
                  onPressed: () {
                    swipeNotifier.value = Swipe.left;
                    _animationController.forward();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 20),
                ActionButtonWidget(
                  onPressed: () {
                    debugPrint("Accepted");
                    Profile acceptedProfile = profiles.last;

                    if (bands.contains(acceptedProfile.name)) {
                      //TODO: NAVIGATES TO BAND PROFILE

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavigateToBandProfile(
                                bandName: acceptedProfile.name)),
                      );
                    } else {
                      navigateToChat(acceptedProfile);
                    }

                    swipeNotifier.value = Swipe.right;
                    _animationController.forward();
                  },
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: DragTarget<int>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return IgnorePointer(
                child: Container(
                  height: 700.0,
                  width: 80.0,
                  color: Colors.transparent,
                ),
              );
            },
            onAccept: (int index) {
              setState(() {
                profiles.removeAt(index);
              });
            },
          ),
        ),
        Positioned(
          right: 0,
          child: DragTarget<int>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return IgnorePointer(
                child: Container(
                  height: 700.0,
                  width: 80.0,
                  color: Colors.transparent,
                ),
              );
            },
            onAccept: (int index) {
              debugPrint("Accepted");
              Profile acceptedProfile = profiles[index];
              if (bands.contains(acceptedProfile.name)) {
                navigateToChat(acceptedProfile);
                //TODO: NAVIGATES TO BAND PROFILE
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigateToBandProfile(
                          bandName: acceptedProfile.name)),
                );
              } else {
                navigateToChat(acceptedProfile);
              }

              setState(() {
                profiles.removeAt(index);
              });
            },
          ),
        ),
      ],
    );
  }
}
