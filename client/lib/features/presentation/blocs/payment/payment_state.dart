part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {
  const PaymentState();
}

final class PaymentInitial extends PaymentState {}

final class PaymentLoading extends PaymentState {}

final class PaymentSuccess extends PaymentState {
  final String message;
  const PaymentSuccess(this.message);
}

final class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure(this.message);
}
