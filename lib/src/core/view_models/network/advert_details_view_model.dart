import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class AdvertDetailsViewModel extends BaseViewModel {
  late Advert _advert;

  Advert get advert => _advert;

  void initialize(Advert advert) {
    _advert = advert;
    notifyListeners();
  }
}
