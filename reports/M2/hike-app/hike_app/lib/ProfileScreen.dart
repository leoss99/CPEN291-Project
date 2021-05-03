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
                  SizedBox(height:15,),
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

class ProfileSelector extends StatefulWidget {
  @override
  _ProfileSelectorState createState() => _ProfileSelectorState();
}

class _ProfileSelectorState extends State<ProfileSelector> {
  // Initialize selector sliders and boxes
  RangeValues _currentElevationRange = const RangeValues(0, 50);
  RangeValues _currentDistanceRange = const RangeValues(0, 50);
  bool _easyChecked = true;
  bool _moderateChecked = true;
  bool _hardChecked = true;

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
          max: 50,
          divisions: 10,
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
          max: 50,
          divisions: 10,
          labels: RangeLabels(
            _currentElevationRange.start.round().toString() + " km",
            _currentElevationRange.end.round().toString() + " km",
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
            Checkbox(
              value: _easyChecked,
              onChanged: (bool value) {
                setState(() {
                  _easyChecked = value;
                });
              },
            ),
            Text("Easy"),
            SizedBox(width: 10,),
            Checkbox(
              value: _moderateChecked,
              onChanged: (bool value) {
                setState(() {
                  _moderateChecked = value;
                });
              },
            ),
            Text("Moderate"),

            // Special Checkbox
            LabelledCheckbox(),
          ],
        ),
      ],
    );
  }

}

class LabelledCheckbox extends StatefulWidget {
  @override
  _LabelledCheckboxState createState() => _LabelledCheckboxState();
}

class _LabelledCheckboxState extends State<LabelledCheckbox> {
  bool _isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (bool value) {
            setState(() {
              _isChecked = value;
            });
          },
        ),
        Text("Hard"),
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