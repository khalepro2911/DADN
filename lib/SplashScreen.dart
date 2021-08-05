import 'SignIn.dart';
import 'package:flutter/material.dart';

import 'package:splashscreen/splashscreen.dart';

class SplashScreens extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreens> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Timer(Duration(seconds: 5), () => Navigator.push(context,MaterialPageRoute(builder:(context)=>HomePage())));
  }
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(

      seconds: 3,
      navigateAfterSeconds: new SignIn(),
      title: new Text(
        'IS',
        textAlign: TextAlign.center,
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 100.0, color: Colors.white),
      ),
      //image: new Image(image: AssetImage('assets/splashscreen.png'),


      backgroundColor: new Color(0xFF622F74),
      gradientBackground: LinearGradient(
        colors: [new Color(0xffc471ed), new Color(0xff12c2e9)],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      ),
      //backgroundColor: Colors.white,
      loaderColor: Colors.white,
    );
  }
}





