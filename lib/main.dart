import 'package:flutter/material.dart';
import 'package:member_manage_web/global/app_info.dart';
import 'package:member_manage_web/pages/home/home_page.dart';
import 'package:member_manage_web/pages/login/login_page.dart';
import 'package:go_router/go_router.dart';
import 'package:member_manage_web/pages/splash/splash_page.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppInfo().setBrightness(MediaQuery.of(context).platformBrightness);
    return ValueListenableBuilder(
      valueListenable: AppInfo().appBrightness,
      builder: (BuildContext context, Brightness brightness, _) {
        return MaterialApp.router(
          title: '会员管理',
          routerConfig: _router,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: brightness,
            ),
            useMaterial3: true,
            brightness: brightness,
          ),
        );
      },
    );
  }
}
