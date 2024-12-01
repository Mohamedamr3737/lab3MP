import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/workout_service.dart';

class WorkoutPlanScreen extends StatefulWidget {
  @override
  _WorkoutPlanScreenState createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  final WorkoutService _workoutService = WorkoutService();
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  void _addOrUpdateWorkoutPlan({String? id}) {
    final plan = {
      'exerciseName': _exerciseNameController.text,
      'sets': int.parse(_setsController.text),
      'reps': int.parse(_repsController.text),
      'duration': int.parse(_durationController.text),
      'status': 'upcoming', // Default status
    };

    if (id == null) {
      _workoutService.addWorkoutPlan(plan);
    } else {
      _workoutService.updateWorkoutPlan(id, plan);
    }

    _exerciseNameController.clear();
    _setsController.clear();
    _repsController.clear();
    _durationController.clear();

    Navigator.pop(context);
  }

  void _showFormDialog({String? id, Map<String, dynamic>? existingPlan}) {
    if (existingPlan != null) {
      _exerciseNameController.text = existingPlan['exerciseName'];
      _setsController.text = existingPlan['sets'].toString();
      _repsController.text = existingPlan['reps'].toString();
      _durationController.text = existingPlan['duration'].toString();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Add Workout Plan' : 'Edit Workout Plan'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: _exerciseNameController, decoration: InputDecoration(labelText: 'Exercise Name')),
                TextField(controller: _setsController, decoration: InputDecoration(labelText: 'Sets'), keyboardType: TextInputType.number),
                TextField(controller: _repsController, decoration: InputDecoration(labelText: 'Reps'), keyboardType: TextInputType.number),
                TextField(controller: _durationController, decoration: InputDecoration(labelText: 'Duration (seconds)'), keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => _addOrUpdateWorkoutPlan(id: id),
              child: Text(id == null ? 'Add' : 'Update'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout Plans')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _workoutService.getWorkoutPlans(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();

          final plans = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final doc = plans[index];
              final plan = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(plan['exerciseName']),
                subtitle: Text('Sets: ${plan['sets']}, Reps: ${plan['reps']}, Duration: ${plan['duration']}s'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showFormDialog(id: doc.id, existingPlan: plan),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _workoutService.deleteWorkoutPlan(doc.id),
                    ),
                    IconButton(
                      icon: Icon(Icons.check, color: plan['status'] == 'completed' ? Colors.green : Colors.grey),
                      onPressed: () => _workoutService.updateWorkoutPlan(doc.id, {'status': 'completed'}),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
