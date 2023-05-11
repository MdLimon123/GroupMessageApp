import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:message_app/helper/helper_funcation.dart';
import 'package:message_app/pages/home_page.dart';
import 'package:message_app/pages/login_page.dart';
import 'package:message_app/services/auth_service.dart';

import '../widgets/widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  final formkKey = GlobalKey<FormState>();
  String fullName = "";
  String email = "";
  String password = "";
  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
                  child: Form(
                    key: formkKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Groupi',
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            'Create your account now to chat and explore!',
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.w400),
                          ),
                          Image.asset('assets/login.png'),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Full Name',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Theme.of(context).primaryColor,
                                )),
                            onChanged: (value) {
                              setState(() {
                                fullName = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Name cannot be empty';
                              }
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Theme.of(context).primaryColor,
                                )),
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            validator: (value) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                )),
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            validator: (value) {
                              if (value!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          InkWell(
                            onTap: () {
                              register();
                            },
                            child: Container(
                              height: 50.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Center(
                                  child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.sp),
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text.rich(TextSpan(
                              text: "Already have an account?",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.black),
                              children: [
                                TextSpan(
                                    text: 'Login now',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(context, const LoginPage());
                                      }),
                              ])),
                        ]),
                  )),
            ),
    );
  }

  register() async {
    if (formkKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await _authService
          .registerUserEmailAndPassword(email, password, fullName)
          .then((value) async {
        if (value == true) {
          await HelperFuncation.saveUserLoggedInStatus(true);
          await HelperFuncation.saveUserEmailStatus(email);
          await HelperFuncation.saveUserNameStatus(fullName);

          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
}
