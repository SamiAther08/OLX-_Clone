import 'package:flutter/material.dart';
import 'package:practice2/ForgetPassword/forget_body.dart';

class ForgetPassword extends StatefulWidget {

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForgetBody(),
    );
  }
}