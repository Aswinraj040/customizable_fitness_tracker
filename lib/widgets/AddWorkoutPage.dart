import 'dart:convert';

import 'package:customizable_fitness_tracker/const/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddWorkoutPage extends StatefulWidget {
  const AddWorkoutPage({super.key});

  @override
  State<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _presetTypes = ['Cardio', 'Strength', 'Custom'];
  String _selectedType = 'Cardio';

  final TextEditingController _workoutNameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();


  Future<void> _saveWorkout() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final String? existingJson = prefs.getString('WorkoutLogging');
    Map<String, dynamic> workoutData = existingJson != null ? json.decode(existingJson) : {};

    int count = workoutData.length;
    String newEntryId = 'a${count + 1}';

    while (workoutData.containsKey(newEntryId)) {
      count++;
      newEntryId = 'a${count + 1}';
    }

    workoutData[newEntryId] = {
      'Workout Name': _workoutNameController.text.trim(),
      'duration': _durationController.text.trim(),
      'notes': _notesController.text.trim(),
      'date/time': _selectedDateTime.toString().split('.').first,
    };

    await prefs.setString('WorkoutLogging', json.encode(workoutData));
    Navigator.pop(context, true); // Return with result to refresh previous screen
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  void dispose() {
    _workoutNameController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1, bool isOptional = false}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      validator: (value) {
        if (!isOptional && (value == null || value.trim().isEmpty)) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Select Workout Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _presetTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                    if (_selectedType != 'Custom') {
                      _workoutNameController.text = _selectedType;
                    } else {
                      _workoutNameController.clear();
                    }
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
                dropdownColor: cardBackgroundColor,
                style: const TextStyle(color: Colors.white),
                iconEnabledColor: Colors.white,
              ),
              const SizedBox(height: 16),

              _buildTextField(_workoutNameController, 'Workout Name'),
              const SizedBox(height: 12),

              _buildTextField(_durationController, 'Duration (e.g., 30 mins)'),
              const SizedBox(height: 12),

              _buildTextField(_notesController, 'Notes', maxLines: 3, isOptional: true),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: cardBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: const Text('Date & Time', style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    _selectedDateTime.toLocal().toString().split('.').first,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.calendar_today, color: Colors.white),
                  onTap: _pickDateTime,
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 5,
                ),
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text('Save Workout', style: TextStyle(color: Colors.white)),
                onPressed: _saveWorkout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
