import 'package:flutter/material.dart';
import 'package:member_manage_web/pages/home/home_page.dart';
import 'package:member_manage_web/pages/login/login_page.dart';
import 'package:member_manage_web/utils/http_util.dart';
import 'package:member_manage_web/utils/sp_util.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final future = initApp();

  initApp() async {
    await SPUtil.init();
    await HttpUtil.init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (HttpUtil.hasToken) {
            return const HomePage();
          }
          return const LoginPage();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
