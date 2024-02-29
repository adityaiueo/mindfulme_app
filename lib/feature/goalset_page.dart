import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class DurationPicker extends StatefulWidget {
  const DurationPicker({super.key});

  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  int _selectedMinute = 5; // Menit default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Minute'),
      ),
      body: Container(
        color: Colors.grey[300], // Warna latar belakang abu-abu
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_selectedMinute minutes',
              style: const TextStyle(fontSize: 20.0),
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
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
            ReminderFeature(selectedMinute: _selectedMinute),
          ],
        ),
      ),
    );
  }
}

class ReminderFeature extends StatelessWidget {
  final int selectedMinute;
  final TextEditingController _controller = TextEditingController();

  ReminderFeature({super.key, required this.selectedMinute});

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      throw Exception('Location services are disabled. turn on your location and enable your permission');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reminder Message:',
          style: TextStyle(fontSize: 16.0),
        ),
        const SizedBox(height: 10.0),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Enter your reminder message here...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () async {
            final reminderText = _controller.text;
            if (reminderText.isNotEmpty) {
              // Mendapatkan lokasi pengguna
              Position position = await _getCurrentLocation();
              // Mendapatkan zona waktu dari lokasi pengguna
              String timeZoneId = await _getTimeZone(position);
              // Mengonversi waktu saat ini ke dalam zona waktu pengguna
              final userLocation = getLocation(timeZoneId);
              final now = TZDateTime.now(userLocation);

              scheduleNotification(
                  selectedMinute ~/ 2, reminderText, now, timeZoneId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reminder set successfully')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a reminder message')),
              );
            }
          },
          child: const Text('Set Reminder'),
        ),
      ],
    );
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
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reminder_channel', // ID channel
      'Reminder Channel', // Nama channel
      channelDescription:
          'Channel for reminder notifications', // Deskripsi channel
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    final scheduledTime = now.add(Duration(minutes: durationInMinutes));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // ID notifikasi
      'Reminder', // Judul notifikasi
      'Ingat tujuanmu: $message', // Pesan notifikasi
      scheduledTime, // Waktu penjadwalan
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: timeZoneId,
    );
  }
}
