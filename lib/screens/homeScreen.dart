
import 'package:flutter/material.dart';
import 'workout_history_screen.dart';
import 'workout_plan_screen.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;  // Track the current index of BottomNavigationBar

  // List of widgets representing each page
  final List<Widget> _pages = [
    WorkoutHistoryScreen(),
    WorkoutPlanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Planner Application '),
      ),
      body: IndexedStack(
        index: _currentIndex,  // Show the selected page
        children: _pages,      // Page content
      ),
      bottomNavigationBar: ClipPath(
        clipper: RoundedTopNavClipper(),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Workout History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_gymnastics),
              label: 'Workout plan',
            ),

          ],
        ),
      ),
    );
  }
}

// Custom Clipper for Rounded Top Corners
class RoundedTopNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double roundnessFactor = 30.0;

    // Start at the top-left of the widget
    path.moveTo(0, roundnessFactor);
    path.quadraticBezierTo(0, 0, roundnessFactor, 0); // Top-left rounded corner
    path.lineTo(size.width - roundnessFactor, 0);
    path.quadraticBezierTo(size.width, 0, size.width, roundnessFactor); // Top-right rounded corner
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height); // Bottom line
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}