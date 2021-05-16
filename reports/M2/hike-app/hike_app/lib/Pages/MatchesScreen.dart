import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hiking_app/HikeObject.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchesScreen extends StatefulWidget{
  // Hike names and urls come from backend
  List<HikeObject> matches;
  MatchesScreen({Key key, this.matches}): super(key: key);

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {

  /// Method for opening a hike url in the user's mobile browser
  void launchHikeInBrowser(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

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

          HikeObject currentHike = widget.matches[index];

          return ListTile(
            leading: Image.network(currentHike.images[0]),
            title: Text(currentHike.parsedName()),
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(title: Text(currentHike.parsedName()),backgroundColor: Colors.lightGreen[700],),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CarouselSlider(
                          items: currentHike.images.map((imgURL) => Image.network(imgURL)).toList(),
                          options: CarouselOptions(
                            scrollDirection: Axis.vertical,
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                          ),
                        ),
                        TwoToneText(title: "Location", content: currentHike.location,),
                        TwoToneText(title: "Difficulty", content: currentHike.difficulty,),
                        TwoToneText(title: "Distance", content: currentHike.length,),
                        TwoToneText(title: "Elevation Gain", content: currentHike.gain,),
                        TwoToneText(title: "Hike Type", content: currentHike.hikeType,),
                        SizedBox(height: 15,),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                child: Row(
                                  children: [
                                    Text("View on AllTrails.com"),
                                    Icon(
                                        Icons.terrain_rounded
                                    ),
                                  ],
                                ),
                                onPressed: (){
                                  launchHikeInBrowser(currentHike.url);
                                }
                            ),
                            ElevatedButton(
                                child: Row(
                                  children: [
                                    Text("Reject"),
                                    Icon(
                                      Icons.highlight_remove
                                    ),
                                  ],
                                ),
                                onPressed: (){
                                  setState(() {
                                    widget.matches.remove(currentHike);
                                  });
                                  Navigator.pop(context);
                                }
                            ),
                          ],
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

/// Helper class for creating Text with a bold title and regular content
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