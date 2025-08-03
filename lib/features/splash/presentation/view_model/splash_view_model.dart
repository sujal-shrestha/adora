// lib/features/splash/presentation/view_model/splash_view_model.dart

import 'dart:async';
import 'package:adora_mobile_app/app/service_locator.dart';
import 'package:adora_mobile_app/core/network/api_config.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

part 'splash_state.dart';

/// A Cubit that drives the splash screen logic.
class SplashViewModel extends Cubit<SplashState> {
  final FlutterSecureStorage _storage;

  SplashViewModel(this._storage) : super(SplashInitial());

  /// Begins the 2s timer, then checks for a saved token.
  void start() {
    emit(SplashLoading());

    Timer(const Duration(seconds: 2), () async {
      final token = await _storage.read(key: 'token');

      if (token != null && token.isNotEmpty) {
        final isValid = await _verifyToken(token);
        if (isValid) {
          emit(SplashAuthenticated());
        } else {
          emit(SplashUnauthenticated());
        }
      } else {
        emit(SplashUnauthenticated());
      }
    });
  }

  /// Hits your `/auth/me` endpoint to verify the saved token.
  Future<bool> _verifyToken(String token) async {
    try {
      final base = await ApiConfig.baseUrl;       // e.g. http://10.0.2.2:5000/api
      final uri  = Uri.parse('$base/auth/me');    // /api/auth/me

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Optional debug:
      print('🔍 VERIFY TOKEN · URL: $uri');
      print('🔍 VERIFY TOKEN · status: ${response.statusCode}');

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
