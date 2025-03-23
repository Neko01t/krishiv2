import 'package:flutter/material.dart';

class ToDoListWidget extends StatefulWidget {
  const ToDoListWidget({super.key});

  @override
  State<ToDoListWidget> createState() => _ToDoListWidgetState();
}

class _ToDoListWidgetState extends State<ToDoListWidget> {
  List<String> tasks = [
    "Water the plants",
    "Check soil moisture",
    "Apply fertilizer",
  ];

  void markTaskDone(int index) {
    String completedTask = tasks[index];

    setState(() {
      tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$completedTask completed! ✅"),
        duration: const Duration(seconds: 1), // Disappears fast
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Ensures proper layout
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "To-Do List",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      "No tasks left! 🎉",
                      style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return toDoItem(tasks[index], index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget toDoItem(String task, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () => markTaskDone(index), // Removes item on tap
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.green, size: 18),
            const SizedBox(width: 8),
            Text(task, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
