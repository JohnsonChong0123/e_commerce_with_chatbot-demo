import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../entity/order_entity.dart';
import '../../repository/order_repository.dart';

class AddOrder implements UseCase<Unit, AddOrderParams> {
  final OrderRepository orderRepository;

  AddOrder(this.orderRepository);

  @override
  Future<Either<Failure, Unit>> call(AddOrderParams params) async {
    return await orderRepository.addOrder(
      subtotal: params.subtotal,
      shippingFee: params.shippingFee,
      totalAmount: params.totalAmount,
      orderItems: params.orderItems,
    );
  }
}

class AddOrderParams extends Equatable {
  final double subtotal;
  final double shippingFee;
  final double totalAmount;
  final List<OrderItemEntity> orderItems;

  const AddOrderParams({
    required this.subtotal,
    required this.shippingFee,
    required this.totalAmount,
    required this.orderItems,
  });

  @override
  List<Object?> get props => [
        subtotal,
        shippingFee,
        totalAmount,
        orderItems,
      ];
}
