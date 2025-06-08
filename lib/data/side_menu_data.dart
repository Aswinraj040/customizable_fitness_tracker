import 'package:customizable_fitness_tracker/model/menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.dashboard, title: 'Dashboard'),            // Dashboard overview
    MenuModel(icon: Icons.fitness_center, title: 'Workout Logging'), // Logging workouts
    MenuModel(icon: Icons.flag, title: 'Goal Setting'),              // Goal target
  ];
}
