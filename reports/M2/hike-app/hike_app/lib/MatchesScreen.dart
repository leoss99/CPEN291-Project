import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiking_app/HikeObject.dart';
import 'package:hiking_app/main.dart';

class MatchesScreen extends StatefulWidget{
  // Hike names and urls come from backend
  List<HikeObject> matches;
  MatchesScreen({Key key, this.matches}): super(key: key);

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {

  @override
  Widget build(BuildContext context){
    //Check for empty list of hikes. If empty, display special screen saying "no matches"
    if (widget.matches.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Matches"),
          backgroundColor: Colors.lightGreen[700],
        ),
        body: Center(
          child: Text(
            "No matches yet, keep swiping!",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Montserat',
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]
            ),
          )
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Matches"),
        backgroundColor: Colors.lightGreen[700],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: widget.matches.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Image.network(widget.matches[index].img_1),
            title: Text(widget.matches[index].parsedName()),
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(title: Text(widget.matches[index].parsedName()),backgroundColor: Colors.lightGreen[700],),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(widget.matches[index].img_1),
                        TwoToneText(title: "Distance", content: "10 km",),
                        TwoToneText(title: "Elevation Gain", content: "100 m",),
                        TwoToneText(title: "Difficulty", content: "Moderate",),
                        SizedBox(height: 15,),
                        Center(
                          child: RaisedButton(
                            child: Text("View on AllTrails.com"),
                            onPressed: (){
                              String hikeURL = 'https://www.alltrails.com/trail/canada/british-columbia/' + widget.matches[index].hikeName;
                              print("Button Pressed! Link to hike is: $hikeURL");
                            }
                          ),
                        ),
                        Center(
                          child: RaisedButton(
                              child: Text("Reject"),
                              onPressed: (){
                                setState(() {
                                  widget.matches.remove(widget.matches[index]);
                                });
                                Navigator.pop(context);
                              }
                          ),
                        ),
                      ],
                    )
                  );
                },
              ));
            },
          );
        },

      ),
    );
  }
}

class TwoToneText extends StatelessWidget {
  final String title;
  final String content;

  TwoToneText({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15,15,0,0),
      child: Row(
        children: [
          Text(
            title + ':',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 5,),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

}