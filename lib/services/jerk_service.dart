import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class JerkService {
  static final JerkService _instance = JerkService._internal();
  factory JerkService() => _instance;
  JerkService._internal();

  final StreamController<void> _JerkController = StreamController<void>.broadcast();
  Stream<void> get onJerk => _JerkController.stream;

  StreamSubscription<AccelerometerEvent>? _accelSub;
  DateTime? _lastJerk;

  /// Lowered to 1.2g so normal Jerks register
  static const double JerkThreshold = 1.2;

  /// Minimum gap between Jerk events
  static const int debounceMs = 1000;

  Future<void> start() async {
    await stop();
    _accelSub = accelerometerEvents.listen(
      (event) {
        // convert m/s² to g
        final gX = event.x / 9.8;
        final gY = event.y / 9.8;
        final gZ = event.z / 9.8;
        final gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

        debugPrint('[JerkService] x:${event.x.toStringAsFixed(1)} '
                   'y:${event.y.toStringAsFixed(1)} '
                   'z:${event.z.toStringAsFixed(1)} '
                   '→ gForce=${gForce.toStringAsFixed(3)}');

        if (gForce > JerkThreshold) {
          final now = DateTime.now();
          if (_lastJerk == null ||
              now.difference(_lastJerk!).inMilliseconds > debounceMs) {
            _lastJerk = now;
            _JerkController.add(null);
          }
        }
      },
      onError: (e) => debugPrint('[JerkService] error: $e'),
      cancelOnError: true,
    );
  }

  Future<void> stop() async {
    await _accelSub?.cancel();
    _accelSub = null;
  }

  Future<void> dispose() async {
    await stop();
    await _JerkController.close();
  }
}