import 'package:flutter/material.dart';
import 'package:practice2/WelcomeScreen/welcomeScreen.dart';

class ErrorAletDialog extends StatelessWidget {

  final String message;

  ErrorAletDialog({
    required this.message
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: () 
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
          },
          child: Center(
            child: Text('OK'),
          ),
        )
      ],
    );
  }
}