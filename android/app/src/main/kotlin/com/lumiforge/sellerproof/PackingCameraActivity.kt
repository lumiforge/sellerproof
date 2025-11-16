package com.lumiforge.sellerproof

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.hardware.camera2.*
import android.media.MediaRecorder
import android.os.Bundle
import android.os.Handler
import android.os.HandlerThread
import android.provider.MediaStore
import android.util.Log
import android.view.Surface
import android.view.TextureView
import android.widget.Button
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import java.io.File

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
    private var scannedCode: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_packing_camera)
        
        // Get scanned code from intent
        scannedCode = intent.getStringExtra("scannedCode")

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
        override fun onSurfaceTextureDestroyed(surface: android.graphics.SurfaceTexture): Boolean = true
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
            val characteristics = cameraManager?.getCameraCharacteristics(cameraId!!)
            val map = characteristics?.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)
            val sizes = map?.getOutputSizes(android.graphics.SurfaceTexture::class.java)
            
            val previewSize = sizes?.firstOrNull { size ->
                size.width <= 1920 && size.height <= 1080
            } ?: sizes?.first()
            
            previewSize?.let {
                texture.setDefaultBufferSize(it.width, it.height)
            } ?: run {
                texture.setDefaultBufferSize(1280, 720)
            }
            
            val surface = Surface(texture)
            
            previewRequestBuilder = try {
                cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_RECORD)
            } catch (e: Exception) {
                Log.w(TAG, "TEMPLATE_RECORD not supported, using TEMPLATE_PREVIEW", e)
                cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW)
            }
            
            previewRequestBuilder?.addTarget(surface)
            
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
                            
                            backgroundHandler?.post {
                                configureCameraSettings()
                                // Автоматически запускаем запись после настройки камеры
                                startRecording()
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
        } catch (e: Exception) {
            Log.e(TAG, "Failed to create preview session", e)
        }
    }

    private fun configureCameraSettings() {
        try {
            val captureRequestBuilder = this.previewRequestBuilder ?: return
            val cameraId = this.cameraId ?: return
            val characteristics = cameraManager?.getCameraCharacteristics(cameraId)
            
            captureRequestBuilder.set(CaptureRequest.CONTROL_MODE, CaptureRequest.CONTROL_MODE_AUTO)
            captureRequestBuilder.set(CaptureRequest.CONTROL_AE_MODE, CaptureRequest.CONTROL_AE_MODE_ON)
            
            // Для превью используем нейтральную яркость
            val exposureRange = characteristics?.get(CameraCharacteristics.CONTROL_AE_COMPENSATION_RANGE)
            if (exposureRange != null) {
                captureRequestBuilder.set(CaptureRequest.CONTROL_AE_EXPOSURE_COMPENSATION, 0)
                Log.d(TAG, "Preview: exposure compensation = 0 (range: ${exposureRange.lower}..${exposureRange.upper})")
            }
            
            captureRequestBuilder.set(CaptureRequest.CONTROL_AF_MODE, CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_VIDEO)
            
            // Получаем доступные FPS диапазоны для превью
            val availableFpsRanges = characteristics?.get(CameraCharacteristics.CONTROL_AE_AVAILABLE_TARGET_FPS_RANGES)
            if (availableFpsRanges != null) {
                // Для превью используем стабильный 30 FPS
                val previewFpsRange = availableFpsRanges.firstOrNull { 
                    it.lower == 30 && it.upper == 30 
                } ?: availableFpsRanges.maxByOrNull { it.upper }
                
                if (previewFpsRange != null) {
                    captureRequestBuilder.set(CaptureRequest.CONTROL_AE_TARGET_FPS_RANGE, previewFpsRange)
                    Log.d(TAG, "Preview: FPS range: ${previewFpsRange.lower}-${previewFpsRange.upper}")
                }
            }
            
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
            
            val videoSize = videoSizes?.firstOrNull { size ->
                size.width <= 1920 && size.height <= 1080
            } ?: videoSizes?.first()
            
            currentVideoFile = getOutputMediaFile()
            
            // ВАЖНО: НЕ добавляем аудио источник для работы голосового управления!
            mediaRecorder?.apply {
                setVideoSource(MediaRecorder.VideoSource.SURFACE)
                setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
                setOutputFile(currentVideoFile!!.absolutePath)
                setVideoEncodingBitRate(12000000)
                setVideoFrameRate(30)
                videoSize?.let {
                    setVideoSize(it.width, it.height)
                } ?: run {
                    setVideoSize(1280, 720)
                }
                setVideoEncoder(MediaRecorder.VideoEncoder.H264)
                prepare()
            }
            
            val texture = textureView.surfaceTexture!!
            videoSize?.let {
                texture.setDefaultBufferSize(it.width, it.height)
            } ?: run {
                texture.setDefaultBufferSize(1280, 720)
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
                            val previewRequestBuilder = cameraDevice?.createCaptureRequest(CameraDevice.TEMPLATE_RECORD)
                            previewRequestBuilder?.addTarget(previewSurface)
                            previewRequestBuilder?.addTarget(recorderSurface)
                            
                            configureRecordingSettings(previewRequestBuilder)
                            
                            session.setRepeatingRequest(previewRequestBuilder!!.build(), null, backgroundHandler)
                            
                            mediaRecorder?.start()
                            isRecording = true
                            btnStartStop.text = "Остановить запись"
                            Toast.makeText(this@PackingCameraActivity, "Запись началась", Toast.LENGTH_SHORT).show()
                            
                            // Отправляем сигнал Flutter что запись началась
                            sendRecordingStateToFlutter(true)
                            
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
    
    private fun configureRecordingSettings(captureRequestBuilder: CaptureRequest.Builder?) {
        try {
            val builder = captureRequestBuilder ?: return
            val cameraId = this.cameraId ?: return
            val characteristics = cameraManager?.getCameraCharacteristics(cameraId)
            
            builder.set(CaptureRequest.CONTROL_MODE, CaptureRequest.CONTROL_MODE_AUTO)
            builder.set(CaptureRequest.CONTROL_AE_MODE, CaptureRequest.CONTROL_AE_MODE_ON)
            
            // ВАЖНО: Адаптивное осветление
            val exposureRange = characteristics?.get(CameraCharacteristics.CONTROL_AE_COMPENSATION_RANGE)
            if (exposureRange != null) {
                val maxExposure = exposureRange.upper
                
                // Начинаем с 60% от максимума
                var targetCompensation = (maxExposure * 0.6).toInt().coerceAtLeast(1)
                
                // Получаем текущую яркость сцены (если доступно)
                val currentExposureCompensation = builder.get(CaptureRequest.CONTROL_AE_EXPOSURE_COMPENSATION) ?: 0
                
                // Если сцена очень темная, увеличиваем до 80%
                if (currentExposureCompensation < -2) {
                    targetCompensation = (maxExposure * 0.8).toInt().coerceAtLeast(1)
                    Log.d(TAG, "Recording: Scene is dark, boosting to 80%")
                }
                
                builder.set(CaptureRequest.CONTROL_AE_EXPOSURE_COMPENSATION, targetCompensation)
                Log.d(TAG, "Recording: Adaptive exposure compensation = $targetCompensation (range: ${exposureRange.lower}..${exposureRange.upper})")
            }
            
            // Фокусировка для видео
            builder.set(CaptureRequest.CONTROL_AF_MODE, CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_VIDEO)
            
            // Отключаем сцены - даем полный контроль яркости
            builder.set(CaptureRequest.CONTROL_SCENE_MODE, CaptureRequest.CONTROL_SCENE_MODE_DISABLED)
            
            // Стабилизация видео если доступна
            val availableVideoStabilization = characteristics?.get(CameraCharacteristics.CONTROL_AVAILABLE_VIDEO_STABILIZATION_MODES)
            if (availableVideoStabilization != null && availableVideoStabilization.contains(CaptureRequest.CONTROL_VIDEO_STABILIZATION_MODE_ON)) {
                builder.set(CaptureRequest.CONTROL_VIDEO_STABILIZATION_MODE, CaptureRequest.CONTROL_VIDEO_STABILIZATION_MODE_ON)
                Log.d(TAG, "Recording: Video stabilization enabled")
            }
            
            // Получаем доступные FPS диапазоны
            val availableFpsRanges = characteristics?.get(CameraCharacteristics.CONTROL_AE_AVAILABLE_TARGET_FPS_RANGES)
            if (availableFpsRanges != null) {
                Log.d(TAG, "Available FPS ranges:")
                availableFpsRanges.forEach { range ->
                    Log.d(TAG, "  - ${range.lower} to ${range.upper}")
                }
                
                // Выбираем диапазон с наименьшим минимумом для лучшей яркости
                val bestFpsRange = availableFpsRanges.minByOrNull { it.lower }
                if (bestFpsRange != null) {
                    builder.set(CaptureRequest.CONTROL_AE_TARGET_FPS_RANGE, bestFpsRange)
                    Log.d(TAG, "Recording: FPS range: ${bestFpsRange.lower}-${bestFpsRange.upper}")
                }
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
        val videoFile = File(mediaStorageDir, "packing_${System.currentTimeMillis()}.mp4")
        
        // Save scanned code with video
        scannedCode?.let { code ->
            val codeFile = File(mediaStorageDir, "packing_${System.currentTimeMillis()}.txt")
            codeFile.writeText(code)
            Log.d(TAG, "Saved scanned code: $code with video: ${videoFile.absolutePath}")
        }
        
        return videoFile
    }

    fun stopRecording() {
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
            
            // Отправляем сигнал Flutter что запись остановлена
            sendRecordingStateToFlutter(false)
            
            currentVideoFile?.let { videoFile ->
                val resultIntent = Intent().apply {
                    putExtra("videoPath", videoFile.absolutePath)
                    // Also include the scanned code
                    putExtra("scannedCode", scannedCode)
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

    private fun sendRecordingStateToFlutter(isRecording: Boolean) {
        // Метод для связи с Flutter через MethodChannel (настроим позже в MainActivity)
        val intent = Intent("RECORDING_STATE_CHANGED")
        intent.putExtra("isRecording", isRecording)
        sendBroadcast(intent)
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
            ContextCompat.checkSelfPermission(this, perm) == PackageManager.PERMISSION_GRANTED
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
                Toast.makeText(this, "Нет разрешений на камеру/микрофон", Toast.LENGTH_SHORT).show()
                finish()
            }
        }
    }

    companion object {
        private const val TAG = "PackingCameraActivity"
        private const val REQUEST_CODE_PERMISSIONS = 10
        private val REQUIRED_PERMISSIONS = arrayOf(
            Manifest.permission.CAMERA,
            Manifest.permission.RECORD_AUDIO  // Нужно для Vosk
        )
        
        // Статический метод для вызова из Flutter
        private var currentActivity: PackingCameraActivity? = null
        
        fun setCurrentActivity(activity: PackingCameraActivity?) {
            currentActivity = activity
        }
        
        fun requestStopRecording() {
            currentActivity?.stopRecording()
        }
    }
    
    init {
        setCurrentActivity(this)
    }
    
    override fun onDestroy() {
        setCurrentActivity(null)
        super.onDestroy()
    }
}
