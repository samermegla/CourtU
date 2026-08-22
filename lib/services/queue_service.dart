import 'package:cloud_firestore/cloud_firestore.dart';

class QueueService {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    final queueTime = DateTime.now(); //Time that they hit "I'm coming"
    late final expirationTime = queueTime.add(const Duration(minutes: 30));
    bool status = false; 


    Future<void> attendanceSheet({
        required String courtID,
        required String uid,
        required String name,
    }) async{
        await _db.collection('queue').doc(uid).set({
            'courtID': courtID,
            'displayName': name,
            'queue': queueTime,
            'expiration': expirationTime
            'status': status,
            
        });
    }
}