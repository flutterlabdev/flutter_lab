// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_lab/flutter_lab.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // To connect to FlutterLab App
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
      title: 'FlutterLab Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'FlutterLab Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LabContainer(
        //Add a Container widget in FlutterLab and rename as "background"
        name: "background",
        alignment: Alignment.center,
        child: LabContainer(
          //Add a Container widget in FlutterLab
          width: 220,
          height: 220,
          child: Center(
            child: Text(
              "Change the properties of this Container with FlutterLab App",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
