import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _studentId;
  bool _isAdmin = false;
  bool _isLoading = true; // Add loading state for init check

  // Configuration
  static const String _adminId = "2023-01322";
  static const String _secretCode = "johnrenanlabay";
  static const String _keyIsLoggedIn = "is_logged_in";
  static const String _keyStudentId = "student_id";
  static const String _keyIsAdmin = "is_admin";

  bool get isLoggedIn => _isLoggedIn;
  String? get studentId => _studentId;
  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;

  String? get currentId => _studentId;

  // Initialize and check for existing session
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    _studentId = prefs.getString(_keyStudentId);
    _isAdmin = prefs.getBool(_keyIsAdmin) ?? false;
    _isLoading = false;
    notifyListeners();
  }

  // Returns error message if failed, null if success
  Future<String?> login(String id, String code) async {
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

    // Save Session
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyStudentId, _studentId!);
    await prefs.setBool(_keyIsAdmin, _isAdmin);

    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _studentId = null;
    _isAdmin = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data

    notifyListeners();
  }
}
