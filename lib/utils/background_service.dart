import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:mindfulme_app/screen/homepage_screen.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:logging/logging.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
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

  // Definisikan dan implementasikan UrlDeepLinkLauncher di dalam MyApp
  final logger = Logger('UrlDeepLinkLauncher'); // Definisikan _logger di sini

  // Fungsi untuk membuka URL khusus dari aplikasi
  HomePageState homePageState = HomePageState();

  Future<void> shouldOpenPage() async {
    bool shouldOpenMindfulPage = await homePageState.openMindfulPageIfNeeded();
    bool shouldOpenTwentyPage = await homePageState.openTwentyPageIfNeeded();
    bool shouldOpenGoalset = await homePageState.openGoalsetPageIfNeeded();

    //ngelaunch mindfulpage
    if (shouldOpenMindfulPage) {
      const url = 'mindfulme_app://mindful';
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        logger.warning('Could not launch $url');
      }
      //launching twenty page
    } else if (shouldOpenTwentyPage) {
      const url = 'mindfulme_app://twenty';
      Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        logger.warning('Could not launch $url');
      }
      //ngelaunch goalset page
    } else if (shouldOpenGoalset) {
      const url = 'mindfulme_app://goalset';
      Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        logger.warning('Could not launch $url');
      }
    }
  }

  shouldOpenPage();
}
