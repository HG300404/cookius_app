import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/constants.dart';
import 'package:cookius_app/controller/usersController.dart';
import 'package:cookius_app/models/users.dart';
import 'package:cookius_app/ui/admin/users_admin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditUsers extends StatefulWidget {
  final String userID;

  const EditUsers({Key? key, required this.userID}) : super(key: key);

  @override
  State<EditUsers> createState() => _EditUsersState();
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

class _EditUsersState extends State<EditUsers> {
  usersController controller = usersController();

  void attemptUpdate(Users user) async {
    bool updateResult = await controller.updateUser(user, widget.userID);
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
          builder: (context) => UsersAdmin(),
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
  var _userNameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _imageURLController = TextEditingController();
  var _userTypeController = TextEditingController();
  var _updatedAtController = TextEditingController();
  var _createdAtController = TextEditingController();

  var _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "CHỈNH SỬA NGƯỜI DÙNG",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Constants.primaryColor,
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: controller.getID(widget.userID),
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
              Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;
              _userNameController.text = userData['userName'] ?? ''; // gán giá trị cho thuộc tính `text`
              _passwordController.text = userData['passwordHash'] ?? '';
              _phoneController.text = userData['phone'] ?? '';
              _emailController.text = userData['email'] ?? '';
              _userTypeController.text = userData['userType'] ?? '';
              _imageURLController.text = userData['imageURL'] ?? '';

              if (userData['createdAt'] != null) {
                _createdAtController.text =
                    _formatTimestamp(userData['createdAt']);
              } else {
                _createdAtController.text = '';
              }

              if (userData['updatedAt'] != null) {
                _updatedAtController.text =
                    _formatTimestamp(userData['updatedAt']);
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
                        title: const Text("Thông tin"),
                        content: Column(children: [
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _userNameController,
                            decoration: const InputDecoration(
                              labelText: "Tên Người Dùng",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: "Mật khẩu",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: "Số điện thoại",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _userTypeController,
                            decoration: const InputDecoration(
                              labelText: "Phân quyền",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _imageURLController,
                            decoration: const InputDecoration(
                              labelText: "Hình đại diện",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ])),
                  ],
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Lưu",
                          style: TextStyle(
                              color: Constants.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.save,
                            color: Color.alphaBlend(
                                Constants.primaryColor, Colors.black12)),
                        onPressed: () {
                          Users user = Users(
                              userID: widget.userID,
                              userName: _userNameController.text,
                              password: _passwordController.text,
                              phone: _phoneController.text,
                              email: _emailController.text,
                              createdAt: convertStringToTimestamp(
                                  _createdAtController.text),
                              updatedAt: Timestamp.now(),
                              userType: _userTypeController.text,
                              imageURL: _imageURLController.text);
                          attemptUpdate(user);
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
