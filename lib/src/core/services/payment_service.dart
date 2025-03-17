import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';

class PaymentService {
  // Public key for client-side operations
  static const String _publicKey =
      'pk_test_5ab5b0b43a7e60a0e7ca4f003a4dcac86f63a7aa';

  // Secret key for server-side operations
  static const String _secretKey =
      'sk_test_ce4d48f4939a7b1e7c65210203f42e483ba220a5';

  /// Initiates a payment transaction using Paystack
  ///
  /// Returns payment data if successful, null otherwise
  /// Note: The library may return different types based on the payment result
  Future<Map<String, dynamic>> makePayment({
    required BuildContext context,
    required String email,
    required String name,
    required double amount,
    String? reference,
  }) async {
    try {
      // Generate a unique reference if not provided
      final String paymentReference =
          reference ?? PayWithPayStack().generateUuidV4();
      debugPrint('Using payment reference: $paymentReference');

      // Create a completer to properly handle the async result
      Completer<Map<String, dynamic>> completer =
          Completer<Map<String, dynamic>>();

      // Convert amount to kobo/cents (multiply by 100)

      PayWithPayStack().now(
        context: context,
        secretKey: _secretKey, // Use secret key as required by the package
        customerEmail: email,
        reference: paymentReference,
        currency: 'NGN', // Using Nigerian Naira which is supported by default
        amount: 100,
        callbackUrl: 'https://the-eap-app.com/payment-callback',
        transactionCompleted: (paymentData) {
          debugPrint('Payment successful: $paymentData');
          // Create a standardized payment result
          Map<String, dynamic> result = {
            'status': 'success',
            'reference': paymentReference,
            'data': paymentData,
            'amount': amount,
            'currency': 'NGN',
          };
          completer.complete(result);
          return paymentData;
        },
        transactionNotCompleted: (reason) {
          debugPrint('Payment failed: $reason');
          completer.complete({
            'status': 'failed',
            'reference': paymentReference,
            'reason': reason,
          });
          return false;
        },
        metaData: {
          'custom_fields': [
            {
              'display_name': 'Deposit',
              'value': amount.toString(),
            }
          ]
        },
      );
      // Wait for the payment to complete (either success or failure)
      return await completer.future;
    } catch (e) {
      debugPrint('Payment error: $e');
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }
}
