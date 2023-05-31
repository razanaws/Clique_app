class BandsModel{
  var profileLink;
  var coverLink;
  var location;
  var bio;
  var genres = [];
  var instruments = [];
  bool recruited = false;
  String? recruiterId;

  BandsModel({required String profileLink, required String coverLink, required String location,
    required String bio, required genres, required instruments, required this.recruited, this.recruiterId});
}