import 'package:cookius_app/constants.dart';
import 'package:flutter/material.dart';

class FavoriteAdmin extends StatefulWidget {
  const FavoriteAdmin({super.key});

  @override
  State<FavoriteAdmin> createState() => _FavoriteAdminState();
}

class _FavoriteAdminState extends State<FavoriteAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QUẢN LÝ YÊU THÍCH"),
        backgroundColor: Constants.primaryColor,
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Text("Home Page"),
      ),
    );
  }
}
