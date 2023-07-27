import 'package:flutter/material.dart';

class AppInfo {
  factory AppInfo() => _instance;

  AppInfo._internal();

  static final AppInfo _instance = AppInfo._internal();

  final _appBrightness = ValueNotifier<Brightness>(Brightness.light);

  ValueNotifier<Brightness> get appBrightness => _appBrightness;

  void setBrightness(Brightness value) {
    _appBrightness.value = value;
  }
}
