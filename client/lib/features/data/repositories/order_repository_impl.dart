import 'package:fpdart/fpdart.dart';
import '../../../core/errors/exception.dart';
import '../../../core/errors/failure.dart';
import '../../domain/entity/order_entity.dart';
import '../../domain/repository/order_repository.dart';
import '../models/order_model.dart';
import '../sources/remote/order_remote_data.dart';

class OrderRepositoryImpl implements OrderRepository {
  
  final OrderRemoteData orderRemoteData;
  const OrderRepositoryImpl(this.orderRemoteData);
  
  
  @override
  Future<Either<Failure, Unit>> addOrder({
    required final double subtotal,
    required final double shippingFee,
    required final double totalAmount,
    required final List<OrderItemEntity> orderItems,
  }) async {
    try {
      OrderModel orderModel = OrderModel(
        orderId: _generateOrderId(),
        subtotal: subtotal,
        shippingFee: shippingFee,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        orderItems: orderItems,
      );
      await orderRemoteData.addOrder(
        orderModel,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrder() async {
    try {
      final orderData = await orderRemoteData.getOrder();
      return right(orderData);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeOrder(String orderId) async {
    try {
      await orderRemoteData.removeOrder(orderId);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearOrder() async {
    try {
      orderRemoteData.clearOrder();
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  String _generateOrderId() {
    DateTime now = DateTime.now();
    return "${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}"
           "${_twoDigits(now.hour)}${_twoDigits(now.minute)}${_twoDigits(now.second)}";
  }
  String _twoDigits(int n) => n.toString().padLeft(2, '0');
  
  
}

