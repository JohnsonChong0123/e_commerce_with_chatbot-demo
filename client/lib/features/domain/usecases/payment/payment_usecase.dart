import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../repository/payment_repository.dart';

class PaymentUsecase implements UseCase<Unit, PaymentParams> {
  final PaymentRepository paymentRepository;

  PaymentUsecase(this.paymentRepository);

  @override
  Future<Either<Failure, Unit>> call(PaymentParams params) async {
    return await paymentRepository.getPaymentSheet(params.amount);
  }
}

class PaymentParams extends Equatable {
  final String amount;

  const PaymentParams(this.amount);

  @override
  List<Object?> get props => [amount];
}
