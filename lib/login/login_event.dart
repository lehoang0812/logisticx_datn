// import 'dart:async';
// import 'dart:developer' as developer;

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:logisticx_datn/login/index.dart';
// import 'package:meta/meta.dart';

// @immutable
// abstract class LoginEvent {
//   Stream<LoginState> applyAsync({LoginState currentState, LoginBloc bloc});
// }

// class UnLoginEvent extends LoginEvent {
//   @override
//   Stream<LoginState> applyAsync(
//       {LoginState? currentState, LoginBloc? bloc}) async* {
//     yield UnLoginState();
//   }
// }

// class LoadLoginEvent extends LoginEvent {
//   @override
//   Stream<LoginState> applyAsync(
//       {LoginState? currentState, LoginBloc? bloc}) async* {
//     try {
//       yield InLoginState();
//     } catch (_, stackTrace) {
//       developer.log('$_',
//           name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
//       yield ErrorLoginState(_.toString());
//     }
//   }
// }

// class SignInEvent extends LoginEvent {
//   final String email;
//   final String password;

//   SignInEvent(this.email, this.password);

//   @override
//   Stream<LoginState> applyAsync(
//       {LoginState? currentState, LoginBloc? bloc}) async* {
//     try {
//       yield UnLoginState();
//       await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//       final userLogin = FirebaseAuth.instance.currentUser ?? "";
//       if (userLogin != "") {
//         yield LoginSuccessState();
//       }
//     } catch (_, stackTrace) {
//       developer.log('$_',
//           name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
//       yield ErrorLoginState(_.toString());
//     }
//   }
// }
