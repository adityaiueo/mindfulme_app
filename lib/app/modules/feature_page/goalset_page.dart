import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mindfulme_app/app/common/color_extension.dart';
import 'package:mindfulme_app/app/widgets/custom_snackbar.dart';
import 'package:mindfulme_app/app/widgets/round_button.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GoalSetting extends StatefulWidget {
  const GoalSetting({super.key});

  @override
  GoalSettingState createState() => GoalSettingState();
}

class GoalSettingState extends State<GoalSetting> {
  int _selectedMinute = 5; // Menit default
  final TextEditingController _controller = TextEditingController();

  int get selectedMinute => _selectedMinute;

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
          'Location services are disabled. turn on your location and enable your permission');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<String> _getTimeZone(Position position) async {
    // Mendapatkan zona waktu dari lokasi pengguna
    TZDateTime now = TZDateTime.from(
        DateTime.now(), getLocation(await timeZoneName(position)));
    return now.timeZoneName;
  }

  Future<String> timeZoneName(Position position) async {
    // Mendapatkan alamat berdasarkan koordinat
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // Mendapatkan zona waktu berdasarkan alamat
    var timeZone = getLocation(placemarks[0].administrativeArea!);
    return timeZone.name;
  }

  Future<void> scheduleNotification(int durationInMinutes, String message,
      TZDateTime now, String timeZoneId) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0, // ID notifikasi
        channelKey: 'reminder_channel', // ID channel
        title: 'Reminder', // Judul notifikasi
        body: 'Ingat tujuanmu: $message', // Pesan notifikasi
      ),
      actionButtons: [],
      schedule: NotificationInterval(
        interval: durationInMinutes, // Durasi interval dalam menit
        timeZone: timeZoneId, // Zona waktu
        repeats: false, // Tidak mengulang notifikasi
      ),
    );
  }

  void showCustomSnackBar(BuildContext context, {bool success = false}) {
    if (success) {
      CustomSnackBar.show(context,
          success: true, title: 'Great!', message: 'Selalu ingat tujuanmu ya');
    } else {
      CustomSnackBar.show(context,
          title: 'Tulis tujuanmu!',
          message: 'Tulis tujuanmu untuk menggunakan app ini');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Reminder'),
      ),
      body: Container(
        color: Colors.white, // Warna latar belakang abu-abu
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Set the reminder time in minutes',
              style: TextStyle(
                color: Tcolor.primaryText,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Helvetica',
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 100.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 60,
                itemBuilder: (context, index) {
                  final minute = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMinute = minute;
                      });
                    },
                    child: Container(
                      width: 60.0,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: minute == _selectedMinute
                            ? Colors.blue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        '$minute',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: minute == _selectedMinute
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            Slider(
              value: _selectedMinute.toDouble(),
              min: 1.0,
              max: 60.0,
              divisions: 59,
              label: '$_selectedMinute minutes',
              onChanged: (value) {
                setState(() {
                  _selectedMinute = value.toInt();
                });
              },
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminder Message:',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Tcolor.secondaryText,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Helvetica',
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your reminder message here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.purple),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.edit, color: Colors.purple),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      final reminderText = _controller.text;
                      if (reminderText.isNotEmpty) {
                        Position position = await _getCurrentLocation();
                        String timeZoneId = await _getTimeZone(position);
                        final userLocation = getLocation(timeZoneId);
                        final now = TZDateTime.now(userLocation);

                        scheduleNotification(_selectedMinute ~/ 2, reminderText,
                            now, timeZoneId);
                        showCustomSnackBar(context, success: true);
                      } else {
                        showCustomSnackBar(context);
                      }
                    },
                    child: const Text('Set Reminder'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            RoundButton(
              title: 'Confirm',
              onPressed: () async {
                final reminderText = _controller.text;
                if (reminderText.isNotEmpty) {
                  Position position = await _getCurrentLocation();
                  String timeZoneId = await _getTimeZone(position);
                  final userLocation = getLocation(timeZoneId);
                  final now = TZDateTime.now(userLocation);

                  scheduleNotification(
                      _selectedMinute ~/ 2, reminderText, now, timeZoneId);

                  showCustomSnackBar(context);
                } else {
                  showCustomSnackBar(context, success: true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
