import 'package:dio/dio.dart';
import '../../app/config/app_config.dart';
import '../interceptors/auth_interceptor.dart';

/// Client HTTP centralisé.
/// Toutes les features passent par cette instance unique.
class AppClient {
  AppClient._();
  static final AppClient _i = AppClient._();
  static AppClient get instance => _i;

  late final Dio _dio;

  Dio get dio => _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(_dio),
      LogInterceptor(
        requestBody: AppConfig.isDev,
        responseBody: AppConfig.isDev,
        error: true,
        logPrint: (obj) => debugPrint('[HTTP] $obj'),
      ),
    ]);
  }

  // ── Wrappers ─────────────────────────────────────────
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.post<T>(path, data: data, options: options);

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.put<T>(path, data: data, options: options);

  Future<Response<T>> delete<T>(
    String path, {
    Options? options,
  }) =>
      _dio.delete<T>(path, options: options);

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.patch<T>(path, data: data, options: options);
}

// ignore: avoid_print
void debugPrint(String msg) => print(msg);
