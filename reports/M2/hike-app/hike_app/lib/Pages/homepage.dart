import 'package:flutter/material.dart';
import 'package:hiking_app/HikeObject.dart';
import 'package:hiking_app/Pages/HikesScreen.dart';
import 'package:hiking_app/Pages/ProfileScreen.dart';
import 'package:hiking_app/Pages/MatchesScreen.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {


  int _currentIndex = 0;
  ProfileData userPreferences;
  List<HikeObject> matchedHikes;
  List<HikeObject> ratedHikes;
  List<HikeObject> unratedHikes;

  ProfileScreen profileScreen;
  HikesScreen hikesScreen;
  MatchesScreen matchesScreen;
  List<Widget> _children;
  Widget currentPage;


  @override
  void initState() {

    userPreferences = ProfileData();

    unratedHikes = [];
    ratedHikes = [];
    matchedHikes = [];

    profileScreen = ProfileScreen(userPreferences: userPreferences,);
    hikesScreen = HikesScreen(matchedHikes: matchedHikes, unratedHikes: unratedHikes, ratedHikes: ratedHikes, userPreferences: userPreferences,);
    matchesScreen = MatchesScreen(matches: matchedHikes,);

    _children = [
      profileScreen,
      hikesScreen,
      matchesScreen
    ];


    super.initState();
  }


  void onTabTapped(int index) {
    setState(() {
      // If the user is moving away from the profile screen, post user preferences to API
      if (_currentIndex == 0) {
        userPreferences.postPreferences();
      }
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
                color: Colors.lightGreen[700]),
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