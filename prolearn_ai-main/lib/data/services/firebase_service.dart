import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }

  Future<List<Map<String, dynamic>>> getDocuments(String collection) async {
    final QuerySnapshot snapshot = await _firestore.collection(collection).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>?> getDocument(String collection, String id) async {
    final DocumentSnapshot doc = await _firestore.collection(collection).doc(id).get();
    return doc.exists ? doc.data() as Map<String, dynamic>? : null;
  }

  Future<void> updateDocument(String collection, String id, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(id).update(data);
  }

  Future<void> deleteDocument(String collection, String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }
}
