import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'platform_service.dart';

void main() {
  // 确保Flutter绑定已初始化
  WidgetsFlutterBinding.ensureInitialized();
  // 设置平台通道处理器
  PlatformService.setupMethodCallHandler();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _deviceInfo = 'No device info';
  String _lastMessage = 'No message received';

  @override
  void initState() {
    super.initState();
    // 设置消息接收回调
    PlatformService.onMessageReceived = (message) {
      setState(() {
        _lastMessage = message;
      });
    };
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
  void _getDeviceInfo() async {
    final info = await PlatformService.getDeviceInfo();
    setState(() {
      _deviceInfo = info?.toString() ?? 'Failed to get device info';
    });
  }
  
  void _calculateSum() async {
    final sum = await PlatformService.calculateSum(10, 25);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sum of 10 + 25 = ${sum ?? 'Error'}')),
      );
    }
  }
  
  void _showToast() async {
    final result = await PlatformService.showToast('Hello from Flutter!');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'Failed to show toast')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Counter: $_counter', 
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _incrementCounter,
                        child: const Text('Increment Counter'),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Platform Channel Demo', 
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _getDeviceInfo,
                          child: const Text('Get Device Info (Dart → Kotlin)'),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _calculateSum,
                          child: const Text('Calculate Sum (Dart → Kotlin)'),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _showToast,
                          child: const Text('Show Toast (Dart → Kotlin)'),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'Device Info:', 
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          _deviceInfo, 
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'Last Message from Kotlin:', 
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          _lastMessage, 
                          style: const TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
