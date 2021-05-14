import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/widgets.dart';

class UserManagement{
  storeNewUser(user, name, context){
    FirebaseFirestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
      'displayName': name,
      'photoURL': user.photoURL,
    }).then((value){
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e){
      print(e);
    });
  }

  Future updateNickName(String newName) async {
    await FirebaseAuth.instance.currentUser.updateProfile(displayName: newName).then((val) {
        FirebaseFirestore.instance
            .collection('/users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({'displayName': newName});
  });
        }

  Future updateProfilePic(picUrl) async {

    await FirebaseAuth.instance.currentUser.updateProfile(photoURL: picUrl).then((val) {
        FirebaseFirestore.instance
            .collection('/users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({'photoUrl': picUrl});
      });
  }
}