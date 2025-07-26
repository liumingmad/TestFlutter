import 'package:flutter/services.dart';

class PlatformService {
  static const MethodChannel _channel = MethodChannel('com.ming.testflutter/platform');
  
  // Dart调用Kotlin函数的方法
  
  /// 获取设备信息
  static Future<Map<String, dynamic>?> getDeviceInfo() async {
    try {
      final result = await _channel.invokeMethod('getDeviceInfo');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Failed to get device info: '${e.message}'");
      return null;
    }
  }
  
  /// 计算两个数的和
  static Future<int?> calculateSum(int a, int b) async {
    try {
      final result = await _channel.invokeMethod('calculateSum', {
        'a': a,
        'b': b,
      });
      return result as int;
    } on PlatformException catch (e) {
      print("Failed to calculate sum: '${e.message}'");
      return null;
    }
  }
  
  /// 显示Toast消息
  static Future<String?> showToast(String message) async {
    try {
      final result = await _channel.invokeMethod('showToast', {
        'message': message,
      });
      return result as String;
    } on PlatformException catch (e) {
      print("Failed to show toast: '${e.message}'");
      return null;
    }
  }
  
  // 处理来自Kotlin的调用
  static void setupMethodCallHandler() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }
  
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getData':
        return _getData();
      case 'receiveMessage':
        return _receiveMessage(call.arguments);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'Method ${call.method} not implemented',
        );
    }
  }
  
  // Kotlin调用的Dart函数
  
  /// 返回数据给Kotlin
  static Map<String, dynamic> _getData() {
    return {
      'data': 'Hello from Flutter!',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'numbers': [1, 2, 3, 4, 5],
      'user': {
        'name': 'Flutter User',
        'id': 12345,
      }
    };
  }
  
  /// 接收来自Kotlin的消息
  static String _receiveMessage(dynamic arguments) {
    if (arguments is Map) {
      final message = arguments['message'] as String?;
      final timestamp = arguments['timestamp'] as int?;
      
      print('Received message from Kotlin: $message at $timestamp');
      
      // 这里可以更新UI或执行其他操作
      _updateUI(message ?? 'No message');
      
      return 'Message received and processed: $message';
    }
    
    return 'Invalid message format';
  }
  
  /// 更新UI的回调函数
  static Function(String)? onMessageReceived;
  
  static void _updateUI(String message) {
    onMessageReceived?.call(message);
  }
}