import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:message_app/helper/helper_funcation.dart';
import 'package:message_app/pages/home_page.dart';
import 'package:message_app/pages/login_page.dart';
import 'package:message_app/shared/Constan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyD4wNTLSSZoBswEuyFAoHM6ljcoVsoYyuA",
            appId: "1:114951362866:web:c3d0dc8c1d356d7f311f2b",
            messagingSenderId: "114951362866",
            projectId: "groupchatapp-66af4"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSigin = false;

  @override
  initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFuncation.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSigin = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Constan().primaryColor,
                scaffoldBackgroundColor: Colors.white),
            home: isSigin ? HomePage() : LoginPage(),
          );
        });
  }
}
