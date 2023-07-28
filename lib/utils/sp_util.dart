import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  SPUtil._();

  static late SharedPreferences _prefs;

  // 初始化SharedPreferences实例
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 存储布尔值
  static Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  // 获取布尔值
  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  // 存储整数
  static Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  // 获取整数
  static int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  // 存储字符串
  static Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  // 获取字符串
  static String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  // 存储字符串列表
  static Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  // 获取字符串列表
  static List<String> getStringList(String key,
      {List<String> defaultValue = const []}) {
    return _prefs.getStringList(key) ?? defaultValue;
  }

  // 删除指定key的数据
  static Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  // 清除所有数据
  static Future<bool> clear() async {
    return _prefs.clear();
  }
}
