package com.ming.testflutter

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking


class EventChannelHandler(private val context: Context): EventChannel.StreamHandler {

    companion object {
        private const val BATTERY_CHANNEL: String = "battery_level_stream"
    }

    private var job: Job? = null

    fun setupChannel(flutterEngine: FlutterEngine) {
        EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), BATTERY_CHANNEL)
            .setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, events: EventSink) {
        var value = 0
        val scope = CoroutineScope(Dispatchers.Main.immediate + SupervisorJob())
        job = scope.launch {
            flow {
                while (true) {
                    emit(value++)
                    delay(2000)
                }
            }.collect {
                println("mingtest onListen collect=${value}")
                events.success(it)
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        println("mingtest cancel")
        job?.cancel()
    }
}