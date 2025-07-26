package com.ming.testflutter

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.ming.testflutter.ui.theme.TestFlutterTheme
import io.flutter.embedding.android.FlutterActivity

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            TestFlutterTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    Column(
                        modifier = Modifier.padding(innerPadding)
                    ) {
                        Greeting(
                            name = "Android",
                            modifier = Modifier
                        )
                        Button(
                            onClick = {
                                // 使用缓存的引擎，确保平台通道已注册
                                startActivity(
                                    FlutterActivity
                                        .withCachedEngine("my_engine_id")
                                        .build(this@MainActivity)
                                )
                            }
                        ) {
                            Text("Open Flutter Module")
                        }
                        
                        Button(
                            onClick = {
                                // 演示Kotlin调用Dart函数
                                val app = application as MyApplication
                                app.platformChannelHandler.requestDataFromDart()
                            }
                        ) {
                            Text("Call Dart Function")
                        }
                        
                        Button(
                            onClick = {
                                // 演示Kotlin发送消息给Dart
                                val app = application as MyApplication
                                app.platformChannelHandler.sendMessageToDart("Hello from Kotlin!")
                            }
                        ) {
                            Text("Send Message to Dart")
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    TestFlutterTheme {
        Greeting("Android")
    }
}