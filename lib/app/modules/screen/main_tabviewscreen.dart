import 'package:flutter/material.dart';
import 'package:mindfulme_app/app/widgets/tab_button.dart';
import 'package:mindfulme_app/app/modules/screen/homepage_screen.dart';
import 'package:mindfulme_app/app/modules/screen/intervention_screen.dart';

class MainTabViewScreen extends StatefulWidget {
  const MainTabViewScreen({super.key});

  @override
  State<MainTabViewScreen> createState() => _MainTabViewScreenState();
}

class _MainTabViewScreenState extends State<MainTabViewScreen>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  int selectTab = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller?.addListener(() {
      selectTab = controller?.index ?? 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: controller, children: const [
        HomePage(),
        InterventionScreen(),
      ]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 10),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -4))
        ]),
        child: SafeArea(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TabButton(
                icon: "assets/img/home.png",
                title: "Dashboard",
                isSelect: selectTab == 0,
                onPressed: () {
                  changeTab(0);
                }),
            TabButton(
                icon: "assets/img/apps.png",
                title: "Interventions",
                isSelect: selectTab == 1,
                onPressed: () {
                  changeTab(1);
                }),
          ],
        )),
      ),
    );
  }

  void changeTab(int index) {
    selectTab = index;
    controller?.animateTo(index);
    setState(() {});
  }
}
