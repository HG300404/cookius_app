import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/constants.dart';
import 'package:cookius_app/controller/dishesController.dart';
import 'package:cookius_app/models/dishes.dart';
import 'package:cookius_app/ui/admin/dishes_admin.dart';
import 'package:flutter/material.dart';
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
  DateFormat  formatter = DateFormat('MMMM d, yyyy at h:mm:ss a'); // Định dạng ví dụ
  return formatter.format(dateTime);
}

Timestamp convertStringToTimestamp(String dateString) {
  DateFormat format = DateFormat('MMMM d, yyyy at h:mm:ss a'); // Định dạng phải phù hợp với chuỗi ngày tháng của bạn
  DateTime dateTime = format.parse(dateString);
  return Timestamp.fromDate(dateTime);
}


class _EditDishesState extends State<EditDishes> {
  dishesController controller = dishesController();

  void attemptUpdate(Dishes dish) async {
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
  var _imageURLController = TextEditingController();
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
        body: FutureBuilder<DocumentSnapshot>(
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
              _imageURLController.text = dishData['imageURL'] ?? '';
              _g_p_lController.text = dishData['g_p_l'] ?? '';

              if (dishData['createdAt'] != null){
                _createdAtController.text = _formatTimestamp(dishData['createdAt']);
              } else {
                _createdAtController.text = '';
              }

              if (dishData['updatedAt'] != null){
                _updatedAtController.text = _formatTimestamp(dishData['updatedAt']);
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

            return Column(
              children: [
              Stepper(
              currentStep: _index,
              onStepCancel: () {
                if (_index > 0) {
                  setState(() {
                    _index -= 1;
                  });
                }
              },
              onStepContinue: () {
                if (_index <= 0) {
                  setState(() {
                    _index += 1;
                  });
                }
              },
              onStepTapped: (int index) {
                setState(() {
                  _index = index;
                });
              },
              steps: <Step>[
                Step(
                    title: const Text("1"),
                    content: Column(children: [
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Tên món ăn",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _typeController,
                        decoration: const InputDecoration(
                          labelText: "Loại món ăn",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _timeController,
                        decoration: const InputDecoration(
                          labelText: "Thời gian",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _levelController,
                        decoration: const InputDecoration(
                          labelText: "Độ khó",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _caloController,
                        decoration: const InputDecoration(
                          labelText: "Calo",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _g_p_lController,
                        decoration: const InputDecoration(
                          labelText: "Đường - Đạm - Béo",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ])),
                Step(
                    title: const Text("2"),
                    content: Column(children: [
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _ingradientController,
                        decoration: const InputDecoration(
                          labelText: "Nguyên liệu",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 10,
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _recipeController,
                        decoration: const InputDecoration(
                          labelText: "Công thức",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 10,
                      ),
                      SizedBox(height: 8.0),
                    ])),
              ],
            ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Lưu",style:TextStyle(
                          color: Constants.primaryColor,fontSize: 20,
                      fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.save,color: Color.alphaBlend(
                            Constants.primaryColor, Colors.black12)),
                        onPressed: (){
                          Dishes dish = Dishes(dishID: widget.dishID,
                              name: _nameController.text,
                              type: _typeController.text,
                              description: _descriptionController.text,
                              time: _timeController.text,
                              level: _levelController.text,
                              calo: _caloController.text,
                              ingradient: _ingradientController.text,
                              recipe: _recipeController.text,
                              createdAt: convertStringToTimestamp(_createdAtController.text),
                              updatedAt: Timestamp.now(),
                              imageURL: _imageURLController.text,
                              g_p_l: _g_p_lController.text);
                          attemptUpdate(dish);
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ));
  }
}
