package com.example.getrunningapps;

import android.app.ActivityManager;
import android.content.Context;
import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends FlutterActivity {
  // Membuat platform channel dengan nama yang sama dengan yang ada di kode Dart
  private static final String CHANNEL = "getRunningApps";

  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    // Membuat method channel dengan nama yang sama dengan yang ada di kode Dart
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          // Membuat method call handler untuk menangani pemanggilan metode dari kode Dart
          (call, result) -> {
            // Mengecek jika metode yang dipanggil adalah 'getRunningApps'
            if (call.method.equals("getRunningApps")) {
              // Memanggil fungsi untuk mendapatkan daftar aplikasi yang sedang berjalan
              List<String> runningApps = getRunningApps();
              // Mengirimkan hasil ke kode Dart
              result.success(runningApps);
            } else {
              // Mengirimkan pesan kesalahan jika metode yang dipanggil tidak dikenali
              result.notImplemented();
            }
          }
        );
  }

  // Membuat fungsi untuk mendapatkan daftar aplikasi yang sedang berjalan
  private List<String> getRunningApps() {
    // Membuat variabel untuk menyimpan daftar aplikasi yang sedang berjalan
    List<String> runningApps = new ArrayList<>();
    // Membuat objek activity manager untuk mengakses informasi tentang aplikasi yang sedang berjalan
    ActivityManager activityManager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
    // Membuat objek list untuk menyimpan informasi tentang proses yang sedang berjalan
    List<ActivityManager.RunningAppProcessInfo> runningAppProcesses = activityManager.getRunningAppProcesses();
    // Melakukan looping untuk setiap proses yang sedang berjalan
    for (ActivityManager.RunningAppProcessInfo processInfo : runningAppProcesses) {
      // Menambahkan nama proses ke daftar aplikasi yang sedang berjalan
      runningApps.add(processInfo.processName);
    }
    // Mengembalikan daftar aplikasi yang sedang berjalan
    return runningApps;
  }
}
