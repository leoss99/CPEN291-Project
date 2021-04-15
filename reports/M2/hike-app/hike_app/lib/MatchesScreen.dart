import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Matches"),
      ),
      body: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 8.0,
          children:[
            Image.asset('assets/matches/colleymount-point-0.jpg'),
            Image.asset('assets/matches/colleymount-point-1.jpg'),
            Image.asset('assets/matches/colleymount-point-2.jpg'),
            Image.asset('assets/matches/skywalk-north-and-south-loop-0.jpg'),
            Image.asset('assets/matches/skywalk-north-and-south-loop-1.jpg'),
            Image.asset('assets/matches/skywalk-north-and-south-loop-2.jpg'),
            Image.asset('assets/matches/colleymount-point-0.jpg'),
            Image.asset('assets/matches/colleymount-point-1.jpg'),
            Image.asset('assets/matches/colleymount-point-2.jpg'),
            Image.asset('assets/matches/skywalk-north-and-south-loop-0.jpg'),
            Image.asset('assets/matches/skywalk-north-and-south-loop-1.jpg'),
            Image.asset('assets/matches/skywalk-north-and-south-loop-2.jpg'),
            Image.network(
              'https://cdn-assets.alltrails.com/uploads/photo/image/23957167/large_04c8a06a56c3a328db71d851edb1bfb7.jpg',
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : LinearProgressIndicator();
              },
            ),
          ]
      ),
    );
  }
}