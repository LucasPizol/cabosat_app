import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getNotifications<T>(String topic) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("notifications")
        .where('topic', isEqualTo: topic)
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
