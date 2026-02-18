
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dummy_user.dart';

class LocalAuthService {
  static final LocalAuthService _instance = LocalAuthService._internal();
  factory LocalAuthService() => _instance;
  LocalAuthService._internal();

  static const String _userKey = 'local_user_session';

  final List<DummyUser> _dummyUsers = [
    DummyUser(
      id: '1',
      email: 'admin@school.com',
      password: '123456',
      name: 'School Admin',
      role: UserRole.schoolAdmin,
      phone: '123-456-7890',
      schoolId: 'school_1',
    ),
    DummyUser(
      id: '2',
      email: 'teacher@school.com',
      password: '123456',
      name: 'Teacher User',
      role: UserRole.teacher,
      phone: '987-654-3210',
      schoolId: 'school_1',
    ),
    DummyUser(
      id: '3',
      email: 'student@school.com',
      password: '123456',
      name: 'Student User',
      role: UserRole.student,
      phone: '555-555-5555',
      schoolId: 'school_1',
    ),
    DummyUser(
      id: '4',
      email: 'parent@school.com',
      password: '123456',
      name: 'Parent User',
      role: UserRole.parent,
      phone: '111-222-3333',
      schoolId: 'school_1',
    ),
  ];

  Future<DummyUser?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = _dummyUsers.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
      );
      
      await _saveSession(user);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<DummyUser?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonStr = prefs.getString(_userKey);
    if (userJsonStr == null) return null;

    try {
      final Map<String, dynamic> userJson = jsonDecode(userJsonStr);
      return DummyUser.fromJson(userJson);
    } catch (e) {
      await logout();
      return null;
    }
  }

  Future<void> _saveSession(DummyUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}
