import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth_page.dart';
import 'screens/workout_history_screen.dart';
import 'screens/workout_plan_screen.dart';
import 'screens/homeScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthPage(),
        '/home': (context) => MainScreen(),
        '/workout-plan': (context) => WorkoutPlanScreen(),
        '/workout-history': (context) => WorkoutHistoryScreen(),
      },
    );
  }
}
