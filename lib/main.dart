import 'package:flutter/material.dart';
import 'quiz_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP2 - Quiz Flutter',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const QuizPage(),
    );
  }
}