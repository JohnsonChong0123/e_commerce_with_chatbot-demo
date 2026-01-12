import 'package:fpdart/fpdart.dart';
import '../../../core/errors/exception.dart';
import '../../../core/errors/failure.dart';
import '../../domain/repository/payment_repository.dart';
import '../sources/remote/payment_remote_data.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteData paymentRemoteData;

  PaymentRepositoryImpl(this.paymentRemoteData);

  @override
  Future<Either<Failure, Unit>> getPaymentSheet(String amount) async {
    try {
      await paymentRemoteData.getPaymentSheet(amount);
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
