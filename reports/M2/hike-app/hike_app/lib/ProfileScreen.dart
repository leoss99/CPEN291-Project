import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget{
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
              child: ProfileSelector(),
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
  @override
  _ProfileSelectorState createState() => _ProfileSelectorState();
}

class _ProfileSelectorState extends State<ProfileSelector> {
  // Initialize selector sliders
  RangeValues _currentElevationRange = const RangeValues(0, 1000);
  RangeValues _currentDistanceRange = const RangeValues(0, 100);

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
          values: _currentDistanceRange,
          min: 0,
          max: 100,
          divisions: 20,
          labels: RangeLabels(
            _currentDistanceRange.start.round().toString() + " km",
            _currentDistanceRange.end.round().toString() + " km",
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentDistanceRange = values;
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
          values: _currentElevationRange,
          min: 0,
          max: 1000,
          divisions: 20,
          labels: RangeLabels(
            _currentElevationRange.start.round().toString() + " m",
            _currentElevationRange.end.round().toString() + " m",
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentElevationRange = values;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LabelledCheckbox(isChecked: true, label: "Easy",),

            LabelledCheckbox(isChecked: true, label: "Moderate",),

            LabelledCheckbox(isChecked: true, label: "Hard",),
          ],
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
  bool isChecked;
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