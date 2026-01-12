import 'package:fpdart/fpdart.dart';
import '../../../core/errors/failure.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Unit>> getPaymentSheet(String amount);
}
