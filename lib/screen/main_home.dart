import 'package:flutter/material.dart';
import 'package:appcheck/appcheck.dart';
import 'package:mindfulme_app/feature/mindful_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:url_launcher/url_launcher.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  List<AppInfo>? _installedApps;
  late SharedPreferences
      _prefs; // Variabel untuk menyimpan instance SharedPreferences

  @override
  void initState() {
    super.initState();
    _getInstalledApps();
    _initPrefs(); // Panggil fungsi untuk inisialisasi SharedPreferences
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //TODO : Ini harusnyaa di main.dartt atau di background_servicenyaa, atau disini aja ya buat dapetin list app ke download? tapi harus cari
  //TODO : harus cari cara sih buat biar bisa mindahin ini ke main
  Future<void> _openMindfulPageIfNeeded() async {
    // Membuka halaman MindfulPage jika kondisi terpenuhi
    // Misalnya: jika aplikasi yang dipilih sudah berjalan selama 15 menit
    // dan sudah dicentang dalam daftar aplikasi yang dipilih sebelumnya
    bool shouldOpen = await _checkSelectedAppUsage();
    if (shouldOpen) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MindfulPage()),
      );
    }
  }

  Future<void> launchMindfulPage() async {
    const String url =
        'your_url_here';
    final Uri uri = Uri.parse(url); // Ganti dengan URL Anda jika ingin membuka URL tertentu
    if (await canLaunchUrl(uri.toString())) {
      await launchUrl(uri.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> _checkSelectedAppUsage() async {
    // Mendapatkan nama aplikasi yang sedang berjalan
    String runningApp = await _getRunningApp();
    if (runningApp.isEmpty) return false;

    // Mendapatkan indeks aplikasi yang dipilih
    int selectedIndex = await _getSelectedAppIndex();
    if (selectedIndex == -1) return false;

    // Memeriksa apakah aplikasi yang dipilih sama dengan aplikasi yang berjalan
    if (_installedApps![selectedIndex].appName == runningApp) {
      // Memeriksa waktu penggunaan aplikasi
      DateTime endTime = DateTime.now();
      DateTime startTime = endTime.subtract(const Duration(minutes: 15));
      List<UsageInfo> usageInfos =
          await UsageStats.queryUsageStats(startTime, endTime);
      for (var info in usageInfos) {
        if (info.packageName == runningApp) {
          // Jika waktu penggunaan aplikasi lebih dari 15 menit, kembalikan true
          if (info.totalTimeInForeground != null &&
              int.tryParse(info.totalTimeInForeground!) != null) {
            int timeInForegroundInMilliseconds =
                int.parse(info.totalTimeInForeground!);
            if (timeInForegroundInMilliseconds >= 15 * 60 * 1000) {
              // konversi menit ke milidetik
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  Future<String> _getRunningApp() async {
    try {
      final List<dynamic> result = await const MethodChannel('getRunningApps')
          .invokeMethod('getRunningApps');
      return result.isNotEmpty ? result.first : '';
    } on PlatformException catch (e) {
      print(e.message);
      return '';
    }
  }

  Future<int> _getSelectedAppIndex() async {
    for (int i = 0; i < _installedApps!.length; i++) {
      bool isChecked = _prefs.getBool('app_$i') ?? false;
      if (isChecked) return i;
    }
    return -1;
  }

  Future<void> _getInstalledApps() async {
    try {
      List<AppInfo>? installedApps = await AppCheck.getInstalledApps();
      if (installedApps != null) {
        setState(() {
          _installedApps = installedApps;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Fungsi untuk menyimpan status checkbox ke SharedPreferences
  Future<void> _saveCheckboxState(int index, bool value) async {
    await _prefs.setBool('app_$index', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installed Apps'),
      ),
      body: _installedApps != null
          ? ListView.builder(
              itemCount: _installedApps!.length,
              itemBuilder: (context, index) {
                // Mendapatkan nilai checkbox dari SharedPreferences
                bool isChecked = _prefs.getBool('app_$index') ?? false;
                return ListTile(
                  title: Text(_installedApps![index].appName!),
                  trailing: Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                        // Simpan status checkbox ke SharedPreferences saat diubah
                        _saveCheckboxState(index, isChecked);
                      });
                    },
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
