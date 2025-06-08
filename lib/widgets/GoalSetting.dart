import 'package:customizable_fitness_tracker/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalSetting extends StatefulWidget {
  const GoalSetting({super.key});

  @override
  State<GoalSetting> createState() => _GoalSettingState();
}

class _GoalSettingState extends State<GoalSetting> {
  final TextEditingController _goalController = TextEditingController();
  String _selectedFrequency = 'Weekly';
  int _goal = 0;
  int _currentProgress = 0;

  final Color primaryColor = const Color(0xFF88B2AC);

  @override
  void initState() {
    super.initState();
    _loadGoalData();
  }

  Future<void> _loadGoalData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _goal = prefs.getInt('goal') ?? 0;
      _currentProgress = prefs.getInt('progress') ?? 0;
      _selectedFrequency = prefs.getString('frequency') ?? 'Weekly';
    });
  }

  Future<void> _saveGoal() async {
    final prefs = await SharedPreferences.getInstance();
    int? goal = int.tryParse(_goalController.text.trim());
    if (goal != null && goal > 0) {
      await prefs.setInt('goal', goal);
      await prefs.setString('frequency', _selectedFrequency);
      setState(() {
        _goal = goal;
      });
      _goalController.clear();
    }
  }

  void _resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('progress', 0);
    await prefs.setInt('goal', 0);
    setState(() {
      _currentProgress = 0;
      _goal = 0;
    });
  }


  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedFrequency,
      decoration: _inputDecoration('Select Frequency'),
      items: ['Weekly', 'Monthly'].map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedFrequency = value!;
        });
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: primaryColor.withOpacity(0.1),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildProgressCard() {
    double progress = (_goal > 0) ? (_currentProgress / _goal).clamp(0.0, 1.0) : 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              color: primaryColor,
              backgroundColor: Colors.grey[300],
              minHeight: 12,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 10),
            Text('$_currentProgress / $_goal workouts ($_selectedFrequency)'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showUpdateProgressDialog,
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text('Update', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _resetProgress,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Reset', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  void _showUpdateProgressDialog() {
    final TextEditingController _updateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Progress'),
        content: TextField(
          controller: _updateController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter completed workouts',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_goal == 0) {
                // Show error dialog if goal is zero
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Goal is kept as Zero!'),
                        SizedBox(height: 10),
                        Text(
                          'Set your workout goal first to track your progress. Every journey starts with a single step!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Okay'),
                      ),
                    ],
                  ),
                );
                return; // Stop here, don’t update progress
              }

              final prefs = await SharedPreferences.getInstance();
              int? update = int.tryParse(_updateController.text.trim());
              if (update != null && update >= 0) {
                int newProgress = _currentProgress + update; // Add to existing progress

                await prefs.setInt('progress', newProgress);
                setState(() {
                  _currentProgress = newProgress;
                });

                Navigator.pop(context); // Close input dialog

                // If goal is achieved or surpassed
                if (newProgress >= _goal) {
                  _showCelebrationDialog();
                }
              } else {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCelebrationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: 1.2,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  child: Icon(Icons.emoji_events, size: 80, color: Colors.amber.shade700),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hurrah! 🎉',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'You have achieved your workout goal!',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('progress', 0);
                    await prefs.setInt('goal', 0);

                    setState(() {
                      _currentProgress = 0;
                      _goal = 0;
                    });

                    Navigator.pop(context); // Close the celebration dialog
                  },
                  child: const Text('Awesome!', style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        );
      },
    );
  }





  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProgressCard(),
            const SizedBox(height: 20),
            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Set Workout Goal'),
            ),
            const SizedBox(height: 16),
            _buildDropdown(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveGoal,
              icon: const Icon(Icons.save , color: Colors.white),
              label: const Text('Save Goal' , style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
