package com.example.getrunningapps

import android.app.ActivityManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "getRunningApps"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getRunningApps") {
                val runningApps = getRunningApps()
                result.success(runningApps)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getRunningApps(): ArrayList<String> {
        val runningApps = ArrayList<String>()
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val runningAppProcesses = activityManager.runningAppProcesses
        for (processInfo in runningAppProcesses) {
            runningApps.add(processInfo.processName)
        }
        return runningApps
    }
}
