//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:hiking_app/main.dart';
import 'package:hiking_app/HikeObject.dart';
import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

class HikesScreen extends StatefulWidget {
  List<HikeObject> unratedHikes;
  List<HikeObject> ratedHikes;
  List<HikeObject> matchedHikes;
  HikesScreen({Key key, this.unratedHikes, this.ratedHikes, this.matchedHikes}): super(key: key);

  @override
  _HikesScreenState createState() => _HikesScreenState();
}


class _HikesScreenState extends State<HikesScreen> with TickerProviderStateMixin{
  Color backgroundColor = Colors.lightGreen[700];
  double likeOpacity = 0;
  double dislikeOpacity = 0;

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
                  // Center(
                  //   child: Container(
                  //     height: 40,
                  //     width: 200,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       children: [
                  //         Icon(
                  //           Icons.clear_rounded,
                  //           color: Colors.red,
                  //           size: 40,
                  //         ),
                  //         VerticalDivider(
                  //           color: Colors.grey,
                  //         ),
                  //
                  //         IconButton(
                  //           color: Colors.white,
                  //
                  //           icon: Icon(
                  //             Icons.check_rounded,
                  //             color: Colors.green,
                  //             size: 40,
                  //           ),
                  //           onPressed: (){
                  //             print("woo!");
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

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
                          //TODO: Add hike refresh functionality.
                          // Note: hikes should automatically refresh when the list gets too small (<5 hikes)
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
                                    child: Center(child: Image.network(
                                        widget.unratedHikes[index].images[0])),
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
                            //Card is LEFT swiping
                            setState(() {
                              backgroundColor = Colors.red;
                            });
                          } else if (align.x > 0) {
                            //Card is RIGHT swiping
                            setState(() {
                              backgroundColor = Colors.blue;
                            });
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

                          if (orientation != CardSwipeOrientation.RECOVER) {
                            // If card was swiped, move the swiped card to the rated list
                            widget.ratedHikes.add(widget.unratedHikes[index]);
                            widget.unratedHikes.remove(
                                widget.unratedHikes[index]);
                          }

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