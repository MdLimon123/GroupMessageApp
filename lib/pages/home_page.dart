import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:message_app/helper/helper_funcation.dart';
import 'package:message_app/pages/search_page.dart';
import 'package:message_app/services/auth_service.dart';
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
            )
          ],
        ),
      ),
    );
  }
}
