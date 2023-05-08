import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logisticx_datn/register/index.dart';
import 'package:meta/meta.dart';

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
      yield UnRegisterState();
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadRegisterEvent', error: _, stackTrace: stackTrace);
      yield ErrorRegisterState(_.toString());
    }
  }
}

class SignUpEvent extends RegisterEvent {
  final String email;
  final String password;
  final String role;

  SignUpEvent(this.email, this.password, this.role);

  @override
  Stream<RegisterState> applyAsync(
      {RegisterState? currentState, RegisterBloc? bloc}) async* {
    try {
      yield UnRegisterState();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final userLogin = FirebaseAuth.instance.currentUser ?? "";
      if (userLogin != "") {
        yield RegisterSuccessState();
      }
    } catch (_, stackTrace) {
      developer.log('$_',
          name: 'LoadRegisterEvent', error: _, stackTrace: stackTrace);
      yield ErrorRegisterState(_.toString());
    }
  }
}
