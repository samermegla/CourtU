import 'package:cloud_firestore/cloud_firestore.dart';

/// Reads and writes the `courts` collection in Firestore.
class CourtService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Writes one volleyball court. [id] is a stable, human-readable document id
  /// (e.g. 'ut-dallas-sand'); reusing it overwrites that same document instead
  /// of creating a duplicate.
  Future<void> addCourt({
    required String id,
    required String name,
    required double lat,
    required double long,
    String surface = 'sand',
  }) async {
    await _db.collection('courts').doc(id).set({
      'name': name,
      'latitude': lat,
      'longitude': long,
      'surface': surface,
    });
  }


  Future<List<Map<String, dynamic>>> fetchCourts() async {
    final snapshot = await _db.collection('courts').get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  //UT Dallas Court
  Future<void> seedUtDallas() async {
    await addCourt(
      id: 'ut-dallas-sand',
      name: 'UT Dallas Sand Volleyball Court',
      lat: 32.983313,
      long: -96.74997,
      surface: 'sand',
    );
  }
}
