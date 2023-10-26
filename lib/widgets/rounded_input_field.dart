import 'package:flutter/material.dart';
import 'package:practice2/widgets/text_feild_container.dart';

class RoundedInputFeild extends StatelessWidget {

  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  RoundedInputFeild({
    required this.hintText,
    this.icon= Icons.person,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFeildContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.purple,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}