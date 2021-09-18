import 'dart:convert';
import 'package:sma_mobile/api/auth.dart';
import 'package:sma_mobile/api/constant.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sma_mobile/models/data.dart';

final BaseOptions baseOptions = BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: 1000,
);

class AuthInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String access = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? expire = prefs.getString('expire');
    if (expire == null) {
      return super.onRequest(options, handler);
    }
    DateTime date = DateTime.parse(expire);
    DateTime now = DateTime.now();
    // 刷新token
    if (date.isBefore(now)) {
      String refresh = prefs.getString("refresh") ?? "";
      access = await ApiAuth.refreshToken(refresh);
    } else {
      access = prefs.getString('access') ?? "";
    }
    Map<String, dynamic> header = {"authorization": "Bearer $access"};
    options.headers.addAll(header);
    return super.onRequest(options, handler);
  }
}

class ApiPortfolio {
  Dio api = Dio(baseOptions);

  useInterceptors() async {
    api.interceptors.add(AuthInterceptors());
  }

  Future<List<PortfolioModel>> wholePortfolios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<PortfolioModel> ps = [];
    var response = await api.get("/v2/portfolio/");
    var d = response.data;
    d.forEach((v) {
      var p = PortfolioModel.fromJson(v);
      ps.add(p);
    });
    String portfolios = jsonEncode(ps);
    prefs.setString("whole_portfolio", portfolios);
    return ps;
  }
}
