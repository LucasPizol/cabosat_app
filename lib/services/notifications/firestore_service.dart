import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getNotifications<T>(String topic) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("notifications")
        .where('topic', isEqualTo: topic)
        .where('createdAt',
            isGreaterThan: DateTime.now().subtract(const Duration(days: 7)))
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
