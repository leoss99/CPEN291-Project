
/// Hike struct for handling hikes and their attributes
class HikeObject {

  String hikeName; // Name of hike, such as garibaldi-lake-trail
  String url; // TODO: Is this needed? URL is always the same with hike name appended
  String img_1, img_2, img_3; // URLs of images. If image is missing, URL is null
  String rating; // Either 'liked', 'disliked', or 'unrated'

  // Extra details for displaying on matches page
  String difficulty;
  String length;
  String gain;
  String location;
  String hikeType;
  // More tags for showing on matches page
  List<String> keywords;


  HikeObject({this.hikeName, this.img_1, this.img_2, this.img_3, this.rating = 'unrated'});


  /// Creates a new HikeObject from a map decoded from a JSON object
  // {'name', 'location', 'difficulty', 'length', 'gain', 'hiketype', 'url', 'img_1', 'img_2', 'img_3', 'keywords'}
  HikeObject.fromJson(Map<String,dynamic> json) {
    this.hikeName = json['name'];
    this.length = json['length'];
    this.difficulty = json['difficulty'];
    this.location = json['location'];
    this.gain = json['gain'];
    this.hikeType = json['hiketype'];
    this.url = json['url'];
    this.img_1 = json['img_1'];
    this.img_2 = json['img_2'];
    this.img_3 = json['img_3'];
    this.keywords = json['keywords'];

    this.rating = "unrated";
  }

  /// Prepares a HikeObject to be encoded in JSON format
  Map<String,String> toJson() {
    return {'name':this.hikeName, 'rating': this.rating};
  }

  /// Returns the hike name, capitalized and hyphen-free
  String parsedName() {
    assert(hikeName != null);
    return this.hikeName.splitAndCapitalize;
  }
}

extension CapExtension on String {
  String get inCaps => this.length > 0 ?'${this[0].toUpperCase()}${this.substring(1)}':'';
  String get splitAndCapitalize => this.split("-").map((str) => str.inCaps).join(" ");
}