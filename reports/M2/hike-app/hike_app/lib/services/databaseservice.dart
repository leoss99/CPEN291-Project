import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userPreferences = FirebaseFirestore.instance.collection('userPreferences');

  Future<void> updateUserData(double prefDistanceMin,
      double prefDistanceMax,
      double prefElevationMin,
      double prefElevationMax,
  bool prefEasy, bool prefMod, bool prefHard) async {
    return await userPreferences.doc(uid).update({
      'prefDistanceMin': prefDistanceMin,
      'prefDistanceMax': prefDistanceMax,
      'prefElevationMin': prefElevationMin,
      'prefElevationMax': prefElevationMax,
      'prefEasy': prefEasy,
      'prefMod': prefMod,
      'prefHard': prefHard,
  });
  }
  Future<void> updateUserName(String newName) async {
    return await userPreferences.doc(uid).update({
      'name': newName,
    });
  }
  Stream<QuerySnapshot> get userPrefs{
    return userPreferences.snapshots();
  }
}