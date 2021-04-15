import 'package:flutter/material.dart';
import 'package:hiking_app/HikesScreen.dart';
import 'package:hiking_app/ProfileScreen.dart';
import 'package:hiking_app/MatchesScreen.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

// class HikingApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    ProfileScreen(),
    HikesScreen(),
    MatchesScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
            color: Color(0xFFf2c82e)),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.terrain,
            color: Colors.green),
            label: 'Hikes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_sharp,
            color: Colors.pink,),
            label: 'Matches',
          ),
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}