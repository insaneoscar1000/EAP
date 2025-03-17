import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class EventDetailsViewModel extends BaseViewModel {
  final _storageService = locator<StorageService>();

  late Event _event;
  String? _userId;

  Event get event => _event;

  Future<void> initialize(Event event) async {
    _event = event;
    _userId = await _storageService.getString(StorageConstants.userId);
    notifyListeners();
  }

  bool get canEdit {
    if (_userId == null) return false;
    return _event.contact.id == _userId;
  }
}
