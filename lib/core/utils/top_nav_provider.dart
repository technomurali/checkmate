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

  void navigateTo(TopNavScreen screen, {Object? argument}) {
    if (_currentScreen != screen) {
      _history.add(_currentScreen);
    }
    _currentScreen = screen;
    _argument = argument;
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
