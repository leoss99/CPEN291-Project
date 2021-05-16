
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hiking_app/services/databaseservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hiking_app/StandInAPI.dart';
import 'package:hiking_app/HikeObject.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget{
  ProfileData userPreferences;

  ProfileScreen({Key key, this.userPreferences}): super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // Default profile image
  String photoURL = 'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg';

  @override
  Widget build(BuildContext context){
    if(FirebaseAuth.instance.currentUser.photoURL != null){
      photoURL = FirebaseAuth.instance.currentUser.photoURL;
    }
    widget.userPreferences.username = FirebaseAuth.instance.currentUser.displayName;
    return new Scaffold(
    body: SingleChildScrollView(
      child: new Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 10,),
              Center(
                child: Column(
                  children: [
                    Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: NetworkImage(
                                    photoURL),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                    SizedBox(height: 15),
                    Text(
                      FirebaseAuth.instance.currentUser.displayName,
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height:10,),
                  ],
                ),

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                      onPressed: (){
                        FirebaseAuth.instance.signOut().then((value){
                          Navigator.of(context).pushReplacementNamed('/landingpage');
                        }).catchError((e){
                          print(e);
                        });
                      },
                      label:
                        Text(
                            "Logout"
                        ),
                      icon:
                        Icon(
                            Icons.logout
                        ),
                    style: 
                      ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)
                        )
                      ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProfileSelector(userPreferences: widget.userPreferences,),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: (){
                    showConfirmDeleteDialog(context);
                  } ,
                  child: Text("DELETE ACCOUNT"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                  ),
                )
              ),

              ],
            ),
            ],
          ),
      ),
    );
  }
}

/// This stateful widget is for the selector boxes and sliders
class ProfileSelector extends StatefulWidget {
  ProfileData userPreferences;
  ProfileSelector({
    Key key,
    this.userPreferences,
  }) : super(key: key);

  @override
  _ProfileSelectorState createState() => _ProfileSelectorState();
}

class _ProfileSelectorState extends State<ProfileSelector> {
  // Initialize user preferences from Firebase
  DocumentReference userPrefs = FirebaseFirestore.instance.collection('userPreferences').doc(FirebaseAuth.instance.currentUser.uid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: userPrefs.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if(snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }
        ProfileData userPreferences = ProfileData.fromSnapshot(snapshot.data.data());
        return new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hike Length:",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
            RangeSlider(
              values: userPreferences.prefDistance,
              min: 0,
              max: 100,
              divisions: 20,
              labels: RangeLabels(
                widget.userPreferences.prefDistance.start.round().toString() + " km",
                widget.userPreferences.prefDistance.end.round().toString() + " km",
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  widget.userPreferences.prefDistance = values;
                  userPreferences.prefElevation = values;
                  updateDB();
                });

              },
            ),
            Text(
              "Elevation Gain:",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
            RangeSlider(
              values: userPreferences.prefElevation,
              min: 0,
              max: 1000,
              divisions: 20,
              labels: RangeLabels(
                widget.userPreferences.prefElevation.start.round().toString() + " m",
                widget.userPreferences.prefElevation.end.round().toString() + " m",
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  userPreferences.prefElevation = values;
                  widget.userPreferences.prefElevation = values;
                  updateDB();
                });
              },
            ),
            Text(
              "Difficulty:",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
            SizedBox(height: 10,),
            Center(
              child: ToggleButtons(
                constraints: BoxConstraints(minWidth: 100, minHeight: 40),
                children: <Widget>[
                  Text("Easy"),
                  Text("Moderate"),
                  Text("Hard"),
                ],
                isSelected: [
                  userPreferences.prefEasy,
                  userPreferences.prefMod,
                  userPreferences.prefHard
                ],
                onPressed: (int index) {
                  setState(() {
                    switch(index) {
                      case 0:
                        widget.userPreferences.prefEasy = !widget.userPreferences.prefEasy;
                        updateDB();
                        return;
                      case 1:
                        widget.userPreferences.prefMod = !widget.userPreferences.prefMod;
                        updateDB();
                        return;
                      default:
                        widget.userPreferences.prefHard = !widget.userPreferences.prefHard;
                        updateDB();
                    }
                  });
                },
              ),
            ),
          ],
        );
      },

    );
  }

  Future<void> updateDB() async {
    await DatabaseService(
        uid: FirebaseAuth.instance.currentUser.uid
    ).updateUserData(
      widget.userPreferences.prefDistance.start,
      widget.userPreferences.prefDistance.end,
      widget.userPreferences.prefElevation.start,
      widget.userPreferences.prefElevation.end,
      widget.userPreferences.prefEasy,
      widget.userPreferences.prefMod,
      widget.userPreferences.prefHard,
    );
  }

}


/// Data object for storing selected preferences on profile page
class ProfileData {

  // Username for identifying user, possibly randomly generated uid?
  String username;
  // For preferences, include results that match any selected value
  RangeValues prefDistance;
  RangeValues prefElevation;
  bool prefEasy, prefMod, prefHard;

  ProfileData({this.username = 'Tom Cruise', this.prefDistance = const RangeValues(0, 100), this.prefElevation = const RangeValues(0, 1000),
      this.prefEasy = true, this.prefMod = true, this.prefHard = true});

  /// Function for converting a ProfileData object to JSON format
  /// {'username', 'distanceMin', 'distanceMax', elevationMin', 'elevationMax', 'easy', 'medium', 'hard'}
  Map<String,dynamic> toJson() {
    return {'length_min': this.prefDistance.start.toString(), 'length_max': this.prefDistance.end.toString(), 'gain_min': this.prefElevation.start.toString(),
      'gain_max': this.prefElevation.end.toString(), 'easy': this.prefEasy.toString().inCaps, 'moderate': this.prefMod.toString().inCaps, 'hard': this.prefHard.toString().inCaps};
  }

  /// API post call to send user preferences to backend
  void postPreferences() async {
    /*
    // Temporary call to stand-in api
    StandInAPI.postPrefsNoAPI(jsonEncode(this.toJson()));
    */


    // Post preferences to the backend to create a new user
    Uri postUri = Uri.parse('http://10.0.2.2:5000/user/${this.username}');

    var response = await http.post(postUri, body: jsonEncode(this.toJson()));

    // Print status code for confirmation
    print("Status code: " + response.statusCode.toString());
    if (response.statusCode == 409)
      print("User already exists");
    if (response.statusCode == 202)
      print("Success creating user");

  }

  ProfileData.fromSnapshot(Map<String, dynamic> snapshot){
    this.prefDistance = new RangeValues(snapshot['prefDistanceMin'], snapshot['prefDistanceMax']);
    this.prefElevation = new RangeValues(snapshot['prefElevationMin'], snapshot['prefElevationMax']);
    this.prefEasy = snapshot['prefEasy'];
    this.prefMod = snapshot['prefMod'];
    this.prefHard = snapshot['prefHard'];
  }
}

showConfirmDeleteDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed:  () => Navigator.of(context).pop(),
  );
  Widget continueButton = TextButton(
    child: Text("I'm sure"),
    onPressed:  () {
      User user = FirebaseAuth.instance.currentUser;
      user.delete().then((value){
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/landingpage');
      }).catchError((e){
        print(e);
      });
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete Account?"),
    content: Text("Are you sure you would like to delete your account? This action cannot be undone."),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

}
extension BoolParsing on String {
  bool parseBool() {
    return this.toLowerCase() == 'true';
  }
}

