import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/order_repository.dart';

class ClearOrder implements UseCase<Unit, NoParams> {
  final OrderRepository orderRepository;

  ClearOrder(this.orderRepository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await orderRepository.clearOrder();
  }
}