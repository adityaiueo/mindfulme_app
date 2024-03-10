import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindfulme_app/app/common/color_extension.dart';
import 'package:usage_stats/usage_stats.dart';

class UsageTimeWidget extends StatelessWidget {
  const UsageTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUsageTime(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
              ''); // Menampilkan loading indicator jika data masih dimuat
        } else {
          if (snapshot.hasData) {
            int totalHours = extractTotalHours(snapshot.data!);
            String text = getText(totalHours);
            Color color = getColor(totalHours);
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color.withAlpha(20),
              ),
              child: Text(
                text,
                style: GoogleFonts.manrope(
                  color: Tcolor.primaryTextW,
                ),
              ),
            );
          } else {
            return const Text(
                'Failed to get usage time'); // Menampilkan pesan jika gagal mendapatkan data
          }
        }
      },
    );
  }

  Future<String> getUsageTime() async {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(days: 1));

    await UsageStats.grantUsagePermission();

    bool? isPermissionGranted = await UsageStats.checkUsagePermission();

    if (isPermissionGranted ?? false) {
      List<UsageInfo> usageStats =
          await UsageStats.queryUsageStats(startDate, endDate);

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

  int extractTotalHours(String data) {
    List<String> parts = data.split(' ');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[2]);
    return hours +
        (minutes >= 30
            ? 1
            : 0); // Round up jika menit lebih dari atau sama dengan 30
  }

  String getText(int totalHours) {
    if (totalHours < 1) {
      return 'okay';
    } else if (totalHours < 2) {
      return 'beware';
    } else {
      return 'too much use';
    }
  }

  Color getColor(int totalHours) {
    if (totalHours < 1) {
      return Colors.lightGreen; // Warna ijo muda
    } else if (totalHours < 2) {
      return Colors.amber; // Warna kuning
    } else {
      return Colors.red; // Warna merah
    }
  }
}
