import 'dart:convert';
import 'package:customizable_fitness_tracker/main.dart';
import 'package:customizable_fitness_tracker/screens/main_screen.dart';
import 'package:customizable_fitness_tracker/widgets/AddWorkoutPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Assume this page exists

class WorkoutLogging extends StatefulWidget {
  const WorkoutLogging({super.key});

  @override
  State<WorkoutLogging> createState() => _WorkoutLoggingState();
}

class _WorkoutLoggingState extends State<WorkoutLogging> {
  Map<String, dynamic> _workoutData = {};

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
  }

  Future<void> _loadWorkoutData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('WorkoutLogging');

    if (jsonString != null) {
      final Map<String, dynamic> decodedData = json.decode(jsonString);
      setState(() {
        _workoutData = decodedData;
      });
    }
  }

  void _showWorkoutDetails(Map<String, dynamic> workout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workout Details', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetail('Workout Name', workout['Workout Name']),
            _buildDetail('Duration', workout['duration']),
            _buildDetail('Notes', workout['notes']),
            _buildDetail('Date/Time', workout['date/time']),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white),
          children: [
            TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _navigateToAddWorkoutPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWorkoutPage()),
    );

    if (result == true) {
      _loadWorkoutData(); // Refresh after adding
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
        ),
        title: const Text('Workout Logging'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _workoutData.isEmpty
            ? const Center(
          child: Text(
            'No workouts',
            style: TextStyle(fontSize: 18),
          ),
        )
            : ListView(
          children: _workoutData.entries.map((entry) {
            final workout = entry.value as Map<String, dynamic>;

            return GestureDetector(
              onTap: () => _showWorkoutDetails(workout),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            workout['Workout Name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16 , color: Colors.black),
                          ),
                        ),
                        Text(
                          workout['duration'] ?? '',
                          style: const TextStyle(fontSize: 14 , color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            (workout['notes'] as String?)!.length > 20
                                ? '${workout['notes'].substring(0, 20)}...'
                                : workout['notes'] ?? '',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        Text(
                          workout['date/time'] ?? '',
                          style: const TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddWorkoutPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
