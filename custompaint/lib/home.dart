import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String data;
  const HomePage({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(data)),
    );
  }
}
