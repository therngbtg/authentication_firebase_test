import 'package:authentication_firebase_test/features/landing_screen.dart';
import 'package:authentication_firebase_test/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        AppSizeConfig().init(constraints, orientation);
        return MaterialApp(
          title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: AppColors.kPrimaryColor,
              primaryColorDark: AppColors.kPrimaryColor,
              primaryColorLight: AppColors.kPrimaryColor,
              primarySwatch: AppColors.kPrimaryColor,
              scaffoldBackgroundColor: AppColors.kLightColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                },
              ),
              // textTheme: appTextTheme,
              appBarTheme: AppBarTheme(
                elevation: 0,
                centerTitle: true,
                titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                color: AppColors.kLightColor,
                iconTheme:  IconThemeData(
                  color: AppColors.kPrimaryColor,
                ),
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const LandingScreen(),
        );
      });
    });
  }
}
