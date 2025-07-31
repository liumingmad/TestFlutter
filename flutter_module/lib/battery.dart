import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryService {
  static const EventChannel _batteryChannel = EventChannel('battery_level_stream');
  
  Stream<int> get batteryLevelStream {
    return _batteryChannel.receiveBroadcastStream().map((dynamic event) => event as int);
  }
}

// 在Widget中使用
class BatteryWidget extends StatefulWidget {
  @override
  _BatteryWidgetState createState() => _BatteryWidgetState();
}

class _BatteryWidgetState extends State<BatteryWidget> {
  int _batteryLevel = 0;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = BatteryService().batteryLevelStream.listen((level) {
      setState(() {
        _batteryLevel = level;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('电池电量: $_batteryLevel%');
  }
}