import '../../domain/entity/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.status,
    required super.amount,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      status: json['status'],
      amount: (json['amount'] / 100).toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'amount': (double.parse(amount) * 100).toInt(),
    };
  }
}
