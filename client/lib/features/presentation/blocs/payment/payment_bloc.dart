import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/payment/payment_usecase.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentUsecase _paymentUsecase;

  PaymentBloc({
    required PaymentUsecase paymentUsecase,
  })  : _paymentUsecase = paymentUsecase,
        super(PaymentInitial()) {
    on<PaymentEvent>((event, emit) => emit(PaymentLoading()));
    on<PaymentAmount>(_onPaymentAmount);
  }

  void _onPaymentAmount(PaymentAmount event, Emitter<PaymentState> emit) async {
    final res = await _paymentUsecase(PaymentParams(event.amount));
    res.fold(
      (l) => emit(PaymentFailure(l.message)),
      (_) => emit(const PaymentSuccess("Payment Successful")),
    );
  }
}
