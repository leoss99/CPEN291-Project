import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfileSelector(userPreferences: widget.userPreferences,),
            ),
          ],
        ),

      ],
    )
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
  // Initialize selector sliders

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
        Text(
          "Tags:",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LabelledCheckbox(isChecked: true, label: "Dog-friendly",),

            LabelledCheckbox(isChecked: true, label: "Wheelchair Accessible",),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LabelledCheckbox(isChecked: true, label: "Picnic",),

            LabelledCheckbox(isChecked: true, label: "Kid-friendly",),

            LabelledCheckbox(isChecked: true, label: "Bike-friendly",),
          ],
        ),
      ],
    );
  }

}

/// A checkbox and label
class LabelledCheckbox extends StatefulWidget {
  bool isChecked; // Need a way to identify status of individual boxes
  final String label;
  double labelSize = 14.0;

  LabelledCheckbox({Key key, this.isChecked, this.label, this.labelSize}): super(key:key);

  @override
  _LabelledCheckboxState createState() => _LabelledCheckboxState();
}

class _LabelledCheckboxState extends State<LabelledCheckbox> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.isChecked,
          onChanged: (bool value) {
            setState(() {
              widget.isChecked = value;
            });
          },
        ),
        Text(
          widget.label,
          style: TextStyle(
              fontSize: widget.labelSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
        ),
      ],
    );
  }
}

/// Data object for storing selected preferences on profile page
class ProfileData {
  // For preferences, include results that match any selected value
  RangeValues prefDistance;
  RangeValues prefElevation;
  bool prefEasy, prefMod, prefHard;
  // For tags, exclude any results that don't match all selected values
  // TODO: Change tags to a list instead of checkboxes
  bool tagChildren, tagWheelchair, tagBike, tagDog, tagPicnic;

  ProfileData({this.prefDistance = const RangeValues(0, 100), this.prefElevation = const RangeValues(0, 1000),
      this.prefEasy = true, this.prefMod = true, this.prefHard = true,
      this.tagBike = false, this.tagChildren = false, this.tagDog = false, this.tagPicnic = false, this.tagWheelchair = false});
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