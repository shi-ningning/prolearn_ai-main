import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }

  /// Set a document with a specific ID (creates or updates)
  Future<void> setDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(collection).doc(id).set(data);
  }

  Future<List<Map<String, dynamic>>> getDocuments(String collection) async {
    final QuerySnapshot snapshot = await _firestore
        .collection(collection)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      // Include document ID
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<Map<String, dynamic>?> getDocument(
    String collection,
    String id,
  ) async {
    final DocumentSnapshot doc = await _firestore
        .collection(collection)
        .doc(id)
        .get();
    return doc.exists ? doc.data() as Map<String, dynamic>? : null;
  }

  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(collection).doc(id).update(data);
  }

  Future<void> deleteDocument(String collection, String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }

  /// Get real-time stream of documents from a collection
  Stream<List<Map<String, dynamic>>> getDocumentsStream(String collection) {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  /// Get real-time stream of syllabi
  Stream<List<Map<String, dynamic>>> getSyllabiStream() {
    return getDocumentsStream('syllabi');
  }
}
