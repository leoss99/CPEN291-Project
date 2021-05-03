import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MatchesScreen extends StatelessWidget{
  // Hike names and urls come from backend, names will need to be parsed and reformatted
  List<String> hikeNames = <String>["Garibaldi Lake", "Eagle Bluff", "Watersprite Lake"];
  List<String> photoURLs = <String>["https://cdn-assets.alltrails.com/uploads/photo/image/23957167/large_04c8a06a56c3a328db71d851edb1bfb7.jpg",
    "https://cdn-assets.alltrails.com/uploads/photo/image/19188231/large_ed307a8a1d3f90ade5f2b58fdf520339.jpg",
    "https://cdn-assets.alltrails.com/uploads/photo/image/23996582/large_05f2f399322b219c104564781265e1be.jpg"];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Matches"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: hikeNames.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Image.network(photoURLs[index]),
            title: Text(hikeNames[index]),
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(title: Text(hikeNames[index])),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(photoURLs[index]),
                        Text("Distance:"),
                        Text("Elevation Gain:"),
                        Text("Difficulty:"),
                        Center(
                          child: RaisedButton(
                            child: Text("View on AllTrails.com"),
                            onPressed: (){
                              print("Button Pressed! Going to link for ${hikeNames[index]}");
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