import 'package:accomodation/test%20firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'dashboard.dart';
import 'package:flutter/material.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options:FirebaseOptions(
        apiKey: "AIzaSyAHsDsqmvVGj0zwvDQaVBt77l2Is2iQUzw",
        appId: "1:980107544854:android:8bb2a70e03b2c47ab26837",
        messagingSenderId: "980107544854",
        projectId: "hdc-dev-9202b"));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    home:Dashboard(),
      );
  }
}

