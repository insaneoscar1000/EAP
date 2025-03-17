import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class NEMAActivityDetailsViewModel extends BaseViewModel {
  late NEMAActivity _activity;

  NEMAActivity get activity => _activity;

  void initialize(NEMAActivity activity) {
    _activity = activity;
    notifyListeners();
  }
}
