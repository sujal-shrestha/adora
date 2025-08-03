// lib/widgets/sensor_manager.dart
import 'package:adora_mobile_app/services/close_service.dart';
import 'package:flutter/widgets.dart';
import 'package:adora_mobile_app/services/jerk_service.dart';
import 'package:get_it/get_it.dart';

class SensorManager extends StatefulWidget {
  final Widget child;
  const SensorManager({required this.child, Key? key}) : super(key: key);

  @override
  State<SensorManager> createState() => _SensorManagerState();
}

class _SensorManagerState extends State<SensorManager> with WidgetsBindingObserver {
  final _prox = GetIt.I<ProximityService>();
  final _jerk = GetIt.I<JerkService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _prox.start();
    _jerk.start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _prox.dispose();
    _jerk.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // pause sensors when backgrounded, restart when resumed:
    if (state == AppLifecycleState.paused) {
      _prox.stop();
      _jerk.stop();
    } else if (state == AppLifecycleState.resumed) {
      _prox.start();
      _jerk.start();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
