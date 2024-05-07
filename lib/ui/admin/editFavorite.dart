import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/constants.dart';
import 'package:cookius_app/controller/favoritesController.dart';
import 'package:cookius_app/models/favorite.dart';
import 'package:cookius_app/ui/admin/favorite_admin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditFavorites extends StatefulWidget {
  final String favoriteId;

  const EditFavorites({Key? key, required this.favoriteId}) : super(key: key);

  @override
  State<EditFavorites> createState() => _EditFavoritesState();
}

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  DateFormat formatter =
  DateFormat('MMMM d, yyyy at h:mm:ss a');
  return formatter.format(dateTime);
}

class _EditFavoritesState extends State<EditFavorites> {
  FavoritesController controller = FavoritesController();

  void attemptUpdate(Favorite favorite) async {
    bool updateResult = await controller.updateFavorite(favorite, widget.favoriteId);
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
          builder: (context) => FavoriteAdmin(),
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

  var _dishController = TextEditingController();
  var _userController = TextEditingController();
  var _createdAtController = TextEditingController();

  var _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "CHỈNH SỬA MỤC YÊU THÍCH",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Constants.primaryColor,
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: controller.getFavoriteById(widget.favoriteId),
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
              Map<String, dynamic> favoriteData =
              snapshot.data!.data() as Map<String, dynamic>;
              _dishController.text =
                  favoriteData['dishId'] ?? '';
              _userController.text = favoriteData['userId'] ?? '';

              _createdAtController.text =
                  formatTimestamp(favoriteData['createdAt']);
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
                        title: const Text("Thông tin mục yêu thích"),
                        content: Column(children: [
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _dishController,
                            decoration: const InputDecoration(
                              labelText: "Mã Món Ăn",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: _userController,
                            decoration: const InputDecoration(
                              labelText: "Mã Người Dùng",
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
                          Favorite favorite = Favorite(
                              favoriteID: widget.favoriteId,
                              dishID: _dishController.text,
                              userID: _userController.text,
                          );

                          attemptUpdate(favorite);
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