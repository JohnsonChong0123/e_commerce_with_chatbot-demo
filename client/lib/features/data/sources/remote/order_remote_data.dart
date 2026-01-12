import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/common/utils/firebase_util.dart';
import '../../../../core/errors/exception.dart';
import '../../models/order_model.dart';

abstract interface class OrderRemoteData {
  Future<void> addOrder(OrderModel order);
  Future<List<OrderModel>> getOrder();
  Future<void> removeOrder(String orderId);
  Future<void> clearOrder();
}

class OrderRemoteDataImpl implements OrderRemoteData {
  @override
  Future<void> addOrder(OrderModel order) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Orders History')
          .doc(order.orderId)
          .set(order.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<OrderModel>> getOrder() async {
    try {
      final orderData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Orders History')
          .orderBy('orderId', descending: true)
          .get();
      return orderData.docs
          .map((order) => OrderModel.fromJson(order.data()))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> removeOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Orders History')
          .doc(orderId)
          .delete();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> clearOrder() async {
    try {
      final orderData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .collection('Orders History')
          .get();
      for (final doc in orderData.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
