import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/constants.dart';
import 'package:cookius_app/controller/usersController.dart';
import 'package:cookius_app/models/dishes.dart';
import 'package:flutter/material.dart';
import 'package:cookius_app/controller/dishesController.dart';
import 'package:intl/intl.dart';


class DishesAdmin extends StatefulWidget {
  const DishesAdmin({super.key});

  @override
  State<DishesAdmin> createState() => _DishesAdminState();
}

class _DishesAdminState extends State<DishesAdmin> {
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
  final _imageURLController = TextEditingController();
  final _g_p_lController = TextEditingController();

  // Hàm để hiển thị AlertDialog
  void _showAddDishDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thêm món ăn mới"),
        content: SingleChildScrollView( // Bao gồm Column trong một SingleChildScrollView
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên món ăn'),
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Loại món ăn'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
                maxLines: null, // Không giới hạn số dòng
                keyboardType: TextInputType
                    .multiline, // Đánh dấu input này sẽ nhận nhiều dòng
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Thời gian nấu'),
              ),
              TextFormField(
                controller: _levelController,
                decoration: const InputDecoration(labelText: 'Cấp độ'),
              ),
              TextFormField(
                controller: _caloController,
                decoration: const InputDecoration(labelText: 'Calo'),
              ),
              TextFormField(
                controller: _ingradientController,
                decoration: const InputDecoration(labelText: 'Nguyên liệu'),
                maxLines: null, // Không giới hạn số dòng
                keyboardType: TextInputType
                    .multiline, // Đánh dấu input này sẽ nhận nhiều dòng
              ),
              TextFormField(
                controller: _recipeController,
                decoration: const InputDecoration(labelText: 'Công thức'),
                maxLines: null, // Không giới hạn số dòng
                keyboardType: TextInputType
                    .multiline, // Đánh dấu input này sẽ nhận nhiều dòng
              ),
              TextFormField(
                controller: _g_p_lController,
                decoration: const InputDecoration(labelText: 'Đường - Đạm - Béo'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () {
              Navigator.of(context).pop(); // Đóng popup
            },
          ),
          TextButton(
            child: const Text('Lưu'),
            onPressed: () async {
              // Lưu dữ liệu vào Firestore
              Dishes newDish = Dishes(
                dishID: "", // Firestore tự động tạo ID nếu để trống
                name: _nameController.text,
                type: _typeController.text,
                description: _descriptionController.text,
                time: _timeController.text,
                level: _levelController.text,
                calo: _caloController.text,
                ingradient: _ingradientController.text,
                recipe: _recipeController.text,
                createdAt: Timestamp.now(),
                imageURL: _imageURLController.text,
                g_p_l:  _g_p_lController.text,
              );

              controller.addDish(newDish); // Đảm bảo chờ hàm addDish hoàn thành

              // Xóa nội dung sau khi lưu
              _nameController.clear();
              _typeController.clear();
              _descriptionController.clear();
              _timeController.clear();
              _levelController.clear();
              _caloController.clear();
              _ingradientController.clear();
              _recipeController.clear();
              _imageURLController.clear();
              _g_p_lController.clear();

              Navigator.of(context).pop(); // Đóng popup
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QUẢN LÝ MÓN ĂN",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Constants.primaryColor,
        actions: [
          IconButton(
              onPressed: _showAddDishDialog, // Gọi hàm để hiển thị popup
              icon: Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getAll(),
        // Sử dụng phương thức getAll() từ controller
        builder: (context, snapshot) {
          //  Kiểm tra xem snapshot có lỗi không
          if (snapshot.hasError) {
            return const Text('Bị lỗi');
          }
          // Hiển thị spinner khi đang chờ dữ liệu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data?.docs == null) {
            return const Center(child: Text("Không có dữ liệu"));
          }



          List<QueryDocumentSnapshot> dishesList = snapshot.data!.docs;

          if (dishesList.isEmpty) {
            return const Center(
              child: Text("Thêm món mới",
                  style: TextStyle(
                      color: Color(0xff296e48),
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            );
          }

          //   Xây dựng ListView dựa trên dữ liệu nhận được
          return ListView.builder(
            itemCount: dishesList?.length ?? 0,
            itemBuilder: (context, index) {
          final doc = dishesList[index];
          final dish = Dishes.fromJson(doc.data() as Map<String,dynamic>, doc.id);
              // Hiển thị mỗi món ăn trong một Card
              return Card(
                elevation: 4.0,
                margin: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.restaurant_menu),
                      title: Text(dish.name),
                      subtitle: Text('${dish.type} • ${dish.level}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Logic to edit the dish
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Logic to remove the dish
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        dish.description,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Calo: ${dish.calo}'),
                              Text('G:P:L: ${dish.g_p_l}'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Thời gian: ${dish.time}'),
                              Text(
                                  'Ngày tạo: ${DateFormat.yMd().format(dish.createdAt.toDate())}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    // Image.network(
                    //   dish.imageURL,
                    //   width: double.infinity,
                    //   height: 150.0,
                    //   fit: BoxFit.cover,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text('Nguyên liệu: ${dish.ingradient}',
                                softWrap: true),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text('Công thức: ${dish.recipe}',
                                softWrap: true),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
