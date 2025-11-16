package com.lumiforge.sellerproof

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.lumiforge.sellerproof/camera"
    private var cameraMethodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Создаем MethodChannel для связи с Flutter
        cameraMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, 
            CHANNEL
        )
        
        // Устанавливаем обработчик вызовов из Flutter
        cameraMethodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "startCamera" -> {
                    // Запускаем нативную активность камеры
                    val intent = Intent(this, PackingCameraActivity::class.java)
                    startActivityForResult(intent, CAMERA_REQUEST_CODE)
                    result.success(null)
                }
                "stopCamera" -> {
                    // Останавливаем запись
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
            // Здесь можете отправить результат обратно во Flutter через MethodChannel
            // если нужно обработать путь к видео
            videoPath?.let {
                cameraMethodChannel?.invokeMethod("onVideoRecorded", mapOf("path" to it))
            }
        }
    }

    companion object {
        private const val CAMERA_REQUEST_CODE = 100
    }
}
