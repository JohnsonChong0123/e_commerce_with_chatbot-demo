import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/common/utils/firebase_util.dart';
import '../../models/wishlist_model.dart';

abstract class WishlistRemoteData {
  Future<void> addToWishlist({
    required String productId,
    required String name,
    required double price,
    required String image,
    required String overview,
  });
  Future<List<WishlistModel>> getWishlist();
  Future<void> removeFromWishlist(String productId);
  Future<void> clearWishlist();
}

class WishlistRemoteDataImpl implements WishlistRemoteData {
  @override
  Future<void> addToWishlist({
    required String productId,
    required String name,
    required double price,
    required String image,
    required String overview,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Favourites')
          .doc(productId)
          .set({
        'wishlistId': productId,
        'wishlistName': name,
        'wishlistImage': image,
        'wishlistPrice': price,
        'wishlistOverview': overview,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<WishlistModel>> getWishlist() async {
    try {
      final wishlistData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Favourites')
          .get();
      final wishlistDataList = wishlistData.docs
          .map((e) => WishlistModel.fromJson(e.data()))
          .toList();
      return wishlistDataList;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Favourites')
          .doc(productId)
          .delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> clearWishlist() async {
    try {
      final wishlistData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Favourites')
          .get();
      for (final doc in wishlistData.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
