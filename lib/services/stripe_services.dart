import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../const.dart';

class StripeServices {
  StripeServices._();

  static final StripeServices instance = StripeServices._();

  Future<void> makePayment({required BuildContext context}) async {
    try {
      final String? clientSercetKey =
          await _createPaymentIntent(amount: 10, currency: 'usd');
      if (clientSercetKey == null) return;
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSercetKey,
        merchantDisplayName: 'Abdul Ahad',
        allowsDelayedPaymentMethods: true,
      ));
      await _processPayment();
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<String?> _createPaymentIntent(
      {required int amount, required String currency}) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amout: amount),
        "currency": currency
      };
      final response = await dio.post(
          'https://api.stripe.com/v1/payment_intents',
          data: data,
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            "Authorization": "Bearer $stripeSecreteKey",
            "Content-Type": "application/x-www-form-urlencoded"
          }));
      if (response.data != null) {
        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      print(e);
    }
  }

  String _calculateAmount({required int amout}) => (amout * 1000).toString();
}
