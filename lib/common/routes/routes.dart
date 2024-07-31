

import 'package:flutter/material.dart';
import 'package:taskoopia/features/auth/pages/login_page.dart';
import 'package:taskoopia/features/auth/pages/otp_page.dart';
import 'package:taskoopia/features/todo/pages/homepage.dart';

import '../../features/onboarding/pages/onboarding.dart';

class Routes{
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String otp = 'otp';
  static const String home = 'home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings){
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (context) => const OnBoarding());

      case login:
        return MaterialPageRoute(builder: (context) => const LoginPage());

      case otp:
        final Map args = settings.arguments as Map;
        return MaterialPageRoute(builder: (context) =>
            OtpPage(
              phone: args['phone'],
              smsCodeId: args['smsCodeId'],
              ));
      case home:
        return MaterialPageRoute(builder: (context) => const HomePage());

      default:
        return MaterialPageRoute(builder: (context) => const HomePage());
    }
  }
}