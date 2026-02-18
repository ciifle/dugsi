import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { schoolAdmin, teacher, student }

UserRole? userRoleFromString(String str) {
  switch (str.toUpperCase()) {
    case 'SCHOOL_ADMIN':
      return UserRole.schoolAdmin;
    case 'TEACHER':
      return UserRole.teacher;
    case 'STUDENT':
      return UserRole.student;
    default:
      return null;
  }
}

class AuthResult {
  final bool success;
  final String message;
  final UserRole? role;

  AuthResult({required this.success, required this.message, this.role});
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => 'AuthException: $message';
}

// User model for API response mapping
class User {
  final int id;
  final String? email;
  final String? emisNumber;
  final String? name;
  final String? phone;
  final int? schoolId;
  final UserRole? role;
  final int? isActive;

  User({
    required this.id,
    this.email,
    this.emisNumber,
    this.name,
    this.phone,
    this.schoolId,
    this.role,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,

      // ✅ FIX HERE
      name: json['fullName'] ?? json['name'],

      email: json['email'] as String?,
      emisNumber: json['emisNumber'] as String?,
      phone: json['phone'] as String?,
      schoolId: json['schoolId'] is int
          ? json['schoolId']
          : int.tryParse(json['schoolId']?.toString() ?? ''),
      role: userRoleFromString(json['role']?.toString() ?? ''),
      isActive: json['isActive'] is int
          ? json['isActive']
          : int.tryParse(json['isActive']?.toString() ?? ''),
    );
  }
}

// The main AuthService class implementing login logic.
class AuthService {
  static const String _loginUrl = 'https://api.fiddosms.com/auth/login';

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('tokenExpiry');
    await prefs.remove('role');
    await prefs.remove('userId');
    await prefs.remove('schoolId');
  }

  Future<AuthResult> login({
    required String identifier,
    required String password,
  }) async {
    try {
      // Map identifier to correct field
      // final Map<String, dynamic> payload;
      final bool isEmail = identifier.contains('@');

      final payload = isEmail
          ? {'email': identifier, 'password': password}
          : {'emisNumber': identifier, 'password': password};

      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        String message = 'Login failed. Please try again.';
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map && errorBody['message'] is String) {
            message = errorBody['message'];
          }
        } catch (_) {}
        return AuthResult(success: false, message: message, role: null);
      }

      final respBody = jsonDecode(response.body);
      final status = respBody['status'];
      if (status != 'success') {
        String message = respBody['message']?.toString() ?? 'Login failed.';
        return AuthResult(success: false, message: message, role: null);
      }

      final data = respBody['data'];
      if (data == null || data['token'] == null || data['user'] == null) {
        return AuthResult(
          success: false,
          message: 'Malformed server response.',
          role: null,
        );
      }

      final String token = data['token'];
      final user = data['user'];
      final String? roleStr = user['role'];
      final UserRole? actualRole = userRoleFromString(roleStr ?? '');

      if (actualRole == null) {
        return AuthResult(
          success: false,
          message: 'Unknown user role.',
          role: null,
        );
      }

      // Check if user is active
      final dynamic isActive = user['isActive'];
      if (isActive is int && isActive == 0) {
        return AuthResult(
          success: false,
          message: 'Your account is inactive. Please contact admin.',
          role: actualRole,
        );
      }

      // Decode JWT token to get expiry
      int? tokenExpiry;
      try {
        final jwtSegments = token.split('.');
        if (jwtSegments.length == 3) {
          // JWT payload is segment 1 (base64url)
          final payloadSeg = base64.normalize(
            jwtSegments[1].replaceAll('-', '+').replaceAll('_', '/'),
          );
          final decodedPayload = utf8.decode(base64.decode(payloadSeg));
          final payloadMap = jsonDecode(decodedPayload);
          tokenExpiry = payloadMap['exp'] is int
              ? payloadMap['exp'] as int
              : null;
        }
      } catch (_) {
        // Could not decode JWT, continue with null expiry
      }

      // Save credentials/details in SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      if (tokenExpiry != null) {
        await prefs.setInt('tokenExpiry', tokenExpiry);
      }
      await prefs.setString('role', roleStr ?? '');
      if (user['id'] != null) {
        await prefs.setInt('userId', user['id']);
      }
      if (user['schoolId'] != null) {
        await prefs.setInt('schoolId', user['schoolId']);
      }

      return AuthResult(
        success: true,
        message: respBody['message']?.toString() ?? 'Login successful.',
        role: actualRole,
      );
    } on http.ClientException catch (_) {
      return AuthResult(
        success: false,
        message: 'Network error. Please check your internet connection.',
        role: null,
      );
    } catch (e) {
      // Handle possible decoding or unexpected errors
      return AuthResult(
        success: false,
        message: 'An unexpected error occurred. Please try again.',
        role: null,
      );
    }
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    print('🟡 [AuthService] getCurrentUser called');
    print('🟡 Token from storage: $token');

    if (token == null || token.isEmpty) {
      print('🔴 No token found → user is NOT logged in');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('https://api.fiddosms.com/auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🟡 /auth/me status: ${response.statusCode}');
      print('🟡 /auth/me raw body: ${response.body}');

      if (response.statusCode != 200) {
        print('🔴 /auth/me failed with status ${response.statusCode}');
        return null;
      }

      final jsonResp = jsonDecode(response.body);

      // ✅ FIX: API returns data.user
      final userJson = jsonResp['data']?['user'];

      if (userJson == null) {
        print('🔴 No user object in response');
        return null;
      }

      final user = User.fromJson(userJson);

      print('🟢 User loaded successfully:');
      print('   id=${user.id}');
      print('   name=${user.name}');
      print('   email=${user.email}');
      print('   role=${user.role}');

      return user;
    } catch (e, s) {
      print('🔴 Exception in getCurrentUser');
      print(e);
      print(s);
      return null;
    }
  }
}
