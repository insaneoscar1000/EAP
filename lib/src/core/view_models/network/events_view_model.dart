import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/storage_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class EventsViewModel extends StreamViewModel<List<Event>> {
  final _eventService = locator<EventService>();
  final _storageService = locator<StorageService>();
  String _searchQuery = '';
  bool _showUserEvents = false;
  String? _userId;

  String get searchQuery => _searchQuery;
  bool get showUserEvents => _showUserEvents;

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
    final now = DateTime.now();

    // Filter out past events
    var filteredEvents = allEvents.where((event) {
      return event.expiryDate.toDate().isAfter(now);
    }).toList();

    // Filter by user's events if showUserEvents is true
    if (_showUserEvents && _userId != null) {
      filteredEvents =
          filteredEvents.where((event) => event.contact.id == _userId).toList();
    }

    // Apply search filter if query is not empty
    if (_searchQuery.isNotEmpty) {
      filteredEvents = filteredEvents.where((event) {
        final query = _searchQuery.toLowerCase();
        return event.name.toLowerCase().contains(query) ||
            event.organization.toLowerCase().contains(query) ||
            event.contact.name.toLowerCase().contains(query);
      }).toList();
    }

    return filteredEvents;
  }

  bool get hasUserEvents {
    if (_userId == null) return false;
    final allEvents = data ?? [];
    return allEvents.any((event) => event.contact.id == _userId);
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleUserEvents() {
    _showUserEvents = !_showUserEvents;
    notifyListeners();
  }
}
