package com.example.mindfulme_app

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.os.Bundle

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

import android.Manifest
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class MainActivity : FlutterActivity() {
    private val CHANNEL = "getRunningApps"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Handle incoming deep links
        handleDeepLinking()
    }

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

    private val PERMISSION_REQUEST_CODE = 100 // Angka acak untuk kode permintaan izin
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Periksa apakah izin telah diberikan
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.GET_TASKS)
            != PackageManager.PERMISSION_GRANTED) {
            // Jika belum, minta izin
            ActivityCompat.requestPermissions(this,
                arrayOf(Manifest.permission.GET_TASKS),
                PERMISSION_REQUEST_CODE)
        } else {
            // Jika sudah diberikan, lanjutkan dengan operasi yang diinginkan
            handleDeepLinking()
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            // Cek apakah izin diberikan
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Izin diberikan, lanjutkan dengan operasi yang diinginkan
                handleDeepLinking()
                getRunningApps()
            } else {
                // Izin tidak diberikan, berikan pesan atau tindakan yang sesuai kepada pengguna
            }
        }
    }

    private fun handleDeepLinking() {
        // Get the data from the intent
        val action: String? = intent.action
        val data: String? = intent.dataString

        if (Intent.ACTION_VIEW == action && data != null) {
            // Handle deep link here
            // You can parse the data string and take necessary actions based on it
        }
    }
}
