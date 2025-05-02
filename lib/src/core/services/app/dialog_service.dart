import 'dart:async';

/// A service that handles showing dialogs and confirmation dialogs
class DialogService {
  Function(DialogRequest)? _showDialogListener;
  Function(DialogRequest)? _showConfirmationDialogListener;

  Completer<DialogResponse>? _dialogCompleter;

  /// Registers a callback function to show a dialog
  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  /// Registers a callback function to show a confirmation dialog
  void registerConfirmationDialogListener(
      Function(DialogRequest) showConfirmationDialogListener) {
    _showConfirmationDialogListener = showConfirmationDialogListener;
  }

  /// Shows a dialog with the given title and description
  Future<DialogResponse?> showDialog({
    required String title,
    required String description,
    String buttonTitle = 'OK',
  }) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener?.call(DialogRequest(
      title: title,
      description: description,
      buttonTitle: buttonTitle,
    ));
    return _dialogCompleter!.future;
  }

  /// Shows a confirmation dialog with the given title and description
  Future<DialogResponse?> showConfirmationDialog({
    required String title,
    required String description,
    String confirmationTitle = 'Yes',
    String cancelTitle = 'No',
  }) {
    _dialogCompleter = Completer<DialogResponse>();
    _showConfirmationDialogListener?.call(DialogRequest(
      title: title,
      description: description,
      buttonTitle: confirmationTitle,
      cancelTitle: cancelTitle,
    ));
    return _dialogCompleter!.future;
  }

  /// Completes the dialog with the given response
  void dialogComplete(DialogResponse response) {
    _dialogCompleter?.complete(response);
    _dialogCompleter = null;
  }
}

/// A class that represents a dialog request
class DialogRequest {
  final String title;
  final String description;
  final String buttonTitle;
  final String? cancelTitle;

  DialogRequest({
    required this.title,
    required this.description,
    required this.buttonTitle,
    this.cancelTitle,
  });
}

/// A class that represents a dialog response
class DialogResponse {
  final bool confirmed;
  final dynamic data;

  DialogResponse({
    required this.confirmed,
    this.data,
  });
}
