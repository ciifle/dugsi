import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class School {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? logo;
  final int? schoolId;

  School({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.logo,
    this.schoolId,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      logo: json['logo'],
      schoolId: json['schoolId'], // ✅ REQUIRED
    );
  }
}

class AppUser {
  final int id;
  final String fullName;
  final String email;
  final String role;

  AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

class SchoolService {
  static const String _baseUrl = 'https://api.fiddosms.com/api/schools';
  static const String _userUrl = 'https://api.fiddosms.com/api/users';

  Future<School?> getSchoolById(int schoolId) async {
    print('getSchoolById called with schoolId: $schoolId');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      print('No auth token found in SharedPreferences');
      return null;
    }

    final url = Uri.parse('$_baseUrl/$schoolId');
    print('Requesting URL: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          return School.fromJson(jsonResponse['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching school info: $e');
      return null;
    }
  }

  Future<List<AppUser>> getAllUsersForAdmin() async {
    print('🟡 [SchoolService] getAllUsersForAdmin called');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('🔴 No token found');
      return [];
    }

    final url = Uri.parse(_userUrl);
    print('🟡 Request URL: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🟡 Status Code: ${response.statusCode}');
      print('🟡 Raw Body: ${response.body}');

      if (response.statusCode != 200) {
        print('🔴 Request failed');
        return [];
      }

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] != 'success') {
        print('🔴 API status not success');
        return [];
      }

      final data = jsonResponse['data'];

      // ✅ HANDLE BOTH POSSIBLE SHAPES
      List usersJson = [];

      if (data is List) {
        usersJson = data;
      } else if (data is Map && data['users'] is List) {
        usersJson = data['users'];
      } else {
        print('🔴 Unexpected data format: $data');
        return [];
      }

      print('🟢 Users count from API: ${usersJson.length}');

      final users = usersJson.map((json) => AppUser.fromJson(json)).toList();

      // Debug roles
      for (final u in users) {
        print('🟢 User: ${u.fullName} | role=${u.role}');
      }

      return users;
    } catch (e) {
      print('🔴 Exception in getAllUsersForAdmin: $e');
      return [];
    }
  }

  Future<int> getStudentCount() async {
    final users = await getAllUsersForAdmin();
    final count = users.where((u) => u.role == 'STUDENT').length;
    print('🟢 Student count: $count');
    return count;
  }

  Future<int> getTeacherCount() async {
    final users = await getAllUsersForAdmin();
    final count = users.where((u) => u.role == 'TEACHER').length;
    print('🟢 Teacher count: $count');
    return count;
  }
}
