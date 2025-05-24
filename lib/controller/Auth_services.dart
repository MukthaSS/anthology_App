import 'package:flutter/foundation.dart'; // For ChangeNotifier

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false; // Initial state: not logged in

  bool get isLoggedIn => _isLoggedIn;

  // Method to simulate user login
  void signIn() {
    _isLoggedIn = true;
    notifyListeners(); // Notify widgets listening to this service
    print('User logged in.');
  }

  // Method to simulate user logout
  void signOut() {
    _isLoggedIn = false;
    notifyListeners(); // Notify widgets listening to this service
    print('User logged out.');
  }

// You would add actual Firebase/other auth logic here
// For example:
// Future<void> signInWithEmailAndPassword(String email, String password) async {
//   try {
//     // ... Firebase auth code ...
//     _isLoggedIn = true;
//     notifyListeners();
//   } catch (e) {
//     // Handle error
//   }
// }
}