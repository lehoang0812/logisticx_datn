import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logisticx_datn/global/global.dart';
import 'package:logisticx_datn/screens/register_screen.dart';
import 'package:logisticx_datn/screens/user_home_screen.dart';

import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _showPassword = true;

  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await firebaseAuth
            .signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim())
            .then((auth) async {
          currentUser = auth.user;
          await Fluttertoast.showToast(msg: "Đăng nhập thành công");
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => UserHomeScreen()));
        });
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
            default:
              Fluttertoast.showToast(
                msg: 'Lỗi không xác định: ${error.toString()}',
                gravity: ToastGravity.BOTTOM,
              );
          }
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Vui lòng nhập đầy đủ các trường");
    }
  }

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
                    image: AssetImage('./assets/ic_car_green.png'),
                    fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 6),
                  child: Text(
                    'XIN CHÀO QUÝ KHÁCH',
                    style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Vui lòng đăng nhập để sử dụng ứng dụng!',
                  style: TextStyle(fontSize: 20, color: Color(0xff606470)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    controller: passwordController,
                    obscureText: _showPassword,
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: Container(
                        width: 50,
                        child: Image(image: AssetImage('./assets/ic_lock.png')),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                          // print('hello');
                        },
                        child: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Mật khẩu không được để trống";
                      }
                      if (text.length < 5) {
                        return "Vui lòng nhập mật khẩu lớn hơn 5 kí tự";
                      }
                      return null;
                    },
                    // onChanged: (text) => setState(() {
                    //   passwordController.text = text;
                    // }),
                  ),
                ),
                Container(
                  constraints: BoxConstraints.loose(Size(double.infinity, 30)),
                  alignment: AlignmentDirectional.centerEnd,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text('Quên mật khẩu?',
                          style: TextStyle(
                              fontSize: 16, color: Color(0xff3277D8))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      child: Text(
                        'Đăng nhập',
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
                          text: 'Bạn chưa có tài khoản? ',
                          style:
                              TextStyle(color: Color(0xff606470), fontSize: 16),
                          children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => RegisterScreen())),
                            text: 'Đăng ký',
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
}
