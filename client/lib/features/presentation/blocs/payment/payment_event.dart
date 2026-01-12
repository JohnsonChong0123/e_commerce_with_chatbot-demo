part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {
  const PaymentEvent();
}

final class PaymentAmount extends PaymentEvent {
  final String amount;

  const PaymentAmount(this.amount);
}
