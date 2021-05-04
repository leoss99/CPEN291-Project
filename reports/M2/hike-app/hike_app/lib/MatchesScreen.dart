import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiking_app/HikeObject.dart';
import 'package:hiking_app/main.dart';

class MatchesScreen extends StatelessWidget{
  // Hike names and urls come from backend
  List<HikeObject> matches;
  // Possible useful resource for building lists from API data:
  // https://www.melvinvivas.com/flutter-listview-example-using-data-from-a-rest-api/

  HikeObject garibaldi = HikeObject(hikeName: 'garibaldi-lake-trail', photoName: 'garibaldi-lake-trail-0',
      photoURL: 'https://cdn-assets.alltrails.com/uploads/photo/image/23957167/large_04c8a06a56c3a328db71d851edb1bfb7.jpg', rating: 'unrated');
  HikeObject bluff = HikeObject(hikeName: 'eagle-bluff-trail', photoName: 'eagle-bluff-trail-0',
      photoURL: 'https://cdn-assets.alltrails.com/uploads/photo/image/19188231/large_ed307a8a1d3f90ade5f2b58fdf520339.jpg', rating: 'unrated');
  HikeObject watersprite = HikeObject(hikeName: 'watersprite-lake-summer-route', photoName: 'watersprite-lake-summer-route-0',
      photoURL: 'https://cdn-assets.alltrails.com/uploads/photo/image/23996582/large_05f2f399322b219c104564781265e1be.jpg', rating: 'unrated');


  @override
  Widget build(BuildContext context){
    // Matches will later be updated by API calls and tinder-card swipes
    matches.add(garibaldi);
    matches.add(bluff);
    matches.add(watersprite);

    return Scaffold(
      appBar: AppBar(
        title: Text("Matches"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: matches.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Image.network(matches[index].photoURL),
            title: Text(matches[index].parsedName()),
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(title: Text(matches[index].parsedName())),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(matches[index].photoURL),
                        TwoToneText(title: "Distance", content: "10 km",),
                        TwoToneText(title: "Elevation Gain", content: "100 m",),
                        TwoToneText(title: "Difficulty", content: "Moderate",),
                        SizedBox(height: 15,),
                        Center(
                          child: RaisedButton(
                            child: Text("View on AllTrails.com"),
                            onPressed: (){
                              String hikeURL = 'https://www.alltrails.com/trail/canada/british-columbia/'+matches[index].hikeName;
                              print("Button Pressed! Link to hike is: $hikeURL");
                            }
                          ),
                        )
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