import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:myapp/stripe/consts.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(BuildContext context) async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        10,
        "usd",
      );
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Nisindu Weerasinghe",
        ),
      );
      await _ProcessPayment(context);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );

      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _ProcessPayment(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      //await Stripe.instance.confirmPaymentSheetPayment();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment Sucessful!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment Faild'),
        ),
      );
      print(e);
    }
  }

  String _calculateAmount(int amount) {
    final calculateAmount = amount * 100;
    return calculateAmount.toString();
  }
}
