import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

/// A widget that manages dialogs for the app
class DialogManager extends StatefulWidget {
  final Widget child;

  const DialogManager({Key? key, required this.child}) : super(key: key);

  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
    _dialogService.registerConfirmationDialogListener(_showConfirmationDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  /// Shows a dialog with the given request
  void _showDialog(DialogRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title),
        content: Text(request.description),
        actions: <Widget>[
          TextButton(
            child: Text(request.buttonTitle),
            style: TextButton.styleFrom(
              foregroundColor: request.buttonTitle.toLowerCase() == 'delete'
                  ? Colors.red
                  : Theme.of(context).primaryColor,
            ),
            onPressed: () {
              _dialogService.dialogComplete(DialogResponse(confirmed: true));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog with the given request
  void _showConfirmationDialog(DialogRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title),
        content: Text(request.description),
        actions: <Widget>[
          TextButton(
            child: Text(request.cancelTitle ?? 'Cancel'),
            onPressed: () {
              _dialogService.dialogComplete(DialogResponse(confirmed: false));
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(request.buttonTitle),
            style: TextButton.styleFrom(
              foregroundColor: request.buttonTitle.toLowerCase() == 'delete'
                  ? Colors.red
                  : Theme.of(context).primaryColor,
            ),
            onPressed: () {
              _dialogService.dialogComplete(DialogResponse(confirmed: true));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
