import 'dart:io';

import 'package:authentication_firebase_test/core/config/connection/app_firebase_conn.dart';
import 'package:authentication_firebase_test/core/constants/constants.dart';
import 'package:authentication_firebase_test/core/packages/app_loading.dart';
import 'package:authentication_firebase_test/core/packages/app_text_form_field.dart';
import 'package:authentication_firebase_test/core/packages/app_wrap.dart';
import 'package:authentication_firebase_test/core/services/shared_preference.dart';
import 'package:authentication_firebase_test/core/utils/password.dart';
import 'package:authentication_firebase_test/features/authentication/screens/signin_screen.dart';
import 'package:authentication_firebase_test/features/authentication/screens/signup_screen.dart';
import 'package:authentication_firebase_test/features/home/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController? _userNameController = TextEditingController();
  TextEditingController? _passWordController = TextEditingController();
  TextEditingController? _passWordConfirmController = TextEditingController();
  TextEditingController? _fullNameController = TextEditingController();
  late bool? _isLoading = false;
  late bool? _obscureText = true;

  // Obtain shared preferences.
  final FirebaseFirestore? _firestore = FirebaseFirestore.instance;

  CollectionReference get _firebaseCollection =>
      _firestore!.collection(AppFirebaseConn.atSoftUserCollection);

  final _firebaseStorage = FirebaseStorage.instanceFor(
      bucket: "gs://authen-firebase-app.appspot.com");

  // final storage = FirebaseStorage.instanceFor(bucket: "gs://atsoft-7f0f9.appspot.com");
  final picker = ImagePicker();

  // imagePath
  late File imagePath = File("");


  void choosePhotoOrCamera(ImageSource imageSource) async {
    try {
      final pickedFile =
          await picker.pickImage(source: imageSource, imageQuality: 50);
      if (pickedFile!.path.isEmpty) {
        print("No image selected");
      } else {
        setState(() {
          imagePath = File(pickedFile.path);
        });
        // upload image to firebase storage
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void popupChooseTyp(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Photo"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(height: AppSizeConfig.heightMultiplier*2),
                GestureDetector(
                  child: const Text("Camera"),
                  onTap: () {
                    choosePhotoOrCamera(ImageSource.camera);

                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: AppSizeConfig.heightMultiplier),
                Divider(),
                SizedBox(height: AppSizeConfig.heightMultiplier),
                GestureDetector(
                  child: const Text("Gallery"),
                  onTap: () {
                    choosePhotoOrCamera(ImageSource.gallery);

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleSingIn() async {
    await _firebaseCollection
        .where("username", isEqualTo: _userNameController!.text)
        .get()
        .then((value) async {
      if (value.docs.length == 0) {
        if (_passWordController!.text == _passWordConfirmController!.text) {
          await _firebaseCollection.add({
            "username": _userNameController!.text,
            "password": encryptPassword(_passWordController!.text),
            "fullname": _fullNameController!.text,
          }).then((value)async {
            print("Add data to firebase collection success");
            // Message register success
            // save user to local storage
           await SharedPreference.setString(
                key: "username", value: _userNameController!.text);

            await _firebaseStorage
                .ref("user/${_userNameController!.text}")
                .putFile(imagePath)
                .then((value) async {
              print("Upload image to firebase storage success");
              // get image url
              await _firebaseStorage
                  .ref("user/${_userNameController!.text}")
                  .getDownloadURL()
                  .then((value) {
                print("Get image url success");
                // save image url to firebase collection
                _firebaseCollection
                    .where("username", isEqualTo: _userNameController!.text)
                    .get()
                    .then((value) {

                      print("Update image url success");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Register success"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(),
                        ),
                      );
                });
              }).catchError((error) {
                print("Get image url error: $error");
              });
            }).catchError((error) {
              print("Upload image to firebase storage error: $error");
            });


          }).catchError((error) {
            print("Add data to firebase collection error: $error");
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("รหัสผ่านไม่ตรงกัน"),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "ชื่อผู้ใช้ ${_userNameController!.text} มีอยู่ในระบบแล้ว"),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    SizedBox(height: AppSize.kAppDefaultPadding * 4),
                    Center(
                      child: Image.asset(AppAssets.appLogo),
                    ),
                    SizedBox(height: AppSize.kAppDefaultPadding * 4),
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
                              child: Text("สมัครสมาชิก",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: AppColors.kTextColor)),
                            ),
                            AppWrap(
                              child: AppTextFormField(
                                controller: _userNameController,
                                hintText: "ชื่อผู้ใช้",
                                validator: "กรุณาป้อนชื่อผู้ใช้",
                              ),
                            ),
                            AppWrap(
                              child: AppTextFormField(
                                  controller: _passWordController,
                                  hintText: "รหัสผ่าน",
                                  validator: "กรุณาป้อนรหัสผ่าน",
                                  obscureText: _obscureText!,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText!;
                                      });
                                    },
                                    icon: Icon(
                                      _obscureText!
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.kTextGreyColor,
                                    ),
                                  )),
                            ),
                            AppWrap(
                              child: AppTextFormField(
                                  controller: _passWordConfirmController,
                                  hintText: "ยืนยันรหัสผ่าน",
                                  validator: "กรุณาป้อนรหัสผ่านอีกครั้ง",
                                  obscureText: _obscureText!,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText!;
                                      });
                                    },
                                    icon: Icon(
                                      _obscureText!
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.kTextGreyColor,
                                    ),
                                  )),
                            ),
                            AppWrap(
                              child: AppTextFormField(
                                  controller: _fullNameController,
                                  hintText: "ชื่อ - นามสกุล",
                                  validator: "กรุณาป้อนชื่อ - นามสกุล"),
                            ),
                            AppWrap(
                                child: GestureDetector(
                                  onTap: (){
                                    if(_userNameController!.text.isNotEmpty){
                                      popupChooseTyp(context);
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("กรุณาป้อนชื่อผู้ใช้"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                              color: AppColors.kPrimaryLight,
                              height: AppSizeConfig.heightMultiplier * 14,
                              width: AppSizeConfig.widthMultiplier * 100,
                              child: imagePath.path!=""? Image.asset(imagePath.path) : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline,
                                      size:
                                          AppSizeConfig.imageSizeMultiplier * 10,
                                      color: AppColors.kTextGreyColor,
                                    ),
                                    Text(
                                      "เพิ่มรูปภาพประจำตัว",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: AppColors.kTextGreyColor,
                                          ),
                                    ),
                                  ],
                              ),
                            ),
                                )),
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
                            _toggleSingIn();
                            setState(() {
                              _isLoading = false;
                            });
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
                          "สมัครสมาชิก",
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
                          "คุณมีบัญชีผู้ใช้งานอยู่แล้ว",
                          style: TextStyle(
                              color: AppColors.kTextGreyColor,
                              fontWeight: FontWeight.bold),
                        ),
                        AppWrap(
                          child: TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                )),
                            child: Text(
                              "เข้าสู่ระบบ",
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
