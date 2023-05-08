import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  RegisterState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnRegisterState extends RegisterState {
  UnRegisterState();
}

/// Initialized
class InRegisterState extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegisterSuccessState extends RegisterState {
  @override
  List<Object> get props => [];
}

class ErrorRegisterState extends RegisterState {
  ErrorRegisterState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
