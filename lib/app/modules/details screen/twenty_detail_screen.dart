import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TwentyDetailScreen extends StatefulWidget {
  const TwentyDetailScreen({super.key});

  @override
  State<TwentyDetailScreen> createState() => _TwentyDetailScreenState();
}

class _TwentyDetailScreenState extends State<TwentyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              '20-20-20 Rule Details',
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
                        'The 20-20-20 Rule',
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'What is it?',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      buildDescriptionBox(
                        context,
                        'English',
                        'The 20-20-20 rule is a simple guideline to help reduce eye strain that can occur from staring at screens for prolonged periods. It suggests that every 20 minutes, you should take a 20-second break and focus on something at least 20 feet away.',
                        'Bahasa Indonesia',
                        'Aturan 20-20-20 adalah pedoman sederhana untuk membantu mengurangi ketegangan mata yang dapat terjadi karena menatap layar untuk waktu yang lama. Aturan ini menyarankan bahwa setiap 20 menit, Anda harus mengambil istirahat selama 20 detik dan fokus pada sesuatu yang setidaknya 20 kaki jauhnya.',
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Why is it important?',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      buildDescriptionBox(
                        context,
                        'English',
                        'Following the 20-20-20 rule can help prevent digital eye strain, which may cause symptoms like dry eyes, headaches, and blurred vision. By taking regular breaks and allowing your eyes to rest, you can reduce the risk of experiencing these discomforts and maintain better eye health.',
                        'Bahasa Indonesia',
                        'Mengikuti aturan 20-20-20 dapat membantu mencegah ketegangan mata digital, yang dapat menyebabkan gejala seperti mata kering, sakit kepala, dan penglihatan kabur. Dengan mengambil istirahat secara teratur dan membiarkan mata Anda beristirahat, Anda dapat mengurangi risiko mengalami ketidaknyamanan ini dan menjaga kesehatan mata yang lebih baik.',
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
