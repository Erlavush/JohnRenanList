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
    final inputId = id.trim();
    final inputCode = code.trim();

    // 1. Admin Auth
    if (inputId == _adminId) {
      if (inputCode != "earljoshdelgado") {
        return "Incorrect Admin Password";
      }
    } 
    // 2. Student Auth
    else {
      if (inputCode != "johnrenanlabay") {
        return "Incorrect Secret Code";
      }
    }

    if (id.trim().isEmpty) {
      return "Please enter your Class ID";
    }

    const allowedIds = {
      '2023-01329', '2023-01676', '2023-00858', '2023-01332', '2023-01322',
      '2023-01326', '2023-00560', '2023-01835', '2023-00855', '2023-00904',
      '2023-01323', '2023-01325', '2022-01280', '2023-00854', '2023-01319',
      '2023-01526', '2023-00850', '2023-01321', '2023-00700', '2023-00570',
      '2023-00913', '2023-00877', '2023-00912', '2023-01532', '2023-00915',
      '2023-01324', '2023-00878', '2023-00914', '2023-00853', '2023-00703',
      '2023-00875', '2023-00872', '2023-00566', '2023-01328', '2023-00562',
      '2023-00860', '2023-00916', '2020-00933'
    };

    if (!allowedIds.contains(id.trim())) {
      return "ID not authorized for this class";
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
