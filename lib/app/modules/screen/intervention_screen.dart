import 'package:flutter/material.dart';
import 'package:mindfulme_app/app/common/color_extension.dart';
import 'package:logger/logger.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class InterventionScreen extends StatefulWidget {
  const InterventionScreen({super.key});

  @override
  State<InterventionScreen> createState() => InterventionScreenState();
}

class InterventionScreenState extends State<InterventionScreen> {
  List<Map<String, dynamic>> items = [
    {
      'imagePath': 'assets/img/mindfulness2.png',
      'serviceName': 'Mindfulness',
      'serviceDetails': ['type :'],
      'info': 'Click for details',
      'type': 'Therapy Based'
    },
    {
      'imagePath': 'assets/img/goalset.png',
      'serviceName': 'Goal Setting',
      'serviceDetails': ['type :'],
      'info': 'Click for details',
      'type': 'Usage Management'
    },
    {
      'imagePath': 'assets/img/twenty.png',
      'serviceName': '20-20-20 Rule',
      'serviceDetails': ['type :'],
      'info': 'Click for details',
      'type': 'Eye Healthcare'
    },
  ];


  void onTapHandler(int index) async {
    // mark the function as async
    switch (index) {
      case 0:
        const url = 'mindfulme-app://open.mindfulme.app/mindful';
        final sanitizedUrl = url.trim();
        logger.d('URL: $sanitizedUrl');
        try {
          final Uri uri = Uri.parse(sanitizedUrl);
          final bool launchable = await canLaunchUrl(uri);
          if (launchable) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            logger.t('Could not launch $sanitizedUrl');
          }
        } catch (e) {
          logger.t('Invalid URL: $sanitizedUrl');
        }
        break;
      case 1:
        context.go('/goalsetd');
        break;
      case 2:
        context.go('/twentyd');
        break;
    }
  }

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              expandedHeight: MediaQuery.of(context).size.width * 0.6,
              flexibleSpace: FlexibleSpaceBar(
                background: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Image.asset(
                    "assets/img/sun.png",
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Interventions",
                      style: GoogleFonts.manrope(
                        color: Tcolor.primaryText,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Learn More About : ",
                      style: GoogleFonts.manrope(
                        color: Tcolor.primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 17),
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = items[index];
                  String imagePath = item['imagePath'] ?? '';
                  String serviceName = item['serviceName'] ?? '';
                  List<String> serviceDetails = item['serviceDetails'] ?? [];
                  String info = item['info'] ?? '';
                  String type = item['type'] ?? '';
                  return InkWell(
                      onTap: () {
                        switch (index) {
                          case 0:
                            onTapHandler(0);
                            break;
                          case 1:
                            context.go('/goalsetd');
                            break;
                          case 2:
                            context.go('/twentyd');
                            break;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF35385A).withOpacity(.12),
                              blurRadius: 30,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                imagePath,
                                width: 88,
                                height: 103,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    serviceName,
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF3F3E3F),
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  RichText(
                                    text: TextSpan(
                                      text:
                                          "Intervention ${serviceDetails.join(', ')}",
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    children: [
                                      Text(
                                        type,
                                        style: GoogleFonts.manrope(
                                          color: const Color(0xFF50CC98),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    children: [
                                      const Icon(
                                        FeatherIcons.info,
                                        size: 14,
                                        color: Color(0xFFACA3A3),
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        info,
                                        style: GoogleFonts.manrope(
                                          fontSize: 12,
                                          color: const Color(0xFFACA3A3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                },
                separatorBuilder: (context, index) =>
                    const Divider(height: 12, color: Colors.transparent),
                itemCount: items.length,
              )
            ],
          ),
        ),
      ),
    );
  }
}
