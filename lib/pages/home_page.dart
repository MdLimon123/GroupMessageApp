import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:message_app/helper/helper_funcation.dart';
import 'package:message_app/pages/login_page.dart';
import 'package:message_app/pages/profile_page.dart';
import 'package:message_app/pages/search_page.dart';
import 'package:message_app/services/auth_service.dart';
import 'package:message_app/services/database_service.dart';
import 'package:message_app/widgets/widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email = "";
  String userName = "";
  AuthService _authService = AuthService();
  Stream? groups;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    gettingUserData();
  }

  gettingUserData() async {
    await HelperFuncation.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    await HelperFuncation.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    // getting the list of snapshots in out stream

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Groups',
          style: TextStyle(
              color: Colors.white,
              fontSize: 27.sp,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                // navigate to search screen
                nextScreen(context, SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
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
              userName,
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
              onTap: () {},
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              title: const Text(
                'Groups',
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(Icons.group),
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(
                    context,
                    ProfilePage(
                      userName: userName,
                      email: email,
                    ));
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30.sp,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text(
              'Create a group',
              textAlign: TextAlign.left,
            ),
          );
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshots) {
        if (snapshots.hasData) {
          if (snapshots.data['groups'] != null) {
            if (snapshots.data['groups'].length != 0) {
              return Text('Hello');
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                color: Colors.grey[700],
                size: 75.sp,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            const Text(
              "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
              textAlign: TextAlign.center,
            )
          ]),
    );
  }
}
