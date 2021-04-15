import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class HikesScreen extends StatefulWidget {
  @override
  _HikesScreenState createState() => _HikesScreenState();
}
class _HikesScreenState extends State<HikesScreen> with TickerProviderStateMixin{
  List<String> imagePaths = [
    "assets/unmatched-hikes/alpha-mountain-east-ridge-route-1.jpg",
    "assets/unmatched-hikes/alpha-mountain-east-ridge-route-2.jpg",
    "assets/unmatched-hikes/bladu-pass-and-marriott-basin-trail-0.jpg",
    "assets/unmatched-hikes/bladu-pass-and-marriott-basin-trail-1.jpg",
    "assets/unmatched-hikes/bladu-pass-and-marriott-basin-trail-2.jpg",
    "assets/unmatched-hikes/video-peak-0.jpg",
    "assets/unmatched-hikes/video-peak-1.jpg",
    "assets/unmatched-hikes/video-peak-2.jpg",
  ];

  @override
  Widget build(BuildContext context){
    CardController controller;
    return Scaffold(
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: TinderSwapCard(
              orientation: AmassOrientation.BOTTOM,
              totalNum: imagePaths.length,
              stackNum: 3,
              swipeEdge: 4.0,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.width * 0.9,
              minWidth: MediaQuery.of(context).size.width * 0.8,
              minHeight: MediaQuery.of(context).size.width * 0.8,
              cardBuilder: (context, index) => Card(
                child: Image.asset('${imagePaths[index]}'),
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
              },
            )
          )
        )

    );
  }
}