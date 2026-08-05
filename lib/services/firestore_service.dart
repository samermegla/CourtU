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
    String? competitiveness,
  }) async {
    await _db.collection('users').doc(uid).set({
      'displayName': name,
      'email': email,
      // Puck avatar: colors stored as ARGB ints, hat as an option id.
      'skinColor': skinColor,
      'jerseyColor': jerseyColor,
      'hat': hat,
      'position': position,
      'competitiveness': competitiveness,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}