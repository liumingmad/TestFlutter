package com.ming.testflutter

import android.content.Context
import android.os.Build
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PlatformChannelHandler(private val context: Context) : MethodChannel.MethodCallHandler {
    
    companion object {
        private const val CHANNEL_NAME = "com.ming.testflutter/platform"
    }
    
    private var methodChannel: MethodChannel? = null
    
    fun setupChannel(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        methodChannel?.setMethodCallHandler(this)
    }
    
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDeviceInfo" -> {
                getDeviceInfo(result)
            }
            "calculateSum" -> {
                val a = call.argument<Int>("a") ?: 0
                val b = call.argument<Int>("b") ?: 0
                calculateSum(a, b, result)
            }
            "showToast" -> {
                val message = call.argument<String>("message") ?: ""
                showToast(message, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
    
    private fun getDeviceInfo(result: MethodChannel.Result) {
        val deviceInfo = mapOf(
            "model" to Build.MODEL,
            "brand" to Build.BRAND,
            "version" to Build.VERSION.RELEASE,
            "sdk" to Build.VERSION.SDK_INT
        )
        result.success(deviceInfo)
    }
    
    private fun calculateSum(a: Int, b: Int, result: MethodChannel.Result) {
        val sum = a + b
        result.success(sum)
    }
    
    private fun showToast(message: String, result: MethodChannel.Result) {
        android.widget.Toast.makeText(context, "From Kotlin: $message", android.widget.Toast.LENGTH_SHORT).show()
        result.success("Toast shown: $message")
    }
    
    // Kotlin调用Dart函数
    fun callDartFunction(functionName: String, arguments: Any? = null, callback: ((Any?) -> Unit)? = null) {
        methodChannel?.invokeMethod(functionName, arguments, object : MethodChannel.Result {
            override fun success(result: Any?) {
                callback?.invoke(result)
            }
            
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                println("Error calling Dart function: $errorCode - $errorMessage")
            }
            
            override fun notImplemented() {
                println("Dart function $functionName not implemented")
            }
        })
    }
    
    // 示例：调用Dart函数的方法
    fun requestDataFromDart() {
        callDartFunction("getData") { result ->
            println("Received from Dart: $result")
        }
    }
    
    fun sendMessageToDart(message: String) {
        val args = mapOf("message" to message, "timestamp" to System.currentTimeMillis())
        callDartFunction("receiveMessage", args) { result ->
            println("Dart processed message: $result")
        }
    }
}