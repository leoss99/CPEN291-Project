
/// Hike struct for handling hikes and their attributes
class HikeObject {

  String hikeName; // Name of hike, such as garibaldi-lake-trail
  String photoName; // Name of hike + photo number, garibaldi-lake-trail-0
  String photoURL; // URL for network photo
  String rating; // Either 'liked', 'disliked', or 'unrated'

  // TBD: extra details for displaying on matches page
  String difficulty;
  String distance;
  String elevation;
  List<String> tags;


  HikeObject({this.hikeName, this.photoName, this.photoURL, this.rating});

  //TODO: implement JSON encode and decode
  HikeObject.fromJson(Map<String,dynamic> json) {
    this.hikeName = json['hikeName'];
    this.photoName = json['photoName'];
    this.photoURL = json['photoURL'];
    this.rating = "unrated";
  }

  String parsedName() {
    assert(hikeName != null);
    return this.hikeName.splitAndCapitalize;
  }
}

extension CapExtension on String {
  String get inCaps => this.length > 0 ?'${this[0].toUpperCase()}${this.substring(1)}':'';
  String get splitAndCapitalize => this.split("-").map((str) => str.inCaps).join(" ");
}