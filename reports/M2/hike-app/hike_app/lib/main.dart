import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiking_app/HikeObject.dart';
import 'package:hiking_app/HikesScreen.dart';
import 'package:hiking_app/ProfileScreen.dart';
import 'package:hiking_app/MatchesScreen.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}


class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {


  int _currentIndex = 1;
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
    // For testing, initialize unrated hikes list
    unratedHikes = [HikeObject(hikeName: 'garibaldi-lake-trail', rating: 'unrated',
        images: [
          'https://cdn-assets.alltrails.com/uploads/photo/image/23957167/large_04c8a06a56c3a328db71d851edb1bfb7.jpg',
          'https://cdn-assets.alltrails.com/uploads/photo/image/34901847/large_be7ea843c1cfe9954a10f250b3130d69.jpg',
          'https://cdn-assets.alltrails.com/uploads/photo/image/34480541/large_fcf2776da5f128d9e494e707ba167708.jpg'],),
      HikeObject(hikeName: 'eagle-bluff-trail', rating: 'unrated',
          images: [
            'https://cdn-assets.alltrails.com/uploads/photo/image/19188231/large_ed307a8a1d3f90ade5f2b58fdf520339.jpg',
            'https://cdn-assets.alltrails.com/uploads/photo/image/34906253/large_03a86e6ff18c9eab7263988d40e11571.jpg',
            'https://cdn-assets.alltrails.com/uploads/photo/image/34903552/large_ab935d1f24175be5500149029dc1b58a.jpg']),
      HikeObject(hikeName: 'watersprite-lake-summer-route', rating: 'unrated',
          images: [
            'https://cdn-assets.alltrails.com/uploads/photo/image/23996582/large_05f2f399322b219c104564781265e1be.jpg',
            'https://cdn-assets.alltrails.com/uploads/photo/image/32187507/large_42718a3b683683b963cfe68853b54f0f.jpg',
            'https://cdn-assets.alltrails.com/uploads/photo/image/31272629/large_0340b9537b9aaacd5289c15cad889007.jpg'],),
    ];


    ratedHikes = [];
    matchedHikes = [];

    profileScreen = ProfileScreen(userPreferences: userPreferences,);
    hikesScreen = HikesScreen(matchedHikes: matchedHikes, unratedHikes: unratedHikes, ratedHikes: ratedHikes,);
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