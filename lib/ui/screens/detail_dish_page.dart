import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/constants.dart';
import 'package:cookius_app/controller/dishesController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailDish extends StatefulWidget {
  const DetailDish({super.key});

  @override
  State<DetailDish> createState() => _DetailDishState();
}

class _DetailDishState extends State<DetailDish> {
  String id = "CpBUloT8xUYnxj6SqfvN";

  dishesController controller = dishesController();

  // Tạo controller cho TextFormField
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  final _levelController = TextEditingController();
  final _caloController = TextEditingController();
  final _ingradientController = TextEditingController();
  final _recipeController = TextEditingController();
  String _imageURLController = '';
  final _g_p_lController = TextEditingController();

  //Toggle Favorite button
  bool toggleIsFavorated(bool isFavorited) {
    return !isFavorited;
  }

  //Toggle add remove from cart
  bool toggleIsSelected(bool isSelected) {
    return !isSelected;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
      future: controller.getID(id),
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
        } else {
          return const Center(
            child: Text("Không có dữ liệu",
                style: TextStyle(
                    color: Color(0xff296e48),
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: media.width,
                height: media.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.white, Colors.transparent, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: media.width - 60,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 35,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Text(
                                      _nameController.text,
                                      style: TextStyle(
                                          color: Constants.primaryColor,
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 30.0),
                                      Column(
                                        children: [
                                          Icon(Icons.access_alarm_outlined,
                                              color: Constants.primaryColor),
                                          Text("Thời gian thực hiện:",
                                              style: TextStyle(
                                                fontSize: 20,
                                              )),
                                          Text(_timeController.text,
                                              style: TextStyle(
                                                  color: Color(0xff296e48),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(width: 70.0),
                                      Column(
                                        children: [
                                          Icon(Icons.lens_blur,
                                              color: Constants.primaryColor),
                                          Text("Độ khó:",
                                              style: TextStyle(
                                                fontSize: 20,
                                              )),
                                          Text(_levelController.text,
                                              style: TextStyle(
                                                  color: Color(0xff296e48),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      SizedBox(width: 30.0),
                                      TextButton(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.greenAccent),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Constants.primaryColor)),
                                        onPressed: () {},
                                        child: Text('Mô tả',
                                            style: TextStyle(
                                              fontSize: 20,
                                            )),
                                      ),
                                      SizedBox(width: 30.0),
                                      TextButton(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.greenAccent),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Constants.primaryColor)),
                                        onPressed: () {},
                                        child: Text('Nguyên liệu',
                                            style: TextStyle(
                                              fontSize: 20,
                                            )),
                                      ),
                                      SizedBox(width: 30.0),
                                      TextButton(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.greenAccent),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Constants.primaryColor)),
                                        onPressed: () {},
                                        child: Text('Công thức',
                                            style: TextStyle(
                                              fontSize: 20,
                                            )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Text(
                                      "Mô tả",
                                      style: TextStyle(
                                          color: Constants.primaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Text(
                                      _descriptionController.text,
                                      style: TextStyle(
                                          color: Constants.secondColor,
                                          fontSize: 18),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Divider(
                                        color: Constants.secondColor
                                            .withOpacity(0.4),
                                        height: 1,
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Text(
                                      "Nguyên liệu",
                                      style: TextStyle(
                                          color: Constants.primaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Text(
                                      _ingradientController.text,
                                      style: TextStyle(
                                          color: Constants.secondColor,
                                          fontSize: 18),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: Divider(
                                        color: Constants.secondColor
                                            .withOpacity(0.4),
                                        height: 1,
                                      )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Text(
                                      "Công thức",
                                      style: TextStyle(
                                          color: Constants.primaryColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Text(
                                      _recipeController.text,
                                      style: TextStyle(
                                          color: Constants.secondColor,
                                          fontSize: 18),
                                    ),
                                  ),
                                ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    Align(
                      alignment: Alignment
                          .topRight, // Căn chỉnh nút ở góc phải trên cùng
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: IconButton(
                          onPressed: () {
                            // Đoạn mã để chuyển đến màn hình khác hoặc thực hành hành động nào đó
                          },
                          icon: Icon(
                            Icons.favorite_outlined,
                            color: Constants.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
