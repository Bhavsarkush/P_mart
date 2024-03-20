import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:p_mart/login/Login.dart';

import 'demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:login(),
      debugShowCheckedModeBanner: false,
    );
  }
}
