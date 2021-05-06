//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:hiking_app/main.dart';
import 'package:hiking_app/HikeObject.dart';
import 'dart:async';
import 'dart:convert';

class HikesScreen extends StatefulWidget {
  List<HikeObject> unratedHikes;
  List<HikeObject> ratedHikes;
  List<HikeObject> matchedHikes;
  HikesScreen({Key key, this.unratedHikes, this.ratedHikes, this.matchedHikes}): super(key: key);

  @override
  _HikesScreenState createState() => _HikesScreenState();
}


class _HikesScreenState extends State<HikesScreen> with TickerProviderStateMixin{
  // List<String> imagePaths = [
  //   "assets/unmatched-hikes/alpha-mountain-east-ridge-route-1.jpg",
  //   "assets/unmatched-hikes/alpha-mountain-east-ridge-route-2.jpg",
  //   "assets/unmatched-hikes/bladu-pass-and-marriott-basin-trail-0.jpg",
  //   "assets/unmatched-hikes/bladu-pass-and-marriott-basin-trail-1.jpg",
  //   "assets/unmatched-hikes/bladu-pass-and-marriott-basin-trail-2.jpg",
  //   "assets/unmatched-hikes/video-peak-0.jpg",
  //   "assets/unmatched-hikes/video-peak-1.jpg",
  //   "assets/unmatched-hikes/video-peak-2.jpg",
  // ];

  /// Method for getting hikes from backend
  void _getHikes(List<HikeObject> unratedHikes) async {
    final hikeAPIUrl = 'http://mock-json-service.glitch.me/';
    final response = await http.get(hikeAPIUrl);

    if (response.statusCode == 200) {
      // If response was successful, parse json object and add hikes to unrated list
      List jsonResponse = json.decode(response.body);
      List<HikeObject> newHikes = jsonResponse.map((hike) => HikeObject.fromJson(hike)).toList();
      unratedHikes.addAll(newHikes);
    } else {
      throw Exception('failed to load new hikes from API');
    }
  }

  @override
  Widget build(BuildContext context){
    CardController controller;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.lightGreen[700],
          ),
          Center(
            child: Icon(
              Icons.terrain_rounded,
              size: 200,
              color: Colors.lightGreen[900],
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: TinderSwapCard(
                orientation: AmassOrientation.BOTTOM,
                totalNum: widget.unratedHikes.length,
                stackNum: 3,
                swipeEdge: 4.0,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.width * 0.9,
                minWidth: MediaQuery.of(context).size.width * 0.8,
                minHeight: MediaQuery.of(context).size.width * 0.8,
                cardBuilder: (context, index) => Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,20,0,0),
                        child: Center(child: Image.network(widget.unratedHikes[index].photoURL)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Container(
                            child: Text(
                                widget.unratedHikes[index].parsedName(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                cardController: controller = CardController(),
                swipeUpdateCallback:
                    (DragUpdateDetails details, Alignment align) {
                  /// Get swiping card's alignment
                  if (align.x < 0) {
                    //Card is LEFT swiping
                  } else if (align.x > 0) {
                    //Card is RIGHT swiping
                  }
                },
                swipeCompleteCallback:
                    (CardSwipeOrientation orientation, int index) {
                    /// Get orientation & index of swiped card!
                    if (orientation == CardSwipeOrientation.RIGHT) {
                      // If swiped right, mark as liked and add to matches
                      widget.unratedHikes[index].rating = 'liked';
                      widget.matchedHikes.add(widget.unratedHikes[index]);
                    } else {
                      // Item was swiped left, mark as disliked
                      widget.unratedHikes[index].rating = 'disliked';
                    }
                    // In all cases, move the swiped card to the rated list
                    widget.ratedHikes.add(widget.unratedHikes[index]);
                    //widget.unratedHikes.remove(widget.unratedHikes[index]);
                    //TODO: figure out how to remove from the unrated list without breaking things
                },
              )
            )
          ),
        ],
      )
    );
  }
}