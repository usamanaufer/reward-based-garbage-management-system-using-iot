import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garbage_app_create/screens/bottom.dart';
import 'package:garbage_app_create/screens/home_screen.dart';
import 'package:garbage_app_create/screens/login_screen.dart';
import 'package:garbage_app_create/screens/past_points.dart';
import 'package:garbage_app_create/screens/provider/google_sign_in.dart';
import 'package:garbage_app_create/screens/reset_screen.dart';
import 'package:garbage_app_create/screens/scanned.dart';
import 'package:garbage_app_create/screens/settings.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'iWaste',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: LoginScreen(),
        ),
      );
}
                