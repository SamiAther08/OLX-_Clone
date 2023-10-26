import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice2/ForgetPassword/forget_password.dart';
import 'package:practice2/LoginScreen/login_background.dart';
import 'package:practice2/SignupScreen/signup_screen.dart';
import 'package:practice2/dialog_box/error_dialog.dart';
import 'package:practice2/dialog_box/loading_dialog.dart';
import 'package:practice2/home_screen/home.dart';
import 'package:practice2/widgets/already_have_an_account_check.dart';
import 'package:practice2/widgets/rounded_button.dart';
import 'package:practice2/widgets/rounded_input_field.dart';
import 'package:practice2/widgets/rounded_paassword_feild.dart';

class LoginBody extends StatefulWidget {

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async
  {
    showDialog(
      context: context,
      builder: (_)
      {
        return LoadingAlertDialog(
          message: 'Please Wait....',
        );
      }
    );
    User? currentUser;

    await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(), 
      password: _passwordController.text.trim(),
      ).then((auth)
      {
        currentUser = auth.user;
      }).catchError((error)
      {
        Navigator.pop(context);
        showDialog(context: context, builder: (context)
        {
          return ErrorAletDialog(
            message: error.message.toString(),
          );
        });
      });

      if(currentUser != null)
      {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
      else
      {
        print('error');
      }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.04,),
            Image.asset('assets/icons/login.png',
            height: size.height * 0.32,
            ),
            SizedBox(height: size.height  * 0.03,),
            RoundedInputFeild(
              hintText: 'Email',
              icon: Icons.person, 
              onChanged: (value){
                _emailController.text = value; 

              }),
              SizedBox(height: 3,),
              RoundedPasswordFeild(
                onChanged: (value)
                {
                  _passwordController.text = value;
                },
              ),
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));
                  },
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  ),
              ),
              RoundedButton(
                text: 'LOGIN',
                press: () {
                  _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
                  ? _login()
                  : showDialog(context: context, builder: (context)
                  {
                    return ErrorAletDialog(message: 'Please Write Email & Password for LogIn');
                  });               
                },
              ),
              SizedBox(height: size.height * 0.01,),
              AlreadyHaveAccountCheck(
                login: true,
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                },
              )
          ],
        ),
      ),
    );
  }
}