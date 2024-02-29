import 'package:flutter/material.dart';
import 'package:appcheck/appcheck.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
