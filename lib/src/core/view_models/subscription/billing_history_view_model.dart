import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';

/// Web-only billing history. Lists all PayStack transactions belonging
/// to the current user from `users/{uid}/billingHistory`, which the
/// PayStack webhook is expected to populate going forward.
class BillingHistoryViewModel extends BaseViewModel {
  List<BillingEntry> _entries = <BillingEntry>[];
  List<BillingEntry> get entries => _entries;

  Future<void> initialize() async {
    setBusy(true);
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        setError('Not signed in.');
        return;
      }
      final QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(uid)
          .collection('billingHistory')
          .orderBy('paidAt', descending: true)
          .limit(100)
          .get();
      _entries = snap.docs.map(BillingEntry.fromDoc).toList();
    } catch (e) {
      debugPrint('BillingHistory load failed: $e');
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }
}

class BillingEntry {
  BillingEntry({
    required this.reference,
    required this.amount,
    required this.currency,
    required this.purpose,
    required this.paidAt,
  });

  factory BillingEntry.fromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data();
    return BillingEntry(
      reference: (data['reference'] as String?) ?? doc.id,
      amount: ((data['amount'] as num?) ?? 0).toDouble(),
      currency: (data['currency'] as String?) ?? '',
      purpose: (data['purpose'] as String?) ?? '',
      paidAt: (data['paidAt'] as Timestamp?)?.toDate(),
    );
  }

  final String reference;
  final double amount;
  final String currency;
  final String purpose;
  final DateTime? paidAt;
}
