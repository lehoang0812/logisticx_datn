import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logisticx_datn/login/index.dart';
import 'package:logisticx_datn/register/index.dart';

import '../home/home_page.dart';
import '../register/register_page.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    required LoginBloc loginBloc,
    Key? key,
  })  : _loginBloc = loginBloc,
        super(key: key);

  final LoginBloc _loginBloc;

  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;
  LoginScreenState();

  @override
  void initState() {
    super.initState();
    emailController.text = emailController.text;
    passwordController.text = passwordController.text;
    _showPassword = _showPassword;
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        bloc: widget._loginBloc,
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Navigator.of(context).pushNamed(HomePage.routeName);
          }
        },
        builder: (
          BuildContext context,
          LoginState currentState,
        ) {
          if (currentState is UnLoginState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (currentState is ErrorLoginState) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(currentState.errorMessage),
                Padding(
                  padding: EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    child: Text("Load lại"),
                    onPressed: _load,
                  ),
                ),
              ],
            ));
          }
          if (currentState is InLoginState) {
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
                        image: AssetImage('./assets/ic_car_green.png'),
                        fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 6),
                      child: Text(
                        'XIN CHÀO QUÝ KHÁCH !!',
                        style:
                            TextStyle(fontSize: 22, color: Color(0xff333333)),
                      ),
                    ),
                    Text(
                      'Vui lòng đăng nhập để sử dụng ứng dụng',
                      style: TextStyle(fontSize: 20, color: Color(0xff606470)),
                    ),
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
                                  BorderRadius.all(Radius.circular(6)))),
                      obscureText: !_showPassword,
                    ),
                    Container(
                      constraints:
                          BoxConstraints.loose(Size(double.infinity, 30)),
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        'Quên mật khẩu?',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff606470)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            widget._loginBloc.add(SignInEvent(
                                emailController.text, passwordController.text));
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
                              text: 'Bạn chưa có tài khoản? ',
                              style: TextStyle(
                                  color: Color(0xff606470), fontSize: 16),
                              children: <TextSpan>[
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pushNamed(
                                      context, RegisterPage.routeName),
                                text: 'Đăng ký',
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
    widget._loginBloc.add(LoadLoginEvent());
  }
}
