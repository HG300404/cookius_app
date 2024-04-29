import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/constants.dart';
import 'package:cookius_app/controller/usersController.dart';
import 'package:cookius_app/ui/widget/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String id = "a2FfD1F2q5YZeOxHHgWB";

  usersController controller = usersController();

  // Tạo controller cho TextFormField
  var _userNameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _imageURLController = "";
  var _userTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              Map<String, dynamic> userData =
                  snapshot.data!.data() as Map<String, dynamic>;
              _userNameController.text = userData['userName'] ??
                  ''; // gán giá trị cho thuộc tính `text`
              _passwordController.text = userData['passwordHash'] ?? '';
              _phoneController.text = userData['phone'] ?? '';
              _emailController.text = userData['email'] ?? '';
              _userTypeController.text = userData['userType'] ?? '';
              _imageURLController = userData['imageURL'] ?? '';
            } else {
              return const Center(
                child: Text("Không có dữ liệu",
                    style: TextStyle(
                        color: Color(0xff296e48),
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              );
            }
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                height: ScreenUtil().screenHeight,
                width: ScreenUtil().screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      child: const CircleAvatar(
                        radius: 60,
                        //        backgroundImage: ExactAssetImage(_imageURLController) ,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Constants.primaryColor.withOpacity(.5),
                          width: 5.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: ScreenUtil().screenWidth * 0.8 * .3,
                      child: Row(
                        children: [
                          Text(
                            'John Doe',
                            style: TextStyle(
                              color: Constants.blackColor,
                              fontSize: 20,
                            ),
                          ),
                          // SizedBox(
                          //     height: 24,
                          //     child: Image.asset("assets/images/verified.png")),
                        ],
                      ),
                    ),
                    Text(
                      'johndoe@gmail.com',
                      style: TextStyle(
                        color: Constants.blackColor.withOpacity(.3),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: ScreenUtil().screenHeight * .7,
                      width: ScreenUtil().screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          ProfileWidget(
                            icon: Icons.person,
                            title: 'My Profile',
                          ),
                          ProfileWidget(
                            icon: Icons.settings,
                            title: 'Settings',
                          ),
                          ProfileWidget(
                            icon: Icons.notifications,
                            title: 'Notifications',
                          ),
                          ProfileWidget(
                            icon: Icons.chat,
                            title: 'FAQs',
                          ),
                          ProfileWidget(
                            icon: Icons.share,
                            title: 'Share',
                          ),
                          ProfileWidget(
                            icon: Icons.logout,
                            title: 'Log Out',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
