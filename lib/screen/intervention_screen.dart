import 'package:flutter/material.dart';
import 'package:mindfulme_app/common/color_extension.dart';
import 'package:mindfulme_app/common_widget/round_button.dart';
import 'package:logger/logger.dart';

class InterventionScreen extends StatefulWidget {
  const InterventionScreen({super.key});

  @override
  State<InterventionScreen> createState() => InterventionScreenState();
}

class InterventionScreenState extends State<InterventionScreen> {
  final Logger logger = Logger();
  
  Future<int?> showTimePickerDialog({required int defaultTime}) async {
    int? selectedTime = defaultTime; // Default selected time

    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Set Time You Want to Get Mindfulness',
            style: TextStyle(
              color: Tcolor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Helvetica',
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Get mindfulness after :',
                    style: TextStyle(
                      color: Tcolor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Helvetica',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: selectedTime?.toDouble() ?? 1, // Null-aware access
                    min: 1,
                    max: 30,
                    divisions: 29, // Number of discrete divisions
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value.toInt();
                      });
                    },
                  ),
                  Text(
                    '$selectedTime minutes',
                    style: TextStyle(
                      color: Tcolor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Helvetica',
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            RoundButton(
              title: 'Save Your Settings',
              type: RoundButtonType.secondary,
              onPressed: () {
                Navigator.of(context).pop(selectedTime);
              },
            ),
          ],
        );
      },
    );
  }

  Future<int?> showDurationPickerDialog(BuildContext context) async {
    int? selectedDuration = 15; // Default selected duration

    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Select Duration of Breathing',
            style: TextStyle(
              color: Tcolor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Helvetica',
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Choose breathing duration (seconds):',
                    style: TextStyle(
                      color: Tcolor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Helvetica',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: selectedDuration!.toDouble(),
                    min: 1,
                    max: 60,
                    divisions: 59, // Number of discrete divisions
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value.toInt();
                      });
                    },
                  ),
                  Text(
                    '$selectedDuration seconds',
                    style: TextStyle(
                      color: Tcolor.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Helvetica',
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            RoundButton(
              title: 'Save Your Settings',
              type: RoundButtonType.secondary,
              onPressed: () {
                Navigator.of(context).pop(selectedDuration);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Image.asset(
                    "assets/img/1.png",
                    width: 55,
                    height: 55,
                  ),
                ),
              ),
              expandedHeight: context.width * 0.6,
              flexibleSpace: FlexibleSpaceBar(
                background: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Image.asset(
                    "assets/img/1.png",
                    width: context.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mindfulness",
                      style: TextStyle(
                        color: Tcolor.primaryText,
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Helvetica'
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Intervention",
                      style: TextStyle(
                        color: Tcolor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Ease The mind bla bla bla",
                      style: TextStyle(
                        color: Tcolor.primaryText,
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                        color: Tcolor.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Helvetica'
                      ),
                    )
                  ],
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return InkWell(
                      onTap: () async {
                        int? selectedTime =
                            await showDurationPickerDialog(context);
                        if (selectedTime != null) {
                          // Do something with the selected time
                          logger.d(
                              'Selected Time for Duration of Breathing: $selectedTime seconds');

                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Duration of Breathing",
                                    style: TextStyle(
                                      color: Tcolor.primaryText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Helvetica'
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    );
                  } else if (index == 1) {
                    return InkWell(
                      onTap: () async {
                        int? selectedTime =
                            await showTimePickerDialog(defaultTime: 15);
                        if (selectedTime != null) {
                          // Do something with the selected time
                          logger.d(
                              'Selected Time for Duration of Breathing: $selectedTime seconds');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Time to Mindfulness",
                                    style: TextStyle(
                                      color: Tcolor.primaryText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Helvetica'
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(); // Return an empty container for other indices
                  }
                },
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                ),
                itemCount: 2, // Assuming there are only two items in the list
              )
            ],
          ),
        ),
      ),
    );
  }
}
