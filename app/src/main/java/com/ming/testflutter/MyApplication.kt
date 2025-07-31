package com.ming.testflutter

import android.app.Application
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MyApplication : Application() {
    lateinit var flutterEngine: FlutterEngine
    lateinit var platformChannelHandler: PlatformChannelHandler
    lateinit var eventChannelHandler: EventChannelHandler

    override fun onCreate() {
        super.onCreate()
        
        // 初始化Flutter引擎
        flutterEngine = FlutterEngine(this)
        
        // 创建平台通道处理器
        platformChannelHandler = PlatformChannelHandler(this)
        eventChannelHandler = EventChannelHandler(this)
        
        // 启动Dart Isolate
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        
        // 设置平台通道
        platformChannelHandler.setupChannel(flutterEngine)
        eventChannelHandler.setupChannel(flutterEngine)
        
        // 缓存Flutter引擎
        FlutterEngineCache
            .getInstance()
            .put("my_engine_id", flutterEngine)
    }
}