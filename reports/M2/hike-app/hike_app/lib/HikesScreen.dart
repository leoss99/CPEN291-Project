import 'package:flutter/material.dart';

class HikesScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.grey,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.done,
                          color: Colors.green)
                  )
              ),),
            Expanded(
              child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.close,
                          color: Colors.red)
                  )
              ),),
          ],
        )

    );
  }
}