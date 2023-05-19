import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logisticx_datn/screens/login_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 140,
                ),
                Image(
                    image: AssetImage('./assets/ic_car_red.png'),
                    fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 6),
                  child: Text(
                    'Đặt lại mật khẩu',
                    style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Vui lòng nhập email để đặt lại mật khẩu!',
                  style: TextStyle(fontSize: 20, color: Color(0xff606470)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextFormField(
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Container(
                          width: 50,
                          child:
                              Image(image: AssetImage('./assets/ic_mail.png')),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Email không được để trống";
                      }
                      if (EmailValidator.validate(text) == true) {
                        return null;
                      }
                      if (text.length < 2) {
                        return "Vui lòng nhập email hợp lệ";
                      }
                      if (text.length > 49) {
                        return "Email quá dài vui lòng nhập lại";
                      }
                      return null;
                    },
                    // onChanged: (text) => setState(() {
                    //   emailController.text = text;
                    // }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        _submit();
                      },
                      child: Text(
                        'Gửi mã',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff3277D8)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6))))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: RichText(
                      text: TextSpan(
                          text: 'Bạn đã có tài khoản? ',
                          style:
                              TextStyle(color: Color(0xff606470), fontSize: 16),
                          children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => LoginScreen())),
                            text: 'Đăng nhập',
                            style: TextStyle(
                                color: Color(0xff3277D8), fontSize: 16))
                      ])),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim(),
        );
        Fluttertoast.showToast(
          msg:
              'Liên kết đặt lại mật khẩu đã được gửi đến email của bạn, vui lòng kiểm tra email',
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
  }
}
