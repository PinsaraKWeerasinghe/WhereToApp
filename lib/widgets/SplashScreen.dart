import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whereto/util/assets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width/3,
              child: Image.asset(Assets.LOGO_GRAPHIC),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text("Powered By:"),
                Text("EVOLABS",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Padding(padding: EdgeInsets.all(50),)
              ],
            ),
          ),

        ],
      ),
    );
  }

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Root');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
}
