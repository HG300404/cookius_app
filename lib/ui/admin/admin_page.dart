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
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "Cookius",
                style: TextStyle(fontSize: 20.0),
              ),
              accountEmail: Text(
                "cookius@gmail.com",
                style: TextStyle(fontSize: 14.0),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "C",
                  style: TextStyle(fontSize: 40.0, color: Color(0xff296e48)),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xff296e48),
              ),
            ),
            ListTile(
              leading: Icon(Icons.fastfood, color: _selectedIndex == 0 ? Colors.blue : null),
              title: const Text('Món ăn'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: _selectedIndex == 1 ? Colors.blue : null),
              title: const Text('Người dùng'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: _selectedIndex == 2 ? Colors.red : null),
              title: const Text('Yêu thích'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            Divider(),
            // You can add other sections or footer here
          ],
        ),
      )
    );
  }
}
