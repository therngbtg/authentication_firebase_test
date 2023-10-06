import 'package:authentication_firebase_test/core/config/connection/app_firebase_conn.dart';
import 'package:authentication_firebase_test/core/constants/constants.dart';
import 'package:authentication_firebase_test/core/packages/app_loading.dart';
import 'package:authentication_firebase_test/core/packages/app_text_form_field.dart';
import 'package:authentication_firebase_test/core/packages/app_wrap.dart';
import 'package:authentication_firebase_test/core/services/shared_preference.dart';
import 'package:authentication_firebase_test/core/utils/password.dart';
import 'package:authentication_firebase_test/features/authentication/screens/signup_screen.dart';
import 'package:authentication_firebase_test/features/home/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController? _userNameController = TextEditingController();
  TextEditingController? _passWordController = TextEditingController();
  late bool? _isLoading = false;
  late bool? _obscureText = true;

  final FirebaseFirestore? _firestore = FirebaseFirestore.instance;

  CollectionReference get _firebaseCollection =>
      _firestore!.collection(AppFirebaseConn.atSoftUserCollection);

  void _toggleSingIn() async {
    // check user in firebase

    await _firebaseCollection
        .where("username", isEqualTo: _userNameController!.text)
        .get()
        .then((value) async {
      if (value.docs.length == 0) {
        print("user not found");
        // if user not found, show error

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ไม่พบผู้ใช้งาน"),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print("user found");
        // if user found, check password
        var pass = comparePassword(
            value.docs[0]["password"], _passWordController!.text);
        if (pass == "true") {
          print("password match");
          await SharedPreference.setString(
              key: "username", value: _userNameController!.text);
          // if password match, save user to local and navigate to home screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        } else {
          // if password not match, show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("รหัสผ่านไม่ถูกต้อง"),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: Scaffold(
        body: AppLoading(
          isLoading: _isLoading,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.kAppDefaultPadding * 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: AppSize.kAppDefaultPadding * 14),
                    Center(
                      child: Image.asset(AppAssets.appLogo),
                    ),
                    SizedBox(height: AppSize.kAppDefaultPadding * 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSize.kAppDefaultPadding * 2,
                        horizontal: AppSize.kAppDefaultPadding,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppWrap(
                              child: Text("เข้าสู่ระบบ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: AppColors.kTextColor)),
                            ),
                            AppWrap(
                              child: AppTextFormField(
                                controller: _userNameController,
                                hintText: "Username",
                                validator: "กรุณาป้อน Username",
                              ),
                            ),
                            AppWrap(
                              child: AppTextFormField(
                                controller: _passWordController,
                                hintText: "Password",
                                validator: "กรุณาป้อน Password",
                                obscureText: _obscureText,
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText!;
                                      });
                                    },
                                    icon: Icon(
                                      _obscureText == true
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: AppColors.kTextColor,
                                    )),
                              ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "ลืมรหัสผ่าน?",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: AppColors.kTextColor),
                                      )),
                                ])
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          Future.delayed(Duration(seconds: 3), () {
                            setState(() {
                              _isLoading = false;
                            });
                            _toggleSingIn();
                          });
                          print("validated");
                        } else {
                          print("not pass validate");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kGreenButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppSize.kAppCircleRadius / 20),
                        ),
                      ),
                      child: AppWrap(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSize.kAppDefaultPadding * 1.5,
                        ),
                        child: Text(
                          "เข้าสู่ระบบ",
                          style: TextStyle(
                              color: AppColors.kLightColor,
                              fontSize: AppSizeConfig.textMultiplier * 2),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ยังไม่มีบัญชีผู้ใช้งาน?",
                          style: TextStyle(
                              color: AppColors.kTextGreyColor,
                              fontWeight: FontWeight.bold),
                        ),
                        AppWrap(
                          child: TextButton(
                            onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                )),
                            child: Text(
                              "สมัครสมาชิก",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: AppColors.kBlueColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
