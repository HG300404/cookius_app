import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/constants.dart';
import 'package:cookius_app/controller/usersController.dart';
import 'package:cookius_app/models/users.dart';
import 'package:cookius_app/ui/firebase_auth/firebase_auth_services.dart';
import 'package:cookius_app/ui/screens/home_page.dart';
import 'package:cookius_app/ui/screens/otp_screen.dart';
import 'package:cookius_app/ui/screens/signin_page.dart';
import 'package:cookius_app/ui/screens/widget/custom_textfield.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  usersController controller = usersController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isSigningUp = false;
  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final usersController _userCtrl = usersController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/signup.png'),
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                 controller: _emailController,
                obscureText: false,
                hintText: 'Nhập Email',
                icon: Icons.alternate_email,
              ),
              CustomTextField(
                controller: _nameController,
                obscureText: false,
                hintText: 'Nhập Tên',
                icon: Icons.person,
              ),
              CustomTextField(
                controller: _phoneController,
                obscureText: false,
                hintText: 'Nhập SĐT',
                icon: Icons.phone,
              ),
              CustomTextField(
                controller: _passwordController,
                obscureText: true,
                hintText: 'Nhập mật khẩu',
                icon: Icons.lock,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _signUp,
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Center(
                      child: isSigningUp ? CircularProgressIndicator(color: Colors.white,):
                      Text(
                        "Đăng Ký",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Constants.primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: InkWell(
                  onTap: () async {
                    try {
                      UserCredential userCredential = await signInWithGoogle();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                    } catch (error) {
                      print('Có lỗi khi đăng nhập với Google: $error');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 30,
                        child: Image.asset('assets/images/google.png'),
                      ),
                         Text(
                            'Đăng ký với Google',
                            style: TextStyle(
                              color: Constants.blackColor,
                              fontSize: 18.0,
                            ),
                          ),


                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const SignIn(),
                          type: PageTransitionType.bottomToTop));

                },
                child: Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Đã có tài khoản? ',
                        style: TextStyle(
                          color: Constants.blackColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Đăng nhập',
                        style: TextStyle(
                          color: Constants.primaryColor,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );;
  }
  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String name = _nameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        // Tạo một đối tượng Users để lưu trữ thông tin người dùng
        Users newUser = Users(
          userID: user.uid, // ID từ firebase Auth
          email: email,
          phone: phone,
          userType: 'client',
          userName: name,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now()
        );

        // Gọi hàm để lưu người dùng vào Firestore
        addUser(newUser);

        print("Người dùng được tạo thành công");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      }
    } catch (e) {
      print("Đã xảy ra một số lỗi: $e");
    } finally {
      setState(() {
        isSigningUp = false;
      });
    }
  }

  void addUser(Users user) async {
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

    try {
      await usersCollection.doc(user.userID).set({
        'userID': user.userID,
        'userName': user.userName,
        'email': user.email,
        'phone': user.phone,
        'userType': "client",
        'createdAt': user.createdAt,
        'updatedAt': user.updatedAt
      });
      print("Dữ liệu người dùng đã thêm vào Firestore");
    } catch (e) {
      print("Lỗi khi thêm người dùng vào Firestore: $e");
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Cancelled login
    if (googleUser == null) {
      throw Exception('Người dùng đã hủy đăng nhập bằng Google');
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      // Check if user already exists in the Firestore database
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        // If user does not exist, create a new user in the Firestore database
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'userName ': user.displayName,
          'userType': 'client',
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
        });
      }
    }

    return userCredential;

}}


