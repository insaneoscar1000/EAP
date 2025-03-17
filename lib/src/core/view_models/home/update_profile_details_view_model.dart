import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';

class UpdateProfileDetailsViewModel extends BaseViewModel {
  final UserService _userService = locator<UserService>();

  UserRecord? user;
  String? userId;

  Future<void> init(UserRecord user) async {
    setBusy(true);
    this.user = user;
    this.userId = user.id;
    notifyListeners();
    setBusy(false);
  }

  Future<void> updateUser(
      String firstName, String lastName, String? dateOfBirth) async {
    if (userId == null) return;

    setBusy(true);
    try {
      await _userService.updateUser(userId!, {
        'details': {
          'firstName': firstName,
          'lastName': lastName,
          'dateOfBirth': dateOfBirth?.isNotEmpty == true
              ? DateFormat('d MMMM yyyy').parse(dateOfBirth!)
              : null,
        }
      });

      // Fetch the updated user data
      user = await _userService.getUser(userId!);
      notifyListeners();
    } catch (e) {
      print('Error updating user: $e');
    } finally {
      setBusy(false);
    }
  }
}
