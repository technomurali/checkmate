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

  TopNavScreen get currentScreen => _currentScreen;
  Object? get argument => _argument;

  void navigateTo(TopNavScreen screen, {Object? argument}) {
    _currentScreen = screen;
    _argument = argument;
    notifyListeners();
  }

  void reset() {
    _currentScreen = TopNavScreen.dashboard;
    _argument = null;
    notifyListeners();
  }
}
