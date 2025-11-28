import 'package:flutter/material.dart';
// Import screens
import 'package:kobac/shared/pages/login_screen.dart';
import 'package:kobac/shared/pages/splash_screen.dart';


class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {

      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );
    }
  }
}
