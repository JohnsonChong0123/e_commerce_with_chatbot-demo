import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../entity/order_entity.dart';
import '../../repository/order_repository.dart';

class GetOrder implements UseCase<List<OrderEntity>, NoParams> {
  final OrderRepository orderRepository;

  GetOrder(this.orderRepository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) async {
    return await orderRepository.getOrder();
  }
}
