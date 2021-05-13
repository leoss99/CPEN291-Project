import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiking_app/services/databaseservice.dart';
import 'package:hiking_app/services/usermanagement.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _email;
  String _password;
  String name;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                  decoration: InputDecoration(
                      hintText: 'Name'
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  }
              ),
              SizedBox(
                  height: 15.0
              ),
              TextField(
                  decoration: InputDecoration(
                      hintText: 'Email'
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  }
              ),
              SizedBox(
                  height: 15.0
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: 'Password'
                ),
                onChanged: (value){
                  setState(() {
                    _password = value;
                  });
                },
                obscureText: true,
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: (){
                  FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _email,
                      password: _password
                  ).then((userCredential) async {
                      UserManagement().storeNewUser(userCredential.user,name, context);
                      FirebaseAuth.instance.currentUser.updateProfile(displayName: name);
                      await DatabaseService(uid: userCredential.user.uid).updateUserName(name);
                      await DatabaseService(uid: userCredential.user.uid).updateUserData(0,100,0,1000, false, false, false);
                      Navigator.of(context).pushReplacementNamed('/homepage');
                  })
                      .catchError((e) {
                    print(e);
                  });
                },
                child: Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20)
                    )
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
