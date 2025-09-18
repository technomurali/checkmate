import 'package:flutter/material.dart';

// Enum for all possible screens
enum TopNavScreen {
  dashboard,
  newEvent,
  eventHistory,
  fileDispute,
  disputeHistory,
  profile,
  eventDetails,
  disputeDetails,
  pendingReceipt,
  receiptHistory,
  // Add more as needed
}

class TopNavProvider extends ChangeNotifier {
  TopNavScreen _currentScreen = TopNavScreen.dashboard;
  Object? _argument;
  final List<TopNavScreen> _history = <TopNavScreen>[];

  TopNavScreen get currentScreen => _currentScreen;
  Object? get argument => _argument;

  set currentScreen(TopNavScreen value) {
    _currentScreen = value;
    notifyListeners();
  }

  set argument(Object? value) {
    _argument = value;
    notifyListeners();
  }

  set history(TopNavScreen value) {
    _history
      .add(value);
    notifyListeners();
  }

  void navigateTo(TopNavScreen screen, {Object? argument}) {
    if (_currentScreen != screen) {
      _history.add(_currentScreen);
    }
    _currentScreen = screen;
    _argument = argument;
    notifyListeners();
  }

  bool _isOnLogin = false;

  bool get isOnLogin => _isOnLogin;

  void resetToLogin() {
    // Clear any in-app stacks/history you maintain
    // e.g., _stack.clear();
    _isOnLogin = true;
    _history.clear();
    notifyListeners();
  }

  void goToHome() {
    _isOnLogin = false;
    notifyListeners();
  }

  bool goBack() {
    if (_history.isEmpty) return false;
    final previous = _history.removeLast();
    _currentScreen = previous;
    _argument = null;
    notifyListeners();
    return true;
  }

  void reset() {
    _history.clear();
    _currentScreen = TopNavScreen.dashboard;
    _argument = null;
    notifyListeners();
  }
}
