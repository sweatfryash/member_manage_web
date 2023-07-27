import 'package:member_manage_web/utils/http_util.dart';

class UserAPI {
  const UserAPI._();

  static const String _api = '/user';

  static Future login(String username, String password) {
    return HttpUtil.fetch(
      FetchType.post,
      url: '$_api/login',
      body: <String, dynamic>{'username': username, 'password': password},
      dataConverter: (dynamic data) => data,
    );
  }
}
