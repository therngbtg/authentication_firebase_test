import 'package:authentication_firebase_test/core/config/connection/app_firebase_conn.dart';
import 'package:authentication_firebase_test/core/constants/app_assets.dart';
import 'package:authentication_firebase_test/core/constants/app_colors.dart';
import 'package:authentication_firebase_test/core/constants/app_size.dart';
import 'package:authentication_firebase_test/core/constants/app_size_config.dart';
import 'package:authentication_firebase_test/core/packages/app_loading.dart';
import 'package:authentication_firebase_test/core/packages/app_wrap.dart';
import 'package:authentication_firebase_test/core/services/shared_preference.dart';
import 'package:authentication_firebase_test/features/authentication/screens/signin_screen.dart';
import 'package:authentication_firebase_test/features/landing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController? _userNameController = TextEditingController();
  TextEditingController? _fullNameController = TextEditingController();

  late bool? _isLoading = false;

  final FirebaseFirestore? _firestore = FirebaseFirestore.instance;

  CollectionReference get _firebaseCollection =>
      _firestore!.collection(AppFirebaseConn.atSoftUserCollection);

  final _firebaseStorage = FirebaseStorage.instanceFor(
      bucket: "gs://authen-firebase-app.appspot.com");
  late String? _imageUrl = "";

  // get data form atSoftUserCollection
  Future<void> _getCollection({String? user}) async {
    // get user detail by username as user and do not response password

    setState(() {
      _isLoading = true;
    });
    try {
      await _firebaseCollection
          .where("username", isEqualTo: user)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          setState(() {
            _userNameController!.text = element["username"];
            _fullNameController!.text = element["fullname"];
          });
        });
      });

      // get image from firebase storage where user id
      Reference ref = _firebaseStorage.ref().child("user/$user");
      ref.getDownloadURL().then((value) {
        setState(() {
          _imageUrl = value;
        });
      });
    } catch (e) {
      print("error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    SharedPreference.getString(key: "username").then((value) {
      print("username: $value");
      _getCollection(user: value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppLoading(
        isLoading: _isLoading,
        child: AppWrap(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.kAppDefaultPadding * 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  AppWrap(
                    child: Center(
                      child: Text(
                        "เข้าสู้ระบบสำเร็จ",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.kTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.kAppDefaultPadding * 4),
                  AppWrap(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.kAppDefaultPadding * 12),
                        child:  ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: _imageUrl ==""? Image.asset(
                            AppAssets.appProfile,
                            width: AppSizeConfig.imageSizeMultiplier * 40,
                            height: AppSizeConfig.imageSizeMultiplier * 40,
                            fit: BoxFit.cover,
                          ): Image.network(
                            _imageUrl!,
                            width: AppSizeConfig.imageSizeMultiplier * 40,
                            height: AppSizeConfig.imageSizeMultiplier * 40,
                            fit: BoxFit.cover,
                          )
                        )),
                  ),
                ],
              ),
              SizedBox(height: AppSize.kAppDefaultPadding * 4),
              // ส่วนตัว
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ส่วนตัว",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.kTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.kPrimaryLight,
                        borderRadius: BorderRadius.circular(
                          AppSize.kAppDefaultRadius,
                        )),
                    child: Column(
                      children: [
                        AppWrap(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: AppSize.kAppDefaultPadding),
                                Text(
                                  "ชื่อ:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.kTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(width: AppSize.kAppDefaultPadding),
                                Text(
                                  "${_fullNameController!.text}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.kTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        AppWrap(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: AppSize.kAppDefaultPadding),
                                Text(
                                  "เบอร์โทร:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.kTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(width: AppSize.kAppDefaultPadding),
                                Text(
                                  "093556949",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.kTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: AppSize.kAppDefaultPadding * 2),
              // บัญชี
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "บัญชี",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.kTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.kPrimaryLight,
                        borderRadius: BorderRadius.circular(
                          AppSize.kAppDefaultRadius,
                        )),
                    child: Column(
                      children: [
                        AppWrap(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: AppSize.kAppDefaultPadding),
                                Text(
                                  "username:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.kTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(width: AppSize.kAppDefaultPadding),
                                Text(
                                  "${_userNameController!.text}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.kTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        AppWrap(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: AppSize.kAppDefaultPadding),
                                    Text(
                                      "password:",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.kTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(width: AppSize.kAppDefaultPadding),
                                    Text(
                                      "*******",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.kTextColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "เปลี่ยนรหัสผ่าน",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.kBlueColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSize.kAppDefaultPadding * 4),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  Future.delayed(Duration(seconds: 3), () {
                    setState(() {
                      _isLoading = false;
                    });
                    SharedPreference.clear();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ));
                  });
                  print("validated");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kGreenButton,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSize.kAppCircleRadius / 20),
                  ),
                ),
                child: AppWrap(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSize.kAppDefaultPadding * 1.5,
                  ),
                  child: Text(
                    "ล็อกเอาท์",
                    style: TextStyle(
                        color: AppColors.kLightColor,
                        fontSize: AppSizeConfig.textMultiplier * 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
