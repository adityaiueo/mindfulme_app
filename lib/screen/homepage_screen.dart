import 'package:flutter/material.dart';
import 'package:appcheck/appcheck.dart';
import 'package:mindfulme_app/screen/intervention_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Logger logger = Logger();

  List<AppInfo>? _installedApps;
  late SharedPreferences
      _prefs; // Variabel untuk menyimpan instance SharedPreferences
  final List<bool> _isChecked = [];

  @override
  void initState() {
    super.initState();
    getInstalledApps();
    _initPrefs(); //call fungsi utk inisialisasi sharedPref
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> openTwentyPageIfNeeded() async {
    String runningApp = await getRunningApp();
    if (runningApp.isEmpty) return false;

    int selectedIndex = await getSelectedAppIndex();
    if (selectedIndex == -1) return false;

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
            if (timeInForegroundInMilliseconds >= 20 * 60 * 1000) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  Future<bool> openMindfulPageIfNeeded() async {
    String runningApp = await getRunningApp();
    if (runningApp.isEmpty) {
      return false;
    }

    int selectedIndex = await getSelectedAppIndex();
    if (selectedIndex == -1) {
      return false;
    }

    InterventionScreenState interventionScreenState = InterventionScreenState();
    int? selectedTime =
        await interventionScreenState.showTimePickerDialog(defaultTime: 15);

    if (selectedTime != null) {
      // Memeriksa apakah aplikasi yang dipilih sama dengan aplikasi yang berjalan
      if (_installedApps![selectedIndex].appName == runningApp) {
        // Memeriksa waktu penggunaan aplikasi
        DateTime endTime = DateTime.now();
        DateTime startTime = endTime.subtract(Duration(minutes: selectedTime));
        List<UsageInfo> usageInfos =
            await UsageStats.queryUsageStats(startTime, endTime);
        for (var info in usageInfos) {
          if (info.packageName == runningApp) {
            // Jika waktu penggunaan aplikasi lebih dari yang telah ditentukan, kembalikan true
            if (info.totalTimeInForeground != null &&
                int.tryParse(info.totalTimeInForeground!) != null) {
              int timeInForegroundInMilliseconds =
                  int.parse(info.totalTimeInForeground!);
              if (timeInForegroundInMilliseconds >= selectedTime * 60 * 1000) {
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }

  Future<bool> openGoalsetPageIfNeeded() async {
    // Mendapatkan nama aplikasi yang sedang berjalan
    String runningApp = await getRunningApp();
    if (runningApp.isEmpty) return false;

    // Mendapatkan indeks aplikasi yang dipilih
    int selectedIndex = await getSelectedAppIndex();
    if (selectedIndex == -1) return false;

    // Memeriksa apakah aplikasi yang dipilih sama dengan aplikasi yang berjalan
    return _installedApps![selectedIndex].appName == runningApp;
  }

  Future<String> getRunningApp() async {
    try {
      final List<dynamic> result = await const MethodChannel('getRunningApps')
          .invokeMethod('getRunningApps');
      return result.isNotEmpty ? result.first : '';
    } on PlatformException catch (e) {
      logger.d(e.message);

      return '';
    }
  }

  Future<int> getSelectedAppIndex() async {
    for (int i = 0; i < _installedApps!.length; i++) {
      bool isChecked = _prefs.getBool('app_$i') ?? false;
      if (isChecked) return i;
    }
    return -1;
  }

  Future<void> getInstalledApps() async {
    try {
      List<AppInfo>? installedApps = await AppCheck.getInstalledApps();
      if (installedApps != null) {
        setState(() {
          _installedApps = installedApps;
        });
      }
    } catch (e) {
      logger.d('Error: $e');
    }
  }

  // Fungsi untuk menyimpan status checkbox ke SharedPreferences
  Future<void> saveCheckboxState(int index, bool value) async {
    await _prefs.setBool('app_$index', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installed Apps'),
      ),
      body: ListView.builder(
        itemCount: _installedApps!.length,
        itemBuilder: (context, index) {
          return Container(
            // Tambahkan margin untuk memberi jarak antara item
            margin: const EdgeInsets.all(8),
            // Tambahkan decoration untuk memberi border, warna, dan bayangan
            decoration: BoxDecoration(
              // Tambahkan border berwarna ungu dengan sudut yang rounded
              border: Border.all(color: Colors.purple, width: 2),
              borderRadius: BorderRadius.circular(10),
              // Tambahkan warna semi transparan berwarna ungu
              color: Colors.purple.withOpacity(0.2),
              // Tambahkan bayangan dengan warna ungu
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              // Tambahkan gambar yang mewakili aplikasi di bagian awal ListTile
              leading: Image.asset(_installedApps![index].appName ?? ''),
              title: Text(_installedApps![index].appName ?? ''),
              trailing: Checkbox(
                value: _isChecked[index],
                onChanged: (value) {
                  setState(() {
                    _isChecked[index] = value!;
                    saveCheckboxState(index, value);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
