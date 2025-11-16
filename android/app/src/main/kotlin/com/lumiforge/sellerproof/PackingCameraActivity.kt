package com.lumiforge.sellerproof

import android.Manifest
import android.app.Activity
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.hardware.camera2.*
import android.media.MediaRecorder
import android.os.Bundle
import android.os.Handler
import android.os.HandlerThread
import android.os.Looper
import android.provider.MediaStore
import android.util.Log
import android.util.Range
import android.view.Surface
import android.view.TextureView
import android.widget.Button
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class PackingCameraActivity : ComponentActivity() {

    private lateinit var textureView: TextureView
    private lateinit var btnStartStop: Button

    private var cameraDevice: CameraDevice? = null
    private var captureSession: CameraCaptureSession? = null
    private var previewRequestBuilder: CaptureRequest.Builder? = null
    private var mediaRecorder: MediaRecorder? = null
    private var isRecording: Boolean = false
    private var finishAfterStop: Boolean = false
    private var currentVideoFile: File? = null
    private var cameraManager: CameraManager? = null
    private var cameraId: String? = null
    private var backgroundHandler: Handler? = null
    private var backgroundThread: HandlerThread? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_packing_camera)

        textureView = findViewById(R.id.viewFinder)
        btnStartStop = findViewById(R.id.btnStartStop)
        
        cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager

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
        try {
            cameraId = cameraManager?.cameraIdList?.find { id ->
                val characteristics = cameraManager?.getCameraCharacteristics(id)
                characteristics?.get(CameraCharacteristics.LENS_FACING) == CameraCharacteristics.LENS_FACING_BACK
            }
            
            if (cameraId == null) {
                Toast.makeText(this, "Не найдена задняя камера", Toast.LENGTH_SHORT).show()
                finish()
                return
            }
            
            startBackgroundThread()
            if (textureView.isAvailable) {
                openCamera()
            } else {
                textureView.surfaceTextureListener = textureListener
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start camera", e)
            Toast.makeText(this, "Ошибка камеры", Toast.LENGTH_SHORT).show()
            finish()
        }
    }
    
    private val textureListener = object : TextureView.SurfaceTextureListener {
        override fun onSurfaceTextureAvailable(surface: android.graphics.SurfaceTexture, width: Int, height: Int) {
            openCamera()
        }

        override fun onSurfaceTextureSizeChanged(surface: android.graphics.SurfaceTexture, width: Int, height: Int) {}

        override fun onSurfaceTextureDestroyed(surface: android.graphics.SurfaceTexture): Boolean {
            return true
        }

        override fun onSurfaceTextureUpdated(surface: android.graphics.SurfaceTexture) {}
    }
    
    private fun openCamera() {
        try {
            cameraId?.let { id ->
                cameraManager?.openCamera(id, stateCallback, backgroundHandler)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Cannot open camera", e)
            Toast.makeText(this, "Ошибка открытия камеры", Toast.LENGTH_SHORT).show()
        }
    }
    
    private val stateCallback = object : CameraDevice.StateCallback() {
        override fun onOpened(camera: CameraDevice) {
            cameraDevice = camera
            backgroundHandler?.post {
                createCameraPreviewSession()
            }
        }

        override fun onDisconnected(camera: CameraDevice) {
            camera.close()
            cameraDevice = null
        }

        override fun onError(camera: CameraDevice, error: Int) {
            camera.close()
            cameraDevice = null
            Toast.makeText(this@PackingCameraActivity, "Ошибка камеры", Toast.LENGTH_SHORT).show()
            finish()
        }
    }
    
    private fun createCameraPreviewSession() {
        try {
            val texture = textureView.surfaceTexture ?: return
            
            // Get camera characteristics to determine supported sizes
            val characteristics = cameraManager?.getCameraCharacteristics(cameraId!!)
            val map = characteristics?.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
            val sizes = map?.getOutputSizes(android.graphics.SurfaceTexture::class.java)
            
            // Choose a suitable preview size (prefer smaller sizes for preview)
            val previewSize = sizes?.let { sizeArray ->
                sizeArray.firstOrNull { size ->
                    size.width <= 1920 && size.height <= 1080
                } ?: sizeArray.first()
            } ?: sizes?.first()
            
            // Set buffer size with supported dimensions
            previewSize?.let {
                texture.setDefaultBufferSize(it.width, it.height)
            } ?: run {
                texture.setDefaultBufferSize(1280, 720) // Fallback to 720p
            }
            
            val surface = Surface(texture)
            
            // Try different templates in order of preference
            previewRequestBuilder = try {
                cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW)
            } catch (e: Exception) {
                Log.w(TAG, "TEMPLATE_PREVIEW not supported, trying TEMPLATE_RECORD", e)
                try {
                    cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_RECORD)
                } catch (e2: Exception) {
                    Log.w(TAG, "TEMPLATE_RECORD not supported, trying TEMPLATE_STILL_CAPTURE", e2)
                    try {
                        cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_STILL_CAPTURE)
                    } catch (e3: Exception) {
                        Log.w(TAG, "TEMPLATE_STILL_CAPTURE not supported, trying TEMPLATE_VIDEO_SNAPSHOT", e3)
                        try {
                            cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_VIDEO_SNAPSHOT)
                        } catch (e4: Exception) {
                            Log.e(TAG, "All templates failed, using TEMPLATE_MANUAL as last resort", e4)
                            cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_MANUAL)
                        }
                    }
                }
            }
            previewRequestBuilder?.addTarget(surface)
            
            // Create capture session with proper surface configuration
            cameraDevice?.createCaptureSession(
                listOf(surface),
                object : CameraCaptureSession.StateCallback() {
                    override fun onConfigured(session: CameraCaptureSession) {
                        captureSession = session
                        try {
                            previewRequestBuilder?.let { builder ->
                                builder.set(CaptureRequest.CONTROL_AF_MODE, CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_PICTURE)
                                session.setRepeatingRequest(builder.build(), null, backgroundHandler)
                            }
                            
                            // Configure additional settings after preview is started
                            backgroundHandler?.post {
                                configureCameraSettings()
                            }
                        } catch (e: CameraAccessException) {
                            Log.e(TAG, "Failed to start preview", e)
                        }
                    }

                    override fun onConfigureFailed(session: CameraCaptureSession) {
                        Log.e(TAG, "Camera configuration failed")
                        Toast.makeText(this@PackingCameraActivity, "Ошибка конфигурации камеры", Toast.LENGTH_SHORT).show()
                    }
                },
                backgroundHandler
            )
        } catch (e: CameraAccessException) {
            Log.e(TAG, "Camera access exception in preview session", e)
            // Try to recover by reopening camera
            cameraDevice?.close()
            cameraDevice = null
            backgroundHandler?.postDelayed({
                openCamera()
            }, 1000) // Wait 1 second before retrying
        } catch (e: Exception) {
            Log.e(TAG, "Failed to create preview session", e)
        }
    }

 


    private fun startRecording() {
        if (isRecording) {
            Log.w(TAG, "startRecording: already recording")
            return
        }

        try {
            mediaRecorder = MediaRecorder()
            val cameraId = this.cameraId ?: return
            val characteristics = cameraManager?.getCameraCharacteristics(cameraId)
            val map = characteristics?.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
            val videoSizes = map?.getOutputSizes(MediaRecorder::class.java)
            
            // Choose a suitable video size
            val videoSize = videoSizes?.let { sizeArray ->
                sizeArray.firstOrNull { size ->
                    size.width <= 1920 && size.height <= 1080
                } ?: sizeArray.firstOrNull { size ->
                    size.width <= 1280 && size.height <= 720
                } ?: sizeArray.first()
            } ?: videoSizes?.first()
            
            currentVideoFile = getOutputMediaFile()
            mediaRecorder?.apply {
                setAudioSource(MediaRecorder.AudioSource.MIC)
                setVideoSource(MediaRecorder.VideoSource.SURFACE)
                setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
                setOutputFile(currentVideoFile!!.absolutePath)
                setVideoEncodingBitRate(12000000)
                setVideoFrameRate(30)
                videoSize?.let {
                    setVideoSize(it.width, it.height)
                } ?: run {
                    setVideoSize(1280, 720) // Fallback to 720p
                }
                setVideoEncoder(MediaRecorder.VideoEncoder.H264)
                setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
                setAudioEncodingBitRate(128000)
                setAudioSamplingRate(44100)
                prepare()
            }
            
            val texture = textureView.surfaceTexture!!
            videoSize?.let {
                texture.setDefaultBufferSize(it.width, it.height)
            } ?: run {
                texture.setDefaultBufferSize(1280, 720) // Fallback to 720p
            }
            val previewSurface = Surface(texture)
            val recorderSurface = mediaRecorder?.surface
            
            if (recorderSurface == null) {
                Log.e(TAG, "Recorder surface is null")
                Toast.makeText(this, "Ошибка записи видео", Toast.LENGTH_SHORT).show()
                return
            }
            
            cameraDevice?.createCaptureSession(
                listOf(previewSurface, recorderSurface),
                object : CameraCaptureSession.StateCallback() {
                    override fun onConfigured(session: CameraCaptureSession) {
                        captureSession = session
                        
                        try {
                            // Try different templates in order of preference for recording
                            val previewRequestBuilder = try {
                                cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_RECORD)
                            } catch (e: Exception) {
                                Log.w(TAG, "TEMPLATE_RECORD not supported, trying TEMPLATE_PREVIEW", e)
                                try {
                                    cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW)
                                } catch (e2: Exception) {
                                    Log.w(TAG, "TEMPLATE_PREVIEW not supported, trying TEMPLATE_STILL_CAPTURE", e2)
                                    try {
                                        cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_STILL_CAPTURE)
                                    } catch (e3: Exception) {
                                        Log.w(TAG, "TEMPLATE_STILL_CAPTURE not supported, trying TEMPLATE_VIDEO_SNAPSHOT", e3)
                                        try {
                                            cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_VIDEO_SNAPSHOT)
                                        } catch (e4: Exception) {
                                            Log.e(TAG, "All templates failed, using TEMPLATE_MANUAL as last resort", e4)
                                            cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_MANUAL)
                                        }
                                    }
                                }
                            }
                            previewRequestBuilder?.addTarget(previewSurface)
                            previewRequestBuilder?.addTarget(recorderSurface)
                            
                            configureRecordingSettings(previewRequestBuilder)
                            
                            session.setRepeatingRequest(previewRequestBuilder!!.build(), null, backgroundHandler)
                            
                            mediaRecorder?.start()
                            isRecording = true
                            btnStartStop.text = "Остановить запись"
                            Toast.makeText(this@PackingCameraActivity, "Запись началась", Toast.LENGTH_SHORT).show()
                            
                        } catch (e: CameraAccessException) {
                            Log.e(TAG, "Camera access exception when starting recording", e)
                            // Try to recover by reopening camera
                            cameraDevice?.close()
                            cameraDevice = null
                            backgroundHandler?.postDelayed({
                                openCamera()
                            }, 1000) // Wait 1 second before retrying
                            Toast.makeText(this@PackingCameraActivity, "Ошибка доступа к камере", Toast.LENGTH_SHORT).show()
                        } catch (e: Exception) {
                            Log.e(TAG, "Failed to start recording", e)
                            Toast.makeText(this@PackingCameraActivity, "Ошибка запуска записи", Toast.LENGTH_SHORT).show()
                        }
                    }

                    override fun onConfigureFailed(session: CameraCaptureSession) {
                        Log.e(TAG, "Recording session configuration failed")
                        Toast.makeText(this@PackingCameraActivity, "Ошибка конфигурации записи", Toast.LENGTH_SHORT).show()
                    }
                },
                backgroundHandler
            )
            
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start recording", e)
            Toast.makeText(this, "Ошибка записи видео", Toast.LENGTH_SHORT).show()
        }
    }
    
    private fun configureCameraSettings() {
        try {
            val captureRequestBuilder = this.previewRequestBuilder ?: return
            val cameraId = this.cameraId ?: return
            val characteristics = cameraManager?.getCameraCharacteristics(cameraId)
            
            // Для PREVIEW - используем ОБЫЧНУЮ автоматику БЕЗ компенсации
            captureRequestBuilder.set(CaptureRequest.CONTROL_MODE, CaptureRequest.CONTROL_MODE_AUTO)
            captureRequestBuilder.set(CaptureRequest.CONTROL_AE_MODE, CaptureRequest.CONTROL_AE_MODE_ON)
            
            // НЕ УСТАНАВЛИВАЕМ компенсацию экспозиции для preview!
            // Или устанавливаем минимальную
            val exposureRange = characteristics?.get(CameraCharacteristics.CONTROL_AE_COMPENSATION_RANGE)
            if (exposureRange != null) {
                // Используем 0 или минимальную компенсацию для preview
                captureRequestBuilder.set(CaptureRequest.CONTROL_AE_EXPOSURE_COMPENSATION, 0)
                Log.d(TAG, "Preview: exposure compensation = 0 (range: ${exposureRange.lower}..${exposureRange.upper})")
            }
            
            // FPS для preview - можно оставить 30
            val fpsRanges = characteristics?.get(CameraCharacteristics.CONTROL_AE_AVAILABLE_TARGET_FPS_RANGES)
            if (fpsRanges != null) {
                val targetRange = fpsRanges.find { it.lower == 30 && it.upper == 30 }
                    ?: fpsRanges.find { it.upper == 30 }
                    ?: fpsRanges.lastOrNull()
                targetRange?.let {
                    captureRequestBuilder.set(CaptureRequest.CONTROL_AE_TARGET_FPS_RANGE, it)
                    Log.d(TAG, "Preview: FPS range: ${it.lower}-${it.upper}")
                }
            }
            
            // Автофокус для preview
            captureRequestBuilder.set(CaptureRequest.CONTROL_AF_MODE, CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_VIDEO)
            
            // Применяем настройки
            captureSession?.let { session ->
                try {
                    session.setRepeatingRequest(captureRequestBuilder.build(), null, backgroundHandler)
                    Log.d(TAG, "Preview settings applied (no exposure boost)")
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to update preview settings", e)
                }
            }
            
        } catch (e: Exception) {
            Log.e(TAG, "Failed to configure camera settings", e)
        }
    }


    private fun configureRecordingSettings(captureRequestBuilder: CaptureRequest.Builder?) {
        try {
            val builder = captureRequestBuilder ?: return
            val cameraId = this.cameraId ?: return
            val characteristics = cameraManager?.getCameraCharacteristics(cameraId)
            
            // Для RECORDING - МАКСИМАЛЬНАЯ яркость
            builder.set(CaptureRequest.CONTROL_MODE, CaptureRequest.CONTROL_MODE_AUTO)
            builder.set(CaptureRequest.CONTROL_AE_MODE, CaptureRequest.CONTROL_AE_MODE_ON)
            
            // МАКСИМАЛЬНАЯ компенсация для записи
            val exposureRange = characteristics?.get(CameraCharacteristics.CONTROL_AE_COMPENSATION_RANGE)
            if (exposureRange != null && exposureRange.upper > 0) {
                val compensation = exposureRange.upper // МАКСИМУМ
                builder.set(CaptureRequest.CONTROL_AE_EXPOSURE_COMPENSATION, compensation)
                Log.d(TAG, "Recording: MAX exposure compensation = $compensation")
            }

            
            // Для записи - используем гибкий FPS диапазон
            val fpsRanges = characteristics?.get(CameraCharacteristics.CONTROL_AE_AVAILABLE_TARGET_FPS_RANGES)
            Log.d(TAG, "Available FPS ranges:")
            fpsRanges?.forEach { range ->
                Log.d(TAG, "  - ${range.lower} to ${range.upper}")
            }

            if (fpsRanges != null) {
                // Ищем диапазон с нижней границей 15-20 и верхней 30
                val targetRange = fpsRanges.find { it.lower >= 15 && it.lower <= 20 && it.upper == 30 }
                    ?: fpsRanges.find { it.upper == 30 }
                    ?: fpsRanges.lastOrNull()
                targetRange?.let {
                    builder.set(CaptureRequest.CONTROL_AE_TARGET_FPS_RANGE, it)
                    Log.d(TAG, "Recording: FPS range: ${it.lower}-${it.upper}")
                }
            }
            
            // Автофокус для видео
            builder.set(CaptureRequest.CONTROL_AF_MODE, CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_VIDEO)
            
            // Отключаем scene mode
            builder.set(CaptureRequest.CONTROL_SCENE_MODE, CaptureRequest.CONTROL_SCENE_MODE_DISABLED)
            
            // Включаем видео стабилизацию
            val availableVideoStabilization = characteristics?.get(CameraCharacteristics.CONTROL_AVAILABLE_VIDEO_STABILIZATION_MODES)
            if (availableVideoStabilization != null && availableVideoStabilization.contains(CaptureRequest.CONTROL_VIDEO_STABILIZATION_MODE_ON)) {
                builder.set(CaptureRequest.CONTROL_VIDEO_STABILIZATION_MODE, CaptureRequest.CONTROL_VIDEO_STABILIZATION_MODE_ON)
            }
            
            Log.d(TAG, "Recording settings configured with MAX brightness")
            
        } catch (e: Exception) {
            Log.e(TAG, "Failed to configure recording settings", e)
        }
    }

    
    private fun getOutputMediaFile(): File {
        val mediaStorageDir = File(getExternalFilesDir(null), "Movies/SellerProof")
        if (!mediaStorageDir.exists()) {
            mediaStorageDir.mkdirs()
        }
        return File(mediaStorageDir, "packing_${System.currentTimeMillis()}.mp4")
    }

    private fun stopRecording() {
        if (!isRecording) {
            Log.w(TAG, "stopRecording: not recording")
            return
        }
        
        try {
            finishAfterStop = true
            mediaRecorder?.stop()
            mediaRecorder?.release()
            mediaRecorder = null
            isRecording = false
            btnStartStop.text = "Начать запись"
            
            // Use the stored video file path
            currentVideoFile?.let { videoFile ->
                val resultIntent = Intent().apply {
                    putExtra("videoPath", videoFile.absolutePath)
                }
                setResult(Activity.RESULT_OK, resultIntent)
            } ?: run {
                Log.e(TAG, "Video file is null")
                setResult(Activity.RESULT_CANCELED)
            }
            
            if (finishAfterStop) {
                finishAfterStop = false
                finish()
            }
            
        } catch (e: Exception) {
            Log.e(TAG, "Failed to stop recording", e)
            Toast.makeText(this, "Ошибка остановки записи", Toast.LENGTH_SHORT).show()
        }
    }

    override fun onBackPressed() {
        if (isRecording) {
            finishAfterStop = true
            stopRecording()
        } else {
            super.onBackPressed()
        }
    }
    
    private fun startBackgroundThread() {
        backgroundThread = HandlerThread("CameraBackground")
        backgroundThread?.start()
        backgroundHandler = Handler(backgroundThread?.looper!!)
    }
    
    private fun stopBackgroundThread() {
        try {
            backgroundThread?.quitSafely()
            backgroundThread?.join()
            backgroundThread = null
            backgroundHandler = null
        } catch (e: InterruptedException) {
            Log.e(TAG, "Failed to stop background thread", e)
        }
    }
    
    override fun onResume() {
        super.onResume()
        startBackgroundThread()
        if (textureView.isAvailable) {
            openCamera()
        } else {
            textureView.surfaceTextureListener = textureListener
        }
    }
    
    override fun onPause() {
        closeCamera()
        stopBackgroundThread()
        super.onPause()
    }
    
    private fun closeCamera() {
        try {
            captureSession?.close()
            captureSession = null
            cameraDevice?.close()
            cameraDevice = null
            mediaRecorder?.release()
            mediaRecorder = null
        } catch (e: Exception) {
            Log.e(TAG, "Failed to close camera", e)
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
