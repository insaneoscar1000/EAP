import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/view_models/subscription/billing_history_view_model.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

/// Web-only billing history.
class BillingHistoryView extends StatelessWidget {
  const BillingHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BillingHistoryViewModel>.reactive(
      viewModelBuilder: () => BillingHistoryViewModel(),
      onViewModelReady: (BillingHistoryViewModel model) => model.initialize(),
      builder:
          (BuildContext context, BillingHistoryViewModel model, Widget? _) {
        return Scaffold(
          appBar: DefaultAppBar(title: 'Billing History'),
          body: BackgroundContainer(
            background: 'background-2',
            child: model.isBusy
                ? LoadingIndicator()
                : model.hasError
                    ? Center(child: Text(model.modelError.toString()))
                    : model.entries.isEmpty
                        ? const Center(
                            child: Text('No transactions yet.'),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: model.entries.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 24),
                            itemBuilder: (BuildContext context, int i) {
                              final BillingEntry e = model.entries[i];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(_titleFor(e)),
                                subtitle: Text(e.paidAt != null
                                    ? DateFormat('d MMM yyyy  HH:mm')
                                        .format(e.paidAt!)
                                    : 'Pending'),
                                trailing: Text(
                                  '${e.currency} ${e.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
          ),
        );
      },
    );
  }

  String _titleFor(BillingEntry e) {
    switch (e.purpose) {
      case 'ad':
        return 'Advert placement';
      case 'subscription':
        return 'Premium subscription';
      default:
        return e.reference;
    }
  }
}
