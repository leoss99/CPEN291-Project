import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class UserManagement{
  storeNewUser(user, context){
    FirebaseFirestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid
    }).then((value){
      print("popping");
      Navigator.of(context).pop();
      print("popped");
      Navigator.of(context).pushReplacementNamed('/homepage');
      print("bruh");
    }).catchError((e){
      print(e);
    });
  }
}