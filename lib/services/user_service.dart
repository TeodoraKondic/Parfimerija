import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parfimerija_app/models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<List<UserModel>> getUsers() async {
    try {
      QuerySnapshot snapshot = await _db.collection('korisnici').get();
      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching user: $e");
      return [];
    }
  }
}