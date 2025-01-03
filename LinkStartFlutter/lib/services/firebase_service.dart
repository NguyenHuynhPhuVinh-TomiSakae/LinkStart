import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> updateSlideValue(int value) async {
    try {
      await _database.child('slide').set(value);
    } catch (e) {
      print('Error updating slide value: $e');
      throw e;
    }
  }
}
