import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class GoalsetDetailScreen extends StatefulWidget {
  const GoalsetDetailScreen({super.key});

  @override
  State<GoalsetDetailScreen> createState() => _GoalsetDetailScreenState();
}

class _GoalsetDetailScreenState extends State<GoalsetDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Goal Setting & Usage Management',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                context.go('/');
              },
              icon: const Icon(FeatherIcons.arrowLeft),
              color: Colors.black,
            ),
            floating: true,
            snap: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            expandedHeight: 15,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Goal Setting & Usage Management',
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Goal Setting',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      buildDescriptionBox(
                        context,
                        'Pengaturan Tujuan',
                        'Pengaturan tujuan adalah proses menentukan tujuan atau target yang ingin dicapai oleh individu atau organisasi. Ini melibatkan mengidentifikasi tujuan yang spesifik, terukur, dapat dicapai, relevan, dan berbatas waktu (SMART) untuk memandu tindakan dan melacak kemajuan.',
                        'Manajemen Penggunaan',
                        'Manajemen penggunaan merujuk pada strategi dan teknik yang digunakan untuk mengatur dan mengontrol jumlah waktu yang dihabiskan di platform media sosial dan teknologi digital lainnya. Ini memainkan peran penting dalam mengurangi kecanduan media sosial, yang dapat menyebabkan konsekuensi negatif seperti penurunan produktivitas, gangguan interaksi sosial, dan masalah kesehatan mental.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDescriptionBox(
    BuildContext context,
    String language1,
    String description1,
    String language2,
    String description2,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLanguageOption(FeatherIcons.flag, language1),
          const SizedBox(height: 10),
          Text(
            description1,
            style: GoogleFonts.manrope(fontSize: 14),
          ),
          const SizedBox(height: 20),
          buildLanguageOption(FeatherIcons.flag, language2),
          const SizedBox(height: 10),
          Text(
            description2,
            style: GoogleFonts.manrope(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget buildLanguageOption(IconData icon, String language) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text(
          language,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
