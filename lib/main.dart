import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:mindfulme_app/common_widget/permission_box.dart';
import 'package:mindfulme_app/feature/goalset_page.dart';
import 'package:mindfulme_app/feature/mindful_page.dart';
import 'package:mindfulme_app/feature/twenty_page.dart';
import 'package:mindfulme_app/main_tabview/main_tabviewscreen.dart';
import 'package:mindfulme_app/utils/notification_controller.dart';
import 'package:mindfulme_app/utils/background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindfulme_app/screen/intro_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();

  AwesomeNotifications().initialize(
    'resource', //! Icon aplikasi
    [
      NotificationChannel(
        channelKey: 'reminder_channel',
        channelName: 'Reminder Channel',
        channelDescription: 'Channel for reminder notifications',
        defaultColor: const Color.fromARGB(255, 175, 111, 186),
        ledColor: Colors.white,
      ),
    ],
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isIntroShown = prefs.getBool('isIntroShown') ?? false;

  runApp(
    DevicePreview(
      enabled: true,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => MyApp(isIntroShown: isIntroShown),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isIntroShown;
  const MyApp({super.key, required this.isIntroShown});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Intro Screen',
      initialRoute: widget.isIntroShown ? 'home' : 'intro',
      home: widget.isIntroShown
          ? const MainTabViewScreen()
          : const IntroPageScreen(),

      //! INI ADALAH RUTE KE PAGENYA
      routes: {
        'intro': (context) => const IntroPageScreen(),
        'home': (context) => const MainTabViewScreen(),
        '/goalset': (context) => const GoalSetting(),
        '/mindful': (context) => const MindfulPage(),
        '/twenty': (context) => const TwentyPage(),
      },
      // Buat fungsi untuk menentukan halaman mana yang akan dibuka berdasarkan URL khusus
      onGenerateRoute: (settings) {
        // Dapatkan nama path dari URL khusus
        String path = Uri.parse(settings.name!).path;

        // Gunakan switch case atau if else untuk menentukan halaman mana yang akan dibuka
        switch (path) {
          case '/mindful': // Ganti '/page1' dengan '/mindful'
            return MaterialPageRoute(builder: (context) => const MindfulPage());
          case '/twenty': // Ganti '/page2' dengan '/twenty'
            return MaterialPageRoute(builder: (context) => const TwentyPage());
          case '/goalset': // Tambahkan '/goalset' sebagai case baru
            return MaterialPageRoute(builder: (context) => const GoalSetting());
          default:
            // Halaman default jika path tidak cocok
            return MaterialPageRoute(
                builder: (context) => const MainTabViewScreen());
        }
      },

      builder: (context, child) {
        return Scaffold(
          body: PermissionBox(
            // Gunakan PermissionBox di luar home
            imagePath: 'assets/notification_icon.png', // Path ikon notifikasi
            message: 'This app needs permission to send notifications '
                'so that you can get the goal settings feature.', // Pesan yang ingin ditampilkan
            onContinuePressed: () async {
              await AwesomeNotifications()
                  .requestPermissionToSendNotifications();
            },
          ),
        );
      },
    );
  }
}
