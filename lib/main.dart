import 'package:flutter/material.dart';
import 'package:member_manage_web/page/home_page.dart';

void main() {
  runApp(const MyApp());
}

final appBrightness = ValueNotifier<Brightness>(Brightness.light);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    appBrightness.value = MediaQuery.of(context).platformBrightness;
    return ValueListenableBuilder(
      valueListenable: appBrightness,
      builder: (BuildContext context, Brightness brightness, _) {
        return MaterialApp(
          title: '管理系统',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: brightness,
            ),
            useMaterial3: true,
            brightness: brightness,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
