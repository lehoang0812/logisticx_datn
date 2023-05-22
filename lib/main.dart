import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logisticx_datn/infoHandler/app_info.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'splashScreen/splash_screen.dart';

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
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        title: 'LogisticX',
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
