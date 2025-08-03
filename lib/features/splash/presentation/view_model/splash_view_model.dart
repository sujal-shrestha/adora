// lib/features/splash/presentation/view_model/splash_view_model.dart

import 'package:adora_mobile_app/app/service_locator.dart';
import 'package:adora_mobile_app/core/network/api_config.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

part 'splash_state.dart';

class SplashViewModel extends Cubit<SplashState> {
  final FlutterSecureStorage _storage;

  SplashViewModel(this._storage) : super(SplashInitial());

  Future<void> start() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 2));
    final token = await _storage.read(key: 'token');
    if (token != null && token.isNotEmpty && await _verifyToken(token)) {
      emit(SplashAuthenticated());
    } else {
      emit(SplashUnauthenticated());
    }
  }

  Future<bool> _verifyToken(String token) async {
    try {
      final base = await ApiConfig.baseUrl;
      final uri = Uri.parse('$base/auth/me');
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
