import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class MindfulnessDetailScreen extends StatelessWidget {
  const MindfulnessDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 249, 249, 249), // Background abu-abu
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Mindfulness Details',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Warna teks hitam
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                context.go(
                    '/'); 
              },
              icon: const Icon(FeatherIcons.arrowLeft),
              color: Colors.black, // Warna ikon hitam
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
                        'Mindfulness',
                        style: GoogleFonts.manrope(
                          fontSize: 20, // Mengurangi ukuran teks menjadi 20
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Warna teks hitam
                        ),
                      ),
                      Text(
                        'Therapy Based Intervention',
                        style: GoogleFonts.manrope(
                          fontSize: 13, // Mengurangi ukuran teks menjadi 13
                          fontWeight: FontWeight.bold,
                          color: Colors.grey, // Warna teks abu-abu
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Intervention details :',
                        style: GoogleFonts.manrope(
                          fontSize: 16, // Mengurangi ukuran teks menjadi 16
                          fontWeight: FontWeight.w500,
                          color: Colors.black, // Warna teks hitam
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildDescriptionBox(
                        context,
                        'Indonesia',
                        'Intervensi kecerdasan emosional adalah pendekatan yang bertujuan untuk membantu individu mengenali, memahami, dan mengelola emosi mereka secara efektif. Hal ini melibatkan pengembangan keterampilan seperti kesadaran diri, pengaturan emosi, empati, dan keterampilan sosial. Dengan meningkatkan kecerdasan emosional, seseorang dapat meningkatkan kemampuan untuk beradaptasi dengan stres, meningkatkan hubungan interpersonal, dan mengambil keputusan yang lebih baik dalam kehidupan sehari-hari.',
                        'English',
                        'Emotional intelligence intervention is an approach aimed at helping individuals recognize, understand, and manage their emotions effectively. It involves developing skills such as self-awareness, emotional regulation, empathy, and social skills. By enhancing emotional intelligence, one can improve their ability to cope with stress, enhance interpersonal relationships, and make better decisions in everyday life.',
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
        color: Colors.white, // Warna latar putih
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLanguageOption(FeatherIcons.flag, language1),
          const SizedBox(height: 10),
          Text(
            description1,
            style: GoogleFonts.manrope(
                fontSize: 14), // Mengurangi ukuran teks menjadi 14
          ),
          const SizedBox(height: 20),
          buildLanguageOption(FeatherIcons.flag, language2),
          const SizedBox(height: 10),
          Text(
            description2,
            style: GoogleFonts.manrope(
                fontSize: 14), // Mengurangi ukuran teks menjadi 14
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
            fontSize: 14, // Mengurangi ukuran teks menjadi 14
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
