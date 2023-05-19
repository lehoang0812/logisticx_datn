import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logisticx_datn/global/global.dart';
import 'package:logisticx_datn/screens/user_home_screen.dart';

import '../login/login_page.dart';

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2({super.key});

  @override
  State<RegisterScreen2> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen2> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  late String _selectedRole;
  bool _showPassword = true;

  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        await firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim())
            .then((auth) async {
          currentUser = auth.user;

          if (currentUser != null) {
            Map userMap = {
              "id": currentUser!.uid,
              "name": nameController.text.trim(),
              "email": emailController.text.trim(),
              "address": addressController.text.trim(),
              "phone": phoneController.text.trim(),
              "role": _selectedRole.trim(),
            };
            DatabaseReference userRef =
                FirebaseDatabase.instance.ref().child("users");
            userRef.child(currentUser!.uid).set(userMap);
          }
          await Fluttertoast.showToast(msg: "Đăng ký thành công");
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
            case 'email-already-in-use':
              Fluttertoast.showToast(
                msg: 'Lỗi, email đã tồn tại!',
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
    final _roleList = ["Admin", "User", "Driver"];
    _selectedRole = _roleList[1];
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
                    'Đăng ký',
                    style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Vui lòng đăng ký để sử dụng ứng dụng!',
                  style: TextStyle(fontSize: 20, color: Color(0xff606470)),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: 'Tên của bạn',
                        prefixIcon: Container(
                          width: 50,
                          child:
                              Image(image: AssetImage('./assets/ic_user.png')),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Tên không được để trống";
                      }
                      if (text.length < 2) {
                        return "Vui lòng nhập tên hợp lệ";
                      }
                      if (text.length > 49) {
                        return "Tên quá dài vui lòng nhập lại";
                      }
                      return null;
                    },
                    // onChanged: (text) => setState(() {
                    //   nameController.text = text;
                    // }),
                  ),
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
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    controller: addressController,
                    decoration: InputDecoration(
                        labelText: 'Địa chỉ',
                        prefixIcon: Container(
                          width: 50,
                          child:
                              Image(image: AssetImage('./assets/ic_home.png')),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffCED0D2), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Địa chỉ không được để trống";
                      }
                      if (text.length < 2) {
                        return "Vui lòng nhập địa chỉ hợp lệ";
                      }
                      if (text.length > 99) {
                        return "Địa quá dài vui lòng nhập lại";
                      }
                      return null;
                    },
                    // onChanged: (text) => setState(() {
                    //   addressController.text = text;
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
                      if (text.length > 50) {
                        return "Mật khẩu dài vui lòng nhập lại";
                      }
                      return null;
                    },
                    // onChanged: (text) => setState(() {
                    //   passwordController.text = text;
                    // }),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    controller: confirmPassController,
                    obscureText: _showPassword,
                    decoration: InputDecoration(
                      labelText: 'Nhập lại mật khẩu',
                      prefixIcon: Container(
                        width: 50,
                        child: Image(image: AssetImage('./assets/ic_lock.png')),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Mật khẩu nhập lại không được để trống";
                      }
                      if (text != passwordController.text) {
                        return "Mật khẩu không khớp";
                      }
                      return null;
                    },
                    // onChanged: (text) => setState(() {
                    //   confirmPassController.text = text;
                    // }),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                //   child: IntlPhoneField(
                //     controller: phoneController,
                //     initialCountryCode: '84',
                //     showCountryFlag: false,
                //     dropdownIcon: Icon(
                //       Icons.arrow_drop_down,
                //       color: Colors.blue,
                //     ),
                //     decoration: InputDecoration(
                //       labelText: "Số điện thoại",
                //       border: OutlineInputBorder(
                //           borderSide:
                //               BorderSide(color: Color(0xffCED0D2), width: 1),
                //           borderRadius: BorderRadius.all(Radius.circular(6))),
                //     ),
                //     // onChanged: (text) => setState(() {
                //     //   phoneController.text = text.completeNumber;
                //     // }),
                //   ),
                // ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Container(
                      width: 50,
                      child: Image(image: AssetImage('./assets/ic_phone.png')),
                    ),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffCED0D2), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Số điện thoại không được để trống";
                    } else if (text.length != 10) {
                      return "Số điện thoại phải có đúng 10 chữ số";
                    }
                    return null;
                  },
                  // onChanged: (text) => setState(() {
                  //   confirmPassController.text = text;
                  // }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Chọn vị trí của bạn',
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value as String;
                      });
                    },
                    items: _roleList
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        _register();
                      },
                      child: Text(
                        'Đăng ký',
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
                              ..onTap = () => Navigator.of(context)
                                  .pushNamed(LoginPage.routeName),
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
}
