import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String id;
  final String status;
  final String amount;

  const PaymentEntity({
    required this.id,
    required this.status,
    required this.amount,
  });

  @override
  List<Object?> get props => [id, status, amount];
}
