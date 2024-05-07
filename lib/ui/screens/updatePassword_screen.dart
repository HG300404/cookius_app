import 'package:cookius_app/ui/screens/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdatePasswordScreen extends StatefulWidget {
  final String? verificationId;

  UpdatePasswordScreen({Key? key, this.verificationId}) : super(key: key);

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _updatePassword(BuildContext context) async {
    if (widget.verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ID xác thực không hợp lệ")),
      );
      return;
    }

    String newPassword = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mật khẩu mới không được để trống")),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mật khẩu và Mật khẩu xác nhận không khớp")),
      );
      return;
    }

    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      await user.updatePassword(newPassword).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cập nhật mật khẩu thành công")),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignIn()),);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không thể cập nhật mật khẩu: ${error.toString()}")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật mật khẩu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mật khẩu mới'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _updatePassword(context),
                child: Text('Cập nhật mật khẩu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}