import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logisticx_datn/register/index.dart';
import 'package:meta/meta.dart';

import '../global/global.dart';

@immutable
abstract class RegisterEvent {
  Stream<RegisterState> applyAsync(
      {RegisterState currentState, RegisterBloc bloc});
}

class UnRegisterEvent extends RegisterEvent {
  @override
  Stream<RegisterState> applyAsync(
      {RegisterState? currentState, RegisterBloc? bloc}) async* {
    yield UnRegisterState();
  }
}

class LoadRegisterEvent extends RegisterEvent {
  @override
  Stream<RegisterState> applyAsync(
      {RegisterState? currentState, RegisterBloc? bloc}) async* {
    try {
      yield InRegisterState();
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadRegisterEvent', error: _, stackTrace: stackTrace);
      yield ErrorRegisterState(_.toString());
    }
  }
}

class SignUpEvent extends RegisterEvent {
  final String name;
  final String email;
  final String address;
  final String phone;
  final String password;
  final String role;

  SignUpEvent(this.name, this.email, this.address, this.phone, this.password,
      this.role);

  @override
  Stream<RegisterState> applyAsync(
      {RegisterState? currentState, RegisterBloc? bloc}) async* {
    try {
      yield UnRegisterState();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((auth) async {
        currentUser = auth.user;

        if (currentUser != null) {
          Map userMap = {
            "id": currentUser!.uid,
            "name": name,
            "email": email,
            "address": address,
            "phone": phone,
            "role": role
          };
          DatabaseReference userRef =
              FirebaseDatabase.instance.ref().child("users");
          userRef.child(currentUser!.uid).set(userMap);
        }
        await Fluttertoast.showToast(msg: "Đăng ký thành công");
      });
      yield RegisterSuccessState();
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadRegisterEvent', error: _, stackTrace: stackTrace);
      yield ErrorRegisterState(_.toString());
    }
  }
}
