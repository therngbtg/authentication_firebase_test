import 'package:authentication_firebase_test/core/constants/app_assets.dart';
import 'package:authentication_firebase_test/core/services/shared_preference.dart';
import 'package:authentication_firebase_test/features/authentication/screens/signin_screen.dart';
import 'package:authentication_firebase_test/features/home/screens/home.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  void _getUserLocal() async {
    String? result = await SharedPreference.getString(key: "user");
    print("username: $result");
    if (result == null) {
      Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignInScreen(),
              )));
    } else {
      Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              )));
    }
  }

  @override
  void initState() {
    _getUserLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppAssets.appLogo),
      ),
    );
  }
}
