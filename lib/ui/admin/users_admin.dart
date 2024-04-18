import 'package:cookius_app/constants.dart';
import 'package:flutter/material.dart';

class UsersAdmin extends StatefulWidget {
  const UsersAdmin({super.key});

  @override
  State<UsersAdmin> createState() => _UsersAdminState();
}

class _UsersAdminState extends State<UsersAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QUẢN LÝ NGƯỜI DÙNG"
        ),
        backgroundColor: Constants.primaryColor,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      body: Center(
        child: Text("Home Page"),
      ),
    );
  }
}
