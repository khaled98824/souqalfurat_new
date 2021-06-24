// @dart=2.9

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souqalfurat/providers/ads_provider.dart';
import 'package:souqalfurat/providers/full_provider.dart';
import 'package:souqalfurat/screens/add_new_ad.dart';
import 'package:souqalfurat/screens/home.dart';
import 'package:souqalfurat/screens/my_chats.dart';
import 'package:souqalfurat/screens/profile_screen.dart';
import 'package:souqalfurat/screens/user_ads_screen.dart';
import '../screens/splash_screen.dart';
import 'providers/auth.dart';
import 'screens/auth_screen.dart';
import 'screens/my_Ads.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: FullDataProvider()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (ctx, authValue, previousProduct) => previousProduct
            ..getData(
              authValue.token,
              authValue.userId,
              previousProduct == null ? null : previousProduct.items,
            ),
        ),

      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              HomeScreen.routeName: (_) => HomeScreen(),
              Profile.routeName: (_) => Profile(),
              MyChats.routeName: (_) => MyChats(),
              MyAds.routeName: (_) => MyAds(),
              AddNewAd.routeName: (_) => AddNewAd(context,''),
              AuthScreen.routeName: (_) => AuthScreen(),
              UserAdsScreen.routeName: (_) => UserAdsScreen(),

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
