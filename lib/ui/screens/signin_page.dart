import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookius_app/constants.dart';
import 'package:cookius_app/ui/admin/admin_page.dart';
import 'package:cookius_app/ui/firebase_auth/firebase_auth_services.dart';
import 'package:cookius_app/ui/root_page.dart';
import 'package:cookius_app/ui/screens/forgot_password.dart';
import 'package:cookius_app/ui/screens/home_page.dart';
import 'package:cookius_app/ui/screens/signup_page.dart';
import 'package:cookius_app/ui/screens/widget/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isSigningIn = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              Image.asset('assets/images/signin.png'),
              const Text(
              'Đăng Ký',
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                obscureText: false,
                hintText: 'Nhập Email',
                icon: Icons.alternate_email,
                controller: _emailController,
              ),
              CustomTextField(
                obscureText: true,
                hintText: 'Nhập mật khẩu',
                icon: Icons.lock,
                controller: _passwordController,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const RootPage(),
                          type: PageTransitionType.bottomToTop));
                },
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child:
                  Center(
                    child: InkWell(
                      onTap: _signIn,
                      child: Center(
                        child: isSigningIn ? CircularProgressIndicator(color: Colors.white,):Text(
                          "Đăng Nhập",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const ForgotPassword(),
                          type: PageTransitionType.bottomToTop));
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Quên mật khẩu? ',
                        style: TextStyle(
                          color: Constants.blackColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Đặt lại ở đây.',
                        style: TextStyle(
                          color: Constants.primaryColor,
                        ),
                      ),
                    ]),
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
                    borderRadius: BorderRadius.circular(10)),
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: InkWell(
                  onTap: () async {
                    try {
                      UserCredential userCredential = await signInWithGoogle();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RootPage()));
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
                        'Đăng nhập với Google',
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
                          child: const SignUp(),
                          type: PageTransitionType.bottomToTop));
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Ngươời mới? ',
                        style: TextStyle(
                          color: Constants.blackColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Đăng ký',
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
    );
  }
  Future<void> _signIn() async {
    setState(() {
      isSigningIn = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter both email and password.', Colors.red);
      _resetSignIn();
      return;
    }

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userDocData = userDoc.data() as Map<String, dynamic>;
          if (userDocData['userType'] == 'admin') {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminPage()));
          } if( (userDocData['userType'] == 'client')) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (  context) => RootPage()));
          }
        } else {
          _showSnackBar('Không có dữ liệu người dùng có sẵn.', Colors.red);
         await auth.signOut();
        }
      } else {
        _showSnackBar('Đăng nhập thất bại. Vui lòng thử lại.', Colors.red);
       await auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      // Bắt lỗi Firebase đăng nhập
      String errorMessage = ''; // Khởi tạo chuỗi rỗng cho biến errorMessage
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Không tìm thấy người dùng với email đã nhập.';
          break;
        case 'wrong-password':
          errorMessage = 'Mật khẩu không đúng cho người dùng này.';
          break;
        case 'user-disabled':
          errorMessage = 'Tài khoản người dùng này đã bị vô hiệu hóa.';
          break;
        case 'too-many-requests':
          errorMessage = 'Quá nhiều yêu cầu. Vui lòng thử lại sau.';
          break;
        default:
          errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại sau.';
      }
      _showSnackBar(errorMessage, Colors.red);
    } catch (e) {
      _showSnackBar('Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.', Colors.red);
    } finally {
      _resetSignIn();
    }
  }

  void _resetSignIn() {
    setState(() {
      isSigningIn = false;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 3),
      ),
    );
  }}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
