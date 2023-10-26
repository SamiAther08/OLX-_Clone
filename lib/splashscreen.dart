import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice2/WelcomeScreen/welcomeScreen.dart';
import 'package:practice2/home_screen/home.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer()
  {
    Timer(Duration(seconds: 5), () async{
      if(FirebaseAuth.instance.currentUser != null)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
      else
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
    Colors.white,
    Colors.cyan,
  ];

  const colorizeTextStyle = TextStyle(
    fontSize: 30.0,
    fontFamily: 'Lobster',
    fontWeight: FontWeight.bold,
  );
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset('assets/images/logo.png', width: 350.0,),

              ),
              SizedBox(height: 10),
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'Buy & Sell',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                  ),
                ],
                isRepeatingAnimation: true,
                onTap: () {
                  print("Tap Event");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}