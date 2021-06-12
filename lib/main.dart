// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/screens/home.dart';
import '../screens/splash_screen.dart';
import 'providers/auth.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),

      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _)=>MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            HomeScreen.routeName: (_) => HomeScreen(),

          },
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? SplashScreen()
                  : AuthScreen())),
      ),
    );
  }
}
