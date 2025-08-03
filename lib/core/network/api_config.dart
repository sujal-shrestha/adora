// lib/core/network/api_config.dart

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class ApiConfig {
  ApiConfig._();

  static String? _baseUrl;

  /// Your Mac’s LAN address when running on a physical device:
  static const _physicalDeviceBase = 'http://192.168.1.69:5050/api';

  /// Android emulator:
  static const _androidEmulatorBase = 'http://10.0.2.2:5050/api';

  /// iOS simulator:
  static const _iosSimulatorBase   = 'http://localhost:5050/api';

  /// Web / desktop:
  static const _webDesktopBase     = 'http://192.168.1.69:5050/api';

  /// Call this once; picks the right base for your environment.
  static Future<String> get baseUrl async {
    if (_baseUrl != null) return _baseUrl!;

    final info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      _baseUrl = android.isPhysicalDevice
          ? _physicalDeviceBase
          : _androidEmulatorBase;
    } else if (Platform.isIOS) {
      final ios = await info.iosInfo;
      _baseUrl = ios.isPhysicalDevice
          ? _physicalDeviceBase
          : _iosSimulatorBase;
    } else {
      _baseUrl = _webDesktopBase;
    }
    return _baseUrl!;
  }

  /// Helper to build full endpoint URLs.
  static Future<String> _endpoint(String path) async =>
      '${await baseUrl}$path';

  // ─── Endpoint getters ────────────────────────────────────────────

  /// Authentication
  static Future<String> get login      => _endpoint('/auth/login');
  static Future<String> get register   => _endpoint('/auth/register');
  static Future<String> get getProfile => _endpoint('/auth/me');
  static Future<String> get changePass => _endpoint('/auth/me/password');

  /// Ads
  static Future<String> get generateAd => _endpoint('/ads/generate');
  static Future<String> get myAds      => _endpoint('/ads/my');

  /// News
  static Future<String> get fetchNews  => _endpoint('/news');

  /// Utility
  static Future<String> get healthCheck => _endpoint('/health');
}
