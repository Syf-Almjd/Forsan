import 'package:flutter/material.dart';

class page extends StatefulWidget {
  const page({super.key});

  @override
  State<page> createState() => _pageState();
}

List names = [
  "ahmed",
  "ali",
  "ahmed",
  "ali",
  "ahmed",
  "ali",
  "ahmed",
  "ali",
];

class _pageState extends State<page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(color: Colors.red),
            ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(color: Colors.blue),
            ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(color: Colors.blue),
            ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(color: Colors.blue),
            ),
          ],
        ),
      )),
    );
  }
}
