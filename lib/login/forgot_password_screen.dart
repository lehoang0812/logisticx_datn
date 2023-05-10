import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu ?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Vui lòng nhập email của bạn dưới đây :",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng nhập email của bạn';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: _emailController.text,
                      );
                      Fluttertoast.showToast(
                        msg:
                            'Liên kết đặt lại mật khẩu đã được gửi đến email của bạn',
                        gravity: ToastGravity.BOTTOM,
                      );
                    } catch (error) {
                      if (error is FirebaseAuthException) {
                        switch (error.code) {
                          case 'invalid-email':
                            Fluttertoast.showToast(
                              msg: 'Lỗi, email không hợp lệ!',
                              gravity: ToastGravity.BOTTOM,
                            );
                            break;
                          case 'user-not-found':
                            Fluttertoast.showToast(
                              msg: 'Lỗi, không tìm thấy người dùng!',
                              gravity: ToastGravity.BOTTOM,
                            );
                            break;
                          case 'missing-email':
                            Fluttertoast.showToast(
                              msg: 'Lỗi, bạn chưa nhập email!',
                              gravity: ToastGravity.BOTTOM,
                            );
                            break;
                          default:
                            Fluttertoast.showToast(
                              msg: 'Lỗi không xác định: ${error.toString()}',
                              gravity: ToastGravity.BOTTOM,
                            );
                        }
                      }
                    }
                  }
                },
                child: Text('Đặt lại mật khẩu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
