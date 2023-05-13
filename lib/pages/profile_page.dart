import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:message_app/pages/home_page.dart';
import 'package:message_app/pages/login_page.dart';
import 'package:message_app/services/auth_service.dart';
import 'package:message_app/widgets/widget.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({super.key, required this.userName, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
              fontSize: 27.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.h),
          children: [
            Icon(
              Icons.account_circle,
              size: 100.sp,
              color: Colors.grey[700],
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              widget.userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30.h,
            ),
            Divider(
              height: 2.h,
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(context, HomePage());
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              title: const Text(
                'Groups',
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(Icons.group),
            ),
            ListTile(
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              onTap: () {
                // nextScreenReplace(context, ProfilePage());
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(Icons.group),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () async {
                                await _authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (_) => LoginPage()),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              )),
                        ],
                      );
                    });
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 150.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 150.sp,
              color: Colors.grey[700],
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Full Name',
                  style: TextStyle(fontSize: 17.sp),
                ),
                Text(
                  widget.userName,
                  style: TextStyle(fontSize: 17.sp),
                )
              ],
            ),
            Divider(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email',
                  style: TextStyle(fontSize: 17.sp),
                ),
                Text(
                  widget.email,
                  style: TextStyle(fontSize: 17.sp),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
