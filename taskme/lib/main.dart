import 'package:flutter/material.dart';
import 'package:taskme/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter("hive_boxes");
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskMe',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: HomePage(),
    );
  }
}

