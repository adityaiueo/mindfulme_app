import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:mindfulme_app/main_tabview/main_tabviewscreen.dart';
import 'package:mindfulme_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindfulme_app/screen/intro_page.dart'; 
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isIntroShown = prefs.getBool('isIntroShown');
  
  runApp(
    DevicePreview(
      builder: (context) => MyApp(isIntroShown: isIntroShown ?? false),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isIntroShown;

  const MyApp({Key? key, required this.isIntroShown}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Intro Screen',
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 30,
            color: MyColors.titleTextColor,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            fontSize: 18,
            color: MyColors.subTitleTextColor,
            fontWeight: FontWeight.w400,
            wordSpacing: 1.2,
            height: 1.2,
          ),
          displaySmall: TextStyle(
            fontSize: 18,
            color: MyColors.titleTextColor,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: isIntroShown ? const MainTabViewScreen() : const IntroPage(),
    );
  }
}

class GetRunningApp extends StatefulWidget {
  const GetRunningApp({super.key});

  @override
  State<GetRunningApp> createState() => _GetRunningAppState();
}

class _GetRunningAppState extends State<GetRunningApp> {
    // Membuat platform channel dengan nama 'getRunningApps'
  static const platform = MethodChannel('getRunningApps');

  // Menjadikan bidang runningApps late jika Anda ingin menginisialisasinya nanti
  late List<String> runningApps;

  @override
  void initState() {
    super.initState();
    runningApps = [];
  }

  Future<void> getRunningApps() async {
    try {
      final List<dynamic> result =
          await platform.invokeMethod('getRunningApps');
      setState(() {
        runningApps = result.cast<String>();
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Get Running Apps Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: getRunningApps,
                child: Text('Get Running Apps'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: runningApps.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(runningApps[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
