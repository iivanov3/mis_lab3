import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lab3/features/user_auth/presentation/pages/login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDwNah-A0n8tPlqI0Wrda1poj1zM-VsGUQ",
            authDomain: "lab3-firebase-28856.firebaseapp.com",
            projectId: "lab3-firebase-28856",
            storageBucket: "lab3-firebase-28856.appspot.com",
            messagingSenderId: "675595500750",
            appId: "1:675595500750:web:c3e6ab5385c5611ed7249f"));
  }
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase',
      home: LoginPage(),
    );
  }
}
