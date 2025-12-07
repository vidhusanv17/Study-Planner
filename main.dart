import 'package:flutter/material.dart';

void main() {
  runApp(const StudyPlannerApp());
}

class StudyTask {
  final String subject;
  final String time;
  final int duration;
  bool completed;

  StudyTask({
    required this.subject,
    required this.time,
    required this.duration,
    this.completed = false,
  });
}

class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<StudyTask> tasks = [];

  void _addTask(String subject, String time, int duration) {
    setState(() {
      tasks.add(
        StudyTask(subject: subject, time: time, duration: duration),
      );
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Planner'),
        backgroundColor: const Color(0xFF5E35B1),
      ),
      body: Column(
        children: [
          AddTaskCard(onAdd: _addTask),
          const SizedBox(height: 10),

          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('No tasks added yet'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        task: tasks[index],
                        onToggle: () => _toggleComplete(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class AddTaskCard extends StatefulWidget {
  final Function(String, String, int) onAdd;

  const AddTaskCard({super.key, required this.onAdd});

  @override
  State<AddTaskCard> createState() => _AddTaskCardState();
}

class _AddTaskCardState extends State<AddTaskCard> {
  final TextEditingController subjectCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();
  final TextEditingController durationCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: subjectCtrl,
            decoration: const InputDecoration(
              labelText: 'Subject',
              prefixIcon: Icon(Icons.book),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: timeCtrl,
            decoration: const InputDecoration(
              labelText: 'Start Time (eg: 6:00 PM)',
              prefixIcon: Icon(Icons.access_time),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: durationCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Duration (minutes)',
              prefixIcon: Icon(Icons.timer),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              if (subjectCtrl.text.isNotEmpty &&
                  timeCtrl.text.isNotEmpty &&
                  durationCtrl.text.isNotEmpty) {
                widget.onAdd(
                  subjectCtrl.text,
                  timeCtrl.text,
                  int.parse(durationCtrl.text),
                );

                subjectCtrl.clear();
                timeCtrl.clear();
                durationCtrl.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E35B1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final StudyTask task;
  final VoidCallback onToggle;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: task.completed ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              task.completed
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.completed ? Colors.green : Colors.grey,
            ),
            onPressed: onToggle,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.subject,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${task.time} • ${task.duration} mins',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
