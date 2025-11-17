package com.lumiforge.sellerproof

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.lumiforge.sellerproof/camera"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startCamera" -> {
                    val intent = Intent(this, PackingCameraActivity::class.java)
                    // Pass scanned code if provided
                    call.argument<String?>("scannedCode")?.let { code ->
                        intent.putExtra("scannedCode", code)
                    }
                    // Pass custom storage path if provided
                    call.argument<String?>("storagePath")?.let { path ->
                        intent.putExtra("storagePath", path)
                    }
                    startActivityForResult(intent, CAMERA_REQUEST_CODE)
                    result.success(null)
                }
                "stopCamera" -> {
                    PackingCameraActivity.requestStopRecording()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == CAMERA_REQUEST_CODE && resultCode == RESULT_OK) {
            val videoPath = data?.getStringExtra("videoPath")
            // Обработка результата
        }
    }

    companion object {
        private const val CAMERA_REQUEST_CODE = 100
    }
}
