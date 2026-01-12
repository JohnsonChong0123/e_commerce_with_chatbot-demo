import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failure.dart';
import '../entity/order_entity.dart';

abstract interface class OrderRepository {
  Future<Either<Failure, Unit>> addOrder({
    required final double subtotal,
    required final double shippingFee,
    required final double totalAmount,
    required final List<OrderItemEntity> orderItems,
  });

  Future<Either<Failure, List<OrderEntity>>> getOrder();

  Future<Either<Failure, Unit>> removeOrder(String orderId);
  Future<Either<Failure, Unit>> clearOrder();
}
