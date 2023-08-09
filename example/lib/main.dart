// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_lab/flutter_lab.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const FlutterLab(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LabContainer(
          alignment: Alignment.center,
          child: LabContainer(
            name: 'Container 2',
            child: LabIcon(
              Icons.favorite,
              size: 140,
            ),
          ),
        ),
      ),
    );
  }
}
