import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/common/utils/firebase_util.dart';
import '../../models/review_model.dart';

abstract interface class ReviewRemoteData {
  Stream<List<ReviewModel>> getReviews(String productId);
  Future<void> addReview({
    required String productId,
    required double rating,
    required String comment,
  });
}

class ReviewRemoteDataImpl implements ReviewRemoteData {
  @override
  Stream<List<ReviewModel>> getReviews(String productId) {
    return FirebaseFirestore.instance
        .collection('Reviews')
        .doc(productId)
        .collection('Items')
        .orderBy('reviewTimestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return ReviewModel.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<void> addReview({
    required String productId,
    required double rating,
    required String comment,
  }) async { 
    final reviewsRef = FirebaseFirestore.instance
        .collection('Reviews')
        .doc(productId)
        .collection('Items');

    final reviewDoc = reviewsRef.doc(); 

    await reviewDoc.set({
      'reviewId': reviewDoc.id, 
      'reviewUserId': currentUser!.uid,
      'reviewUsername': currentUser!.displayName,
      'reviewRating': rating,
      'reviewComment': comment,
      'reviewTimestamp': DateTime.now().toIso8601String(),
    });
  }
}
