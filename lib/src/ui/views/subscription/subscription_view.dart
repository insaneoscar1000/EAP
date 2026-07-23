import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/theme.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

/// Subscription screen — status display only.
///
/// Per App Store guideline 3.1.3 (anti-steering) and Google Play
/// equivalent rules, this screen does NOT contain any subscribe
/// button, pricing, or link to a web checkout. Premium subscriptions
/// are sold exclusively on the web app.
class SubscriptionView extends StatelessWidget {
  const SubscriptionView({Key? key, this.justReturnedFromCheckout = false})
      : super(key: key);

  /// True when the user was just redirected back from PayStack checkout.
  /// The webhook that activates the subscription in Firestore can take a
  /// few minutes to arrive, so show a "confirming payment" message instead
  /// of letting the free-account state look like the payment failed.
  final bool justReturnedFromCheckout;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubscriptionViewModel>.reactive(
      viewModelBuilder: () => SubscriptionViewModel(),
      onViewModelReady: (SubscriptionViewModel model) => model.initialize(),
      builder: (BuildContext context, SubscriptionViewModel model, Widget? _) {
        return Scaffold(
          appBar: DefaultAppBar(title: 'Subscription'),
          body: BackgroundContainer(
            background: 'background-2',
            child: model.isBusy
                ? LoadingIndicator()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _Header(isPremium: model.isPremium),
                        if (justReturnedFromCheckout && !model.isPremium) ...<Widget>[
                          const SizedBox(height: 16),
                          const _ConfirmingPaymentBanner(),
                        ],
                        const SizedBox(height: 24),
                        if (model.isPremium)
                          _ActiveStatus(expirationDate: model.expirationDate)
                        else if (model.isInTrial)
                          _TrialStatus(trialEndsAt: model.trialEndsAt)
                        else
                          const _InactiveStatus(),
                        const SizedBox(height: 16),
                        const _FeaturesList(),
                        if (kIsWeb && !model.isPremium) ...<Widget>[
                          const SizedBox(height: 16),
                          _WebSubscribeCta(model: model),
                        ],
                        if (kIsWeb && model.isPremium) ...<Widget>[
                          const SizedBox(height: 16),
                          _WebCancelCta(model: model),
                        ],
                        if (model.errorMessage != null) ...<Widget>[
                          const SizedBox(height: 12),
                          _ErrorBanner(message: model.errorMessage!),
                        ],
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isPremium});
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            AppTheme.themeData.primaryColor,
            AppTheme.themeData.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            isPremium ? IconsaxPlusBold.crown_1 : IconsaxPlusLinear.crown_1,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            isPremium ? 'Premium Member' : 'Free Account',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPremium
                ? 'Thank you for your support!'
                : 'Your account is on the free plan.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActiveStatus extends StatelessWidget {
  const _ActiveStatus({required this.expirationDate});
  final DateTime? expirationDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              IconsaxPlusBold.tick_circle,
              color: Colors.green,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Active Subscription',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                if (expirationDate != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    'Renews: ${DateFormat('d MMMM yyyy').format(expirationDate!)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrialStatus extends StatelessWidget {
  const _TrialStatus({required this.trialEndsAt});
  final DateTime? trialEndsAt;

  @override
  Widget build(BuildContext context) {
    final int daysLeft = trialEndsAt == null
        ? 0
        : trialEndsAt!.difference(DateTime.now()).inDays;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.4)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              IconsaxPlusBold.timer_1,
              color: Colors.amber,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Free trial active',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                if (trialEndsAt != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    daysLeft > 0
                        ? '$daysLeft day${daysLeft == 1 ? '' : 's'} remaining '
                            '(ends ${DateFormat('d MMMM yyyy').format(trialEndsAt!)})'
                        : 'Trial ends today.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InactiveStatus extends StatelessWidget {
  const _InactiveStatus();

  @override
  Widget build(BuildContext context) {
    // Informational only — no link, no button, no pricing on mobile.
    // Required to stay compliant with App Store anti-steering rules.
    final String message = kIsWeb
        ? 'You do not have an active premium subscription.'
        : 'Premium subscriptions are managed on our website. '
            'They are not available for purchase inside this app.';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
    );
  }
}

class _WebSubscribeCta extends StatelessWidget {
  const _WebSubscribeCta({required this.model});
  final SubscriptionViewModel model;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: model.isStartingCheckout ? null : model.startCheckout,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.themeData.primaryColor,
        padding: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: model.isStartingCheckout
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Subscribe Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }
}

class _WebCancelCta extends StatelessWidget {
  const _WebCancelCta({required this.model});
  final SubscriptionViewModel model;

  Future<void> _confirmAndCancel(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Cancel subscription?'),
        content: Text(
          model.expirationDate != null
              ? 'You will keep premium access until '
                  '${DateFormat('d MMMM yyyy').format(model.expirationDate!)}. '
                  'After that, your subscription will not renew.'
              : 'Your subscription will not renew. Premium access will end '
                  'at the close of the current billing period.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep subscription'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Cancel subscription'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await model.cancelSubscription();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: model.isCancelling ? null : () => _confirmAndCancel(context),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: Colors.grey[400]!),
      ),
      child: model.isCancelling
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              'Cancel subscription',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
    );
  }
}

class _ConfirmingPaymentBanner extends StatelessWidget {
  const _ConfirmingPaymentBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.4)),
      ),
      child: const Row(
        children: <Widget>[
          SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Payment received — confirming your subscription. This page '
              'will update automatically, which can take a few minutes.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: <Widget>[
          const Icon(IconsaxPlusLinear.warning_2, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesList extends StatelessWidget {
  const _FeaturesList();

  static const List<String> _features = <String>[
    'Create service provider listings',
    'Be visible to all EAP App users',
    'Showcase your services & expertise',
    'Direct contact from potential clients',
    'Priority support',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Premium Features',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._features.map((String f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: <Widget>[
                    Icon(
                      IconsaxPlusBold.tick_circle,
                      color: AppTheme.themeData.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        f,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
