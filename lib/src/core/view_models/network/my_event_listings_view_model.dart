import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';

class MyEventListingsViewModel extends StreamViewModel<List<Event>> {
  final _eventService = locator<EventService>();
  final _storageService = locator<StorageService>();
  String? _userId;

  @override
  Stream<List<Event>> get stream => _eventService.events;

  @override
  Future<void> onData(List<Event>? data) async {
    if (_userId == null) {
      _userId = await _storageService.getString(StorageConstants.userId);
    }
    super.onData(data);
  }

  List<Event> get events {
    final allEvents = data ?? [];
    if (_userId == null) return [];
    
    final now = DateTime.now();
    
    return allEvents.where((event) => 
      event.contact.id == _userId && 
      event.expiryDate.toDate().isAfter(now)
    ).toList();
  }
}
