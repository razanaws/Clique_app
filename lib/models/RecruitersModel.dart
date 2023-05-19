class RecruitersModel {
  var name;
  var profileLink;
  var coverLink;
  var location;
  var bio;
  var genres = [];
  var requirements = [];

  RecruitersModel({required String name, required String profileLink, required String coverLink, required String location,
    required String bio, required genres, required requirements});
}
