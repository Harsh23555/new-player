package com.novaplayer.app

import android.app.PictureInPictureParams
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.media.audiofx.AudioEffect
import android.media.audiofx.BassBoost
import android.media.audiofx.Equalizer
import android.media.audiofx.LoudnessEnhancer
import android.media.audiofx.Virtualizer
import android.os.Build
import android.util.Log
import android.util.Rational
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {

    private val PIP_CHANNEL = "com.novaplayer.app/pip"
    private val EQUALIZER_CHANNEL = "com.novaplayer.app/equalizer"

    private var equalizer: Equalizer? = null
    private var bassBoost: BassBoost? = null
    private var virtualizer: Virtualizer? = null
    private var loudnessEnhancer: LoudnessEnhancer? = null

    // Persistent settings to apply to new sessions
    private var isEnabled = false
    private var currentGains: DoubleArray? = null
    private var currentBassBoost = 0
    private var currentVirtualizer = 0
    private var currentPreamp = 0.0
    private var activeSessionId: Int = 0

    private val receiver = object : android.content.BroadcastReceiver() {
        override fun onReceive(context: android.content.Context?, intent: android.content.Intent?) {
            if (intent?.action == AudioEffect.ACTION_OPEN_AUDIO_EFFECT_CONTROL_SESSION) {
                val sessionId = intent.getIntExtra(AudioEffect.EXTRA_AUDIO_SESSION, 0)
                if (sessionId != 0 && sessionId != activeSessionId) {
                    activeSessionId = sessionId
                    initEffects(sessionId)
                }
            }
        }
    }

    override fun onCreate(saved: android.os.Bundle?) {
        super.onCreate(saved)
        try {
            val filter = IntentFilter(AudioEffect.ACTION_OPEN_AUDIO_EFFECT_CONTROL_SESSION)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(receiver, filter, Context.RECEIVER_EXPORTED)
            } else {
                registerReceiver(receiver, filter)
            }
        } catch (e: Exception) {
            android.util.Log.e("NovaPlayer", "Failed to register audio broadcast receiver", e)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PIP_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "enterPiP" -> {
                    if (tryEnterPipMode()) {
                        result.success(null)
                    } else {
                        result.error("PIP_FAILED", "Unable to enter PiP mode", null)
                    }
                }
                "isPipSupported" -> {
                    result.success(isPipSupported())
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EQUALIZER_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "setEnabled" -> {
                    isEnabled = call.argument<Boolean>("enabled") ?: false
                    applyToAllEffects()
                    result.success(null)
                }
                "setAudioSessionId" -> {
                    val sessionId = call.argument<Int>("sessionId") ?: 0
                    if (sessionId != 0 && sessionId != activeSessionId) {
                        activeSessionId = sessionId
                        initEffects(sessionId)
                    }
                    result.success(null)
                }
                "setBandLevel" -> {
                    val band = call.argument<Int>("band") ?: 0
                    val level = call.argument<Double>("level") ?: 0.0
                    if (currentGains == null) currentGains = DoubleArray(5)
                    if (band >= 0 && band < (currentGains?.size ?: 0)) {
                        currentGains!![band] = level
                    }
                    equalizer?.setBandLevel(band.toShort(), (level * 100).toInt().toShort())
                    result.success(null)
                }
                "applyPreset" -> {
                    val gains = call.argument<List<Double>>("gains")
                    if (gains != null) {
                        currentGains = gains.toDoubleArray()
                        applyGains()
                    }
                    result.success(null)
                }
                "setPreamp" -> {
                    currentPreamp = call.argument<Double>("preamp") ?: 0.0
                    applyPreamp()
                    result.success(null)
                }
                "setBassBoost" -> {
                    currentBassBoost = call.argument<Int>("strength") ?: 0
                    applyBassBoost()
                    result.success(null)
                }
                "setVirtualizer" -> {
                    currentVirtualizer = call.argument<Int>("strength") ?: 0
                    applyVirtualizer()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun initEffects(sessionId: Int) {
        releaseEffects()
        try {
            Log.d("NovaPlayer", "Initializing effects for session $sessionId")
            
            // Priority 1000 to ensure our app's effects take precedence
            equalizer = Equalizer(1000, sessionId)
            bassBoost = BassBoost(1000, sessionId)
            virtualizer = Virtualizer(1000, sessionId)
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                loudnessEnhancer = LoudnessEnhancer(sessionId)
            }

            applyToAllEffects()
        } catch (e: Exception) {
            Log.e("NovaPlayer", "Failed to init effects", e)
        }
    }

    private fun applyToAllEffects() {
        try {
            equalizer?.enabled = isEnabled
            bassBoost?.enabled = isEnabled && currentBassBoost > 0
            virtualizer?.enabled = isEnabled && currentVirtualizer > 0
            loudnessEnhancer?.enabled = isEnabled && currentPreamp > 0

            if (isEnabled) {
                applyGains()
                applyBassBoost()
                applyVirtualizer()
                applyPreamp()
            }
        } catch (e: Exception) {
            Log.e("NovaPlayer", "Error applying effects", e)
        }
    }

    private fun applyGains() {
        val gains = currentGains ?: return
        val eq = equalizer ?: return
        try {
            for (i in gains.indices) {
                if (i < eq.numberOfBands) {
                    eq.setBandLevel(i.toShort(), (gains[i] * 100).toInt().toShort())
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun applyBassBoost() {
        val bb = bassBoost ?: return
        try {
            if (bb.strengthSupported) {
                bb.setStrength(currentBassBoost.toShort())
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun applyVirtualizer() {
        val virt = virtualizer ?: return
        try {
            if (virt.strengthSupported) {
                virt.setStrength(currentVirtualizer.toShort())
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun applyPreamp() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            val le = loudnessEnhancer ?: return
            try {
                // preamp scale: 1.0 = 0mB, 2.0 = 1000mB, 3.0 = 2000mB
                val gainmB = ((currentPreamp - 1.0) * 1000).toInt()
                le.setTargetGain(gainmB)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun releaseEffects() {
        equalizer?.release()
        bassBoost?.release()
        virtualizer?.release()
        loudnessEnhancer?.release()
        equalizer = null
        bassBoost = null
        virtualizer = null
        loudnessEnhancer = null
    }

    private fun tryEnterPipMode(): Boolean {
        if (!isPipSupported()) return false
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val params = PictureInPictureParams.Builder()
                    .setAspectRatio(Rational(16, 9))
                    .build()
                enterPictureInPictureMode(params)
                true
            } else {
                false
            }
        } catch (e: Exception) {
            false
        }
    }

    private fun isPipSupported(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
        } else {
            false
        }
    }

    override fun onDestroy() {
        try {
            unregisterReceiver(receiver)
        } catch (e: Exception) {
            // Ignore if not registered
        }
        releaseEffects()
        super.onDestroy()
    }
}

