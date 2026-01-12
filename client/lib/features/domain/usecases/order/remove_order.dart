import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/order_repository.dart';

class RemoveOrder implements UseCase<Unit, RemoveOrderParams> {
  final OrderRepository orderRepository;

  RemoveOrder(this.orderRepository);

  @override
  Future<Either<Failure, Unit>> call(RemoveOrderParams params) async {
    return await orderRepository.removeOrder(
      params.orderId,
    );
  }
}

class RemoveOrderParams extends Equatable {
  final String orderId;

  const RemoveOrderParams({
    required this.orderId,
  });

  @override
  List<Object?> get props => [
        orderId,
      ];
}
