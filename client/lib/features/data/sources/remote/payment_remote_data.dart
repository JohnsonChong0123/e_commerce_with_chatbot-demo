import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../../../../../../lib/core/configs/apis/keys.dart';
import '../../../../core/errors/exception.dart';

abstract interface class PaymentRemoteData {
  Future<void> getPaymentSheet(String amount);
}

class PaymentRemoteDataImpl implements PaymentRemoteData {
  Map<String, dynamic>? paymentIntent;

  @override
  Future<void> getPaymentSheet(String amount) async {
    try {
      paymentIntent = await _createPaymentIntent(amount, 'usd');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: 'Johnson'));

      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        throw const ServerException('Payment Cancelled');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': _calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Payment Intent Body->>> ${response.body.toString()}');
        return jsonDecode(response.body);
      } else if (response.statusCode == 400) {
        print('Bad Request: The request was invalid.');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
    throw const ServerException('Unexpected error occurred');
  }

  String _calculateAmount(String amount) {
    final calculatedAmount = (double.parse(amount) * 100).toInt();
    return calculatedAmount.toString();
  }
}
