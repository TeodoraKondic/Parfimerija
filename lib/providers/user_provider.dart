import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;
  UserModel? get getUser => _userModel;

 
  Future<void> fetchUserInfo(String email) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("korisnici")
          .where("email", isEqualTo: email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        _userModel = UserModel.fromFirestore(userDoc.docs.first.data());
        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }
  void clearUser() {
    _userModel = null; 
    notifyListeners(); 
  }
}