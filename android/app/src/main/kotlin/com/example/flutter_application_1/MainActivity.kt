package com.example.flutter_application_1

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "com.example.flutter_application_1/call"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            if (call.method == "makeCall") {
                val phoneNumber = call.argument<String>("phoneNumber")?.trim().orEmpty()
                if (phoneNumber.isEmpty()) {
                    result.error("INVALID_ARGUMENT", "phoneNumber is required", null)
                    return@setMethodCallHandler
                }
                val normalized = phoneNumber.replace("\\s".toRegex(), "")
                val uri = Uri.parse("tel:$normalized")
                val intent = Intent(Intent.ACTION_DIAL, uri)
                try {
                    startActivity(intent)
                    result.success("dialer_opened")
                } catch (e: Exception) {
                    result.error("DIALER_ERROR", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
