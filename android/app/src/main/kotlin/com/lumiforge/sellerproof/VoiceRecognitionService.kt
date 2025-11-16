package com.lumiforge.sellerproof

import android.content.Intent
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.util.Log

class VoiceRecognitionService(
    private val activity: PackingCameraActivity,
    private val onStopCommand: () -> Unit
) : RecognitionListener {
    
    private var speechRecognizer: SpeechRecognizer? = null
    private var isListening = false
    
    companion object {
        private const val TAG = "VoiceRecognition"
        // Команды для остановки (можно расширить)
        private val STOP_COMMANDS = listOf(
            "стоп", "stop", "остановить", "остановись", 
            "хватит", "закончить", "стопай", "остановка"
        )
    }
    
    fun startListening() {
        if (isListening) {
            Log.d(TAG, "Already listening")
            return
        }
        
        if (!SpeechRecognizer.isRecognitionAvailable(activity)) {
            Log.e(TAG, "Speech recognition not available")
            return
        }
        
        speechRecognizer = SpeechRecognizer.createSpeechRecognizer(activity)
        speechRecognizer?.setRecognitionListener(this)
        
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, "ru-RU") // Русский язык
            putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 5)
            putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true) // Промежуточные результаты
            putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_COMPLETE_SILENCE_LENGTH_MILLIS, 1500)
        }
        
        speechRecognizer?.startListening(intent)
        isListening = true
        Log.d(TAG, "Started listening for voice commands")
    }
    
    fun stopListening() {
        if (isListening) {
            speechRecognizer?.stopListening()
            speechRecognizer?.cancel()
            speechRecognizer?.destroy()
            speechRecognizer = null
            isListening = false
            Log.d(TAG, "Stopped listening")
        }
    }
    
    override fun onReadyForSpeech(params: Bundle?) {
        Log.d(TAG, "Ready for speech")
    }
    
    override fun onBeginningOfSpeech() {
        Log.d(TAG, "Speech started")
    }
    
    override fun onRmsChanged(rmsdB: Float) {
        // Можно использовать для визуализации уровня звука
    }
    
    override fun onBufferReceived(buffer: ByteArray?) {
        // Не используется
    }
    
    override fun onEndOfSpeech() {
        Log.d(TAG, "Speech ended")
    }
    
    override fun onError(error: Int) {
        val errorMessage = when (error) {
            SpeechRecognizer.ERROR_AUDIO -> "Audio recording error"
            SpeechRecognizer.ERROR_CLIENT -> "Client side error"
            SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -> "Insufficient permissions"
            SpeechRecognizer.ERROR_NETWORK -> "Network error"
            SpeechRecognizer.ERROR_NETWORK_TIMEOUT -> "Network timeout"
            SpeechRecognizer.ERROR_NO_MATCH -> "No match"
            SpeechRecognizer.ERROR_RECOGNIZER_BUSY -> "RecognitionService busy"
            SpeechRecognizer.ERROR_SERVER -> "Server error"
            SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> "No speech input"
            else -> "Unknown error"
        }
        Log.e(TAG, "Recognition error: $errorMessage")
        
        // Автоматически перезапускаем, если идет запись
        if (error != SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS) {
            isListening = false
            // Перезапуск после небольшой задержки
            android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                if (!isListening) {
                    startListening()
                }
            }, 1000)
        }
    }
    
    override fun onResults(results: Bundle?) {
        val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
        matches?.forEach { result ->
            Log.d(TAG, "Recognized: $result")
            
            // Проверяем, содержит ли распознанный текст команду остановки
            if (STOP_COMMANDS.any { command -> 
                result.lowercase().contains(command.lowercase()) 
            }) {
                Log.d(TAG, "Stop command detected!")
                onStopCommand()
                return
            }
        }
        
        // Продолжаем слушать
        isListening = false
        startListening()
    }
    
    override fun onPartialResults(partialResults: Bundle?) {
        val matches = partialResults?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
        matches?.forEach { result ->
            Log.d(TAG, "Partial: $result")
            
            // Можно реагировать на частичные результаты для более быстрого отклика
            if (STOP_COMMANDS.any { command -> 
                result.lowercase().contains(command.lowercase()) 
            }) {
                Log.d(TAG, "Stop command detected (partial)!")
                onStopCommand()
            }
        }
    }
    
    override fun onEvent(eventType: Int, params: Bundle?) {
        // Не используется
    }
}
