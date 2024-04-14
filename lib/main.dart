import 'package:flutter/material.dart';
import 'package:ldsw_widgets/screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, //Para quitar banner DEBUG
      title: 'LDSW Widgets',
      home: HomeScreen(),
    );
  }
}
