import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  final CollectionReference _reviews =
      FirebaseFirestore.instance.collection('reviews');

  Future<List<Map<String, dynamic>>> getReviews() async {
    final snapshot = await _reviews.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['recId'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> addReview({
    required String uid,
    required String productId,
    required String comment,
    required int rating,
  }) async {
    await _reviews.add({
      'uid': uid,
      'productId': productId,
      'comment': comment,
      'rating': rating,
    });
  }

  Future<void> updateReview({
    required String recId,
    required String comment,
    required int rating,
  }) async {
    await _reviews.doc(recId).update({
      'comment': comment,
      'rating': rating,
    });
  }

  Future<void> deleteReview(String recId) async {
    await _reviews.doc(recId).delete();
  }
}
