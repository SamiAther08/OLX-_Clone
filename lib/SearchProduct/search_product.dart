import 'package:flutter/material.dart';

class SearchProduct extends StatefulWidget {

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Product',
          style: TextStyle(
            color: Colors.black54,
            fontFamily: 'Signatra',
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}