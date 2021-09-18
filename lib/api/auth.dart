import 'package:dio/dio.dart';
import 'package:sma_mobile/api/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final BaseOptions baseOptions = BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: 1000,
);
final Dio api = Dio(baseOptions);

class ApiAuth {
  // 验证证件号
  static Future<bool> checkIdentify(String identify) async {
    var response = await api.post("/sms/idcheck/", data: {"identify": identify});
    var data = response.data;
    if (data['code'] == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", data['username']);
      return true;
    }
    return false;
  }

  // 获取验证码
  static Future<String> getVerifyCode(String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString("username");
    var response = await api.get("/sms/code/", queryParameters: {"username": username, "mobile": mobile});
    var data = response.data;
    String msg = data['msg'];
    return msg;
  }

  // 验证登陆
  static Future<String> verify(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString("username");
    var response = await api.post("/sms/code/", data: {"username": username, "code": code});
    var data = response.data;
    DateTime time = DateTime.now();
    int statusCode = data['code'];
    String msg = data['msg'];
    if (statusCode != 0) {
      return msg;
    }
    time.add(const Duration(hours: 1));
    String expire = time.toString();
    String access = data['access'];
    String refresh = data['refresh'];
    prefs.setString('expire', expire);
    prefs.setString('access', access);
    prefs.setString('refresh', refresh);
    return msg;
  }

  // Token续租
  static Future<String> refreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await api.post("/token/refresh/", data: {"refresh": token});
    var data = response.data;
    DateTime time = DateTime.now();
    String access = data['access'];
    time.add(const Duration(hours: 1));
    String expire = time.toString();
    prefs.setString('expire', expire);
    prefs.setString('access', access);
    return access;
  }
}