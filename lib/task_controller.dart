import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'task_model.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;


  final taskNameController = TextEditingController();
  final dueDateController = TextEditingController();

  final isComplete = false.obs;

  // Reactive state variables
  final Rx<DateTime?> dueDate = Rx<DateTime?>(null);
  final RxString priority = ''.obs;

  final List<String> priorities = ['High', 'Medium', 'Low'];


  void submit(GlobalKey<FormState> formKey) {
    try {
      if (formKey.currentState!.validate()) {

        final taskName = taskNameController.text;

        final selectedDueDate = dueDate.value;

        if (kDebugMode) {
          print("Adding Task - Title: $taskName, DueDate: $dueDate, Priority: $priority");
        }

        addTask(
          taskName,
          selectedDueDate ?? DateTime.now(),
          // Use current date if no date selected
          priority.value.isEmpty ? "Not Found" : priority.value,
        );
        Get.back(); // Close the dialog
      }
    }catch(e){
      if (kDebugMode) {
        print("submit $e}");
      }
    }
  }


  // Load tasks from Hive
  void loadTasks() {
    try {
      final box = Hive.box<Task>('tasks');
      tasks.value = box.values.toList();
    }catch(e){
      if (kDebugMode) {
        print("loadTasks $e}");
      }
    }
  }

  // Add a new task
  void addTask(String title, DateTime? dueDate, String? priority) {
    try {
      final box = Hive.box<Task>('tasks');
      final id = box.isEmpty ? 0 : box.keys.last + 1; // Generate unique ID
      final task = Task(title: title,
          dueDate: dueDate,
          priority: priority,
          id: id); // Include dueDate
      box.put(id, task); // Save task in Hive
      tasks.add(task); // Update the reactive list
    }catch(e){
      if (kDebugMode) {
        print("addTask $e}");
      }
    }finally{
      clearFields();
    }
  }


  // Delete a task
  void deleteTask(int index) {
    try {
      final box = Hive.box<Task>('tasks');
      final taskToDelete = tasks[index];
      final key = box.keys.firstWhere((k) => box.get(k) == taskToDelete,
          orElse: () => null);

      if (key != null) {
        box.delete(key); // Remove from Hive
        tasks.removeAt(index);
      }
    }catch(e){
      if (kDebugMode) {
        print("deleteTask $e}");
      }
    }
  }



  void toggleCompletion(int index) {
    try {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      update(); // Notify listeners (if using GetX or similar state management)
      tasks.refresh(); // Refresh the observable list
    }catch(e){
      if (kDebugMode) {
        print("toggleCompletion $e}");
      }
    }
  }

  clearFields(){
    taskNameController.clear();
    dueDateController.clear();
    dueDate.value = DateTime.now();
    priority.value = '';
  }

}
