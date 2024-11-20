import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: '12230300 Ali Hussein Project 1',
        debugShowCheckedModeBanner: false,
        home: Home()
    );
  }
}