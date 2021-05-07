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
    unratedHikes = [HikeObject(hikeName: 'garibaldi-lake-trail',
        img_1: 'https://cdn-assets.alltrails.com/uploads/photo/image/23957167/large_04c8a06a56c3a328db71d851edb1bfb7.jpg', rating: 'unrated'),
      HikeObject(hikeName: 'eagle-bluff-trail',
          img_1: 'https://cdn-assets.alltrails.com/uploads/photo/image/19188231/large_ed307a8a1d3f90ade5f2b58fdf520339.jpg', rating: 'unrated'),
      HikeObject(hikeName: 'watersprite-lake-summer-route',
          img_1: 'https://cdn-assets.alltrails.com/uploads/photo/image/23996582/large_05f2f399322b219c104564781265e1be.jpg', rating: 'unrated'),
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

    // matchedHikes = [HikeObject(hikeName: 'garibaldi-lake-trail', photoName: 'garibaldi-lake-trail-0',
    //   photoURL: 'https://cdn-assets.alltrails.com/uploads/photo/image/23957167/large_04c8a06a56c3a328db71d851edb1bfb7.jpg', rating: 'unrated'),
    //   HikeObject(hikeName: 'eagle-bluff-trail', photoName: 'eagle-bluff-trail-0',
    //   photoURL: 'https://cdn-assets.alltrails.com/uploads/photo/image/19188231/large_ed307a8a1d3f90ade5f2b58fdf520339.jpg', rating: 'unrated'),
    //   HikeObject(hikeName: 'watersprite-lake-summer-route', photoName: 'watersprite-lake-summer-route-0',
    //   photoURL: 'https://cdn-assets.alltrails.com/uploads/photo/image/23996582/large_05f2f399322b219c104564781265e1be.jpg', rating: 'unrated')
    // ];



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