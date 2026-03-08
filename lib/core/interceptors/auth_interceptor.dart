import 'package:dio/dio.dart';
import '../../app/config/app_config.dart';
import '../../core/storage/app_storage.dart';
import '../../core/error/app_exception.dart';

/// Intercepteur Dio :
/// 1. Injecte le token Bearer sur chaque requête
/// 2. Tente un refresh automatique sur 401
/// 3. Convertit les réponses d'erreur en AppException typées
class AuthInterceptor extends Interceptor {
  final Dio _dio;

  AuthInterceptor(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = AppStorage.instance.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    options.headers['X-App-Version'] = AppConfig.appVersion;
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Tenter refresh token
      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Rejouer la requête originale avec le nouveau token
          final token = AppStorage.instance.getToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (_) {}
      // Refresh échoué → logout
      await AppStorage.instance.clearAll();
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const UnauthorizedException(),
        ),
      );
    }
    return handler.next(_mapException(err));
  }

  Future<bool> _refreshToken() async {
    final refresh = AppStorage.instance.getRefreshToken();
    if (refresh == null) return false;
    try {
      final res = await _dio.post(
        '${AppConfig.baseUrl}${AppConfig.kRefreshToken}',
        data: {'refresh_token': refresh},
      );
      final newToken = res.data['data']['access_token'] as String?;
      if (newToken == null) return false;
      await AppStorage.instance.saveToken(newToken);
      return true;
    } catch (_) {
      return false;
    }
  }

  DioException _mapException(DioException err) {
    AppException mapped;
    switch (err.response?.statusCode) {
      case 422:
        final errors = (err.response?.data['errors'] as Map?)
            ?.map((k, v) => MapEntry(k as String, List<String>.from(v as List)));
        mapped = ValidationException(errors: errors ?? {});
        break;
      case 404:
        mapped = const NotFoundException();
        break;
      case 500:
      case 502:
      case 503:
        mapped = const ServerException();
        break;
      default:
        if (err.type == DioExceptionType.connectionError ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.connectionTimeout) {
          mapped = const NetworkException();
        } else {
          mapped = AppException(
            message: err.response?.data?['message'] ?? 'Erreur inconnue',
            statusCode: err.response?.statusCode,
          );
        }
    }
    return DioException(requestOptions: err.requestOptions, error: mapped, response: err.response);
  }
}