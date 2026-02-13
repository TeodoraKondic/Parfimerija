import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get getUser => _user;
  bool get isAdmin => _user != null && _user!.role == 'admin';
  
  Future<void> fetchUserInfo(String identifier, {bool byUid = false}) async {
    try {
      DocumentSnapshot doc;
      if (byUid) {
        doc = await FirebaseFirestore.instance
            .collection('korisnici')
            .doc(identifier)
            .get();
      } else {
        
        final query = await FirebaseFirestore.instance
            .collection('korisnici')
            .where('email', isEqualTo: identifier)
            .limit(1)
            .get();
        if (query.docs.isEmpty) {
          _user = null;
          notifyListeners();
          return;
        }
        doc = query.docs.first;
      }

      if (doc.exists) {
        _user = UserModel.fromFirestore(doc.data() as Map<String, dynamic>);
      } else {
        _user = null;
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching user info: $e");
    }
  }

  
  Future<void> updateUser(Map<String, dynamic> updates) async {
    if (_user == null) return;
    try {
      final userDoc = FirebaseFirestore.instance
          .collection('korisnici')
          .doc(updates['uid'] ?? _user!.email);

      
      await userDoc.set(updates, SetOptions(merge: true));

   
      _user = UserModel.fromFirestore({
        ...(_user!.toMap()),
        ...updates,
      });

      notifyListeners();
    } catch (e) {
      debugPrint("Error updating user: $e");
    }
  }

 
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}

extension on UserModel {
}
