import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:logisticx_datn/login/index.dart';
import 'package:logisticx_datn/register/index.dart';

import '../home/home_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    required RegisterBloc registerBloc,
    Key? key,
  })  : _registerBloc = registerBloc,
        super(key: key);

  final RegisterBloc _registerBloc;

  @override
  RegisterScreenState createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool _showPassword = true;
  RegisterScreenState();

  @override
  void initState() {
    super.initState();
    nameController.text = nameController.text;
    emailController.text = emailController.text;
    addressController.text = addressController.text;
    phoneController.text = phoneController.text;
    passwordController.text = passwordController.text;
    confirmPassController.text = confirmPassController.text;
    _showPassword = _showPassword;
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _roleList = ["Admin", "Người dùng", "Tài xế"];
    String _selectedRole = _roleList[1];
    return BlocConsumer<RegisterBloc, RegisterState>(
        bloc: widget._registerBloc,
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            Navigator.of(context).pushNamed(HomePage.routeName);
          }
        },
        builder: (
          BuildContext context,
          RegisterState currentState,
        ) {
          if (currentState is UnRegisterState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorRegisterState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    child: Text('Load lại'),
                    onPressed: _load,
                  ),
                ),
              ],
            ));
          }
          if (currentState is InRegisterState) {
            return Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              constraints: BoxConstraints.expand(),
              color: Colors.white,
              child: SingleChildScrollView(
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
                        style:
                            TextStyle(fontSize: 22, color: Color(0xff333333)),
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
                              child: Image(
                                  image: AssetImage('./assets/ic_user.png')),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED0D2), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
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
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Container(
                              width: 50,
                              child: Image(
                                  image: AssetImage('./assets/ic_mail.png')),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED0D2), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
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
                        onChanged: (text) => setState(() {
                          emailController.text = text;
                        }),
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
                              child: Image(
                                  image: AssetImage('./assets/ic_home.png')),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED0D2), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
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
                        onChanged: (text) => setState(() {
                          addressController.text = text;
                        }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: TextFormField(
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        controller: passwordController,
                        obscureText: _showPassword,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon: Container(
                            width: 50,
                            child: Image(
                                image: AssetImage('./assets/ic_lock.png')),
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
                              borderSide: BorderSide(
                                  color: Color(0xffCED0D2), width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Mật khẩu không được để trống";
                          }
                          if (text.length < 5) {
                            return "Vui lòng nhập mật khẩu lớn hơn 5 kí tự";
                          }
                          if (text.length > 99) {
                            return "Mật khẩu dài vui lòng nhập lại";
                          }
                          return null;
                        },
                        onChanged: (text) => setState(() {
                          passwordController.text = text;
                        }),
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      controller: confirmPassController,
                      obscureText: _showPassword,
                      decoration: InputDecoration(
                        labelText: 'Nhập lại mật khẩu',
                        prefixIcon: Container(
                          width: 50,
                          child:
                              Image(image: AssetImage('./assets/ic_lock.png')),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffCED0D2), width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return "Mật khẩu nhập lại không được để trống";
                        }
                        if (text != passwordController.text) {
                          return "Mật khẩu không khớp";
                        }
                        return null;
                      },
                      onChanged: (text) => setState(() {
                        confirmPassController.text = text;
                      }),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: IntlPhoneField(
                        controller: phoneController,
                        initialCountryCode: '84',
                        showCountryFlag: false,
                        dropdownIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.amber.shade400,
                        ),
                        decoration: InputDecoration(
                          labelText: "Số điện thoại",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCED0D2), width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                        ),
                        onChanged: (text) => setState(() {
                          phoneController.text = text.completeNumber;
                        }),
                      ),
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
                            widget._registerBloc.add(SignUpEvent(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                addressController.text.trim(),
                                phoneController.text.trim(),
                                passwordController.text.trim(),
                                _selectedRole));
                          },
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff3277D8)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
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
                              style: TextStyle(
                                  color: Color(0xff606470), fontSize: 16),
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
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void _load() {
    widget._registerBloc.add(LoadRegisterEvent());
  }
}
