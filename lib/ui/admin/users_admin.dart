import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/constants.dart';
import 'package:cookius_app/controller/usersController.dart';
import 'package:cookius_app/models/users.dart';
import 'package:cookius_app/ui/admin/editUsers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UsersAdmin extends StatefulWidget {
  const UsersAdmin({super.key});

  @override
  State<UsersAdmin> createState() => _UsersAdminState();
}

class _UsersAdminState extends State<UsersAdmin> {
  usersController controller = usersController();

  // Tạo controller cho TextFormField
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _userTypeController = TextEditingController();
  final _imageURLController = TextEditingController();

  // Hàm để hiển thị AlertDialog
  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thêm người dùng mới"),
        content: SingleChildScrollView(
          // Bao gồm Column trong một SingleChildScrollView
          child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(labelText: 'Tên người dùng'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _userTypeController,
                decoration: const InputDecoration(labelText: 'Phân quyền'),
              ),
              IconButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                    await imagePicker.pickImage(source: ImageSource.camera);
                    print('${file?.path}');
                  },
                  icon: Icon(Icons.camera_alt))
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
              Users newUser = Users(
                userID: "", // Firestore tự động tạo ID nếu để trống
                userName: _userNameController.text,
                password: controller.hashPassword(_passwordController.text) ,
                phone: _phoneController.text,
                email: _emailController.text,
                createdAt: Timestamp.now(),
                updatedAt: Timestamp.now(),
                userType: _userTypeController.text,
                imageURL: _imageURLController.text,
              );

              controller.addUser(newUser);

              // Xóa nội dung sau khi lưu
              _userNameController.clear();
              _passwordController.clear();
              _phoneController.clear();
              _emailController.clear();
              _userTypeController.clear();
              _imageURLController.clear();

              Navigator.of(context).pop(); // Đóng popup
            },
          ),
        ],
      ),
    );
  }

  void attemptDelete(String id) async {
    bool deleteResult = await controller.deleteUserById(id);
    if (deleteResult) {
      showDialog(
        context: context, // sử dụng context của StatefulWidget
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Xoá thành công", style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold)
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context, // sử dụng context của StatefulWidget
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Xoá không thành công", style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold)),
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
          "QUẢN LÝ NGƯỜI DÙNG",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Constants.primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,
            color: Color.alphaBlend(Colors.white, Colors.black12)),
        backgroundColor: Constants.primaryColor,
        onPressed: _showAddUserDialog,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getAll(),
        // Sử dụng phương thức getAll() từ controller
        builder: (context, snapshot) {
          //  Kiểm tra xem snapshot có lỗi không
          if (snapshot.hasError) {
            return const Center(
              child: Text('Bị lỗi',
                  style: TextStyle(
                      color: Color(0xff296e48),
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            );
          }
          // Hiển thị spinner khi đang chờ dữ liệu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> usersList = snapshot.data!.docs;

          if (usersList.isEmpty) {
            return const Center(
              child: Text("Thêm người dùng mới",
                  style: TextStyle(
                      color: Color(0xff296e48),
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            );
          }

          //   Xây dựng ListView dựa trên dữ liệu nhận được
          return ListView.builder(
            itemCount: usersList?.length ?? 0,
            itemBuilder: (context, index) {
              final doc = usersList[index];
              final user =
              Users.fromJson(doc.data() as Map<String, dynamic>, doc.id);
              return
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), // Bạn có thể điều chỉnh radius này
                  ),
                  child: ClipRRect(
                    // Điều này giúp cho mọi thứ trong Card đều có góc tròn như Card
                    borderRadius: BorderRadius.circular(15.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.person, color: Constants.primaryColor.withOpacity(0.7)),
                          title: Text(user.userName,
                              style: TextStyle(
                                  color: Color(0xff296e48),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text('${user.phone} • ${user.email} • ${user.userType}',
                              style: TextStyle(
                                color: Color(0xff296e48).withOpacity(0.7), // Slightly lighter
                                fontSize: 15,
                              )),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Constants.primaryColor.withOpacity(0.7)),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditUsers(userID: user.userID),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red.withOpacity(0.7)),
                                onPressed: () {
                                  attemptDelete(user.userID);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                );
            },
          );
        },
      ),
    );
  }
}
