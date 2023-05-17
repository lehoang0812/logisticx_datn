import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'home/home_bloc.dart';
import 'home/home_page.dart';
import 'home/home_state.dart';
import 'login/login_bloc.dart';
import 'login/login_page.dart';
import 'login/login_state.dart';
import 'register/register_bloc.dart';
import 'register/register_page.dart';
import 'register/register_state.dart';

Future main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc(InLoginState())),
        BlocProvider<HomeBloc>(create: (context) => HomeBloc(InHomeState())),
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(InRegisterState()),
        )
      ],
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "LogisticX",
          initialRoute: '/',
          onGenerateRoute: onGenerateRoute,
        );
      }),
    );
  }
}

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
    case HomePage.routeName:
      return MaterialPageRoute(
        builder: (context) => HomePage(),
      );
    case RegisterPage.routeName:
      return MaterialPageRoute(
        builder: (context) => RegisterPage(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
  }
}
