import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
