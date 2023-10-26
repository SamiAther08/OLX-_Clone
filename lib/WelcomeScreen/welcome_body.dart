import 'package:flutter/material.dart';
import 'package:practice2/LoginScreen/login_screen.dart';
import 'package:practice2/SignupScreen/signup_screen.dart';
import 'package:practice2/WelcomeScreen/welcome_background.dart';
import 'package:practice2/widgets/rounded_button.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WelcomeBackground(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'X-Wheels',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              fontFamily: 'Signatra',
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Image.asset(
            'assets/icons/chat.png',
            height: size.height * 0.40,
          ),
          RoundedButton(
            text: 'LogIn',
            press: ()
             {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));

             }
             ),
             RoundedButton(
            text: 'SignUp',
            press: ()
             {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupScreen()));

             }
             ),
        ],
      ),
    ));
  }
}
