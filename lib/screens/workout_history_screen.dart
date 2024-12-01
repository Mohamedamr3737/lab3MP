import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/workout_service.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  @override
  _WorkoutHistoryScreenState createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  final WorkoutService _workoutService = WorkoutService();
  String _filter = 'All'; // Default filter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'All', child: Text('All')),
              PopupMenuItem(value: 'Completed', child: Text('Completed')),
              PopupMenuItem(value: 'Upcoming', child: Text('Upcoming')),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _workoutService.getWorkoutHistory(filter: _filter),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final history = snapshot.data?.docs ?? [];

          if (history.isEmpty) {
            return Center(child: Text('No workouts found.'));
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final doc = history[index];
              final workout = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(workout['exerciseName']),
                subtitle: Text('Duration: ${workout['duration']} seconds\nStatus: ${workout['status']}'),
                trailing: workout['status'] == 'completed'
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.access_time, color: Colors.grey),
              );
            },
          );
        },
      ),
    );
  }
}
