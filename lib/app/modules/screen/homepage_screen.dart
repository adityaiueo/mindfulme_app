import 'package:app_settings/app_settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindfulme_app/app/common/color_extension.dart';
import 'package:mindfulme_app/app/modules/feature_page/goalset_page.dart';
import 'package:mindfulme_app/app/utils/app_usage.dart';
import 'package:mindfulme_app/app/widgets/permission_box.dart';
import 'package:mindfulme_app/app/widgets/usagetime_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:logger/logger.dart';
import 'package:device_apps/device_apps.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Logger logger = Logger();
  late BuildContext _context;

  // Function to check permissions
  void checkPermissions() async {
    // Check notification permission
    bool isNotificationAllowed =
        await AwesomeNotifications().isNotificationAllowed();
    if (!isNotificationAllowed && mounted) {
      showDialog(
        context: _context, // Use the stored context
        builder: (BuildContext context) {
          return PermissionBox(
            imagePath: 'assets/notification_icon.png',
            message: 'This app needs permission to send notifications '
                'so that you can get the full feature.',
            onContinuePressed: () async {
              await AwesomeNotifications()
                  .requestPermissionToSendNotifications();
              Navigator.pop(
                  context); // Close the dialog after requesting permission
            },
          );
        },
      );
    }

    // Check location permission
    PermissionStatus locationPermissionStatus =
        await Permission.location.status;
    if (locationPermissionStatus.isDenied && mounted) {
      showDialog(
        context: _context, // Use the stored context
        builder: (BuildContext context) {
          return PermissionBox(
            imagePath: 'assets/notification_icon.png',
            message: 'This app needs permission to access location '
                'so that you can get the full feature.',
            onContinuePressed: () async {
              await Permission.location.request();
              Navigator.pop(
                  context); // Close the dialog after requesting permission
            },
          );
        },
      );
    } else if (locationPermissionStatus.isPermanentlyDenied) {
      AppSettings.openAppSettings(type: AppSettingsType.location);
    }

    // Check location service enabled
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled && mounted) {
      showDialog(
        context: _context, // Use the stored context
        builder: (BuildContext context) {
          return const PermissionBox(
            imagePath: 'assets/notification_icon.png',
            message:
                'Location service is disabled. Please enable it to use the app.',
          );
        },
      );
    }

    // Check usage stats permission
    bool? isUsageStatAllowed = await UsageStats.checkUsagePermission();
    if (isUsageStatAllowed == false && mounted) {
      showDialog(
        context: _context, // Use the stored context
        builder: (BuildContext context) {
          return PermissionBox(
            imagePath: 'assets/notification_icon.png',
            message: 'This app needs usage access permission '
                'so that you can get the full feature. Please go to your device settings, '
                'tap on the top right corner, select usage access permission, and activate it for the app.',
            onContinuePressed: () async {
              AppSettings.openAppSettings(type: AppSettingsType.settings);
              UsageStats.grantUsagePermission();
              Navigator.pop(
                  context); // Close the dialog after granting permission
            },
          );
        },
      );
    }
  }

  Future<bool> openTwentyPageIfNeeded() async {
    String runningApp = await getRunningApp();
    if (runningApp.isEmpty) return false;

    int selectedIndex = await getSelectedAppIndex();
    if (selectedIndex == -1) return false;

    if (socialApps[selectedIndex].appName == runningApp) {
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

    // Memeriksa apakah aplikasi yang dipilih sama dengan aplikasi yang berjalan
    if (socialApps[selectedIndex].appName == runningApp) {
      // Memeriksa waktu penggunaan aplikasi
      DateTime endTime = DateTime.now();
      DateTime startTime = endTime.subtract(const Duration(minutes: 15));
      List<UsageInfo> usageInfos =
          await UsageStats.queryUsageStats(startTime, endTime);
      for (var info in usageInfos) {
        if (info.packageName == runningApp) {
          // Jika waktu penggunaan aplikasi lebih dari yang telah ditentukan, kembalikan true
          if (info.totalTimeInForeground != null &&
              int.tryParse(info.totalTimeInForeground!) != null) {
            int timeInForegroundInMilliseconds =
                int.parse(info.totalTimeInForeground!);
            if (timeInForegroundInMilliseconds >= 15 * 60 * 1000) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  Future<bool> openGoalsetPageIfNeeded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Periksa apakah status sebelumnya telah disimpan di SharedPreferences
    bool isFirstRun = prefs.getBool('open_goalset_first_run') ?? true;

    // Jika ini adalah run pertama, langsung return true tanpa memeriksa launchTime
    if (isFirstRun) {
      prefs.setBool('open_goalset_first_run',
          false); // Set status bahwa fungsi ini sudah dijalankan
      return true;
    }

    // Jika ini bukan run pertama, lanjutkan dengan pemeriksaan launchTime
    GoalSettingState goalSettingState = GoalSettingState();
    int launchTime = goalSettingState.selectedMinute;

    // Mendapatkan nama aplikasi yang sedang berjalan
    String runningApp = await getRunningApp();
    if (runningApp.isEmpty) return false;

    // Mendapatkan indeks aplikasi yang dipilih
    int selectedIndex = await getSelectedAppIndex();
    if (selectedIndex == -1) return false;

    // Memeriksa apakah aplikasi yang dipilih sama dengan aplikasi yang berjalan
    if (socialApps[selectedIndex].appName == runningApp) {
      // Memeriksa waktu penggunaan aplikasi
      DateTime endTime = DateTime.now();
      DateTime startTime = endTime.subtract(Duration(minutes: launchTime));
      List<UsageInfo> usageInfos =
          await UsageStats.queryUsageStats(startTime, endTime);
      for (var info in usageInfos) {
        if (info.packageName == runningApp) {
          // Jika waktu penggunaan aplikasi lebih dari yang telah ditentukan, kembalikan true
          if (info.totalTimeInForeground != null &&
              int.tryParse(info.totalTimeInForeground!) != null) {
            int timeInForegroundInMilliseconds =
                int.parse(info.totalTimeInForeground!);
            if (timeInForegroundInMilliseconds >= launchTime * 60 * 1000) {
              return true;
            }
          }
        }
      }
    }

    // Jika tidak memenuhi kondisi, kembalikan false
    return false;
  }

  Future<String> getRunningApp() async {
    try {
      // Panggil fungsi getForegroundApp dari kelas AppUsage melalui MethodChannel
      final String runningApp = await AppUsage.getForegroundApp();
      return runningApp;
    } on PlatformException catch (e) {
      logger.d(e.message);
      return '';
    }
  }

  Future<String> getUsageTime() async {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate
        .subtract(const Duration(days: 1)); // Misalnya untuk 1 hari terakhir

    // Minta izin penggunaan
    await UsageStats.grantUsagePermission();

    // Periksa izin
    bool? isPermissionGranted = await UsageStats.checkUsagePermission();

    if (isPermissionGranted ?? false) {
      // Dapatkan statistik penggunaan
      List<UsageInfo> usageStats =
          await UsageStats.queryUsageStats(startDate, endDate);

      // Hitung total waktu penggunaan
      int totalMilliseconds = 0;
      for (var info in usageStats) {
        totalMilliseconds += int.parse(info.totalTimeInForeground!);
      }

      int totalSeconds = (totalMilliseconds ~/ 1000).toInt();
      int hours = totalSeconds ~/ 3600;
      int minutes = (totalSeconds % 3600) ~/ 60;

      return '$hours jam $minutes menit';
    } else {
      return 'Tidak ada izin penggunaan';
    }
  }

  Future<String> getLastTimeUsed() async {
    DateTime? lastTimeUsed;

    DateTime endDate = DateTime.now();
    DateTime startDate = endDate
        .subtract(const Duration(days: 1)); // Misalnya untuk 1 hari terakhir

    // Minta izin penggunaan
    await UsageStats.grantUsagePermission();

    // Periksa izin
    bool? isPermissionGranted = await UsageStats.checkUsagePermission();

    if (isPermissionGranted ?? false) {
      // Dapatkan statistik penggunaan
      List<UsageInfo> usageStats =
          await UsageStats.queryUsageStats(startDate, endDate);

      // Temukan waktu terakhir digunakan dari statistik penggunaan
      for (var info in usageStats) {
        if (info.lastTimeUsed != null) {
          int lastTimeUsedInMillis = int.parse(info.lastTimeUsed!);
          if (lastTimeUsed == null ||
              lastTimeUsedInMillis > lastTimeUsed.millisecondsSinceEpoch) {
            lastTimeUsed =
                DateTime.fromMillisecondsSinceEpoch(lastTimeUsedInMillis);
          }
        }
      }

      // Hitung waktu yang telah berlalu
      if (lastTimeUsed != null) {
        Duration difference = DateTime.now().difference(lastTimeUsed);
        if (difference.inDays > 0) {
          return 'last time used: ${difference.inDays} days ago';
        } else if (difference.inHours > 0) {
          return 'last time used: ${difference.inHours} hours ago';
        } else if (difference.inMinutes > 0) {
          return 'last time used: ${difference.inMinutes} minutes ago';
        } else {
          return 'last time used: just now';
        }
      } else {
        return 'last time used: unknown';
      }
    } else {
      return 'last time used: no permission granted';
    }
  }

  Future<int> getSelectedAppIndex() async {
    for (int i = 0; i < socialApps.length; i++) {
      bool isChecked = appPrefs.getBool('app_$i') ?? false;
      if (isChecked) return i;
    }
    return -1;
  }

  @override
  void initState() {
    super.initState();
    socialAppsFuture = loadSocialApps();
    _context = context;
    checkPermissions();
    initializeData();
  }

  Future<void> initializeData() async {
    appPrefs = await SharedPreferences.getInstance();
    await loadSocialApps();
  }

  Future<List<Application>?>? socialAppsFuture;

  List<Application> socialApps = [];

  List<bool> isChecked = [];

  Future<List<Application>?> loadSocialApps() async {
    try {
      final loadedSocialApps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
      );

      socialApps = loadedSocialApps
          .where((app) => [
                'Instagram',
                'Facebook',
                'Twitter',
                'WhatsApp',
                'Snapchat',
                'LinkedIn',
                'YouTube',
                'Tik Tok'
              ].contains(app.appName))
          .toList();

      isChecked = await loadCheckboxState();

      logger.d('Finished loading social apps : $socialApps');

      return socialApps;
    } catch (e) {
      logger.e('Error in loadSocialApps(): $e');
      return null;
    }
  }

  late SharedPreferences appPrefs;
  //Untuk memuat atau mengambil status checkbox yang telah disimpan sebelumnya dari SharedPreferences. Fungsi ini dipanggil saat aplikasi dimulai (di initState
  //mengatur nilai awal dari setiap checkbox berdasarkan status yang disimpan sebelumnya.
  Future<List<bool>> loadCheckboxState() async {
    try {
      List<bool> savedState = [];
      for (int i = 0; i < socialApps.length; i++) {
        bool? value = appPrefs.getBool(socialApps[i].appName);
        if (value != null) {
          savedState.add(value);
        } else {
          //kalo null value checkboxnya
          savedState.add(true);
        }
      }
      logger.d('Loaded checkbox state: $savedState');
      return savedState;
    } catch (e) {
      logger.e('Error in loadCheckboxState(): $e');
      return List.generate(socialApps.length,
          (index) => true); // return default value in case of error
    }
  }

  Future<void> saveCheckboxState(int index, bool value) async {
    try {
      if (index < isChecked.length) {
        if (socialApps.isNotEmpty) {
          if (index >= 0 && index < socialApps.length) {
            isChecked[index] = value;
            await appPrefs.setBool(socialApps[index].appName, isChecked[index]);
            //                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            // Memperbaiki agar nilai isChecked disimpan, bukan nilai baru dari argumen value
            logger.d('Saved checkbox state: ${isChecked[index]}');
          } else {
            logger.e('Error: Index out of range');
          }
        } else {
          logger.e('Error: Social apps list is null or empty');
        }
      } else {
        logger.e('Error: isChecked list is null or empty');
      }
    } catch (e) {
      logger.e('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard Settings',
          style: GoogleFonts.manrope(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Tcolor.primaryTextW,
          ),
        ),
        centerTitle: true,
        backgroundColor: Tcolor.primary,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(15),
        )),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder<List<Application>?>(
          future: socialAppsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Application>? socialApps = snapshot.data!;
              //! builder
              return ListView.separated(
                shrinkWrap: true,
                itemCount: socialApps.length,
                itemBuilder: (BuildContext context, int index) {
                  final app = socialApps[index];
                  //! the box
                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color.fromARGB(255, 229, 229,
                            229), // Ubah dengan warna yang diinginkan
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF35385A).withOpacity(.12),
                          blurRadius: 30,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: app is ApplicationWithIcon
                                          ? Image.memory(app.icon)
                                          : const Placeholder(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          app.appName,
                                          style: GoogleFonts.manrope(
                                            textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 56, 56, 56),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        FutureBuilder<String>(
                                          future: getUsageTime(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Text(
                                                "",
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontFamily: 'Manrope',
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              return Text(
                                                snapshot.data!,
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontFamily: 'Manrope',
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isChecked[index] = !isChecked[index];
                                  try {
                                    saveCheckboxState(index, isChecked[index]);
                                  } catch (e) {
                                    logger.e('Error in saveCheckboxState: $e');
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                height: 35,
                                padding: const EdgeInsets.all(5),
                                duration: const Duration(milliseconds: 100),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isChecked[index]
                                        ? Colors.green.shade100
                                        : Colors.red.shade300,
                                  ),
                                ),
                                child: Center(
                                  child: isChecked[index]
                                      ? const Icon(FeatherIcons.checkSquare,
                                          color: Colors.green)
                                      : Icon(FeatherIcons.circle,
                                          color: Colors.red.shade600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 70),
                                child: const Row(
                                  children: [
                                    UsageTimeWidget(),
                                  ],
                                ),
                              ),
                            ),
                            FutureBuilder<String>(
                              future: getLastTimeUsed(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    "",
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontFamily: 'Manrope',
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Text(
                                    snapshot.data!,
                                    style: GoogleFonts.manrope(
                                      color: Colors.grey.shade800,
                                      fontSize: 12,
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const Divider(height: 10, color: Colors.transparent),
              );
            }
          },
        ),
      ),
    );
  }
}



//TODO : only medsos, di simpen jadi ga loading ulang pake sharedpref, sama.. ui nya
//TODO : BE MINDFUL, and AWARE, THERE'S A REAL
