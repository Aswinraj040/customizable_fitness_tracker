import 'package:customizable_fitness_tracker/util/responsive.dart';
import 'package:customizable_fitness_tracker/widgets/GoalSetting.dart';
import 'package:customizable_fitness_tracker/widgets/WorkoutLogging.dart';
import 'package:customizable_fitness_tracker/widgets/dashboard_widget.dart';
import 'package:customizable_fitness_tracker/widgets/side_menu_widget.dart';
import 'package:customizable_fitness_tracker/widgets/summary_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardWidget(),
    WorkoutLogging(),
    GoalSetting(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      drawer: !isDesktop
          ? SizedBox(
        width: 250,
        child: SideMenuWidget(
          selectedIndex: selectedIndex,
          onItemSelected: (index) {
            setState(() => selectedIndex = index);
            Navigator.pop(context); // close drawer on tap
          },
        ),
      )
          : null,
      endDrawer: Responsive.isMobile(context)
          ? SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: const SummaryWidget(),
      )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 2,
                child: SideMenuWidget(
                  selectedIndex: selectedIndex,
                  onItemSelected: (index) => setState(() => selectedIndex = index),
                ),
              ),
            Expanded(
              flex: 7,
              child: pages[selectedIndex],
            ),
            if (isDesktop)
              Expanded(
                flex: 3,
                child: const SummaryWidget(),
              ),
          ],
        ),
      ),
    );
  }
}
