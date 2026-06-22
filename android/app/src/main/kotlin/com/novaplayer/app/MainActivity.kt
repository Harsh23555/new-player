package com.novaplayer.app

import android.app.PictureInPictureParams
import android.content.pm.PackageManager
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.ryanheise.audioservice.AudioServiceActivity

class MainActivity : AudioServiceActivity() {

    private val PIP_CHANNEL = "com.novaplayer.app/pip"

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

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        // Auto-enter PiP when user presses Home during video playback
        // This is handled from Flutter side via WidgetsBindingObserver
    }
}
