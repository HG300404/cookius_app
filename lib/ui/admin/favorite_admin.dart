import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/constants.dart';
import 'package:cookius_app/controller/favoritesController.dart';
import 'package:cookius_app/models/favorite.dart';
import 'package:cookius_app/ui/admin/editFavorite.dart';
import 'package:flutter/material.dart';

class FavoriteAdmin extends StatefulWidget {
  const FavoriteAdmin({Key? key}) : super(key: key);

  @override
  State<FavoriteAdmin> createState() => _FavoritesAdminState();
}

class _FavoritesAdminState extends State<FavoriteAdmin> {
  final FavoritesController controller = FavoritesController();

  // Tạo controller cho TextFormField
  final _dishIdController = TextEditingController();
  final _userIdController = TextEditingController();

  void _showAddFavoriteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm món ăn yêu thích mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _dishIdController,
                decoration: const InputDecoration(labelText: 'ID Món ăn'),
              ),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'ID Người dùng'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Hủy'),
            onPressed: () {
              _dishIdController.clear();
              _userIdController.clear();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Lưu'),
            onPressed: () async {
              // Logic để thêm món ăn yêu thích mới
              Favorite newFavorite = Favorite(
                favoriteID: "", // Firestore tự động tạo ID nếu để trống
                dishID: _dishIdController.text,
                userID: _userIdController.text,
                // Thêm các thuộc tính khác
              );

              await controller.addFavorite(newFavorite);

              // Làm sạch các bộ điều khiển và đóng hộp thoại
              _dishIdController.clear();
              _userIdController.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void attemptDelete(String favoriteId) async {
    bool deleteResult = await controller.deleteFavoriteById(favoriteId);
    if (deleteResult) {
      // Hiển thị thông báo xóa thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Xoá thành công', style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold)
            ),
          );
        },
      );
    } else {
      // Hiển thị thông báo xóa không thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Xoá không thành công', style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold)
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QUẢN LÝ MÓN ĂN YÊU THÍCH",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Constants.primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFavoriteDialog, // Gọi hàm hiển thị hộp thoại thêm mới
        tooltip: 'Thêm món ăn yêu thích',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getAllFavorites(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Bị lỗi',
                  style: TextStyle(
                      color: Color(0xff296e48),
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          List<DocumentSnapshot> favoritesList = snapshot.data!.docs;

          if (favoritesList.isEmpty) {
            return const Center(
              child: Text("Thêm món ăn yêu thích mới",
                  style: TextStyle(
                      color: Color(0xff296e48),
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            );
          }

          return ListView.builder(
              itemCount: favoritesList?.length ?? 0,
              itemBuilder: (context, index) {
                final doc = favoritesList[index];
                final favorite =
                Favorite.fromJson(doc.data() as Map<String, dynamic>, doc.id);
              return Card(
                elevation: 4.0,
                margin: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person,
                          color: Color.alphaBlend(
                              Constants.primaryColor, Colors.black12)),
                      title:  Text("${favorite.userID} - ${favorite.dishID}",
                          style: TextStyle(
                              color: Color(0xff296e48),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit,color: Color.alphaBlend(
                                Constants.primaryColor, Colors.black12)),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditFavorites(favoriteId: favorite.favoriteID),
                                ),
                              );
                            },
                          ),

                          IconButton(
                            icon: Icon(Icons.delete,color: Color.alphaBlend(
                                Constants.primaryColor, Colors.black12)),
                            onPressed: () {
                              attemptDelete(favorite.favoriteID);
                            },
                          ),
                        ],
                      ),
                    ),
                      SizedBox(height: 10.0),
                  ]
                ),
              );
              },
          );
        },
      ),
    );
  }
}