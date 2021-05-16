
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hiking_app/Pages/ProfileScreen.dart';
import 'package:hiking_app/StandInAPI.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:hiking_app/HikeObject.dart';
import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

class HikesScreen extends StatefulWidget {
  List<HikeObject> unratedHikes;
  List<HikeObject> ratedHikes;
  List<HikeObject> matchedHikes;
  ProfileData userPreferences;
  HikesScreen({Key key, this.unratedHikes, this.ratedHikes, this.matchedHikes, this.userPreferences}): super(key: key);

  @override
  _HikesScreenState createState() => _HikesScreenState();
}


class _HikesScreenState extends State<HikesScreen> with TickerProviderStateMixin{
  Color backgroundColor = Colors.lightGreen[700];
  double likeOpacity = 0;
  double dislikeOpacity = 0;

  /// Method for getting hikes from backend
  void _getHikes(List<HikeObject> unratedHikes) async {

    /*
    // This temporary method can be used to simulate the API call
    String tempAPIResponse = StandInAPI.getHikesNoAPI();
    // Decode the json string and make hike objects
    List jsonResponse = json.decode(tempAPIResponse);
    List<HikeObject> newHikes = jsonResponse.map((hike) => HikeObject.fromJson(hike)).toList();
    // Add the new hike objects to the list of unrated hikes
    unratedHikes.addAll(newHikes);
    */


    // Get new hikes from the API
    Uri hikeAPIUrl = Uri.parse('http://10.0.2.2:5000/hike/${widget.userPreferences.username}');
    final response = await http.get(hikeAPIUrl);

    if (response.statusCode != 404) {
      print("Status code: "+ response.statusCode.toString());
      print("Response successful");
      // If response was successful, parse json object and add hikes to unrated list
      List jsonResponse = json.decode(response.body);
      List<HikeObject> newHikes = jsonResponse.map((hike) => HikeObject.fromJson(hike)).toList();
      unratedHikes.addAll(newHikes);
      print(unratedHikes.toString());
    } else {
      print("Status code: "+ response.statusCode.toString());
      throw Exception('Failed to load new hikes from API');
    }

  }

  /// Method for posting a single hike to the backend
  void _postHike(HikeObject ratedHike) async {

    /*
    // This temporary method can be used to simulate the API call
    String jsonHike = jsonEncode(ratedHike.toJson());
    StandInAPI.postHikesNoAPI(jsonHike);
    */

    // Post a review for a single hike to the API
    Uri hikeAPIUrl = Uri.parse('http://10.0.2.2:5000/review/${widget.userPreferences.username}');
    final response = await http.post(hikeAPIUrl, body: jsonEncode(ratedHike.toJson()));

    if (response.statusCode == 202) {
      print("Post successful");
    } else {
      print("Status code: "+ response.statusCode.toString());
      throw Exception('Failed to post hike to API');
    }

  }

  @override
  Widget build(BuildContext context){
    CardController controller;

      return Scaffold(
          body: Stack(
            children: [
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: backgroundColor,
              ),
              Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Refresh, or come back later!",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Montserat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]
                            ),
                          ),
                          Icon(
                            Icons.terrain_rounded,
                            size: 200,
                            color: Colors.lightGreen[900],
                          ),
                        ],
                      )
                    ],
                  )

              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    buttonHeight: 50,
                    buttonMinWidth: 90,
                    children: [
                      RaisedButton(
                        child: Icon(
                          Icons.clear_rounded,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          controller.triggerLeft();
                        },
                        color: Colors.white,
                      ),
                      RaisedButton(
                        child: Icon(
                          Icons.refresh_rounded,
                          color: Colors.yellow[700],
                        ),
                        onPressed: () {
                          setState(() {
                            _getHikes(widget.unratedHikes);
                          });
                        },
                        color: Colors.white,
                      ),
                      RaisedButton(
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          controller.triggerRight();
                        },
                        color: Colors.white,
                      ),
                    ],
                  ),

                  SizedBox(height: 40,)
                ],
              ),
              Center(
                  child: Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.6,
                      child: TinderSwapCard(
                        orientation: AmassOrientation.BOTTOM,
                        totalNum: widget.unratedHikes.length,
                        stackNum: 3,
                        swipeEdge: 4.0,
                        maxWidth: MediaQuery
                            .of(context)
                            .size
                            .width * 0.9,
                        maxHeight: MediaQuery
                            .of(context)
                            .size
                            .width * 0.9,
                        minWidth: MediaQuery
                            .of(context)
                            .size
                            .width * 0.8,
                        minHeight: MediaQuery
                            .of(context)
                            .size
                            .width * 0.8,
                        cardBuilder: (context, index) =>
                            Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 20, 0, 0),
                                    child: Center(
                                        child: CarouselSlider(
                                          items: widget.unratedHikes[index].images.map((imgURL) => Image.network(imgURL)).toList(),
                                          options: CarouselOptions(
                                            scrollDirection: Axis.vertical,
                                            enlargeCenterPage: true,
                                            viewportFraction: 1,
                                          ),
                                        ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                            child: Text(
                                              widget.unratedHikes[index]
                                                  .parsedName(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                        ),
                                      ],
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
                            // Card is LEFT swiping, indicate with red background
                            setState(() {
                              backgroundColor = Colors.red;
                            });
                          } else if (align.x > 0) {
                            // Card is RIGHT swiping, indicate with blue background
                            setState(() {
                              backgroundColor = Colors.blue;
                            });
                          }
                        },
                        swipeCompleteCallback:
                            (CardSwipeOrientation orientation, int index) {
                          /// Get orientation & index of swiped card!
                          HikeObject currentHike = widget.unratedHikes[index];
                          if (orientation == CardSwipeOrientation.RIGHT) {
                            // If swiped right, mark as liked and add to matches
                            currentHike.isLiked = true;
                            currentHike.isRated = true;
                            widget.matchedHikes.add(currentHike);
                          } else {
                            // Item was swiped left, mark as disliked
                            currentHike.isLiked = false;
                            currentHike.isRated = true;
                          }

                          if (orientation != CardSwipeOrientation.RECOVER) {
                            // If card was swiped, move the swiped card to the rated list and post the rating to API
                            widget.ratedHikes.add(currentHike);
                            _postHike(currentHike);
                            widget.unratedHikes.remove(
                                currentHike);

                            // Check if we need to get more hikes
                            if (widget.unratedHikes.length == 0) {
                              // Make API calls to get more hikes and send back rated hikes
                              setState(() {
                                _getHikes(widget.unratedHikes);
                              });
                            }
                          }

                          // Reset the background colour
                          setState(() {
                            backgroundColor = Colors.lightGreen[700];
                          });
                        },
                      )
                  )
              ),
            ],
          )
      );
  }
}