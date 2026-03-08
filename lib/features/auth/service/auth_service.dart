import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../app/config/app_config.dart';
import '../../../core/network/app_client.dart';
import '../../../core/storage/app_storage.dart';
import '../../../core/error/app_exception.dart';
import '../model/user_model.dart';

class AuthService {
  final _client  = AppClient.instance;
  final _storage = AppStorage.instance;

  Future<UserModel> login({required String email, required String password}) async {
    try {
      final res  = await _client.post(AppConfig.login, data: {'email': email, 'password': password});
      final data = res.data['data'];
      await _storage.saveToken(data['access_token'] as String);
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      await _storage.saveUserJson(jsonEncode(user.toJson()));
      return user;
    } on DioException catch (e) {
      throw e.error as AppException? ?? AppException(message: 'Erreur de connexion');
    }
  }

  // Register simplifié : email + password uniquement
  Future<void> register({required String email, required String password}) async {
    try {
      await _client.post(AppConfig.register, data: {
        'email': email,
        'password': password,
        'password_confirmation': password,
      });
    } on DioException catch (e) {
      throw e.error as AppException? ?? AppException(message: 'Erreur d\'inscription');
    }
  }

  Future<UserModel> verifyOtp({required String email, required String code}) async {
    try {
      final res  = await _client.post(AppConfig.otpVerify, data: {'email': email, 'code': code});
      final data = res.data['data'];
      await _storage.saveToken(data['access_token'] as String);
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      await _storage.saveUserJson(jsonEncode(user.toJson()));
      return user;
    } on DioException catch (e) {
      throw e.error as AppException? ?? AppException(message: 'Code invalide');
    }
  }

  Future<void> resendOtp(String email) async {
    try { await _client.post(AppConfig.otpResend, data: {'email': email}); }
    on DioException catch (e) { throw e.error as AppException? ?? AppException(message: 'Échec renvoi'); }
  }

  Future<void> forgotPassword(String email) async {
    try { await _client.post(AppConfig.forgotPwd, data: {'email': email}); }
    on DioException catch (e) { throw e.error as AppException? ?? AppException(message: 'Erreur'); }
  }

  Future<void> resetPassword({required String email, required String code, required String password}) async {
    try {
      await _client.post(AppConfig.resetPwd, data: {
        'email': email, 'code': code,
        'password': password, 'password_confirmation': password,
      });
    } on DioException catch (e) { throw e.error as AppException? ?? AppException(message: 'Erreur'); }
  }

  Future<void> logout() async {
    try { await _client.post(AppConfig.logout); } catch (_) {}
    await _storage.clearAll();
  }

  UserModel? get cachedUser {
    final json = _storage.userJson;
    if (json == null) return null;
    try { return UserModel.fromJson(jsonDecode(json) as Map<String, dynamic>); }
    catch (_) { return null; }
  }
}