package com.example.mindfulme_app

import android.app.ActivityManager
import android.content.Context

import androidx.annotation.NonNull

import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

import android.net.Uri
import android.content.Intent

import android.app.AppOpsManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager

import android.os.Bundle
import android.provider.Settings

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.accessibilityservice.AccessibilityServiceInfo


import android.content.ComponentName
import android.content.pm.ActivityInfo
import android.os.Build
import android.util.Log

class MainActivity : FlutterActivity() {
    private lateinit var accessibilityService: MyAccessibilityService

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Start the accessibility service
        val intent = Intent(this, MyAccessibilityService::class.java)
        startService(intent)
        accessibilityService = MyAccessibilityService()
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        // Set up the 'window_change_detecting_service' method channel
        val windowChangeChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.window_change_detecting_service")
        windowChangeChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getCurrentActivity" -> {
                    val currentActivity = accessibilityService.getCurrentActivityPackage()
                    if (currentActivity != null) {
                        result.success(currentActivity)
                    } else {
                        result.error("UNAVAILABLE", "Current activity not available.", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}

class MyAccessibilityService : AccessibilityService() {
    private var currentAppPackage: String? = null

    override fun onServiceConnected() {
        super.onServiceConnected()

        // Configure these here for compatibility with API 13 and below.
        val config = AccessibilityServiceInfo()
        config.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
        config.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC

        if (Build.VERSION.SDK_INT >= 16) {
            // Just in case this helps
            config.flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS
        }

        serviceInfo = config
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            if (event.packageName != null && event.className != null) {
                val componentName = ComponentName(
                    event.packageName.toString(),
                    event.className.toString()
                )

                val activityInfo = tryGetActivity(componentName)
                val isActivity = activityInfo != null
                if (isActivity) {
                    Log.i("CurrentActivity", componentName.flattenToShortString())
                    currentAppPackage = componentName.packageName
                }
            }
        }
    }

    private fun tryGetActivity(componentName: ComponentName): ActivityInfo? {
        return try {
            packageManager.getActivityInfo(componentName, 0)
        } catch (e: PackageManager.NameNotFoundException) {
            null
        }
    }

    fun getCurrentActivityPackage(): String? {
        return currentAppPackage
    }

    override fun onInterrupt() {}
}
