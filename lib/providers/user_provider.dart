import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _studentId;
  bool _isAdmin = false;

  // Configuration
  static const String _adminId = "2023-01322";
  static const String _secretCode = "johnrenanlabay";

  bool get isLoggedIn => _isLoggedIn;
  String? get studentId => _studentId;
  bool get isAdmin => _isAdmin;

  String? get currentId => _studentId;

  // Returns error message if failed, null if success
  String? login(String id, String code) {
    if (code.trim() != _secretCode) {
      return "Incorrect Secret Code";
    }

    if (id.trim().isEmpty) {
      return "Please enter your Class ID";
    }

    _isLoggedIn = true;
    _studentId = id.trim();
    
    // Check if this is the Admin (Secretary)
    if (_studentId == _adminId) {
      _isAdmin = true;
    } else {
      _isAdmin = false;
    }

    notifyListeners();
    return null;
  }

  void logout() {
    _isLoggedIn = false;
    _studentId = null;
    _isAdmin = false;
    notifyListeners();
  }
}
