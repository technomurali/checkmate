import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/forgot_password_screen.dart';
import 'package:checkmate/features/auth/screens/password_reset_screen.dart';
import 'package:checkmate/features/auth/screens/signin_screen.dart';
import 'package:checkmate/features/auth/screens/signup_screen.dart';
import 'package:checkmate/features/auth/screens/top_nav.dart';
import 'package:checkmate/routes/route_name.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Auth state derived from both id and token
    final bool isAuthenticated = (userModal.token.isNotEmpty) && userModal.id != '0';

    // Always allow core auth flows via Navigator
    if (settings.name == RouteName.signIn) {
      return MaterialPageRoute(
        builder: (_) => const SigninScreen(),
        settings: settings,
      );
    }
    if (settings.name == RouteName.signup) {
      return MaterialPageRoute(
        builder: (_) => const SignupScreen(),
        settings: settings,
      );
    }
    if (settings.name == RouteName.forgotPassword) {
      return MaterialPageRoute(
        builder: (_) => const ForgotPasswordScreen(),
        settings: settings,
      );
    }
    if (settings.name == RouteName.resetPassword) {
      return MaterialPageRoute(
        builder: (_) => PasswordResetScreen(email: settings.arguments as String),
        settings: settings,
      );
    }

    // For any non-auth route: if authenticated, go to TopNav (TopNavProvider-driven UI)
    if (isAuthenticated) {
      return MaterialPageRoute(
        builder: (_) => const TopNav(),
        settings: settings,
      );
    }
    // Unauthenticated: normal routing
    Widget screen = Scaffold(body: Center(child: Text('No route defined')));
    return MaterialPageRoute(builder: (context) => screen, settings: settings);
  }
}
