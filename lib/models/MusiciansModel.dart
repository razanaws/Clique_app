class MusiciansModel {
  var name;
  late String? profileLink;
  late String coverLink;
  var location;
  var bio;
  var genres = [];
  var instruments = [];
  bool recruited = false;
  String? recruiterId;

  MusiciansModel({required String name, required String? profileLink, required String coverLink, required String location,
    required String bio, required genres, required instruments, required this.recruited, this.recruiterId});
}
