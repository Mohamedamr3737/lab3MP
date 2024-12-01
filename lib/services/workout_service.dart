import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab_3/services/auth_service.dart';
class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // Collection references
  final CollectionReference _workoutPlans = FirebaseFirestore.instance.collection('workoutPlans');
  final CollectionReference _workoutHistory = FirebaseFirestore.instance.collection('workoutHistory');



  // Add a workout plan
  Future<void> addWorkoutPlan(Map<String, dynamic> workoutPlan) async {
    String? uid = await _authService.getCurrentUserId();
    if (uid != null) {
      workoutPlan['uid'] = uid; // Associate the plan with the user
      await _workoutPlans.add(workoutPlan);
    }
  }

  // Update a workout plan
  Future<void> updateWorkoutPlan(String id, Map<String, dynamic> updatedPlan) async {
    await _workoutPlans.doc(id).update(updatedPlan);
  }

  // Delete a workout plan
  Future<void> deleteWorkoutPlan(String id) async {
    await _workoutPlans.doc(id).delete();
  }

  // Get all workout plans for the current user
  Stream<QuerySnapshot> getWorkoutPlans() async* {
    String? uid = await _authService.getCurrentUserId();
    if (uid != null) {
      yield* _workoutPlans.where('uid', isEqualTo: uid).snapshots();
    }
  }

  Stream<QuerySnapshot> getWorkoutHistory({String? filter}) async* {
    String? uid = await _authService.getCurrentUserId();
    if (uid != null) {
      Query query = _workoutPlans.where('uid', isEqualTo: uid);
      if (filter == 'Completed') {
        query = query.where('status', isEqualTo: 'completed');
      } else if (filter == 'Upcoming') {
        query = query.where('status', isEqualTo: 'upcoming');
      }
      yield* query.snapshots();
    }
  }


}
