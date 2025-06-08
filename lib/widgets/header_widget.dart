import 'package:customizable_fitness_tracker/const/constant.dart';
import 'package:customizable_fitness_tracker/util/responsive.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.menu,
                  color: Colors.grey,
                  size: 25,
                ),
              ),
            ),
          ),
        Expanded(
          child: Center(
            child: Text(
              'Welcome!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // To keep space on the right equal to left, add an empty SizedBox only for non-desktop
        if (!Responsive.isDesktop(context))
          const SizedBox(width: 45), // approx width of the menu icon + padding
      ],
    );
  }

}
