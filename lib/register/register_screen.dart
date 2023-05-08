import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  RegisterScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final _roleList = ["Admin", "Người dùng", "Tài xế"];
    String _selectedRole = _roleList[1];
    bool isPasswordObscure = true;
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
                    // Text(
                    //   'Nhanh chóng, tiện lợi, an toàn',
                    //   style: TextStyle(fontSize: 20, color: Color(0xff606470)),
                    // ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 80, 0, 20),
                      child: TextField(
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: 'Tài khoản',
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
                      ),
                    ),
                    TextField(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      controller: passwordController,
                      obscureText: isPasswordObscure,
                      decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon: Container(
                            width: 50,
                            child: Image(
                                image: AssetImage('./assets/ic_lock.png')),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: () {
                                setState(() {
                                  isPasswordObscure = !isPasswordObscure;
                                });
                              }),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCED0D2), width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)))),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: DropdownButtonFormField(
                          value: _selectedRole,
                          items: _roleList.map((e) {
                            return DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedRole = val as String;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blue,
                          ),
                          dropdownColor: Colors.blue.shade50,
                          decoration: InputDecoration(
                              labelText: "Chọn vị trí bạn muốn",
                              prefixIcon: Icon(
                                Icons.accessibility_new_rounded,
                                color: Colors.blueGrey,
                              ),
                              border: UnderlineInputBorder()),
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
                            widget._registerBloc.add(SignUpEvent(
                                emailController.text,
                                passwordController.text,
                                _selectedRole));
                          },
                          child: Text(
                            'Đăng nhập',
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
