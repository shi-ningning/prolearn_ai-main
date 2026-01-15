import '../models/user_model.dart';
import '../services/firebase_service.dart';

class UserRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<UserModel?> getUser(String id) async {
    final docs = await _firebaseService.getDocuments('users');
    final userData = docs.firstWhere((doc) => doc['id'] == id, orElse: () => {});
    if (userData.isEmpty) return null;
    return UserModel.fromJson(userData);
  }

  Future<void> saveUser(UserModel user) async {
    await _firebaseService.addDocument('users', user.toJson());
  }
}
