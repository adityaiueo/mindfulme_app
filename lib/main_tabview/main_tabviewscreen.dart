import 'package:flutter/material.dart';
import 'package:mindfulme_app/common_widget/tab_button.dart';
import 'package:mindfulme_app/screen/home_page.dart';
import 'package:mindfulme_app/feature/mindful_page.dart';
import 'package:mindfulme_app/feature/twenty_page.dart';

class MainTabViewScreen extends StatefulWidget {
  const MainTabViewScreen({super.key});

  @override
  State<MainTabViewScreen> createState() => _MainTabViewScreenState();
}

class _MainTabViewScreenState extends State<MainTabViewScreen>  with SingleTickerProviderStateMixin {
  TabController? controller;
  int selectTab = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this);
    controller?.addListener(() {
      selectTab = controller?.index ?? 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: controller, children: const [
        MainHome(),
        MindfulPage(),
        TwentyPage(),
      ]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 15),
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
                title: "Mindfulness",
                isSelect: selectTab == 1,
                onPressed: () {
                  changeTab(1);
                }),
            TabButton(
                icon: "assets/img/eye.png",
                title: "20-20-20",
                isSelect: selectTab == 2,
                onPressed: () {
                  changeTab(2);
                })
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
