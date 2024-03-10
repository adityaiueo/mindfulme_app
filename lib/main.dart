import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:mindfulme_app/app/modules/details%20screen/goalset_detail_screen.dart';
import 'package:mindfulme_app/app/modules/details%20screen/mindfulness_detail_screen.dart';
import 'package:mindfulme_app/app/modules/details%20screen/twenty_detail_screen.dart';
import 'package:mindfulme_app/app/modules/feature_page/goalset_page.dart';
import 'package:mindfulme_app/app/modules/feature_page/mindful_page.dart';
import 'package:mindfulme_app/app/modules/feature_page/twenty_page.dart';
import 'package:mindfulme_app/app/modules/screen/homepage_screen.dart';
import 'package:mindfulme_app/app/modules/screen/intervention_screen.dart';
import 'package:mindfulme_app/app/modules/screen/main_tabviewscreen.dart';
import 'package:mindfulme_app/app/utils/notification_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:logging/logging.dart';

import 'dart:async';
import 'package:uni_links/uni_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();

  AwesomeNotifications().initialize(
    'resource://drawable/goalset',
    [
      NotificationChannel(
        channelKey: 'reminder_channel',
        channelName: 'Reminder Channel',
        channelDescription: 'Channel for reminder notifications',
        defaultColor: const Color.fromARGB(255, 255, 255, 255),
        ledColor: Colors.white,
      ),
    ],
  );

  runApp(
    DevicePreview(
      enabled: false,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => const MyApp(),
    ),
  );
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  DartPluginRegistrant.ensureInitialized();

  AwesomeNotifications().initialize(
    'resource://drawable/goalset',
    [
      NotificationChannel(
        channelKey: 'reminder_channel',
        channelName: 'Reminder Channel',
        channelDescription: 'Channel for reminder notifications',
        defaultColor: const Color.fromARGB(255, 255, 255, 255),
        ledColor: Colors.white,
      ),
    ],
  );

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  HomePageState homePageState = HomePageState();
  bool shouldOpenMindfulPage = await homePageState.openMindfulPageIfNeeded();
  bool shouldOpenTwentyPage = await homePageState.openTwentyPageIfNeeded();
  bool shouldOpenGoalset = await homePageState.openGoalsetPageIfNeeded();

  if (shouldOpenMindfulPage) {
    service.invoke("openPage", {"page": "/mindful"});
  }
  if (shouldOpenTwentyPage) {
    service.invoke("openPage", {"page": "/twenty"});
  }
  if (shouldOpenGoalset) {
    service.invoke("openPage", {"page": "/goalset"});
  }

  Logger.detached('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late final GoRouter _router;
  StreamSubscription? _sub;

  final logger = Logger('UrlDeepLinkLauncher');

  void _handleIncomingLink(Uri uri) {
    // Parse the link and navigate to the correct screen using GoRouter
    Logger.detached('uri nya : $uri');
    switch (uri.path) {
      case '/':
        _router.go('/');
        break;
      case '/goalset':
        _router.go('/goalset');
        break;
      case '/mindful':
        _router.go('/mindful');
        break;
      case '/twenty':
        _router.go('/twenty');
        break;
      case '/twentyd':
        _router.go('/twentyd');
        break;
      case '/mindfuld':
        _router.go('/mindfuld');
        break;
      case '/goalsetd':
        _router.go('/goalsetd');
        break;
      case '/intervention':
        _router.go('/intervention');
        break;
      default:
        _router.go('/');
    }
  }

  @override
  void initState() {
    super.initState();
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleIncomingLink(uri);
      }
    }, onError: (err) {
      logger.warning(err);
    });

    _sub = FlutterBackgroundService().on('openPage').listen((event) async {
      String page = event!["page"];
      String url = 'mindfulme-app://open.mindfulme.app/$page';
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        logger.warning('Could not launch $url');
      }
    });

    _router = GoRouter(
      initialLocation: '/',
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const MainTabViewScreen();
          },
        ),
        GoRoute(
          path: '/goalset',
          builder: (context, state) {
            return const GoalSetting();
          },
        ),
        GoRoute(
          path: '/mindful',
          builder: (context, state) {
            return const MindfulPage();
          },
        ),
        GoRoute(
          path: '/twenty',
          builder: (context, state) {
            return const TwentyPage();
          },
        ),
        GoRoute(
          path: '/twentyd',
          builder: (context, state) {
            return const TwentyDetailScreen();
          },
        ),
        GoRoute(
          path: '/mindfuld',
          builder: (context, state) {
            return const MindfulnessDetailScreen();
          },
        ),
        GoRoute(
          path: '/goalsetd',
          builder: (context, state) {
            return const GoalsetDetailScreen();
          },
        ),
        GoRoute(
          path: '/intervention',
          builder: (context, state) {
            return const InterventionScreen();
          },
        ),
      ],
    );

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
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
