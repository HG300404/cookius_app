import 'package:cookius_app/constants.dart';
import 'package:cookius_app/ui/admin/dishes_admin.dart';
import 'package:cookius_app/ui/admin/users_admin.dart';
import 'package:cookius_app/ui/admin/favorite_admin.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DishesAdmin(),
    UsersAdmin(),
    FavoriteAdmin(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QUẢN LÝ COOKIUS"),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Align(
                alignment: Alignment.center, // Căn chính giữa
                child: Text(
                  "MENU COOKIUS",
                  style: TextStyle(
                    color: Colors.white, // Màu sắc của chữ
                    fontWeight: FontWeight.bold, // Làm cho chữ đậm
                    fontSize: 30, // Kích cỡ font của chữ
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xff296e48),
              ),
            ),
            ListTile(
              title: const Text('Users'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Dishes'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Favorite'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
