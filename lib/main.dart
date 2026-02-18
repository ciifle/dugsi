import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kobac/shared/pages/splash_screen.dart';
import 'package:kobac/shared/pages/login_screen.dart';

import 'package:kobac/student/pages/student_dashboard.dart';
import 'package:kobac/teacher/pages/teacher_dashboard.dart';
import 'package:kobac/school_admin/pages/school_admin_screen.dart';

/// =========================
/// AUTH UTILITIES
/// =========================

Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final expiry = prefs.getInt('tokenExpiry');

  if (token == null || expiry == null) return false;

  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  if (now < expiry) {
    return true;
  } else {
    await logout();
    return false;
  }
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('tokenExpiry');
  await prefs.remove('role');
  await prefs.remove('userId');
  await prefs.remove('schoolId');
}

/// =========================
/// ENTRY POINT
/// =========================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppRoot());
}

/// =========================
/// ROOT APP
/// =========================

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kobac',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AppStartRouter(),
    );
  }
}

/// =========================
/// SPLASH → LOGIN / HOME ROUTER
/// =========================

class AppStartRouter extends StatefulWidget {
  const AppStartRouter({super.key});

  @override
  State<AppStartRouter> createState() => _AppStartRouterState();
}

class _AppStartRouterState extends State<AppStartRouter> {
  bool _initialized = false;
  Widget? _startScreen;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay

    final loggedIn = await isLoggedIn();

    setState(() {
      _startScreen = loggedIn ? const RoleRouter() : const LoginPage();
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const SplashScreen();
    }
    return _startScreen!;
  }
}

/// =========================
/// ROLE ROUTER
/// =========================

class RoleRouter extends StatefulWidget {
  const RoleRouter({super.key});

  @override
  State<RoleRouter> createState() => _RoleRouterState();
}

class _RoleRouterState extends State<RoleRouter> {
  late Future<String?> _roleFuture;

  @override
  void initState() {
    super.initState();
    _roleFuture = _getRole();
  }

  Future<String?> _getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _roleFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SplashScreen();
        }

        switch (snapshot.data) {
          case 'STUDENT':
          case 'PARENT':
            return StudentDashboardScreen();
          case 'TEACHER':
            return TeacherDashboardScreen();
          case 'SCHOOL_ADMIN':
            return const SchoolAdminScreen();
          default:
            return const LoginPage();
        }
      },
    );
  }
}
