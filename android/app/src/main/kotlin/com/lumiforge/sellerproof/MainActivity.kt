package com.lumiforge.sellerproof

import android.app.Activity
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "packing_camera_channel"
    private val requestCodePackingCamera = 1001
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "startPackingCamera") {
                    if (pendingResult != null) {
                        result.error(
                            "ALREADY_RECORDING",
                            "Прошлый запрос ещё не завершён",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    pendingResult = result
                    openPackingCamera()
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun openPackingCamera() {
        val intent = Intent(this, PackingCameraActivity::class.java)
        startActivityForResult(intent, requestCodePackingCamera)
    }

    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?
    ) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == requestCodePackingCamera) {
            val result = pendingResult
            pendingResult = null

            if (result == null) {
                return
            }

            if (resultCode == Activity.RESULT_OK && data != null) {
                val videoPath = data.getStringExtra("videoPath")
                if (videoPath != null && videoPath.isNotEmpty()) {
                    result.success(videoPath)
                } else {
                    result.error(
                        "NO_VIDEO_PATH",
                        "PackingCameraActivity не вернула путь к видео",
                        null
                    )
                }
            } else if (resultCode == Activity.RESULT_CANCELED) {
                result.success(null)
            } else {
                result.error(
                    "UNKNOWN_RESULT",
                    "Неизвестный результат от PackingCameraActivity",
                    null
                )
            }
        }
    }
}