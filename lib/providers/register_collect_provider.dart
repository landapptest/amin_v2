import 'package:firebase_database/firebase_database.dart';

class RegisterCollectProvider {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      await _database.child('users').push().set(userData);
      print("User data saved successfully!");
    } catch (e) {
      print("Error saving user data: $e");
      rethrow;
    }
  }
}