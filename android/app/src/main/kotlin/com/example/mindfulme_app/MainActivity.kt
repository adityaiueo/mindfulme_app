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


import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log


import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    
    private val CHANNEL = "app_usage"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "app" -> {
                    val foregroundApp = printForegroundTask()
                    result.success(foregroundApp)
                }
                "needPermissionForBlocking" -> {
                    val needPermission = needPermissionForBlocking(context)
                    result.success(needPermission)
                }
                "openUsageAccessSettings" -> {
                    startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun needPermissionForBlocking(context: Context): Boolean {
        return try {
            val packageManager = context.packageManager
            val applicationInfo = packageManager.getApplicationInfo(context.packageName, 0)
            val appOpsManager = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val mode = appOpsManager.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, applicationInfo.uid, applicationInfo.packageName)
            mode != AppOpsManager.MODE_ALLOWED
        } catch (e: PackageManager.NameNotFoundException) {
            true
        }
    }

    private fun printForegroundTask(): String {
        var currentApp = "NULL"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val usm = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
            val time = System.currentTimeMillis()
            val usageEvents = usm.queryEvents(time - 1000, time)
            var event: UsageEvents.Event = UsageEvents.Event()
            while (usageEvents.hasNextEvent()) {
                usageEvents.getNextEvent(event)
                if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                    currentApp = event.packageName
                }
            }
        } else {
            val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val tasks = am.runningAppProcesses
            currentApp = tasks[0].processName
        }

        Log.e("adapter", "Current App in foreground is: $currentApp")
        return currentApp
    }

    private fun handleCustomUri() {
        // Dummy URI for testing
        val uri = Uri.parse("mindfulme-app://open.mindfulme.app")
        val path: String? = uri.path

        // Navigate to the appropriate screen based on the URI path
        when (path) {
            "/" -> navigateToMainTabViewScreen()
            "/goalset" -> navigateToGoalSettingScreen()
            "/mindful" -> navigateToMindfulPage()
            "/twenty" -> navigateToTwentyPage()
            "/twentyd" -> navigateToTwentyDetailScreen()
            "/mindfuld" -> navigateToMindfulnessDetailScreen()
            "/goalsetd" -> navigateToGoalsetDetailScreen()
            "/intervention" -> navigateToInterventionScreen()
            else -> println("Unhandled URI: $uri")
        }
    }

    private fun navigateToMainTabViewScreen() {
        val intent = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = Uri.parse("mindfulme-app://open.mindfulme.app/")
        }
        startActivity(intent)
    }

    private fun navigateToGoalSettingScreen() {
        val intent = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = Uri.parse("mindfulme-app://open.mindfulme.app/goalset")
        }
        startActivity(intent)
    }

    private fun navigateToMindfulPage() {
        val intent = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = Uri.parse("mindfulme-app://open.mindfulme.app/mindful")
        }
        startActivity(intent)
    }

    private fun navigateToTwentyPage() {
        val intent = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = Uri.parse("mindfulme-app://open.mindfulme.app/twenty")
        }
        startActivity(intent)
    }

    private fun navigateToTwentyDetailScreen() {
        val intent = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = Uri.parse("mindfulme-app://open.mindfulme.app/twentyd")
        }
        startActivity(intent)
    }

    private fun navigateToMindfulnessDetailScreen() {
        val intent = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = Uri.parse("mindfulme-app://open.mindfulem.app/mindfuld")
        }
        startActivity(intent)
    }

    private fun navigateToGoalsetDetailScreen() {
        val intent = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = Uri.parse("mindfulme-app://open.mindfulme.app/goalsetd")
        }
        startActivity(intent)
    }

    private fun navigateToInterventionScreen() {
        val intent = Intent(this, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = Uri.parse("mindfulme-app:/open.mindfulme.app/intervention")
        }
        startActivity(intent)
    }

}