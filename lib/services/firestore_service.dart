import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createProfile({
    required String uid,
    required String name,
    required String? email,
    int? skinColor,
    int? jerseyColor,
    String? hat,
    String? position,
  }) async {
    await _db.collection('users').doc(uid).set({
      'displayName': name,
      'email': email,
      'skinColor': skinColor,
      'jerseyColor': jerseyColor,
      'hat': hat,
      'position': position,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}