
/// Hike struct for handling hikes and their attributes
class HikeObject {

  String hikeName; // Name of hike, such as garibaldi-lake-trail
  String url; // URL to AllTrails page of hike
  List<String> images; // URLs of images. If image is missing, URL is null
  bool isRated; // True if rated, else false
  bool isLiked; // True if liked, else false

  // Extra details for displaying on matches page
  int rating;
  String difficulty;
  String length;
  String gain;
  String location;
  String hikeType;
  // More tags for showing on matches page
  List<String> keywords;


  HikeObject({this.hikeName, this.images, this.isRated = false, this.isLiked = false});


  /// Creates a new HikeObject from a map decoded from a JSON object
  // {'name', 'location', 'difficulty', 'length', 'gain', 'hiketype', 'url', 'img_1', 'img_2', 'img_3', 'keywords'}
  HikeObject.fromJson(Map<String,dynamic> json) {
    this.hikeName = json['name']; // hyphenated hike name
    this.length = json['length'];
    this.difficulty = json['difficulty'];
    this.location = json['location'];
    this.gain = json['gain'];
    this.hikeType = json['hiketype'];
    this.url = json['url'];
    this.rating = json['rating'];

    this.images = [];
    if (json['img_1'] != null)
      this.images.add(json['img_1']);
    if (json['img_2'] != null)
      this.images.add(json['img_2']);
    if (json['img_3'] != null)
      this.images.add(json['img_3']);


    this.keywords = json['keywords'];

    this.isLiked = false;
    this.isRated = false;
  }

  /// Prepares a HikeObject to be encoded in JSON format
  Map<String,dynamic> toJson() {
    return {'hike_id':this.hikeName, 'like': this.isLiked};
  }

  /// Returns the hike name, capitalized and hyphen-free
  String parsedName() {
    assert(hikeName != null);
    return this.hikeName.splitAndCapitalize;
  }
}

// Extensions for parsing hyphenated hike names and formatting for display
extension CapExtension on String {
  String get inCaps => this.length > 0 ?'${this[0].toUpperCase()}${this.substring(1)}':'';
  String get splitAndCapitalize => this.split("-").map((str) => str.inCaps).join(" ");
}