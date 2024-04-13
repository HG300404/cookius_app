import 'package:cookius_app/controller/usersController.dart';
import 'package:cookius_app/firebase_options.dart';
import 'package:cookius_app/models/users.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'ui/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //List of Plants data
  Users user = Users(
    username: "Huong@3004",
    passwordHash: 'abc123',
    phone: '0888518142',
    email: 'nglienhg000@gmail.com',
    userType: "admin",
    imageURL: "",
    userID: '',
    createdAt: '',
  );

  // Đối tượng của usersController
  usersController controller = usersController();
  controller.addUser(user);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Onboarding Screen',
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}