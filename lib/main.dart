import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/controller/usersController.dart';
import 'package:cookius_app/firebase_options.dart';
import 'package:cookius_app/models/users.dart';
import 'package:cookius_app/ui/admin/admin_page.dart';
import 'package:cookius_app/ui/admin/dishes_admin.dart';
import 'package:cookius_app/ui/screens/detail_dish_page.dart';

import 'package:cookius_app/ui/screens/favorite_page.dart';
import 'package:cookius_app/ui/screens/updatePassword_screen.dart';
import 'package:cookius_app/ui/screens/home_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ui/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return const MaterialApp(
    //   title: 'Onboarding Screen',
    //   home: DetailDish(),
    //   debugShowCheckedModeBanner: false,
    // );
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (BuildContext context, Widget? _) => MaterialApp(
      title: 'Onboarding Screen',
      home: DetailDish(),
      debugShowCheckedModeBanner: false,
      ),
    );
  }
}