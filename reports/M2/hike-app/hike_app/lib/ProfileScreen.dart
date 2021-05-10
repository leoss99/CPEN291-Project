import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_tags/flutter_tags.dart';

class ProfileScreen extends StatefulWidget{
  ProfileData userPreferences;
  ProfileScreen({Key key, this.userPreferences}): super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context){
    return new Scaffold(
    body: new Stack(
      children: <Widget>[
        ClipPath(
          //TODO: Replace black background clip with customizable image
          child: Container(color: Colors.black.withOpacity(0.8)),
          clipper: getClipper(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 10,),
            Center(
              child: Column(
                children: [
                  Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          //TODO: Make profile picture customizable
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(75.0)),
                          boxShadow: [
                            BoxShadow(blurRadius: 7.0, color: Colors.black)
                          ])),
                  SizedBox(height: 15),
                  Text(
                    // TODO: Allow user to change username, save username for sending to backend
                    'Tom Cruise',
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
                Spacer(flex: 2),
                ElevatedButton.icon(
                  onPressed: (){},
                  label:
                  Text(
                      "Change Pic"
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)
                      )
                  ),
                  icon: Icon(
                    Icons.file_upload
                  ),
                ),
                Spacer(),
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
                Spacer(flex: 2),

              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfileSelector(userPreferences: widget.userPreferences,),
            ),

          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: (){
              showAlertDialog(context);
            } ,
            child: Text("DELETE ACCOUNT"),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
            ),

          ),
        ),

      ],
    )
    );
  }
  Future getImage() async{
    //var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
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

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hike Length:",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
        ),
        RangeSlider(
          values: widget.userPreferences.prefDistance,
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
            });
          },
        ),
        Text(
          "Elevation Gain:",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
        ),
        RangeSlider(
          values: widget.userPreferences.prefElevation,
          min: 0,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            widget.userPreferences.prefElevation.start.round().toString() + " m",
            widget.userPreferences.prefElevation.end.round().toString() + " m",
          ),
          onChanged: (RangeValues values) {
            setState(() {
              widget.userPreferences.prefElevation = values;
            });
          },
        ),
        Text(
          "Difficulty:",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
        ),
        SizedBox(height: 5,),
        Center(
          child: ToggleButtons(
            constraints: BoxConstraints(minWidth: 100, minHeight: 40),
            children: <Widget>[
              Text("Easy"),
              Text("Moderate"),
              Text("Hard"),
            ],
            isSelected: [
              widget.userPreferences.prefEasy,
              widget.userPreferences.prefMod,
              widget.userPreferences.prefHard
            ],
            onPressed: (int index) {
              setState(() {
                switch(index) {
                  case 0:
                    widget.userPreferences.prefEasy = !widget.userPreferences.prefEasy;
                    return;
                  case 1:
                    widget.userPreferences.prefMod = !widget.userPreferences.prefMod;
                    return;
                  default:
                    widget.userPreferences.prefHard = !widget.userPreferences.prefHard;
                }
              });
            },
          ),
        ),

      ],
    );
  }

}


/// Data object for storing selected preferences on profile page
class ProfileData {

  // TODO: When sending preferences to API, put in the form:
  // {'username', 'distanceMin', 'distanceMax', elevationMin', 'elevationMax', 'easy', 'medium', 'hard'}

  // Username for identifying user, possibly randomly generated uid?
  String username;
  // For preferences, include results that match any selected value
  RangeValues prefDistance;
  RangeValues prefElevation;
  bool prefEasy, prefMod, prefHard;
  // For tags, exclude any results that don't match all selected values
  List<bool> tagSelected;
  List<String> tagLabels;

  ProfileData({this.prefDistance = const RangeValues(0, 100), this.prefElevation = const RangeValues(0, 1000),
      this.prefEasy = true, this.prefMod = true, this.prefHard = true, this.tagLabels, this.tagSelected}) {

    if (tagLabels == null) {
      // no tags have been provided, make default list
      this.tagLabels = [
        'Bike-friendly', 'Child-friendly', 'Dog-friendly', 'Wheelchair-accessible', 'Picnic'
      ];
    }

    if (tagSelected == null) {
      // Not specified which tags are selected, default set all unselected
      this.tagSelected = List<bool>.filled(this.tagLabels.length, false);
    }

    assert(tagSelected.length == tagLabels.length);
    print(tagLabels);
  }
}


class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 3);
    path.lineTo(size.width *1.85, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }


}
showAlertDialog(BuildContext context) {

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

