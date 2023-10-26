import 'package:flutter/material.dart';
import 'package:practice2/widgets/text_feild_container.dart';

class RoundedPasswordFeild extends StatefulWidget {

  final ValueChanged<String> onChanged;

  RoundedPasswordFeild({
    required this.onChanged,
  });

  @override
  State<RoundedPasswordFeild> createState() => _RoundedPasswordFeildState();
}

bool obscureText = true;

class _RoundedPasswordFeildState extends State<RoundedPasswordFeild> {
  @override
  Widget build(BuildContext context) {
    return TextFeildContainer(
      child: TextFormField(
        obscureText: !obscureText,
        onChanged: widget.onChanged,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(
            Icons.lock,
            color: Colors.purple,
          ),
          suffixIcon: GestureDetector(
            onTap: ()
            {
              setState(() {
                obscureText = !obscureText;
              });
            },
            child: Icon(
              obscureText
              ? Icons.visibility
              :Icons.visibility_off,
              color: Colors.black54,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}