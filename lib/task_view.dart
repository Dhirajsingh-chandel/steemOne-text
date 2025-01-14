import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'task_controller.dart';
import 'add_task_form.dart';
import 'package:intl/intl.dart';


class TaskScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    taskController.loadTasks(); // Load tasks on initialization

    // Get screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Task Manager'),
        elevation: 0,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Column(
             children: [
               const SizedBox(height: 16),
               Obx(() {
                 if (taskController.tasks == null || taskController.tasks.isEmpty) {
                   return const Center(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.inbox, size: 80, color: Colors.grey),
                         SizedBox(height: 16),
                         Text(
                           "No Tasks Found",
                           style: TextStyle(
                             fontSize: 18,
                             color: Colors.grey,
                           ),
                         ),
                         SizedBox(height: 8),
                         Text("Add your tasks to get started!",
                           style: TextStyle(
                             fontSize: 14,
                             color: Colors.grey,
                           ),
                         ),
                       ],
                     ),
                   );
                 }
                 return Flexible (
                   child: ListView.builder(
                     shrinkWrap: true,
                     itemCount: taskController.tasks.length,
                     itemBuilder: (context, index) {
                       final task = taskController.tasks[index];
                       return Card(
                         margin: EdgeInsets.symmetric(vertical: 8, horizontal: screenWidth * 0.05),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(12), // Rounded corners
                         ),
                         elevation: 4, // Subtle shadow
                         child: Container(
                           padding: const EdgeInsets.all(12),
                           decoration: BoxDecoration(
                             gradient: LinearGradient(
                               colors: [Colors.white, Colors.blue.shade50], // Light gradient
                               begin: Alignment.topLeft,
                               end: Alignment.bottomRight,
                             ),
                             borderRadius: BorderRadius.circular(12),
                           ),
                           child: ListTile(
                             leading: GestureDetector(
                               onTap: () {
                                 // Toggle the isCompleted status for the specific task
                                 taskController.toggleCompletion(index);
                               },
                               child: Icon(
                                 task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                 color: task.isCompleted ? Colors.green : Colors.grey,
                                 size: 32,
                               ),
                             ),
                             title: Text(
                               task.title,
                               style: const TextStyle(
                                 fontSize: 18,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.black87,
                               ),
                             ),
                             subtitle: Padding(
                               padding: const EdgeInsets.only(top: 8.0),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   if (task.dueDate != null)
                                     Row(
                                       children: [
                                         const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                         const SizedBox(width: 6),
                                         Text(
                                           'Due Date: ${DateFormat('dd-MM-yyyy').format(task.dueDate!)}',
                                           style: const TextStyle(color: Colors.black54,fontSize: 10),overflow: TextOverflow.ellipsis,
                                         ),
                                       ],
                                     ),
                                   if (task.priority != null)
                                     Row(
                                       children: [
                                         const Icon(Icons.flag, size: 16, color: Colors.grey),
                                         const SizedBox(width: 6),
                                         Text(
                                           'Priority: ${task.priority}',
                                           style: TextStyle(
                                             color: task.priority == "High"
                                                 ? Colors.red
                                                 : task.priority == "Medium"
                                                 ? Colors.orange
                                                 : Colors.green,
                                             fontWeight: FontWeight.bold,
                                           ),
                                         ),
                                       ],
                                     ),
                                 ],
                               ),
                             ),
                             trailing: IconButton(
                               icon: const Icon(Icons.delete, color: Colors.red),
                               onPressed: () => taskController.deleteTask(index),
                             ),
                           ),
                         ),
                       );
                     },
                   ),
                 );
               }),
             ],
          ),
          // Positioned Add Task button at the bottom of the screen
          Positioned(
            bottom: 16, // 16px from the bottom
            left: screenWidth * 0.1, // Center the button horizontally
            right: screenWidth * 0.1, // Ensure proper padding from the edges
            child: ElevatedButton(
              onPressed: () {
                Get.dialog(const AddTaskForm()); // Open AddTaskForm dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent, // Button color
                elevation: 8, // Add shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(vertical: 16), // Adjust padding based on screen height
              ),
              child: const Text(
                'Add Task',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



