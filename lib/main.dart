import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'todopage.dart';
// If you used flutterfire CLI, uncomment below:
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase
  await Firebase.initializeApp(
    // If using flutterfire CLI, use this:
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),

      home:  TodoPage(),
    );
  }
}