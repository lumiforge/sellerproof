package com.lumiforge.sellerproof

import androidx.camera.extensions.ExtensionMode
import androidx.camera.extensions.ExtensionsManager
import android.Manifest
import android.app.Activity
import android.content.ContentValues
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import android.widget.Button
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.camera.core.Camera
import androidx.camera.core.CameraSelector
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.video.MediaStoreOutputOptions
import androidx.camera.video.Quality
import androidx.camera.video.QualitySelector
import androidx.camera.video.Recorder
import androidx.camera.video.Recording
import androidx.camera.video.VideoCapture
import androidx.camera.video.VideoRecordEvent
import androidx.camera.view.PreviewView
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class PackingCameraActivity : ComponentActivity() {

    private lateinit var viewFinder: PreviewView
    private lateinit var btnStartStop: Button

    private var camera: Camera? = null
    private var videoCapture: VideoCapture<Recorder>? = null
    private var recording: Recording? = null
    private var isRecording: Boolean = false
    private var finishAfterStop: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_packing_camera)

        viewFinder = findViewById(R.id.viewFinder)
        btnStartStop = findViewById(R.id.btnStartStop)

        btnStartStop.setOnClickListener {
            if (!isRecording) {
                startRecording()
            } else {
                stopRecording()
            }
        }

        if (allPermissionsGranted()) {
            startCamera()
        } else {
            ActivityCompat.requestPermissions(
                this,
                REQUIRED_PERMISSIONS,
                REQUEST_CODE_PERMISSIONS
            )
        }
    }

    private fun startCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)

        cameraProviderFuture.addListener({
            try {
                val cameraProvider = cameraProviderFuture.get()
                val baseSelector = CameraSelector.DEFAULT_BACK_CAMERA

                // Поднимаем ExtensionsManager
                val extensionsManagerFuture =
                    ExtensionsManager.getInstanceAsync(this, cameraProvider)

                extensionsManagerFuture.addListener({
                    try {
                        val extensionsManager = extensionsManagerFuture.get()

                        // Пытаемся включить AUTO или HDR (что доступно на девайсе)
                        val mode: Int? = when {
                            extensionsManager.isExtensionAvailable(
                                baseSelector,
                                ExtensionMode.AUTO
                            ) -> ExtensionMode.AUTO

                            extensionsManager.isExtensionAvailable(
                                baseSelector,
                                ExtensionMode.HDR
                            ) -> ExtensionMode.HDR

                            else -> null
                        }

                        // Если есть extension — берём селектор с ним, иначе обычный
                        val cameraSelector = if (mode != null) {
                            Log.d(TAG, "Using CameraX extension mode=$mode")
                            extensionsManager.getExtensionEnabledCameraSelector(
                                baseSelector,
                                mode
                            )
                        } else {
                            Log.d(TAG, "No extensions available, using base camera")
                            baseSelector
                        }

                        val preview = Preview.Builder()
                            .build()
                            .also { it.setSurfaceProvider(viewFinder.surfaceProvider) }

                        val recorder = Recorder.Builder()
                            .setQualitySelector(
                                QualitySelector.from(Quality.FHD)
                            )
                            .build()

                        videoCapture = VideoCapture.withOutput(recorder)

                        cameraProvider.unbindAll()
                        camera = cameraProvider.bindToLifecycle(
                            this,
                            cameraSelector,
                            preview,
                            videoCapture
                        )
                    } catch (e: Exception) {
                        Log.e(TAG, "Extensions / binding failed", e)
                        Toast.makeText(this, "Ошибка камеры", Toast.LENGTH_SHORT).show()
                        finish()
                    }
                }, ContextCompat.getMainExecutor(this))
            } catch (e: Exception) {
                Log.e(TAG, "Camera provider init failed", e)
                Toast.makeText(this, "Ошибка камеры", Toast.LENGTH_SHORT).show()
                finish()
            }
        }, ContextCompat.getMainExecutor(this))
    }


    private fun startRecording() {
        val videoCapture = this.videoCapture ?: run {
            Log.w(TAG, "startRecording: videoCapture is null")
            return
        }

        if (isRecording) {
            Log.w(TAG, "startRecording: already recording")
            return
        }

        val name = "packing_${System.currentTimeMillis()}.mp4"
        val contentValues = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, name)
            put(MediaStore.MediaColumns.MIME_TYPE, "video/mp4")
            put(MediaStore.Video.Media.RELATIVE_PATH, "Movies/SellerProof")
        }

        val outputOptions = MediaStoreOutputOptions
            .Builder(
                contentResolver,
                MediaStore.Video.Media.EXTERNAL_CONTENT_URI
            )
            .setContentValues(contentValues)
            .build()

        var pendingRecording =
            videoCapture.output.prepareRecording(this, outputOptions)

        if (ContextCompat.checkSelfPermission(
                this,
                Manifest.permission.RECORD_AUDIO
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            pendingRecording = pendingRecording.withAudioEnabled()
        }

        recording = pendingRecording.start(
            ContextCompat.getMainExecutor(this)
        ) { event ->
            when (event) {
                is VideoRecordEvent.Start -> {
                    Log.d(TAG, "Recording started")
                    isRecording = true
                    btnStartStop.text = "Остановить запись"
                    Toast.makeText(this, "Запись началась", Toast.LENGTH_SHORT).show()
                }

                is VideoRecordEvent.Finalize -> {
                    Log.d(TAG, "Recording finalized, hasError=${event.hasError()}")
                    isRecording = false
                    recording = null
                    btnStartStop.text = "Начать запись"

                    if (!event.hasError()) {
                        val uri = event.outputResults.outputUri
                        Log.d(TAG, "Saved to: $uri")

                        // Возвращаем путь в Flutter (как и в системной камере)
                        val resultIntent = Intent().apply {
                            putExtra("videoPath", uri.toString())
                        }
                        setResult(Activity.RESULT_OK, resultIntent)
                    } else {
                        setResult(Activity.RESULT_CANCELED)
                        Toast.makeText(
                            this,
                            "Ошибка записи видео",
                            Toast.LENGTH_SHORT
                        ).show()
                    }

                    if (finishAfterStop) {
                        finishAfterStop = false
                        finish()
                    }
                }

                else -> {
                    // Остальные события (pause/resume/status) сейчас не используем
                }
            }
        }
    }

    private fun stopRecording() {
        if (!isRecording) {
            Log.w(TAG, "stopRecording: not recording")
            return
        }
        finishAfterStop = true
        recording?.stop()
    }

    override fun onBackPressed() {
        if (isRecording) {
            // Сначала останавливаем запись, после финализации закрываем Activity
            finishAfterStop = true
            recording?.stop()
        } else {
            super.onBackPressed()
        }
    }

    private fun allPermissionsGranted(): Boolean =
        REQUIRED_PERMISSIONS.all { perm ->
            ContextCompat.checkSelfPermission(
                this,
                perm
            ) == PackageManager.PERMISSION_GRANTED
        }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_CODE_PERMISSIONS) {
            if (allPermissionsGranted()) {
                startCamera()
            } else {
                Toast.makeText(
                    this,
                    "Нет разрешений на камеру/микрофон",
                    Toast.LENGTH_SHORT
                ).show()
                finish()
            }
        }
    }

    companion object {
        private const val TAG = "PackingCameraActivity"
        private const val REQUEST_CODE_PERMISSIONS = 10

        private val REQUIRED_PERMISSIONS = arrayOf(
            Manifest.permission.CAMERA,
            Manifest.permission.RECORD_AUDIO
        )
    }
}
