import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/constants.dart';
import 'package:cookius_app/controller/dishesController.dart';
import 'package:cookius_app/models/dishes.dart';
import 'package:cookius_app/ui/admin/dishes_admin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditDishes extends StatefulWidget {
  final String dishID;

  const EditDishes({Key? key, required this.dishID}) : super(key: key);

  @override
  State<EditDishes> createState() => _EditDishesState();
}

String _formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  // Bạn có thể thay đổi pattern để phù hợp với định dạng bạn muốn
  DateFormat formatter =
      DateFormat('MMMM d, yyyy at h:mm:ss a'); // Định dạng ví dụ
  return formatter.format(dateTime);
}

Timestamp convertStringToTimestamp(String dateString) {
  DateFormat format = DateFormat(
      'MMMM d, yyyy at h:mm:ss a'); // Định dạng phải phù hợp với chuỗi ngày tháng của bạn
  DateTime dateTime = format.parse(dateString);
  return Timestamp.fromDate(dateTime);
}

class _EditDishesState extends State<EditDishes> {
  dishesController controller = dishesController();

  void attemptUpdate(Dishes dish) async {

    if (_imageURLController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chưa chọn được ảnh')));
    }

    bool updateResult = await controller.updateDish(dish, widget.dishID);
    if (updateResult) {
      showDialog(
        context: context, // sử dụng context của StatefulWidget
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Cập nhật thành công"),
          );
        },
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DishesAdmin(),
        ),
      );
    } else {
      showDialog(
        context: context, // sử dụng context của StatefulWidget
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Cập nhật không thành công"),
          );
        },
      );
    }
  }


  // Tạo controller cho TextFormField
  var _nameController = TextEditingController();
  var _typeController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _timeController = TextEditingController();
  var _levelController = TextEditingController();
  var _caloController = TextEditingController();
  var _ingradientController = TextEditingController();
  var _recipeController = TextEditingController();
  var _imageURLController = '';
  var _g_p_lController = TextEditingController();
  var _updatedAtController = TextEditingController();
  var _createdAtController = TextEditingController();

  var _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "CHỈNH SỬA MÓN ĂN",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Constants.primaryColor,
        ),
        body:
        FutureBuilder<DocumentSnapshot>(
          future: controller.getID(widget.dishID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Bị lỗi',
                    style: TextStyle(
                        color: Color(0xff296e48),
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              );
            }

            if (snapshot.hasData && snapshot.data!.data() != null) {
              Map<String, dynamic> dishData =
                  snapshot.data!.data() as Map<String, dynamic>;
              _nameController.text =
                  dishData['name'] ?? ''; // gán giá trị cho thuộc tính `text`
              _typeController.text = dishData['type'] ?? '';
              _descriptionController.text = dishData['description'] ?? '';
              _timeController.text = dishData['time'] ?? '';
              _levelController.text = dishData['level'] ?? '';
              _caloController.text = dishData['calo'] ?? '';
              _ingradientController.text = dishData['ingradient'] ?? '';
              _recipeController.text = dishData['recipe'] ?? '';
              _imageURLController = dishData['imageURL'] ?? '';
              _g_p_lController.text = dishData['g_p_l'] ?? '';

              if (dishData['createdAt'] != null) {
                _createdAtController.text =
                    _formatTimestamp(dishData['createdAt']);
              } else {
                _createdAtController.text = '';
              }

              if (dishData['updatedAt'] != null) {
                _updatedAtController.text =
                    _formatTimestamp(dishData['updatedAt']);
              } else {
                _updatedAtController.text = '';
              }
            } else {
              return const Center(
                child: Text("Không có dữ liệu",
                    style: TextStyle(
                        color: Color(0xff296e48),
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              );
            }
            return
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Món ăn',
                          border: OutlineInputBorder(), // Consistent border style
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _typeController,
                        decoration: InputDecoration(
                          labelText: 'Loại món ăn',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _timeController,
                        decoration: InputDecoration(
                          labelText: 'Thời gian thực hiện',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _levelController,
                        decoration: InputDecoration(
                          labelText: 'Độ khó',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _caloController,
                        decoration: InputDecoration(
                          labelText: 'Hàm lượng calo',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _g_p_lController,
                        decoration: InputDecoration(
                          labelText: 'Đường_Đạm_Béo',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Mô tả',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _ingradientController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Nguyên liệu',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _recipeController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Công thức',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    Card(
                      elevation: 4.0, // Subtle elevation
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        child: _imageURLController.isEmpty
                            ? Icon(Icons.image, size: 80.0) // Placeholder icon when no image is set
                            : Image.network(_imageURLController),
                      ),
                    ),

                    // Center aligns its children horizontally; the Row is no longer necessary.
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.save, color: Theme.of(context).primaryColor),
                        onPressed: () {
                          // Your existing save functionality
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "Lưu",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor, // Color from theme
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

            );
          },
        )
    );
  }
}
